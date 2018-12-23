local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")

local PlayerManager 	= require("logic_server/PlayerManager")
local RoomManager 		= require("logic_server/RoomManager")
local Player 			= require("logic_server/Player")
local NetWork 			= require("logic_server/NetWork")

local GameManager 	= class("GameManager")

function GameManager:getInstance()
	if not GameManager._instance then
		GameManager._instance = GameManager.new()
	end
	return GameManager._instance
end

function GameManager:on_timer()
	-- print('GameManager>> on_timer  ')
end

function GameManager:ctor()
	self._cmd_handler_map =
	{
		[Cmd.eUserReconnectedReq] 	= self.on_reconnect,
		[Cmd.eUserReadyReq] 		= self.on_user_ready,
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

function GameManager:on_reconnect(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	print('hcc>> GameManager:on_reconnect uid: ' .. uid)
	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork:getInstance():send_status(session, Cmd.eUserReconnectedRes, uid, Respones.PlayerIsNotExist)
		return
	end

	local msg_body = {
		status 	= Respones.OK,
	}

	player:send_msg(Cmd.eUserReconnectedRes, msg_body)
end

function GameManager:on_user_ready(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local body 	= req[4]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork:getInstance():send_status(session, Cmd.eUserReadyRes, uid, Respones.PlayerIsNotExist)
		return
	end
	if not body then return end
	dump(body,"on_user_ready")

	local room_id = player:get_room_id()
	if room_id == -1 then
		NetWork:getInstance():send_status(session, Cmd.eUserReadyRes, uid, Respones.PlayerIsNotInRoom)
	end

	local room = RoomManager:getInstance():get_room_by_room_id(room_id)
	if not room then 
		NetWork:getInstance():send_status(session, Cmd.eUserReadyRes, uid, Respones.RoomIsNotExist)
	end

	local ready_state = body.ready_state
	local msg_body ={
		status = Respones.OK,
		seatid = player:get_seat_id(),
		brandid = player:get_brand_id(),
		numberid = player:get_number_id(),
		user_state = player:get_state(),
	}

	if ready_state == 1 then -- user send ready
		if player:get_state() >= Player.STATE.psReady then
			msg_body.status = Respones.PlayerIsAlreadyReady
		else
			player:set_state(Player.STATE.psReady)
		end
	elseif ready_state == 2 then -- user send cancel ready
		if player:get_state() == Player.STATE.psReady then
			player:set_state(Player.STATE.psWait)
		elseif player:get_state() > Player.STATE.psReady then
			msg_body.status = Respones.PlayerIsAlreadyStartGame
		else
			msg_body.status = Respones.PlayerIsNotReady	
		end
	end

	msg_body.user_state = player:get_state()
	player:send_msg(Cmd.eUserReadyRes, msg_body)
	room:broacast_in_room(Cmd.eUserReadyRes, msg_body, player)
	room:check_game_start()
end

return GameManager