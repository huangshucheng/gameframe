local BaseScene     = require("game.Base.BaseScene")
local LobbyScene    = class("LobbyScene", BaseScene)
GT.LobbyScene       = LobbyScene

local Cmd                   = require("game.net.protocol.Cmd")
local Respones              = require("game.net.Respones")
local cmd_name_map          = require("game.net.protocol.cmd_name_map")
local UserInfo              = require("game.clientdata.UserInfo")
local RoomData              = require("game.clientdata.RoomData")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local SystemServiceProxy    = require("game.modules.SystemServiceProxy")
local Function              = require('game.Base.Function')

--------------拓展
require('game.Lobby.LobbyScene.LobbySceneReceiveMsg')

---------------end

LobbyScene.RESOURCE_FILENAME = 'Lobby/LobbyScene.csb'

local PANEL_CENTER          = 'PANEL_CENTER'
local IMG_JOIN_ROOM         = 'IMG_JOIN_ROOM'
local IMG_CREATE_ROOM       = 'IMG_CREATE_ROOM'
local IMG_BACK_ROOM         = 'IMG_BACK_ROOM'
local PANEL_HEAD_BG         = 'PANEL_HEAD_BG'
local IMG_TOP_BG            = 'IMG_TOP_BG'
local TEXT_USER_NAME        = 'TEXT_USER_NAME'
local TEXT_USER_ID          = 'TEXT_USER_ID'
local BTN_SESTTING          = 'BTN_SESTTING'
local BTN_MESSAGE           = 'BTN_MESSAGE'
local BTN_MAIL              = 'BTN_MAIL'
local TEXT_COIN             = 'TEXT_COIN'
local TEXT_DIAMOND          = 'TEXT_DIAMOND'
local IMG_HEAD              = 'IMG_HEAD'

function LobbyScene:ctor()
    self._user_name_text    = nil
    self._user_id_text      = nil
    self._coin_text         = nil
    self._diamond_text      = nil
    self._img_head          = nil

    self._img_back_room     = nil
    self._img_create_room   = nil

    LobbyScene.super.ctor(self)
end

function LobbyScene:onCreate()
    local panel_center          = self:getResourceNode():getChildByName(PANEL_CENTER)
    if  not panel_center then return end

    local btn_join_room         = panel_center:getChildByName(IMG_JOIN_ROOM)
    self._img_back_room         = panel_center:getChildByName(IMG_BACK_ROOM)
    self._img_create_room       = panel_center:getChildByName(IMG_CREATE_ROOM)

    if btn_join_room then
        btn_join_room:addTouchEventListener(handler(self,self.onTouchJoinRoomBtn))
    end

    if self._img_create_room then
        self._img_create_room:addTouchEventListener(handler(self,self.onTouchCreateRoomBtn))
    end

    if self._img_back_room then
        self._img_back_room:addTouchEventListener(handler(self,self.onTouchBackRoomBtn))
    end

    local img_top_bg = self:getResourceNode():getChildByName(IMG_TOP_BG)
    if not img_top_bg then return end

    local panel_head_bg = ccui.Helper:seekWidgetByName(img_top_bg, PANEL_HEAD_BG)
    if panel_head_bg then
        panel_head_bg:addTouchEventListener(handler(self,self.onTouchEventHeadImgBg))
    end

    local btn_setting   = ccui.Helper:seekWidgetByName(img_top_bg,BTN_SESTTING)
    if btn_setting then
        btn_setting:addClickEventListener(handler(self,self.onTouchSettingBtn))
    end

    local btn_message = ccui.Helper:seekWidgetByName(img_top_bg,BTN_MESSAGE)
    if btn_message then
         btn_message:addClickEventListener(handler(self,self.onTouchMessageBtn))
    end 

    local btn_mail = ccui.Helper:seekWidgetByName(img_top_bg,BTN_MAIL)
    if btn_mail then
         btn_mail:addClickEventListener(handler(self,self.onTouchMailBtn))
    end 

    self._user_name_text    = ccui.Helper:seekWidgetByName(img_top_bg, TEXT_USER_NAME)
    self._user_id_text      = ccui.Helper:seekWidgetByName(img_top_bg, TEXT_USER_ID)
    self._coin_text         = ccui.Helper:seekWidgetByName(img_top_bg, TEXT_COIN)
    self._diamond_text      = ccui.Helper:seekWidgetByName(img_top_bg, TEXT_DIAMOND)
    self._img_head          = ccui.Helper:seekWidgetByName(img_top_bg, IMG_HEAD)
    if self._user_name_text then
        self._user_name_text:setString(UserInfo.getUserName())
    end
    if self._user_id_text then
        -- self._user_id_text:setString('ID:00000' .. UserInfo.getUserId())
        self._user_id_text:setString('ID:' .. UserInfo.getBrandId())
    end
    if self._img_head then
        self._img_head:loadTexture(string.format('Lobby/LobbyRes/rectheader/1%s.png',UserInfo.getUserface()))
    end
end

function LobbyScene:onTouchJoinRoomBtn(send,eventType)
    if eventType == ccui.TouchEventType.began then
        send:setScale(0.9)
        send:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        send:setScale(1)
        send:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    GT.showPopLayer('JoinRoomLayer')
end

function LobbyScene:onTouchCreateRoomBtn(send,eventType)
    if eventType == ccui.TouchEventType.began then
        send:setScale(0.9)
        send:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        send:setScale(1)
        send:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    --[[    
    local str = 'start<< '
    for idx = 1 , 500 do
        str = str .. idx
    end
    str = str .. '  end>>'
    ]]
    LogicServiceProxy:getInstance():sendCreateRoom('房间规则')
    GT.showPopLayer('LoadingLayer')
end

function LobbyScene:onTouchBackRoomBtn(send,eventType)
    if eventType == ccui.TouchEventType.began then
        send:setScale(0.9)
        send:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        send:setScale(1)
        send:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    LogicServiceProxy:getInstance():sendBackRoomReq()
    GT.showPopLayer('LoadingLayer')
end

function LobbyScene:onTouchEventHeadImgBg(send,eventType)
      if eventType == ccui.TouchEventType.began then
        send:setScale(0.9)
        send:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        send:setScale(1)
        send:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    GT.showPopLayer('MyCenterLayer')
end

function LobbyScene:onTouchSettingBtn(send, eventType)
    GT.showPopLayer('SetLayer')
end

function LobbyScene:onTouchMessageBtn(send, evnetType)
    GT.showPopLayer("RankLayer")
    -- SystemServiceProxy:getInstance():sendGetLoginBonues()--登录奖励  TODO
end

function LobbyScene:onTouchMailBtn(send, evnetType)
    GT.showPopLayer("MsgLayer")
end

function LobbyScene:onEnter()
    print('LobbyScene:onEnter')
    GT.showPopLayer         = Function.showPopLayer
    --获取用户信息
    SystemServiceProxy:getInstance():sendGetUgameInfo()
    LogicServiceProxy:getInstance():sendGetCreateStatus()
    RoomData:getInstance():reset()
end

function LobbyScene:onExit()
    print('LobbyScene:onExit')
end

return LobbyScene
