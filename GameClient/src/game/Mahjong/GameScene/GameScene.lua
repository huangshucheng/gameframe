local BaseScene     = require("game.views.Base.BaseScene")
local GameScene     = class("GameScene", BaseScene)
GT.GameScene        = GameScene

local Cmd               	= require("game.net.protocol.Cmd")
local Respones          	= require("game.net.Respones")
local cmd_name_map      	= require("game.net.protocol.cmd_name_map")
local UserInfo          	= require("game.clientdata.UserInfo")
local LogicServiceProxy 	= require("game.modules.LogicServiceProxy")
local Function 				= require("game.Mahjong.Base.Function")

--------------拓展
require('game.Mahjong.GameScene.GameSceneReceiveMsg')

---------------end

GameScene.RESOURCE_FILENAME = 'MahScene/MahScene.csb'

function GameScene:ctor()
	GameScene.super.ctor(self)

	GT.showPopLayer 		= Function.showPopLayer
end

function GameScene:onCreate()
	local btn_setting = self:getResourceNode():getChildByName('KW_BTN_SET')
	if btn_setting then
		btn_setting:addTouchEventListener(handler(self,self.onTouchSettingBtn))
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