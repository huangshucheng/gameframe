local LobbyScene = class("LobbyScene")
--[[
function LobbyScene:addServerEventListener()
    -- addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
    -- addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    -- addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    -- addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    -- addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
    print("hcc>> LobbyScene:addServerEventListener")
end
]]
--[[
function LobbyScene:onEventData(event)
	print("hcc>> LobbyScene:onEventData"
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
]]
--[[
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
]]

return LobbyScene