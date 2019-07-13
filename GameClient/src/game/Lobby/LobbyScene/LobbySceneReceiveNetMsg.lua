local LobbyScene = class("LobbyScene")

local UserInfo              = require("game.clientdata.UserInfo")
local AuthServiceProxy      = require("game.modules.AuthServiceProxy")
local HeartBeat             = require("game.Lobby.Base.HeartBeat")
local NetWork               = require("game.net.NetWork")
local Respones              = require("game.net.Respones")

function LobbyScene:initNetEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self._lobbyScene, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self._lobbyScene, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self._lobbyScene, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self._lobbyScene, self.onEventClosed)
    addEvent(ClientEvents.ON_NETWORK_OFF, self, self._lobbyScene, self.onEventNetWorkOff)
    addEvent("HeartBeatRes", self, self._lobbyScene, self.onEventHeartBeat)
end

function LobbyScene:onEventNetConnect(envet)
    Lobby.showPopLayer('TipsLayer',{"网络连接成功!"})
    Lobby.popLayer('LoadingLayer')
    HeartBeat:getInstance():resetHeartBeatCount()
    --重新登录
    local loginType = UserInfo.getLoginType()
    print('loginType: '.. loginType)
    if loginType == 'uname' then
        local name  = UserInfo.getUserAccount() 
        local pwd   = UserInfo.getUserPwd()
        AuthServiceProxy:getInstance():sendUnameLogin(name,pwd)
    elseif loginType == 'guest' then
        local guestkey = UserInfo.getUserGuestKey()
        AuthServiceProxy:getInstance():sendGuestLogin(guestkey)
    end
end

function LobbyScene:onEventNetConnectFail(envet)
    Lobby.showPopLayer('TipsLayer',{"网络连接失败!"})
    Lobby.showPopLayer('LoadingLayer')
end

function LobbyScene:onEventClose(envet)
    Lobby.showPopLayer('LoadingLayer')
end

function LobbyScene:onEventClosed(envet)
    Lobby.showPopLayer('LoadingLayer')
end

function LobbyScene:onEventHeartBeat(event)
    local body = event._usedata
    if body.status == Respones.OK then
        print('LobbyScene>> onEventHeartBeat')
        HeartBeat:getInstance():onHeartBeat()
    end
end

function LobbyScene:onEventNetWorkOff(event)
    NetWork:getInstance():reConnect()
end

return LobbyScene