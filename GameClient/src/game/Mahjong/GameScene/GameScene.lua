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

local KW_ROOM_NUM           = 'KW_ROOM_NUM'
local KW_BTN_SET            = 'KW_BTN_SET'
local KW_PANEL_TOP          = 'KW_PANEL_TOP'
local KW_TEXT_RULE          = 'KW_TEXT_RULE'
local KW_PANEL_USER_INFO    = 'KW_PANEL_USER_INFO_'

local KW_TEXT_NAME          = 'KW_TEXT_NAME'
local KW_TEXT_SCORE         = 'KW_TEXT_SCORE'
local KW_IMG_OFFINLE        = 'KW_IMG_OFFINLE'
local KW_IMG_HEAD           = 'KW_IMG_HEAD'

local MAX_PLAYER_NUM = RoomData:getInstance():getChars()

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

    for i = 1 , MAX_PLAYER_NUM do
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
    if seatId > MAX_PLAYER_NUM or seatId < 0 then return end

    local player = RoomData:getInstance():getPlayerBySeatId(seatId)

    local localSeat = GameFunction.serverSeatToLocal(seatId)
    print('hcc>> serverSeat: '.. seatId .. '  ,localseat: ' .. localSeat)

    if self._panel_user_info_table[localSeat] then
        self._panel_user_info_table[localSeat]:setVisible(player ~= nil)
    end

    if player then
        local infoPanel = self._panel_user_info_table[localSeat]
        if infoPanel then
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
        print('roomid: '.. tostring(roomid))
        if roomid then
            self._btn_room_num:setString('房间号:' .. roomid)
        end
    end
    if self._text_room_rule then
        local roomRule = RoomData:getInstance():getRoomInfo()
        if roomRule then
             self._text_room_rule:setString(roomRule)
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