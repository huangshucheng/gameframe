local GameScene = GT.GameScene or {}

local Cmd               	= require("game.net.protocol.Cmd")
local Respones          	= require("game.net.Respones")
local cmd_name_map      	= require("game.net.protocol.cmd_name_map")

function GameScene:addServerEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
end

function GameScene:addClientEventListener()
    addEvent("DessolveRes",self, self.onEventDessolve)
    addEvent("ExitRoomRes",self, self.onEventExitRoom)
end

function GameScene:onEventData(event)
    local data = event._usedata
    if not data then return end

    dump(data)
    postEvent(cmd_name_map[data.ctype], data.body)  -- post all client event to evety poplayer

    local ctype = data.ctype
    if ctype == Cmd.eRelogin then
        self:enterScene('game.Lobby.LobbyScene.LoginScene')
        GT.showPopLayer('TipsLayer',{'帐号在其他地方登录!'})
    end
end

function GameScene:onEventNetConnect(envet)
        GT.showPopLayer('TipsLayer',{"网络连接成功!"})
end

function GameScene:onEventNetConnectFail(envet)
        GT.showPopLayer('TipsLayer',{"网络连接失败!"}) 
end

function GameScene:onEventClose(envet)
        GT.showPopLayer('TipsLayer',{"网络连接关闭111!"})
end

function GameScene:onEventClosed(envet)
        GT.showPopLayer('TipsLayer',{"网络连接关闭222!"})
end

function GameScene:onEventDessolve(event)
    local data = event._usedata
    if data.status == Respones.OK then
        self:enterScene('game.Lobby.LobbyScene.LobbyScene')
    else
        GT.showPopLayer('TipsLayer',{"解散房间失败"})
    end
end

function GameScene:onEventExitRoom(event)
    local data = event._usedata
    if data.status == Respones.OK then
        local seatid = data.user_info.seatid
        if seatid == 1 then
            self:enterScene('game.Lobby.LobbyScene.LobbyScene')
        else
            -- other player exit room success
        end
    else
        -- self or other player exit room failed
        GT.showPopLayer('TipsLayer',{"退出房间失败!"})
    end
end