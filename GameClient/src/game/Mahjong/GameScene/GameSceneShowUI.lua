local GameScene = class("GameScene")

local RoomData              = require("game.clientdata.RoomData")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")
local ToolUtils             = require("game.utils.ToolUtils")
local GameFunction 			= require("game.Mahjong.Base.GameFunction")
local Player 				= require("game.clientdata.Player")

local MAX_PLAYER_COUNT = 4

function GameScene:showUserInfoBySeatId(seatId) --serverSeat
    local localSeat = GameFunction.serverSeatToLocal(seatId)
    local player = RoomData:getInstance():getPlayerBySeatId(seatId)
    -- print('hcc>> serverSeat: '.. seatId .. '  ,localseat: ' .. localSeat)
    if player then
        local seat =  GameFunction.serverSeatToLocal(player:getServerSeat())
        local infoPanel = Lobby.UIFunction.seekWidgetByName(self:getRootNode(),GameSceneDefine.KW_PANEL_USER_INFO .. seat)
        if infoPanel then
            infoPanel:setVisible(true)
            Lobby.UIFunction.setString(infoPanel,GameSceneDefine.KW_TEXT_NAME,player:getUNick())
            Lobby.UIFunction.setString(infoPanel,GameSceneDefine.KW_TEXT_SCORE,'1000')
            Lobby.UIFunction.setVisible(infoPanel,GameSceneDefine.KW_IMG_OFFINLE,player:getIsOffline())
            Lobby.UIFunction.loadTexture(infoPanel,GameSceneDefine.KW_IMG_HEAD,string.format('MahScene/MahRes/rectheader/1%d.png',tonumber(player:getUFace())))
        end
    else
        Lobby.UIFunction.setVisible(self:getRootNode(),GameSceneDefine.KW_PANEL_USER_INFO .. localSeat,false)
        -- print('localseat: ' .. localSeat .. " false")
    end
end

function GameScene:showAllExistUserInfo()
    local playerCount = RoomData:getInstance():getChars()
    print('playerCount: ' .. playerCount)
    for serverSeat = 1 , MAX_PLAYER_COUNT do
        self:showUserInfoBySeatId(serverSeat)
    end
end

function GameScene:showRoomInfo()
    local panel_top = Lobby.UIFunction.seekWidgetByName(self:getRootNode(),GameSceneDefine.KW_PANEL_TOP)
    if panel_top then
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
            Lobby.UIFunction.setString(panel_top,GameSceneDefine.KW_TEXT_RULE,strRule)
         end 
    end
end

function GameScene:showRoomId()
    local panel_top =  Lobby.UIFunction.seekWidgetByName(self:getRootNode(),GameSceneDefine.KW_PANEL_TOP)
    if panel_top then
        Lobby.UIFunction.setString(panel_top,GameSceneDefine.KW_ROOM_NUM,RoomData:getInstance():getRoomId())
    end
end

function GameScene:showReadyBtn()
	local selfPlayer = GameFunction.getSelfPlayer()
	if not selfPlayer then
		return
	end
	
	local showFunc = function(isShow)
         Lobby.UIFunction.setVisible(self:getRootNode(),GameSceneDefine.KW_BTN_READY,isShow)
	end

	local state = selfPlayer:getState()
	local show = (state < Player.STATE.psReady) and true or false
	showFunc(show)
end

function GameScene:showReadyImag()
    local showFunc = function(localSeat, isShow)
        local infoPanel = Lobby.UIFunction.seekWidgetByName(self:getRootNode(),GameSceneDefine.KW_PANEL_USER_INFO .. localSeat)
        if infoPanel then
             Lobby.UIFunction.setVisible(infoPanel,GameSceneDefine.KW_IMG_READY,isShow)
        end
    end
    for sSeat = 1 , MAX_PLAYER_COUNT do
        local localSeat = GameFunction.serverSeatToLocal(sSeat)
        local player = RoomData:getInstance():getPlayerBySeatId(sSeat)
        if player then
            local isShow = player:getState() == Player.STATE.psReady
            showFunc(player:getLocalSeat(), isShow)
        else
            showFunc(localSeat, false)
        end
    end
end

function GameScene:showHostImag()
    local showFunc = function(localSeat, isShow)
        local infoPanel = Lobby.UIFunction.seekWidgetByName(self:getRootNode(),GameSceneDefine.KW_PANEL_USER_INFO .. localSeat)
        if infoPanel then
            Lobby.UIFunction.setVisible(infoPanel,GameSceneDefine.KW_IMG_MASTER,isShow)
        end
    end
    for sSeat = 1 , MAX_PLAYER_COUNT do
        local localSeat = GameFunction.serverSeatToLocal(sSeat)
        local player = RoomData:getInstance():getPlayerBySeatId(sSeat)
        if player then
            showFunc(player:getLocalSeat(), player:getIsHost())
        else
            showFunc(localSeat, false)
        end
    end
end

function GameScene:showPlayCount()
    local leftTopPanel = Lobby.UIFunction.seekWidgetByName(self:getRootNode(),GameSceneDefine.KW_PANEL_LEFT_TOP)
    if leftTopPanel then
        local count = RoomData:getInstance():getPlayCount()
        local total = RoomData:getInstance():getTotalPlayCount()
        Lobby.UIFunction.setString(leftTopPanel,GameSceneDefine.KW_TEXT_PLAY_COUNT,'局数:' .. tostring(count) .. '/' .. tostring(total))
    end
end

return GameScene