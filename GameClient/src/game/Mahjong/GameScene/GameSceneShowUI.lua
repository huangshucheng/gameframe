local GameScene = Game.GameScene or {}

local RoomData              = require("game.clientdata.RoomData")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")
local ToolUtils             = require("game.utils.ToolUtils")
local GameFunction 			= require("game.Mahjong.Base.GameFunction")
local Player 				= require("game.clientdata.Player")

local MAX_PLAYER_NUM = 4

function GameScene:showUserInfoBySeatId(seatId) --serverSeat
    local localSeat = GameFunction.serverSeatToLocal(seatId)
    local player = RoomData:getInstance():getPlayerBySeatId(seatId)
    print('hcc>> serverSeat: '.. seatId .. '  ,localseat: ' .. localSeat)
    if player then
        local seat =  GameFunction.serverSeatToLocal(player:getSeat())
        local infoPanel = self._panel_user_info_table[seat]
        if infoPanel then
            infoPanel:setVisible(true)
            local textName      = ccui.Helper:seekWidgetByName(infoPanel,GameSceneDefine.KW_TEXT_NAME)
            local textScore     = ccui.Helper:seekWidgetByName(infoPanel,GameSceneDefine.KW_TEXT_SCORE)
            local imgOffLine    = ccui.Helper:seekWidgetByName(infoPanel,GameSceneDefine.KW_IMG_OFFINLE)
            local imgHead       = ccui.Helper:seekWidgetByName(infoPanel,GameSceneDefine.KW_IMG_HEAD)
            if textName then
                textName:setString(player:getUNick())
            end
            if textScore then
                textScore:setString('1000')    --TODO
            end
            if imgOffLine then
                imgOffLine:setVisible(player:getIsOffline())
            end
            if imgHead then
                imgHead:loadTexture(string.format('MahScene/MahRes/rectheader/1%d.png',tonumber(player:getUFace())))
            end
        end
    else
        local infoPanel = self._panel_user_info_table[localSeat]
        if infoPanel then
            infoPanel:setVisible(false)
        end
        print('localseat: ' .. localSeat .. " false")
    end
end

function GameScene:showAllExistUserInfo()
    for seat = 1 , MAX_PLAYER_NUM do
        self:showUserInfoBySeatId(seat)
    end
end

function GameScene:showRoomInfo()
    if self._btn_room_num then
        local roomid = RoomData:getInstance():getRoomId()
        if roomid then
            self._btn_room_num:setString('房间号:' .. roomid)
        end
    end
    if self._text_room_rule then
        local roomRule = RoomData:getInstance():getRoomInfo()
        if roomRule then
            local playerNum = ToolUtils.getLuaStrValue(roomRule,"playerNum")
            local playCount = ToolUtils.getLuaStrValue(roomRule,"playCount")
            local isAAPay = ToolUtils.getLuaStrValue(roomRule,"isAAPay")
            local baseScore = ToolUtils.getLuaStrValue(roomRule,"baseScore")
            print('hcc>> rule: ' .. playerNum .. "  ," .. playCount .. " ," .. isAAPay .. ' ,' .. baseScore)

            local strRule = ''
            local payStr = ((tostring(isAAPay) == '1') and "AA支付") or "房主支付"

            strRule = strRule .. "人数:" .. tostring(playerNum) .. ","
            strRule = strRule .. "局数:" .. tostring(playCount) .. ","
            strRule = strRule .. "底分:" .. tostring(baseScore) .. ","
            strRule = strRule .. tostring(payStr)

            self._text_room_rule:setString(strRule)
         end 
    end
end

function GameScene:showReadyBtn()
	local selfPlayer = GameFunction.getSelfPlayer()
	if not selfPlayer then
		return
	end
	
	local showFunc = function(isShow)
		local panel_btn = self:getResourceNode():getChildByName(GameSceneDefine.KW_PANEL_BOTTON_BTN)
		if panel_btn then
			local ready_btn = panel_btn:getChildByName(GameSceneDefine.KW_BTN_READY)
			if ready_btn  then
			 	ready_btn:setVisible(isShow)
			 end 
		end
	end

	local state = selfPlayer:getState()
	local show = (state < Player.STATE.psReady) and true or false
	showFunc(show)	
end