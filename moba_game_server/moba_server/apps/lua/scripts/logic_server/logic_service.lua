local Respones 		= require("Respones")
local Stype 		= require("Stype")
local Cmd 			= require("Cmd")
local game_mgr 		= require("logic_server/game_mgr")

local logic_service_handlers = {}
logic_service_handlers[Cmd.eLoginLogicReq] = game_mgr.login_logic_server
logic_service_handlers[Cmd.eUserLostConn] = game_mgr.on_player_disconnect
-- logic_service_handlers[Cmd.eEnterZoneReq] = game_mgr.enter_zone
-- logic_service_handlers[Cmd.eExitMatchReq] = game_mgr.do_exit_match

-- {stype, ctype, utag, body}
function on_logic_recv_cmd(s, msg)
	print("logic service: " , msg[1] , msg[2], msg[3])
	if logic_service_handlers[msg[2]] then 
		logic_service_handlers[msg[2]](s, msg)
	end
end

function on_gateway_disconnect(s, stype) 
	print("Logic service disconnect with gateway !!!")
	game_mgr.on_gateway_disconnect(s)
end

function on_gateway_connect(s, stype)
	print("gateway connect to Logic !!!")
	game_mgr.on_gateway_connect(s)
end

local logic_service = {
	on_session_recv_cmd = on_logic_recv_cmd,
	on_session_disconnect = on_gateway_disconnect,
	on_session_connect = on_gateway_connect
}

return logic_service