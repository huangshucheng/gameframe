local LobbyScene = class("LobbyScene", cc.load("mvc").ViewBase)

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.Cmd")
local Stype             = require("game.net.Stype")
local Respones          = require("game.net.Respones")
local UserInfo          = require("game.clientdata.UserInfo")

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

function LobbyScene:ctor(app, name)
    self._user_name_text    = nil
    self._user_id_text      = nil
    self._coin_text         = nil
    self._diamond_text      = nil

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

    self._user_name_text = ccui.Helper:seekWidgetByName(img_top_bg, TEXT_USER_NAME)
    self._user_id_text = ccui.Helper:seekWidgetByName(img_top_bg, TEXT_USER_ID)
    self._coin_text = ccui.Helper:seekWidgetByName(img_top_bg, TEXT_COIN)
    self._diamond_text = ccui.Helper:seekWidgetByName(img_top_bg, TEXT_DIAMOND)
    if self._user_name_text then
        self._user_name_text:setString(UserInfo.getUserName())
    end
    if self._user_id_text then
        self._user_id_text:setString('ID:00000' .. UserInfo.getUserId())
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
    local count = GT.RootLayer:getInstance():getLayerCount()
    print("all layer start \n")
    local allLayer = GT.RootLayer:getInstance():getAllLayers()
    print( 'allLayers: ' .. tostring(allLayer) .. '   size: ' .. #allLayer )

    for k,v in pairs(allLayer) do
        print('layer: '.. tostring(v) .. "  ,name: " .. v:getName())
    end
    print("all layer end \n")
end

function LobbyScene:onTouchMessageBtn(send, evnetType)
    -- NetWork:getInstance():sendMsg(Stype.System,Cmd.eGetUgameInfoReq,nil)     --游戏信息 OK
    -- NetWork:getInstance():sendMsg(Stype.System,Cmd.eRecvLoginBonuesReq,nil)  --登录奖励  NO
    -- NetWork:getInstance():sendMsg(Stype.System,Cmd.eGetWorldRankUchipReq,nil)   --排行榜 OK
    -- NetWork:getInstance():sendMsg(Stype.System,Cmd.eGetSysMsgReq,{ver_num = 1}) --系统消息  OK
    -- GT.showPopLayer("LoadingLayer")
end

function LobbyScene:onTouchMailBtn(send, evnetType)
    
end

function LobbyScene:addEventListenner()
    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
    addEvent(ServerEvents.ON_SERVER_EVENT_MSG_SEND, self, self.onEventMsgSend)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_NETLOWER, self, self.onEventNetLower)

    -- clientEvent
    addEvent(ClientEvents.ON_ASYC_USER_INFO, self, self.onEventAsycUserInfo)
end


function LobbyScene:onEventData(event)
    local data = event._usedata
    if not data then
        return
    end
    dump(data)
    local ctype = data.ctype

    if ctype == Cmd.eEditProfileRes then
        GT.popLayer('LoadingLayer')
    elseif ctype == Cmd.eAccountUpgradeRes then
        GT.popLayer('LoadingLayer')
    elseif ctype == Cmd.eRelogin then
        self:getApp():enterScene('LoginScene')
        GT.popLayer('LoadingLayer')
        gt.showPopLayer('TipsLayer',{'帐号在其他地放登录!'})
    elseif ctype == Cmd.eUnameLoginRes then
        GT.popLayer('LoadingLayer')
    elseif ctype == Cmd.eLoginOutRes then
        self:getApp():enterScene('LoginScene')
        GT.popLayer('LoadingLayer')
    elseif ctype == Cmd.eGetUgameInfoRes then
        GT.popLayer('LoadingLayer')
        local body = data.body
        if body.status == 1 then
            if self._coin_text and self._diamond_text then
                self._coin_text:setString(tostring(body.uinfo.uchip))
                self._diamond_text:setString(tostring(body.uinfo.uchip2))
            end
        end
    elseif ctype == Cmd.eRecvLoginBonuesRes then
        if data.body.status == 1 then
            NetWork:getInstance():sendMsg(Stype.System,Cmd.eGetUgameInfoReq,nil)
        end
        GT.popLayer('LoadingLayer')
    elseif ctype == Cmd.eGetWorldRankUchipRes then
        local body = data.body
        if body.status == 1 then
            local rank_info = body.rank_info
            print('rank-----------------------------start')
            dump(rank_info)
            print('rank-----------------------------end')
        end
    end
end 

function LobbyScene:onEventMsgSend(envet)
    
end

function LobbyScene:onEventNetConnect(envet)
        GT.showPopLayer('TipsLayer',{"网络连接成功!"})
end

function LobbyScene:onEventNetConnectFail(envet)
        GT.showPopLayer('TipsLayer',{"网络连接失败!"}) 
end

function LobbyScene:onEventClose(envet)
        GT.showPopLayer('TipsLayer',{"网络连接关闭!"})
end

function LobbyScene:onEventClosed(envet)
        GT.showPopLayer('TipsLayer',{"网络连接关闭!"})
end

function LobbyScene:onEventNetLower(envet)
        GT.showPopLayer('TipsLayer',{"网络连接不稳定!"})
end

function LobbyScene:onEventAsycUserInfo(event)
    local uname = UserInfo.getUserName()
    if uname and uname ~= '' then
        self._user_name_text:setString(tostring(uname))
    end
end
--------------------

function LobbyScene:onEnter()
    print('LobbyScene:onEnter')
    print("all layer start \n")
    local allLayer = GT.RootLayer:getInstance():getAllLayers()
    print( 'allLayers: ' .. tostring(allLayer) .. '   size: ' .. #allLayer )

    for k,v in pairs(allLayer) do
        print('layer: '.. tostring(v) .. "  ,name: " .. v:getName())
    end
    print("all layer end \n")
    --获取用户信息
    NetWork:getInstance():sendMsg(Stype.System,Cmd.eGetUgameInfoReq,nil)
end

function LobbyScene:onExit()
    print('LobbyScene:onExit')
    GT.clearLayers()
end

return LobbyScene
