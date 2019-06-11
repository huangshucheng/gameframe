local BaseScene     = require("game.Base.BaseScene")
local GameScene     = class("GameScene", BaseScene)
Game.GameScene      = GameScene

local Function 				= require("game.Mahjong.Base.Function")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")
local Scheduler             = require("game.utils.scheduler")

--------------拓展
require('game.Mahjong.GameScene.GameSceneReceiveMsg')
require('game.Mahjong.GameScene.GameSceneTouchEvent')
require('game.Mahjong.GameScene.GameSceneShowUI')
require('game.Mahjong.GameScene.GameSceneUI')
---------------end

GameScene.RESOURCE_FILENAME = 'MahScene/MahScene.csb'

function GameScene:ctor()
    self._panel_user_info_table = {}
	GameScene.super.ctor(self)

    self._sync_frameid = 0
    self._last_frame_opt = nil

    self._joystick = nil
    self._hero_list = {}
end

function GameScene:onCreate()
    self:initUI()
    self:addUITouchEvent()
    self:showRoomInfo()
    self:showAllExistUserInfo()
    self:showReadyBtn()
    self:showReadyImag()
    -- self:showJoystick()
    -- self.tickScheduler = Scheduler.scheduleUpdateGlobal(handler(self, self.update))
end

function GameScene:initUI()
    for i = 1 , 4 do
        local panel_user = self:getResourceNode():getChildByName(GameSceneDefine.KW_PANEL_USER_INFO .. i)
        if panel_user then
            self._panel_user_info_table[#self._panel_user_info_table + 1] = panel_user
            panel_user:setVisible(false)
        end
    end
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
    if self.tickScheduler then
        Scheduler.unscheduleGlobal(self.tickScheduler)
        self.tickScheduler = nil
    end 
end

function GameScene:update(dt)
    self:showHeroPos(dt)
end

return GameScene