local ProtoMan = class(ProtoMan)

local ByteArray         = require("game.utils.ByteArray")
local ConfigKeyWord 	= require("game.net.ConfigKeyWord")
local cmd_name_map 		= require("game.net.protocol.cmd_name_map")

local HEADER_SIZE = 8		-- 2 stype, 2 ctype, 4 utag,  body;

function ProtoMan:getInstance()
    if not self._instance then
        self._instance = ProtoMan.new()
    end
    return self._instance
end
-- regist pb
function ProtoMan:regist_pb()
	local fileUtils = cc.FileUtils:getInstance()
	local pbFilePath = fileUtils:fullPathForFilename(ConfigKeyWord.pb_file_name)
	if not fileUtils:isFileExist (pbFilePath) then
		print("ProtoMan>> PB file is empty!")	
		return
	end
    print("ProtoMan>> PB file path: "..pbFilePath)
    local buffer = read_protobuf_file_c(pbFilePath)
    protobuf.register(buffer)
end
-- package protobuf 
function ProtoMan:pack_protobuf_cmd(stype, ctype, proto_msg)
	if (not stype) or (not ctype) then return end
	local buf = nil
	if proto_msg then
		buf = protobuf.encode(cmd_name_map[ctype],proto_msg) 
	end

    local msg_byte = ByteArray.new(ByteArray.ENDIAN_LITTLE)
    msg_byte:writeShort(stype)
    msg_byte:writeShort(ctype)	
    msg_byte:writeInt(0)	--utag(default 0)
    if buf then msg_byte:writeStringBytes(buf) end
    msg_byte:setPos(1)
    return msg_byte:getPack()
end
-- decode protobuf package
function ProtoMan:unpack_protobuf_cmd(recvData) -- stype , ctype ,utag , body
	if not recvData then return end
	local msg_byte = ByteArray.new(ByteArray.ENDIAN_LITTLE)
    msg_byte:writeStringBytes(recvData)
    msg_byte:setPos(1)

    local tb = {}
    local msg_len = msg_byte:getLen()
    if msg_len < HEADER_SIZE then
    	return tb
    end

    local stype = msg_byte:readShort()
    local ctype = msg_byte:readShort()
    local utag  = msg_byte:readInt()
    local body  = msg_byte:readStringBytes(msg_len - HEADER_SIZE)

    tb.stype = stype
    tb.ctype = ctype
    tb.utag  = utag
    if body then
        -- tb.body = protobuf.decode(cmd_name_map[ctype], body)   -- can not decode sub table
    	tb.body = protobuf.decodeAll(cmd_name_map[ctype], body)
    end
    return tb
end

function ProtoMan:pack_json_cmd(stype, ctype, json_msg)
	if (not stype) or (not ctype) then return end

    local msg_byte = ByteArray.new(ByteArray.ENDIAN_LITTLE)
    msg_byte:writeShort(stype)
    msg_byte:writeShort(ctype)	
    msg_byte:writeInt(0)	--utag(default 0)
    msg_byte:setPos(1)
    if json_msg then
    	msg_byte:writeStringBytes(json_msg)
    end
    return msg_byte:getPack()
end

function ProtoMan:unpack_cmd_msg(recvData) -- stype , ctype ,utag , body
	if not recvData then return end
	local msg_byte = ByteArray.new(ByteArray.ENDIAN_LITTLE)
    msg_byte:writeStringBytes(recvData)
    msg_byte:setPos(1)

    local tb = {}
    local msg_len = msg_byte:getLen()
    if msg_len < HEADER_SIZE then
    	return tb
    end

    local stype = msg_byte:readShort()
    local ctype = msg_byte:readShort()
    local utag  = msg_byte:readInt()
    local body  = msg_byte:readStringBytes(msg_len - HEADER_SIZE)

    tb.stype = stype
    tb.ctype = ctype
    tb.utag  = utag
    if body then
    	tb.body = body
    end

    return tb
end

return ProtoMan