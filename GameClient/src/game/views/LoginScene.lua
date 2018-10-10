local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)

local ByteArray         = require("game.utils.ByteArray")
local NetWork           = require("game.net.NetWork")
local ProtoMan          = require("game.utils.ProtoMan")
local cmd_name_map      = require("game.net.cmd_name_map")
local Cmd               = require("game.net.Cmd")
local Stype             = require("game.net.Stype")

LoginScene.RESOURCE_FILENAME = 'LoginScene.csb'

function LoginScene:createResourceNode(resourceFilename)
    LoginScene.super.createResourceNode(self,resourceFilename)
    self:getResourceNode():setContentSize(display.size)
    ccui.Helper:doLayout(self:getResourceNode())

    local btn_guest_login = self:getResourceNode():getChildByName('BTN_GUEST_LOGIN')
    if btn_guest_login then
        btn_guest_login:addClickEventListener(handler(self,self.onEventBtnGuestLogin))
    end
end

function LoginScene:onCreate()
    self:addEventListenner()
end

function LoginScene:addEventListenner()
    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
    addEvent(ServerEvents.ON_SERVER_EVENT_MSG_SEND, self, self.onEventMsgSend)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_NETLOWER, self, self.onEventNetLower)
end


function LoginScene:onEventData(event)
    local data = event._usedata
    if not data then
        return
    end
    dump(data)
    if data.ctype == Cmd.eGuestLoginRes then
       if data.body then
            if data.body.status == 1 then
                 self:getApp():enterScene('LobbyScene')
            else
                print("login error " .. tostring(data.body.status))
            end
       end
    end
end

function LoginScene:onEventMsgSend(envet)
    
end

function LoginScene:onEventNetConnect(envet)
    
end

function LoginScene:onEventNetConnectFail(envet)

end

function LoginScene:onEventClose(envet)

end

function LoginScene:onEventClosed(envet)

end

function LoginScene:onEventNetLower(envet)

end

function LoginScene:onEventBtnGuestLogin(sender,eventType)
    local rdstr = math.random(100000, 999999)
    local keystr = tostring(rdstr) .. '8JvrDstUNDuTNnnCKFEw4pKFsn'
    print("rdstr: ".. keystr )
    keystr = '8JvrDstUNDuTNnnCKFEw4pKFsn666666'
    NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eGuestLoginReq,{guest_key = keystr})
end

return LoginScene
