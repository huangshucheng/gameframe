local LoginScene = GT.LoginScene or {}

local Cmd               = require("game.net.protocol.Cmd")
local Respones          = require("game.net.Respones")
local UserInfo          = require("game.clientdata.UserInfo")
local LogicServiceProxy = require("game.modules.LogicServiceProxy")
local cmd_name_map      = require("game.net.protocol.cmd_name_map")

function LoginScene:addServerEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
end

function LoginScene:addClientEventListener()
	addEvent("GuestLoginRes", self, self.onEventGuestLogin)
	addEvent("UnameLoginRes", self, self.onEventUnameLoginRes)
	addEvent("UserRegistRes", self, self.onEventUserRegistRes)
end

function LoginScene:onEventData(event)
    local data = event._usedata
    if not data then return end
    dump(data)
    postEvent(cmd_name_map[data.ctype], data.body)
end

function LoginScene:onEventGuestLogin(event)
	local body = event._usedata
  	if body then
        GT.popLayer('LoadingLayer')
        if body.status == Respones.OK then
            local uinfo = body.uinfo
            UserInfo.setUserName(uinfo.unick)
            UserInfo.setUserface(uinfo.uface)
            UserInfo.setUserSex(uinfo.usex)
            UserInfo.setUserVip(uinfo.uvip)
            UserInfo.setUserId(uinfo.uid)
            UserInfo.setUserIsGuest(true)
            UserInfo.flush()
            self:enterScene('game.Lobby.LobbyScene.LobbyScene')
            GT.showPopLayer('TipsLayer',{"游客登录成功!"})
        else
            GT.showPopLayer('TipsLayer',{"游客登录失败，您帐号已升级成正式帐号!"})
        end
   	end
end

function LoginScene:onEventUnameLoginRes(event)
	local body = event._usedata
 	GT.popLayer('LoadingLayer')
    if body.status == Respones.OK then
        local uinfo = body.uinfo
        UserInfo.setUserName(uinfo.unick)
        UserInfo.setUserface(uinfo.uface)
        UserInfo.setUserSex(uinfo.usex)
        UserInfo.setUserVip(uinfo.uvip)
        UserInfo.setUserId(uinfo.uid)
        UserInfo.flush()
        -- login logic server
        LogicServiceProxy:getInstance():sendLoginLogicServer()
        self:enterScene('game.Lobby.LobbyScene.LobbyScene')
        GT.showPopLayer('TipsLayer',{"登录成功!"})
    else
        GT.showPopLayer('TipsLayer',{"登录失败,帐号或密码错误!"})
    end
end

function LoginScene:onEventUserRegistRes(event)
   	local body = event._usedata
    GT.popLayer('LoadingLayer')
    if body.status == Respones.OK then
        GT.showPopLayer('TipsLayer',{"注册成功!"})
    else
        GT.showPopLayer('TipsLayer',{"注册失败!"})
    end
end

function LoginScene:onEventNetConnect(event)
    GT.showPopLayer('TipsLayer',{"网络连接成功!"})
end

function LoginScene:onEventNetConnectFail(event)
   GT.showPopLayer('TipsLayer',{"网络连接失败!"}) 
end

function LoginScene:onEventClose(event)
    GT.showPopLayer('TipsLayer',{"网络连接关闭111!"})
end

function LoginScene:onEventClosed(event)
    GT.showPopLayer('TipsLayer',{"网络连接关闭222!"})
end