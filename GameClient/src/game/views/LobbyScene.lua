local LobbyScene = class("LobbyScene", cc.load("mvc").ViewBase)

local ByteArray         = require("game.utils.ByteArray")
local NetWork           = require("game.net.NetWork")
local ProtoMan          = require("game.utils.ProtoMan")
local cmd_name_map      = require("game.net.cmd_name_map")
local Cmd               = require("game.net.Cmd")
local Stype             = require("game.net.Stype")

LobbyScene.RESOURCE_FILENAME = 'Lobby/LobbyScene.csb'

function LobbyScene:createResourceNode(resourceFilename)
    LobbyScene.super.createResourceNode(self,resourceFilename)
    self:getResourceNode():setContentSize(display.size)
    ccui.Helper:doLayout(self:getResourceNode())

    local panel_center          = self:getResourceNode():getChildByName('PANEL_CENTER')
    if  not panel_center then return end

    local btn_join_room         = panel_center:getChildByName('IMG_JOIN_ROOM')
    local btn_create_room       = panel_center:getChildByName('IMG_CREATE_ROOM')
    local btn_back_room         = panel_center:getChildByName('IMG_BACK_ROOM')

    if btn_join_room then
        btn_join_room:addTouchEventListener(handler(self,self.onTouchJoinRoomBtn))
    end

    if btn_create_room then
        btn_create_room:addTouchEventListener(handler(self,self.onTouchCreateRoomBtn))
    end

    if btn_back_room then
        btn_back_room:addTouchEventListener(handler(self,self.onTouchBackRoomBtn))
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

function LobbyScene:onCreate()
    self:addEventListenner()
end

function LobbyScene:addEventListenner()
    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
    addEvent(ServerEvents.ON_SERVER_EVENT_MSG_SEND, self, self.onEventMsgSend)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_NETLOWER, self, self.onEventNetLower)
end


function LobbyScene:onEventData(event)
    local data = event._usedata
    if not data then
        return
    end
    dump(data)
end

function LobbyScene:onEventMsgSend(envet)
    
end

function LobbyScene:onEventNetConnect(envet)

end

function LobbyScene:onEventNetConnectFail(envet)

end

function LobbyScene:onEventClose(envet)

end

function LobbyScene:onEventClosed(envet)

end

function LobbyScene:onEventNetLower(envet)

end

function LobbyScene:onEventBtnGuestLogin(sender,eventType)
   
end

return LobbyScene
