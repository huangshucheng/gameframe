local SocketUDP = class("SocketUDP")

local Scheduler     = require("game.utils.scheduler")
local ConfigKeyWord = require("game.net.ConfigKeyWord")
local socket        = require "socket"

SocketUDP.EVENT_DATA = 'SOCKET_UDP_DATA'

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

function SocketUDP:ctor()
	cc.bind(self, "event")
    self.host = ConfigKeyWord.ip
    self.port = ConfigKeyWord.udp_port
	self.tickScheduler = nil

	if isIpv6(self.host) then
		self.udp = socket.udp6()
	else
		self.udp = socket.udp()
	end
	
	if self.udp then
		self.udp:settimeout(0)
		self.udp:setpeername(self.host, self.port)	--绑定远程端口
		self.tickScheduler = Scheduler.scheduleUpdateGlobal(handler(self, self._tick))
		print('hcc>>tick ' .. tostring(self.tickScheduler))
	end
end

function SocketUDP:_tick(dt)
	if self.udp then
		local __data = self.udp:receive()		--receive目前该默认大小为8192字节
		if __data then
			self:dispatchEvent({name = SocketUDP.EVENT_DATA, data = __data})
		end
	end
end

function SocketUDP:send(data)
    if self.udp and data then
		self.udp:send(data)
    end
end

function SocketUDP:close()
	if self.udp then
		self.udp:close()
		self.udp = nil
	end
	if self.tickScheduler then
		Scheduler.unscheduleGlobal(self.tickScheduler)
		self.tickScheduler = nil
	end	
end

return SocketUDP
