local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")
local Room 				= require("logic_server/Room")
local PlayerManager 	= require("logic_server/PlayerManager")
local NetWork 			= require("logic_server/NetWork")

local RoomManager 		= class("RoomManager")

local server_rooms 		= {}

function RoomManager:getInstance()
	if not RoomManager._instance then
		RoomManager._instance = RoomManager.new()
	end
	return RoomManager._instance
end

function RoomManager:ctor()
	math.newrandomseed()
	self._cmd_handler_map =
	{
		[Cmd.eCreateRoomReq] 	= self.on_create_room,
		[Cmd.eJoinRoomReq]  	= self.on_join_room,
		[Cmd.eExitRoomReq]  	= self.on_exit_room,
		[Cmd.eDessolveReq] 		= self.on_dessolve_room,
		[Cmd.eBackRoomReq] 		= self.on_back_room,
		[Cmd.eGetCreateStatusReq] = self.on_get_create_status,
	}
end

function RoomManager:receive_msg(session, msg)
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

function RoomManager:generate_room_id()
	local function general_rand_id()
		local room_id = ''
		for i = 1 , 6 do
			room_id = room_id .. (math.random(0, 9))
		end
		return room_id
	end
	
	local id = tonumber(general_rand_id())
	if server_rooms[id] then
		RoomManager.generate_room_id(self) 	--TODO test
	end
	return id
end

function RoomManager:on_create_room(s, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local body 	= req[4]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork:getInstance():send_status(s, stype, Cmd.eCreateRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> create_room 1')
		return
	end

	if not body then
		NetWork:getInstance():send_status(s, stype, Cmd.eCreateRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> create_room 2')
		return
	end

	if self:get_is_player_uid_in_room(player) then
		NetWork:getInstance():send_status(s, stype, Cmd.eCreateRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> create_room 3')
		return
	end

	local player_room_id = player:get_room_id()
	if player_room_id ~= -1 then -- this player already create one room
		print('hcc>> create_room 4')
		NetWork:getInstance():send_status(s, stype, Cmd.eCreateRoomRes, uid, Respones.InvalidOpt)
		return
	end

	local room = Room:create()
	local roomid = self:generate_room_id()

	room:set_room_id(roomid)
	room:set_room_info(body.room_info)
	room:enter_player(player)
	server_rooms[roomid] = room

	player:set_is_host(true)
	player:set_seat_id(1)

	local user_info = player:get_user_arrived_info()

	local msg_body = {
		status 		= Respones.OK,
		room_info 	= body.room_info,
		user_info 	= user_info,
	}

	player:send_msg(stype, Cmd.eCreateRoomRes, msg_body)
	print('hcc>> create_room success roomid: ' .. tostring(roomid) .. '  ,roomNum: ' .. self:get_total_rooms())
	--test
	-- local body_msg = {
	-- 	user_info = player:get_user_arrived_info(),
	-- }
	-- room:broacast_in_room(stype, Cmd.eUserOffLine, body_msg)
end

function RoomManager:on_exit_room(s, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork:getInstance():send_status(s, stype, Cmd.eExitRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> exit_room 1')
		return
	end

	local room_id = player:get_room_id()

	if room_id == -1 then
		NetWork:getInstance():send_status(s, stype, Cmd.eExitRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> exit_room 2')
		return
	end

	local room = server_rooms[room_id]
	if not room then
		NetWork:getInstance():send_status(s, stype, Cmd.eExitRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> exit_room 3')
		return
	end

	local ishost = player:get_is_host()
	if ishost then
		player:set_is_offline(true)
	end

	local tmp_user_info = player:get_user_arrived_info()
	local ret = room:exit_player(player)
	if not ret then
		NetWork:getInstance():send_status(s, stype, Cmd.eExitRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> exit_room 4')
		return
	end
	
	local body_msg = {
		status = 1,
		user_info = tmp_user_info,
	}

	player:send_msg(stype, Cmd.eExitRoomRes, body_msg)	-- send to self player
	room:broacast_in_room(stype, Cmd.eExitRoomRes, body_msg, player) -- send to other player

	print("hcc>> exit_room success roomNum: " .. self:get_total_rooms())
end

function RoomManager:on_join_room(s, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local body 	= req[4]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork:getInstance():send_status(s, stype, Cmd.eJoinRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> join_room 1')
		return
	end

	if not body then 
		NetWork:getInstance():send_status(s, stype, Cmd.eJoinRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> join_room 3')
		return
	end

	local room_id = body.room_id
	print('hcc>> join_room, room_id: '.. room_id)

	local room = server_rooms[tonumber(room_id)]
	if not room then
		NetWork:getInstance():send_status(s, stype, Cmd.eJoinRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> join_room 4')
		return
	end

	local ret =  room:enter_player(player)
	if not ret then
		NetWork:getInstance():send_status(s, stype, Cmd.eJoinRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> join_room 5')
		return
	end

	local users_info = {}
	local players = room:get_room_players()
	for i = 1 , #players do
		users_info[#users_info + 1] = players[i]:get_user_arrived_info()
	end

	local msg_body ={
		status = Respones.OK,
		room_info = room:get_room_info(),
		users_info = users_info,
	}

	player:send_msg(stype, Cmd.eJoinRoomRes, msg_body)
	room:broacast_in_room(stype, Cmd.eUserArrived, player:get_user_arrived_info(), player)
	print('hcc>> join_room usccess roomNum: ' .. self:get_total_rooms())
end

function RoomManager:on_dessolve_room(s, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork:getInstance():send_status(s, stype, Cmd.eDessolveRes, uid, Respones.InvalidOpt)
		print('hcc>> dessolve_room 1')
		return
	end

	local room_id = player:get_room_id()
	if room_id == -1 then
		NetWork:getInstance():send_status(s, stype, Cmd.eDessolveRes, uid, Respones.InvalidOpt)
		print('hcc>> dessolve_room 2')
		return
	end

	local room = server_rooms[room_id]
	if not room then
		NetWork:getInstance():send_status(s, stype, Cmd.eDessolveRes, uid, Respones.InvalidOpt)
		print('hcc>> dessolve_room 3')
		return
	end

	local ishost = player:get_is_host()
	if not ishost then
		NetWork:getInstance():send_status(s, stype, Cmd.eDessolveRes, uid, Respones.InvalidOpt)
		print('hcc>> dessolve_room 4')
		return
	end

	local msg = {
		status = Respones.OK
	}
	room:broacast_in_room(stype, Cmd.eDessolveRes, msg)
	room:kick_all_players_in_room()
	self:delete_room(room_id)
	print('hcc>> dessolve_room success roomNum: '.. self:get_total_rooms())
end

function RoomManager:on_get_create_status(s, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork:getInstance():send_status(s, stype, Cmd.eGetCreateStatusRes, uid, Respones.InvalidOpt)
		print('hcc>> on_get_create_status 1')
		return
	end

	local room = self:get_is_player_uid_in_room(player)
	if room then
		player:send_msg(stype, Cmd.eGetCreateStatusRes, {status = Respones.OK})
		print('hcc>> on_get_create_status 2')
	else
		player:send_msg(stype, Cmd.eGetCreateStatusRes, {status = Respones.InvalidOpt})
		print('hcc>> on_get_create_status 3')
	end
end

function RoomManager:on_back_room(s, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork:getInstance():send_status(s, stype, Cmd.eBackRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> on_back_room 1')
		return
	end

	local room = self:get_is_player_uid_in_room(player)
	if not room then
		NetWork:getInstance():send_status(s, stype, Cmd.eBackRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> on_back_room 2')
	end

	local ret =  room:enter_player(player) -- TODO error :attempt to index a boolean value (local 'room')
	if not ret then
		NetWork:getInstance():send_status(s, stype, Cmd.eBackRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> on_back_room 3')
		return
	end

	local users_info = {}
	local players = room:get_room_players()
	for i = 1 , #players do
		users_info[#users_info + 1] = players[i]:get_user_arrived_info()
	end

	local msg_body ={
		status = Respones.OK,
		room_info = room:get_room_info(),
		users_info = users_info,
	}

	player:send_msg(stype, Cmd.eBackRoomRes, msg_body)
	room:broacast_in_room(stype, Cmd.eUserArrived, player:get_user_arrived_info(), player)
	print('hcc>> on_back_room usccess roomNum: ' .. self:get_total_rooms())
end
-- TODO
function RoomManager:on_player_disconnect(player)
	print('hcc>> on_player_disconnect')
	if type(player) ~= 'table' then
		return
	end

	local room_id = player:get_room_id()

	if room_id == -1 then
		print('hcc>> on_player_disconnect 1')
		return
	end

	local room = server_rooms[room_id]
	if not room then
		print('hcc>> on_player_disconnect 2')
		return
	end

	player:set_is_offline(true)
	local body_msg = {
		user_info = player:get_user_arrived_info(),
	}
	room:broacast_in_room(Stype.Logic, Cmd.eUserOffLine, body_msg)
	print("hcc>> on_player_disconnect roomNum: " .. self:get_total_rooms())
end

function RoomManager:get_is_player_uid_in_room(player)
	if type(player) ~= 'table' then
		return false
	end
	for _ , room in pairs(server_rooms) do
		if room:is_player_uid_in_room(player) then
			return room
		end
	end
	return false
end

function RoomManager:delete_room(room_id)
	if server_rooms[room_id] then
		server_rooms[room_id] = nil
	end
end

function RoomManager:get_total_rooms()
	return table.nums(server_rooms)
end

function RoomManager:get_room_by_room_id(room_id)
	return server_rooms[room_id]
end

return RoomManager