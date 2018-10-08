local LobbyScene = class("LobbyScene", cc.load("mvc").ViewBase)

local ByteArray         = require("game.utils.ByteArray")
local NetWork           = require("game.net.NetWork")
local ProtoMan          = require("game.utils.ProtoMan")
local cmd_name_map      = require("game.net.cmd_name_map")
local Cmd               = require("game.net.Cmd")
local Stype             = require("game.net.Stype")

LobbyScene.RESOURCE_FILENAME = 'LobbyScene.csb'

function LobbyScene:createResourceNode(resourceFilename)
    LobbyScene.super.createResourceNode(self,resourceFilename)
    self:getResourceNode():setContentSize(display.size)
    ccui.Helper:doLayout(self:getResourceNode())
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
