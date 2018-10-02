local TCPPacker         = class(TCPPacker)

local ByteArray         = require("game.utils.ByteArray")
local ByteArrayVarint   = require("game.utils.ByteArrayVarint")

local HEADER_SIZE = 2
local MAX_PKT_LEN = 65535 - 2
--local MAX_PKT_LEN = 7999

function TCPPacker:getInstance()
    if not self._instance then
        self._instance = TCPPacker.new()
    end
    return self._instance
end

-- 头两个字节表示长度，后面接body
-- 服务端用小尾(高位存储在高内存地址，低位存在低内存地址)
function TCPPacker:tcp_pack(string)
    if type(string) ~= 'string' then return end
    local c_byte = ByteArray.new(ByteArrayVarint.ENDIAN_LITTLE)    --小尾
    c_byte:writeStringBytes(string)
    c_byte:setPos(1)
    local content_len = c_byte:getLen()
    if content_len > MAX_PKT_LEN then
    	print("packet is too long , max size is " .. tostring(MAX_PKT_LEN))
    	return
    end
    
    local msg_byte = ByteArray.new(ByteArrayVarint.ENDIAN_LITTLE)
    msg_byte:writeShort(content_len + HEADER_SIZE)
    msg_byte:writeStringBytes(string)
    msg_byte:setPos(1)
    return msg_byte:getPack()
end

return TCPPacker