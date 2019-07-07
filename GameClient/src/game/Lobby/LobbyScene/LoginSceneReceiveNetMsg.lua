local LoginScene = class('LoginScene')

function LoginScene:initNetEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self._loginScene, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self._loginScene, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self._loginScene, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self._loginScene, self.onEventClosed)
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