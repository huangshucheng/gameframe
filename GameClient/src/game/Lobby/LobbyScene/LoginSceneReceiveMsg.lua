local LoginScene = class('LoginScene')

local Cmd               = require("game.net.protocol.Cmd")
local Respones          = require("game.net.Respones")
local UserInfo          = require("game.clientdata.UserInfo")
local LogicServiceProxy = require("game.modules.LogicServiceProxy")
local cmd_name_map      = require("game.net.protocol.cmd_name_map")

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

return LoginScene