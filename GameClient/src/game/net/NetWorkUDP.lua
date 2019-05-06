local NetWorkUDP        = class("NetWorkUDP")

local SocketUDP         = require("game.net.SocketUDP")
local ConfigKeyWord     = require("game.net.ConfigKeyWord")
local ProtoMan          = require("game.utils.ProtoMan")
local cmd_name_map      = require("game.net.protocol.cmd_name_map")
local socket            = require "socket"

function NetWorkUDP:getInstance()
    if not NetWorkUDP._instance then
        NetWorkUDP._instance = NetWorkUDP.new()
    end
    return NetWorkUDP._instance
end

function NetWorkUDP:ctor()
    self._ip         	= ConfigKeyWord.ip
    self._port       	= ConfigKeyWord.udp_port
    self._isEncrypt  	= false
    self._socketUDP     = SocketUDP.new()
    self:addEventListenner()
    -- TODO 加密
end

function NetWorkUDP:start()
    print('hcc>>NetWorkUDP:start')
end

function NetWorkUDP:addEventListenner()
    if self._socketUDP then
        self._socketUDP:addEventListener(SocketUDP.EVENT_DATA, handler(self,self.onMessage))
    end
end

-- 接收数据
function NetWorkUDP:onMessage(event)
    if event.data == nil then return end
    local data_tb = ProtoMan:getInstance():unpack_protobuf_cmd(event.data)
    if data_tb then
        if cmd_name_map[data_tb.ctype] then
            postEvent(cmd_name_map[data_tb.ctype],data_tb.body)
            dump(data_tb,'[udp协议:' .. tostring(cmd_name_map[data_tb.ctype]) .. ']',5)
        end
    end
end

function NetWorkUDP:sendMsg(stype, ctype, packet)
    local proto_cmd = ProtoMan:getInstance():pack_protobuf_cmd(stype,ctype,packet)
    if proto_cmd then
        if self._socketUDP then
            self._socketUDP:send(proto_cmd)
        end
    end
end

return NetWorkUDP