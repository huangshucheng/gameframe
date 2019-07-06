local LoginScene = class('LoginScene')

local Cmd               = require("game.net.protocol.Cmd")
local Respones          = require("game.net.Respones")
local UserInfo          = require("game.clientdata.UserInfo")
local LogicServiceProxy = require("game.modules.LogicServiceProxy")
local cmd_name_map      = require("game.net.protocol.cmd_name_map")

function LoginScene:initNetEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self._loginScene, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self._loginScene, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self._loginScene, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self._loginScene, self.onEventClosed)
end

function LoginScene:initClientEventListener()
	addEvent("GuestLoginRes", self, self._loginScene, self.onEventGuestLogin)
	addEvent("UnameLoginRes", self, self._loginScene, self.onEventUnameLoginRes)
	addEvent("UserRegistRes", self, self._loginScene, self.onEventUserRegistRes)
end

function LoginScene:onEventGuestLogin(event)
	local body = event._usedata
  	if body then
        Lobby.popLayer('LoadingLayer')
        if body.status == Respones.OK then
            UserInfo.setUInfo(body.uinfo)
            UserInfo.setUserIsGuest(true)
            LogicServiceProxy:getInstance():sendLoginLogicServer()
            Lobby.showPopLayer('TipsLayer',{"游客登录成功!"})
            local lobbyScene = require("game.Lobby.LobbyScene.LobbyScene"):create()
            lobbyScene:run()
        else
            Lobby.showPopLayer('TipsLayer',{"游客登录失败，您帐号已升级成正式帐号!"})
        end
   	end
end

function LoginScene:onEventUnameLoginRes(event)
	local body = event._usedata
 	Lobby.popLayer('LoadingLayer')
    if body.status == Respones.OK then
        UserInfo.setUInfo(body.uinfo)
        LogicServiceProxy:getInstance():sendLoginLogicServer()
        Lobby.showPopLayer('TipsLayer',{"登录成功!"})
        local lobbyScene = require("game.Lobby.LobbyScene.LobbyScene"):create()
        lobbyScene:run()
    else
        Lobby.showPopLayer('TipsLayer',{"登录失败,帐号或密码错误!"})
    end
end

function LoginScene:onEventUserRegistRes(event)
   	local body = event._usedata
    Lobby.popLayer('LoadingLayer')
    if body.status == Respones.OK then
        Lobby.showPopLayer('TipsLayer',{"注册成功!"})
    else
        Lobby.showPopLayer('TipsLayer',{"注册失败!"})
    end
end

function LoginScene:onEventNetConnect(event)
    Lobby.showPopLayer('TipsLayer',{"网络连接成功!"})
    Lobby.popLayer('LoadingLayer')
end

function LoginScene:onEventNetConnectFail(event)
   Lobby.showPopLayer('TipsLayer',{"网络连接失败!"}) 
end

function LoginScene:onEventClose(event)
end

function LoginScene:onEventClosed(event)
end

return LoginScene