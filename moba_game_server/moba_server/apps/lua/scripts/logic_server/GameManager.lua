local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")

local PlayerManager 	= require("logic_server/PlayerManager")
local RoomManager 	= require("logic_server/RoomManager")

local GameManager 	= class("GameManager")

function GameManager:getInstance()
	if not GameManager._instance then
		GameManager._instance = GameManager.new()
	end
	return GameManager._instance
end

function GameManager:ctor()
	self._cmd_handler_map =
	{
		[Cmd.eUserReconnectedReq] 	= self.on_reconnect,
	}
end

function GameManager:receive_msg(session, msg)
	if not msg then 
		return false
	end

	local ctype = msg[2]

	if not ctype then
	 	return false
	end

	if self._cmd_handler_map[ctype] then
		self._cmd_handler_map[ctype](self, session, msg)
		return true
	end
	
	return false
end

function GameManager:on_reconnect(s, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	print('hcc>> GameManager:on_reconnect uid: ' .. uid)
	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork:getInstance():send_status(s, stype, Cmd.eUserReconnectedRes, uid, Respones.PlayerIsNotExist)
		return
	end

	local msg_body = {
		status 	= Respones.OK,
	}

	player:send_msg(stype, Cmd.eUserReconnectedRes, msg_body)
end

return GameManager