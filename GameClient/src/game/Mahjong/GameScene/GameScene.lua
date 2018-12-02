local BaseScene     = require("game.Base.BaseScene")
local GameScene     = class("GameScene", BaseScene)
Game.GameScene        = GameScene

local Cmd               	= require("game.net.protocol.Cmd")
local Respones          	= require("game.net.Respones")
local cmd_name_map      	= require("game.net.protocol.cmd_name_map")
local UserInfo          	= require("game.clientdata.UserInfo")
local RoomData              = require("game.clientdata.RoomData")
local LogicServiceProxy 	= require("game.modules.LogicServiceProxy")
local Function 				= require("game.Mahjong.Base.Function")
local GameFunction          = require("game.Mahjong.Base.GameFunction")
local ToolUtils             = require("game.utils.ToolUtils")

local KW_ROOM_NUM           = 'KW_ROOM_NUM'
local KW_BTN_SET            = 'KW_BTN_SET'
local KW_PANEL_TOP          = 'KW_PANEL_TOP'
local KW_TEXT_RULE          = 'KW_TEXT_RULE'
local KW_PANEL_USER_INFO    = 'KW_PANEL_USER_INFO_'

local KW_TEXT_NAME          = 'KW_TEXT_NAME'
local KW_TEXT_SCORE         = 'KW_TEXT_SCORE'
local KW_IMG_OFFINLE        = 'KW_IMG_OFFINLE'
local KW_IMG_HEAD           = 'KW_IMG_HEAD'

local MAX_PLAYER_NUM = 4

--------------拓展
require('game.Mahjong.GameScene.GameSceneReceiveMsg')

---------------end

GameScene.RESOURCE_FILENAME = 'MahScene/MahScene.csb'

function GameScene:ctor()
    self._btn_room_num      = nil
    self._text_room_rule    = nil
    self._panel_user_info_table = {}
	GameScene.super.ctor(self)
end

function GameScene:onCreate()
	local btn_setting = self:getResourceNode():getChildByName(KW_BTN_SET)
	if btn_setting then
		btn_setting:addTouchEventListener(handler(self,self.onTouchSettingBtn))
	end
    local panel_top = self:getResourceNode():getChildByName(KW_PANEL_TOP)
    if not panel_top then return end
    self._btn_room_num = panel_top:getChildByName(KW_ROOM_NUM)
    self._text_room_rule = panel_top:getChildByName(KW_TEXT_RULE)

    for i = 1 , 4 do
        local panel_user = self:getResourceNode():getChildByName(KW_PANEL_USER_INFO .. i)
        if panel_user then
            self._panel_user_info_table[#self._panel_user_info_table + 1] = panel_user
            panel_user:setVisible(false)
        end
    end
    self:showRoomInfo()
    self:showAllExistUserInfo()
end

function GameScene:showUserInfoBySeatId(seatId) --serverSeat
    local localSeat = GameFunction.serverSeatToLocal(seatId)
    local player = RoomData:getInstance():getPlayerBySeatId(seatId)
    print('hcc>> serverSeat: '.. seatId .. '  ,localseat: ' .. localSeat)
    if player then
        local seat =  GameFunction.serverSeatToLocal(player:getSeat())
        local infoPanel = self._panel_user_info_table[seat]
        if infoPanel then
            infoPanel:setVisible(true)
            local textName      = ccui.Helper:seekWidgetByName(infoPanel,KW_TEXT_NAME)
            local textScore     = ccui.Helper:seekWidgetByName(infoPanel,KW_TEXT_SCORE)
            local imgOffLine    = ccui.Helper:seekWidgetByName(infoPanel,KW_IMG_OFFINLE)
            local imgHead       = ccui.Helper:seekWidgetByName(infoPanel,KW_IMG_HEAD)
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

function GameScene:onTouchSettingBtn(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        sender:setScale(0.9)
        sender:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        sender:setScale(1)
        sender:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    Game.showPopLayer('SetLayer')
end

function GameScene:onEnter()
	print('GameScene onEnter')
    Game.showPopLayer         = Function.showPopLayer
    Game.popLayer             = Function.popLayer
    Game.getLayer             = Function.getLayer
end

function GameScene:onExit()
    print('GameScene onExit')
end

return GameScene