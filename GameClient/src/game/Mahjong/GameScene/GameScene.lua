local BaseScene     = require("game.Base.BaseScene")
local GameScene     = class("GameScene", BaseScene)
GT.GameScene        = GameScene

local Cmd               	= require("game.net.protocol.Cmd")
local Respones          	= require("game.net.Respones")
local cmd_name_map      	= require("game.net.protocol.cmd_name_map")
local UserInfo          	= require("game.clientdata.UserInfo")
local UserRoomInfo          = require("game.clientdata.UserRoomInfo")
local LogicServiceProxy 	= require("game.modules.LogicServiceProxy")
local Function 				= require("game.Mahjong.Base.Function")

local KW_ROOM_NUM           = 'KW_ROOM_NUM'
local KW_BTN_SET            = 'KW_BTN_SET'
local KW_PANEL_TOP          = 'KW_PANEL_TOP'
local KW_TEXT_RULE          = 'KW_TEXT_RULE'

--------------拓展
require('game.Mahjong.GameScene.GameSceneReceiveMsg')

---------------end

GameScene.RESOURCE_FILENAME = 'MahScene/MahScene.csb'

function GameScene:ctor()
    self._btn_room_num      = nil
    self._text_room_rule    = nil
	GameScene.super.ctor(self)

	GT.showPopLayer 		= Function.showPopLayer
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
    if self._btn_room_num then
        local roomid = UserRoomInfo.getRoomId()
        if roomid then
            self._btn_room_num:setString('房间号:' .. roomid)
        end
    end
    if self._text_room_rule then
        local roomRule = UserRoomInfo.getRoomInfo()
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
    GT.showPopLayer('SetLayer')
end

function GameScene:onEnter()
	
end

function GameScene:onExit()
	
end

return GameScene