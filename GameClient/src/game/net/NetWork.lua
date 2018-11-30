local NetWork         = class("NetWork")

local SocketTCP         = require("game.net.SocketTCP")
local ByteArray         = require("game.utils.ByteArray")
local BitUtil           = require("game.utils.BitUtil")
local TcpPacker         = require("game.utils.TcpPacker")
local ConfigKeyWord     = require("game.net.ConfigKeyWord")
local ProtoMan          = require("game.utils.ProtoMan")
local Cmd               = require("game.net.protocol.Cmd")
local cmd_name_map      = require("game.net.protocol.cmd_name_map")
local Stype             = require("game.net.Stype")

local socket            = require "socket"

local HEADER_SIZE       = 2

local __name            = 'NetWork>> '
local __buf             = ByteArray.new(ByteArray.ENDIAN_LITTLE)

function NetWork:getInstance()
    if not NetWork._instance then
        NetWork._instance = NetWork.new()
    end
    return NetWork._instance
end

function NetWork:ctor()
    self._ip         	= ConfigKeyWord.ip
    self._port       	= ConfigKeyWord.port
    self._isEncrypt  	= false

    self._socketTCP     = SocketTCP.new(self._ip,self._port,true)
    self._socketTCP:setReconnTime(0)
    
    self:addEventListenner()
    -- TODO 加密
end

function NetWork:addEventListenner()
    if self._socketTCP then
        self._socketTCP:addEventListener(SocketTCP.EVENT_CONNECTED, handler(self,self.onConnect))
        self._socketTCP:addEventListener(SocketTCP.EVENT_DATA, handler(self, self.onMessage))
        self._socketTCP:addEventListener(SocketTCP.EVENT_CLOSE, handler(self,self.onClose))
        self._socketTCP:addEventListener(SocketTCP.EVENT_CLOSED, handler(self,self.onClosed))
        self._socketTCP:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self.onConnectFail))
    end
end
-------- event start --------

function NetWork:onConnect(stats)
	print(__name .. "onConnect>> 连接成功")
    postEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT)
end

-- 接收数据
function NetWork:onMessage(event)
   if event.data == nil then return end
    local data_tb = self:_onReciveMsg(event.data)
    if data_tb then
        for index = 1 , #data_tb do
            local tb = ProtoMan:getInstance():unpack_protobuf_cmd(data_tb[index])
            if cmd_name_map[tb.ctype] then
                postEvent(cmd_name_map[tb.ctype],tb.body)
                if tb.ctype ~= Cmd.eHeartBeatRes then
                    dump(tb,'[协议:' .. tostring(cmd_name_map[tb.ctype]) .. ']',5)
                end
            end
        end
    end
end

function NetWork:onClose()
	print(__name .. " onClose>> 连接失败1")
    postEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE)
end

function NetWork:onClosed()
	print(__name .. " onClosed>> 连接失败2")
    postEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED)
end

function NetWork:onConnectFail()
    print(__name .. " onConnectFail>> 连接失败")
    postEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL)
end

-------- event end --------

-------- interface start --------

function NetWork:start()
   if self._socketTCP then
   		self._socketTCP:connect()
   end
end

function NetWork:reConnect()
    self._socketTCP = SocketTCP.new(self._ip,self._port,false)

    if self._socketTCP then
    	self._socketTCP:connect()
    end
end

function NetWork:stop()
	if self._socketTCP then
   		self._socketTCP:disconnect()
	end
end

function NetWork:isConnected()
    if self._socketTCP then
        return self._socketTCP.isConnected
    end
end

function NetWork:disconnect()
    if self._socketTCP then
    	self._socketTCP:disconnect()
    end
end

function NetWork:sendMsg(stype, ctype, packet)
    local proto_cmd = ProtoMan:getInstance():pack_protobuf_cmd(stype,ctype,packet)
    if proto_cmd then
        local pkt = TcpPacker:getInstance():tcp_pack(proto_cmd)
        if self._socketTCP and pkt then
         	self._socketTCP:send(pkt)
        end
    end
end
-- 粘包处理
function NetWork:_onReciveMsg(msg)
    if not __buf then return end
    local msgs_tb = {}
    __buf:setPos(__buf:getLen()+1)
    __buf:writeStringBytes(msg)
    __buf:setPos(1)

    while __buf:getAvailable() >= HEADER_SIZE do  -- 可读取长度 >= 消息体长度
        local bodyLen = __buf:readShort()
        
        if __buf:getAvailable() < bodyLen - HEADER_SIZE then
            __buf:setPos(__buf:getPos() - HEADER_SIZE)
            break
        end
        msgs_tb[#msgs_tb+1] = __buf:readStringBytes(bodyLen - HEADER_SIZE)
    end

    if __buf:getAvailable() <= 0 then
        -- clear buffer on exhausted
        __buf = NetWork.getBaseBA()
    else
        -- some datas in buffer yet, write them to a new blank buffer.
        local tmpBuf = NetWork.getBaseBA()
        __buf:readBytes(tmpBuf, 1, __buf:getAvailable())    -- 将__buf 写到 tmpBuf
        __buf = tmpBuf
    end

    return msgs_tb
end
-------- interface end --------

function NetWork.getBaseBA()
    return ByteArray.new(ByteArray.ENDIAN_LITTLE)
end

return NetWork