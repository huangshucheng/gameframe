local SocketTCP = class("SocketTCP")

local SOCKET_RECONNECT_TIME 		= 5			-- socket reconnect try interval
local SOCKET_CONNECT_FAIL_TIMEOUT 	= 3			-- socket failure timeout

local STATUS_CLOSED                 = "closed"
local STATUS_NOT_CONNECTED          = "Socket is not connected"
local STATUS_ALREADY_CONNECTED      = "already connected"
local STATUS_ALREADY_IN_PROGRESS    = "Operation already in progress"
local STATUS_TIMEOUT                = "timeout"

SocketTCP.EVENT_DATA                = "SOCKET_TCP_DATA"
SocketTCP.EVENT_CLOSE               = "SOCKET_TCP_CLOSE"
SocketTCP.EVENT_CLOSED              = "SOCKET_TCP_CLOSED"
SocketTCP.EVENT_CONNECTED           = "SOCKET_TCP_CONNECTED"
SocketTCP.EVENT_CONNECT_FAILURE     = "SOCKET_TCP_CONNECT_FAILURE"

local Scheduler     = require("game.utils.scheduler")
local socket        = require "socket"

SocketTCP._VERSION 	= socket._VERSION
SocketTCP._DEBUG 	= socket._DEBUG

function SocketTCP:ctor(__host, __port, __retryConnectWhenFailure)
	cc.bind(self, "event")
    self.host = __host
    self.port = __port
	self.tickScheduler = nil			-- timer for data
	self.reconnectScheduler = nil		-- timer for reconnect
	self.connectTimeTickScheduler = nil	-- timer for connect timeout
	self.name = 'SocketTCP'
	self.tcp = nil
	self.isRetryConnect = __retryConnectWhenFailure
	self.isConnected = false

end

function SocketTCP:setName( __name )
	self.name = __name
	return self
end

function SocketTCP:setReconnTime(__time)
	SOCKET_RECONNECT_TIME = __time
	return self
end

function SocketTCP:setConnFailTime(__time)
	SOCKET_CONNECT_FAIL_TIMEOUT = __time
	return self
end

local function isIpv6(_domain)
    local result = socket.dns.getaddrinfo(_domain)
    local ipv6 = false
    if result then
    	if result[1].family == "inet6" then
    		ipv6 = true
    	end
    end
    return ipv6
end

function SocketTCP:connect(__host, __port, __retryConnectWhenFailure)
	if __host then self.host = __host end
	if __port then self.port = __port end
	if __retryConnectWhenFailure ~= nil then self.isRetryConnect = __retryConnectWhenFailure end
	assert(self.host or self.port, "Host and port are necessary!")

	if isIpv6(self.host) then
		self.tcp = socket.tcp6()
	else
		self.tcp = socket.tcp()
	end

	self.tcp:settimeout(0)

	if not self:_checkConnect() then
		if self.connectTimeTickScheduler then Scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
		self.connectTimeTickScheduler = Scheduler.scheduleUpdateGlobal(handler(self, self._connectTimeTick))
	end
end

function SocketTCP:send(__data)
	if not self.isConnected then return end
	-- assert(self.isConnected, self.name .. " is not connected.")
    if not __data then return end
	self.tcp:send(__data)
end

function SocketTCP:close( ... )
	self.tcp:close()
	if self.connectTimeTickScheduler then Scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
	if self.tickScheduler then Scheduler.unscheduleGlobal(self.tickScheduler) end
	self:dispatchEvent({name = SocketTCP.EVENT_CLOSE})
end

function SocketTCP:disconnect()
	self:_disconnect()
	self.isRetryConnect = false
end

function SocketTCP.getTime()
	return socket.gettime()
end

-------------------- private --------------------

function SocketTCP:_checkConnect()
	local __succ = self:_connect()
	if __succ then
		self:_onConnected()
	end
	return __succ
end

function SocketTCP:_connectTimeTick(dt)
	if self.isConnected then return end
	self.waitConnect = self.waitConnect or 0
	self.waitConnect = self.waitConnect + dt
	if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
		self.waitConnect = nil
		self:close()
		self:_connectFailure()
	end
	self:_checkConnect()
end

function SocketTCP:_tick(dt)
	local __body, __status, __partial = self.tcp:receive("*a")	-- read the package body
    if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
    	self:close()
    	if self.isConnected then
    		self:_onDisconnect()
    	else
    		self:_connectFailure()
    	end
   		return
	end
    if 	(__body and string.len(__body) == 0) or
		(__partial and string.len(__partial) == 0)
	then return end
	if __body and __partial then __body = __body .. __partial end
	self:dispatchEvent({name = SocketTCP.EVENT_DATA , data = (__partial or __body) , partial = __partial , body = __body})
end

function SocketTCP:_connect()
	local __succ, __status = self.tcp:connect(self.host, self.port)
	return __succ == 1 or __status == STATUS_ALREADY_CONNECTED
end

function SocketTCP:_disconnect()
	self.isConnected = false
	self.tcp:shutdown()
	self:dispatchEvent({name = SocketTCP.EVENT_CLOSED})
end

function SocketTCP:_onDisconnect()
	self.isConnected = false
	self:_reconnect();
	self:dispatchEvent({name = SocketTCP.EVENT_CLOSED})
end

function SocketTCP:_onConnected()
	self.isConnected = true
	if self.connectTimeTickScheduler then Scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end	
	self.tickScheduler = Scheduler.scheduleUpdateGlobal(handler(self, self._tick))
	self:dispatchEvent({name = SocketTCP.EVENT_CONNECTED})
end

function SocketTCP:_connectFailure(status)
	self:_reconnect();
	self:dispatchEvent({name = SocketTCP.EVENT_CONNECT_FAILURE})
end

function SocketTCP:_reconnect(__immediately)
	if not self.isRetryConnect then return end
	if __immediately then self:connect() return end
	
	if self.reconnectScheduler then 
		Scheduler.unscheduleGlobal(self.reconnectScheduler) 
	end

	self.reconnectScheduler = Scheduler.performWithDelayGlobal(function()
	 	self:connect()
	end, SOCKET_RECONNECT_TIME)
end

return SocketTCP
