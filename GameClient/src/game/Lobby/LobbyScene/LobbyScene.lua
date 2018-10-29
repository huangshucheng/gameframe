local BaseScene     = require("game.views.Base.BaseScene")
local LobbyScene    = class("LobbyScene", BaseScene)

local Cmd                   = require("game.net.protocol.Cmd")
local Respones              = require("game.net.Respones")
local cmd_name_map          = require("game.net.protocol.cmd_name_map")
local UserInfo              = require("game.clientdata.UserInfo")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local SystemServiceProxy    = require("game.modules.SystemServiceProxy")
local Function              = require('game.views.Base.Function')

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

function LobbyScene:ctor(app, name)
    self._user_name_text    = nil
    self._user_id_text      = nil
    self._coin_text         = nil
    self._diamond_text      = nil
    self._img_head          = nil

    GT.showPopLayer         = Function.showPopLayer
    GT.clearLayers          = Function.clearLayers

    LobbyScene.super.ctor(self, app, name)
end

function LobbyScene:onCreate()
    local panel_center          = self:getResourceNode():getChildByName(PANEL_CENTER)
    if  not panel_center then return end

    local btn_join_room         = panel_center:getChildByName(IMG_JOIN_ROOM)
    local btn_create_room       = panel_center:getChildByName(IMG_CREATE_ROOM)
    local btn_back_room         = panel_center:getChildByName(IMG_BACK_ROOM)

    if btn_join_room then
        btn_join_room:addTouchEventListener(handler(self,self.onTouchJoinRoomBtn))
    end

    if btn_create_room then
        btn_create_room:addTouchEventListener(handler(self,self.onTouchCreateRoomBtn))
    end

    if btn_back_room then
        btn_back_room:addTouchEventListener(handler(self,self.onTouchBackRoomBtn))
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
        self._user_id_text:setString('ID:00000' .. UserInfo.getUserId())
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
    self:enterScene('game.Mahjong.GameScene.GameScene')
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

function LobbyScene:addServerEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
end

function LobbyScene:addClientEventListener()
    addEvent(ClientEvents.ON_ASYC_USER_INFO, self, self.onEventAsycUserInfo)
end

function LobbyScene:onEventData(event)
    local data = event._usedata
    if not data then return end

    postEvent(cmd_name_map[data.ctype], data.body)  -- post all client event to evety poplayer

    dump(data)

    local ctype = data.ctype
    if ctype == Cmd.eEditProfileRes then
        GT.popLayer('LoadingLayer')
    elseif ctype == Cmd.eAccountUpgradeRes then
        GT.popLayer('LoadingLayer')
    elseif ctype == Cmd.eRelogin then
        self:enterScene('game.Lobby.LobbyScene.LoginScene')
        GT.popLayer('LoadingLayer')
        GT.showPopLayer('TipsLayer',{'帐号在其他地方登录!'})
    elseif ctype == Cmd.eUnameLoginRes then
        GT.popLayer('LoadingLayer')
    elseif ctype == Cmd.eLoginOutRes then
        self:enterScene('game.Lobby.LobbyScene.LoginScene')
        GT.popLayer('LoadingLayer')
    elseif ctype == Cmd.eGetUgameInfoRes then
        GT.popLayer('LoadingLayer')
        local body = data.body
        if body.status == Respones.OK then
            if self._coin_text and self._diamond_text then
                self._coin_text:setString(tostring(body.uinfo.uchip))
                self._diamond_text:setString(tostring(body.uinfo.uchip2))
            end
        end
    elseif ctype == Cmd.eRecvLoginBonuesRes then
        GT.popLayer('LoadingLayer')
    elseif ctype == Cmd.eLoginLogicRes then
        GT.showPopLayer('TipsLayer',{"登录逻辑服成功!"})
    end
end

function LobbyScene:onEventNetConnect(envet)
        GT.showPopLayer('TipsLayer',{"网络连接成功!"})
end

function LobbyScene:onEventNetConnectFail(envet)
        GT.showPopLayer('TipsLayer',{"网络连接失败!"}) 
end

function LobbyScene:onEventClose(envet)
        GT.showPopLayer('TipsLayer',{"网络连接关闭111!"})
end

function LobbyScene:onEventClosed(envet)
        GT.showPopLayer('TipsLayer',{"网络连接关闭222!"})
end

function LobbyScene:onEventAsycUserInfo(event)
    local uname = UserInfo.getUserName()
    if uname and uname ~= '' then
        self._user_name_text:setString(tostring(uname))
    end

    if self._img_head then
        self._img_head:loadTexture(string.format('Lobby/LobbyRes/rectheader/1%s.png',UserInfo.getUserface()))
    end
end
--------------------

function LobbyScene:onEnter()
    print('LobbyScene:onEnter')
    --获取用户信息
    -- LogicServiceProxy:getInstance():sendLoginLogicServer()
    -- SystemServiceProxy:getInstance():sendGetUgameInfo()
    -- GT.clearLayers()
end

function LobbyScene:onExit()
    
end

return LobbyScene
