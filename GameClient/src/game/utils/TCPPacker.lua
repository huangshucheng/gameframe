local TcpPacker         = class('TcpPacker')

local ByteArray         = require("game.utils.ByteArray")

local HEADER_SIZE = 2
local MAX_PKT_LEN = 65535 - 2

function TcpPacker:getInstance()
    if not TcpPacker._instance then
        TcpPacker._instance = TcpPacker.new()
    end
    return TcpPacker._instance
end

function TcpPacker:tcp_pack(packet)
    if type(packet) ~= 'string' then return end
    local c_byte = ByteArray.new(ByteArray.ENDIAN_LITTLE)    --小尾
    c_byte:writeStringBytes(packet)
    c_byte:setPos(1)
    local content_len = c_byte:getLen()
    if content_len > MAX_PKT_LEN then
    	print("packet is too long , max size is " .. tostring(MAX_PKT_LEN))
    	return
    end
    
    local msg_byte = ByteArray.new(ByteArray.ENDIAN_LITTLE)
    msg_byte:writeShort(content_len + HEADER_SIZE)
    msg_byte:writeStringBytes(packet)
    msg_byte:setPos(1)
    return msg_byte:getPack()
end

return TcpPacker