local SocketUDP = class("SocketUDP")

local Scheduler     = require("game.utils.scheduler")
local ProtoMan 		= require("game.utils.ProtoMan")
local ConfigKeyWord = require("game.net.ConfigKeyWord")
local socket        = require "socket"

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
	self.name = 'SocketUDP'

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
		print('hcc>>self.tickScheduler: ' .. tostring(self.tickScheduler))
	end
end
local index = 0
function SocketUDP:_tick(dt)
	if self.udp then
		--receive目前该默认大小为8192字节
		local __body = self.udp:receive()
		if __body then
			index = index + 1
			local tb = ProtoMan:getInstance():unpack_protobuf_cmd(__body)
			dump(tb,"hcc>>udp tb " .. index)
		end
	end
end

function SocketUDP:setName(name)
	self.name = name
	return self
end

function SocketUDP:send(data)
    if self.udp and data then
		self.udp:send(data)
    end
end

function SocketUDP:sendMsg(stype, ctype, packet)
    local proto_cmd = ProtoMan:getInstance():pack_protobuf_cmd(stype,ctype,packet)
    if proto_cmd then
        if self.udp then
         	self:send(proto_cmd)
        end
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
