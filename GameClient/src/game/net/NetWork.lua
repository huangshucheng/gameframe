local NetWork         = class("NetWork")

local SocketTCP         = require("game.net.SocketTCP")
local ByteArray         = require("game.utils.ByteArray")
local BitUtil           = require("game.utils.BitUtil")
local TcpPacker         = require("game.utils.TcpPacker")
local ConfigKeyWord     = require("game.net.ConfigKeyWord")
local ProtoMan          = require("game.utils.ProtoMan")

local socket            = require "socket"

local HEADER_SIZE       = 2

local __name            = 'NetWork>> '
local __buf             = ByteArray.new(ByteArray.ENDIAN_LITTLE)

function NetWork:getInstance()
    if not self._instance then
        self._instance = NetWork.new()
    end
    return self._instance
end

function NetWork:ctor()
    self._ip         	= ConfigKeyWord.ip
    self._port       	= ConfigKeyWord.port
    self._isEncrypt  	= false
    self._key        	= "123456"
    self._lastDealStr 	= ""

    self._socketTCP     = SocketTCP.new(self._ip,self._port,true)
    self._socketTCP:setReconnTime(0)
    
    self._lastRecvHeartbeat = 0
    self:addEventListenner()

    print(__name .. "  ip: " .. self._ip .. "  ,port: " .. tostring(self._port))
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
    self._lastRecvHeartbeat = os.time()
    postEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT)
end

-- 接收数据
function NetWork:onMessage(event)
	print(__name .. " onMessage>> 收到消息------------start\n")

   if event.data == nil then return end
    --[[
    local ba = ByteArray.new(ByteArray.ENDIAN_LITTLE)
    ba:writeBuf(event.data) --可能有两个包
    ba:setPos(1)
    if  ba:getAvailable() <= ba:getLen() then
        local msg_byte = ByteArray.new(ByteArray.ENDIAN_LITTLE)
        msg_byte:writeBuf(event.data)
        msg_byte:setPos(1)
        local len = msg_byte:readShort()
        print("可读长度1：" .. msg_byte:getAvailable())
        local data = msg_byte:readString(len - 2)
        print("可读长度2：" .. msg_byte:getAvailable())
        print("包长度：" .. tostring(len))
        print("数据：" .. data)    --proto buf msg
        local tb = ProtoMan:getInstance():unpack_protobuf_cmd(data)
        dump(tb)
        postEvent(ServerEvents.ON_SERVER_EVENT_DATA, tb)
    end
    ]]
    -- 解连包
    local data_tb = self:_onReciveMsg(event.data)
    print("size: >>>>  " .. #data_tb)
    for _ , v in pairs(data_tb) do
        local tb = ProtoMan:getInstance():unpack_protobuf_cmd(v)
        postEvent(ServerEvents.ON_SERVER_EVENT_DATA , tb)
    end
    print(__name .. " onMessage>> 收到消息------------end\n")
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
   self._lastRecvHeartbeat = os.time()

   if self._socketTCP then
   		self._socketTCP:connect()
   end
end

function NetWork:reConnect()
    self._lastRecvHeartbeat = os.time()
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
            postEvent(ServerEvents.ON_SERVER_EVENT_MSG_SEND, pkt)
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