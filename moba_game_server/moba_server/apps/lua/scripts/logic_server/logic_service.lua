local Respones 		= require("Respones")
local Stype 		= require("Stype")
local Cmd 			= require("Cmd")
local PlayerManager = require("logic_server/PlayerManager")

local _playerManager = PlayerManager:create()

local function on_logic_recv_cmd(session, msg)
	if not msg then return end
	if _playerManager then
		_playerManager:receive_msg(session, msg)
	end
end

local function on_gateway_disconnect(session, stype) 
	if _playerManager then
		_playerManager:on_gateway_disconnect(session)
	end
end

local function on_gateway_connect(session, stype)
	if _playerManager then
		_playerManager:on_gateway_connect(session)
	end
end

local logic_service = {
	on_session_recv_cmd 		= on_logic_recv_cmd,
	on_session_disconnect 		= on_gateway_disconnect,
	on_session_connect 			= on_gateway_connect
}

return logic_service