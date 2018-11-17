local Respones 		= require("Respones")
local Stype 		= require("Stype")
local Cmd 			= require("Cmd")
local PlayerManager = require("logic_server/PlayerManager")
local RoomManager   = require("logic_server/RoomManager")

local function on_logic_recv_cmd(session, msg)
	if PlayerManager:getInstance():receive_msg(session, msg) then return end
	if RoomManager:getInstance():receive_msg(session, msg) 	 then return end
end

local function on_gateway_disconnect(session, stype) 
	PlayerManager:getInstance():on_gateway_disconnect(session)
end

local function on_gateway_connect(session, stype)
	PlayerManager:getInstance():on_gateway_connect(session)
end

local logic_service = {
	on_session_recv_cmd 		= on_logic_recv_cmd,
	on_session_disconnect 		= on_gateway_disconnect,
	on_session_connect 			= on_gateway_connect
}

return logic_service