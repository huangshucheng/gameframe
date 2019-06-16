local BaseScene     = require("game.Base.BaseScene")
local GameScene     = class("GameScene", BaseScene)
Game.GameScene      = GameScene

local Function 				= require("game.Mahjong.Base.Function")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local Scheduler             = require("game.utils.scheduler")

--------------拓展
require('game.Mahjong.GameScene.GameSceneReceiveMsg')
require('game.Mahjong.GameScene.GameSceneTouchEvent')
require('game.Mahjong.GameScene.GameSceneShowUI')
require('game.Mahjong.GameScene.GameSceneUI')
---------------end

GameScene.RESOURCE_FILENAME = 'MahScene/MahScene.csb'

function GameScene:ctor()
	GameScene.super.ctor(self)
end

function GameScene:onCreate()
    print('GameScene>>onCreate')
    LogicServiceProxy:getInstance():sendCheckLinkGameReq()
    self:initUI()
    self:addUITouchEvent()
end

function GameScene:initUI()
    local panel_user = nil
    local index = 0
    repeat
        index = index + 1
        panel_user = self:getResourceNode():getChildByName(GameSceneDefine.KW_PANEL_USER_INFO .. index)
        if panel_user then
            panel_user:setVisible(false)
        end
    until panel_user == nil
end

function GameScene:addUITouchEvent()
    local btn_setting = self:getResourceNode():getChildByName(GameSceneDefine.KW_BTN_SET)
    if btn_setting then
        btn_setting:addTouchEventListener(handler(self,self.onTouchSettingBtn))
    end

    local panel_btn = self:getResourceNode():getChildByName(GameSceneDefine.KW_PANEL_BOTTON_BTN)
    if panel_btn then
        local ready_btn = panel_btn:getChildByName(GameSceneDefine.KW_BTN_READY)
        if ready_btn  then
            ready_btn:addClickEventListener(handler(self, self.onTouchReadyBtn))
         end
    end
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

function GameScene:update(dt)
    self:showHeroPos(dt)
end

return GameScene