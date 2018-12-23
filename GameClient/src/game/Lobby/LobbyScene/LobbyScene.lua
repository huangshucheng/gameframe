local BaseScene     = require("game.Base.BaseScene")
local LobbyScene    = class("LobbyScene", BaseScene)
Lobby.LobbyScene       = LobbyScene

local UserInfo              = require("game.clientdata.UserInfo")
local RoomData              = require("game.clientdata.RoomData")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local SystemServiceProxy    = require("game.modules.SystemServiceProxy")
local Function              = require('game.Base.Function')
local LobbySceneDefine      = require('game.Lobby.LobbyScene.LobbySceneDefine')

--------------拓展
require('game.Lobby.LobbyScene.LobbySceneReceiveMsg')
require('game.Lobby.LobbyScene.LobbySceneTouchEvent')
require('game.Lobby.LobbyScene.LobbySceneShowUI')
---------------end

LobbyScene.RESOURCE_FILENAME = 'Lobby/LobbyScene.csb'

function LobbyScene:ctor()
    LobbyScene.super.ctor(self)
end

function LobbyScene:onCreate()
    self:initUI()
    self:addUITouchEvent()
    self:showUserInfo()
end

function LobbyScene:initUI()

end

function LobbyScene:addUITouchEvent()
    local panel_center = self:getResourceNode():getChildByName(LobbySceneDefine.PANEL_CENTER)
    if panel_center then
        local btn_join_room         = panel_center:getChildByName(LobbySceneDefine.IMG_JOIN_ROOM)
        local img_back_room         = panel_center:getChildByName(LobbySceneDefine.IMG_BACK_ROOM)
        local img_create_room       = panel_center:getChildByName(LobbySceneDefine.IMG_CREATE_ROOM)
        if btn_join_room then
            btn_join_room:addTouchEventListener(handler(self,self.onTouchJoinRoomBtn))
        end
        if img_back_room then
             img_back_room:addTouchEventListener(handler(self,self.onTouchBackRoomBtn))
        end
        if img_create_room then
            img_create_room:addTouchEventListener(handler(self,self.onTouchCreateRoomBtn))
        end
    end

    local img_top_bg = self:getResourceNode():getChildByName(LobbySceneDefine.IMG_TOP_BG)

    if img_top_bg then
        local panel_head_bg = ccui.Helper:seekWidgetByName(img_top_bg, LobbySceneDefine.PANEL_HEAD_BG)
        if panel_head_bg then
            panel_head_bg:addTouchEventListener(handler(self,self.onTouchEventHeadImgBg))
        end

        local btn_setting   = ccui.Helper:seekWidgetByName(img_top_bg,LobbySceneDefine.BTN_SESTTING)
        if btn_setting then
            btn_setting:addClickEventListener(handler(self,self.onTouchSettingBtn))
        end

        local btn_message = ccui.Helper:seekWidgetByName(img_top_bg,LobbySceneDefine.BTN_MESSAGE)
        if btn_message then
             btn_message:addClickEventListener(handler(self,self.onTouchMessageBtn))
        end 

        local btn_mail = ccui.Helper:seekWidgetByName(img_top_bg,LobbySceneDefine.BTN_MAIL)
        if btn_mail then
             btn_mail:addClickEventListener(handler(self,self.onTouchMailBtn))
        end 
    end
end

function LobbyScene:onEnter()
    print('LobbyScene:onEnter')
    Lobby.showPopLayer = Function.showPopLayer
    --获取用户信息
    SystemServiceProxy:getInstance():sendGetUgameInfo()
    LogicServiceProxy:getInstance():sendGetCreateStatus()
    RoomData:getInstance():reset()
end

function LobbyScene:onExit()
    print('LobbyScene:onExit')
end

return LobbyScene
