local BaseScene     = require("game.Base.BaseScene")
local GameScene     = class("GameScene", BaseScene)
Game.GameScene        = GameScene

local Function 				= require("game.Mahjong.Base.Function")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")

--------------拓展
require('game.Mahjong.GameScene.GameSceneReceiveMsg')
require('game.Mahjong.GameScene.GameSceneTouchEvent')
require('game.Mahjong.GameScene.GameSceneShowUI')
---------------end

GameScene.RESOURCE_FILENAME = 'MahScene/MahScene.csb'

function GameScene:ctor()
    self._btn_room_num      = nil
    self._text_room_rule    = nil
    self._panel_user_info_table = {}
	GameScene.super.ctor(self)
end

function GameScene:onCreate()
    self:initUI()
    self:addUITouchEvent()
    self:showRoomInfo()
    self:showAllExistUserInfo()
    self:showReadyBtn()
end

function GameScene:initUI()
    local csbNode = self:getResourceNode()
    if not csbNode then return end
    local panel_top = csbNode:getChildByName(GameSceneDefine.KW_PANEL_TOP)
    if panel_top then
        self._btn_room_num = panel_top:getChildByName(GameSceneDefine.KW_ROOM_NUM)
        self._text_room_rule = panel_top:getChildByName(GameSceneDefine.KW_TEXT_RULE)
    end

    for i = 1 , 4 do
        local panel_user = csbNode:getChildByName(GameSceneDefine.KW_PANEL_USER_INFO .. i)
        if panel_user then
            self._panel_user_info_table[#self._panel_user_info_table + 1] = panel_user
            panel_user:setVisible(false)
        end
    end
end

function GameScene:addUITouchEvent()
    local csbNode = self:getResourceNode()
    if not csbNode then return end
    local btn_setting = csbNode:getChildByName(GameSceneDefine.KW_BTN_SET)

    if btn_setting then
        btn_setting:addTouchEventListener(handler(self,self.onTouchSettingBtn))
    end

    local panel_btn = csbNode:getChildByName(GameSceneDefine.KW_PANEL_BOTTON_BTN)
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

return GameScene