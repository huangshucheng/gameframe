local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")
-- local mysql_game 	= require("database/mysql_game")
-- local redis_game 	= require("database/redis_game")
-- local mysql_center 	= require("database/mysql_auth_center")
-- local redis_center 	= require("database/redis_center")

local Room 				= require("logic_server/Room")
local PlayerManager 	= require("logic_server/PlayerManager")
local InterFace 		= require("logic_server/InterFace")

local RoomManager 		= class("RoomManager",InterFace)

local server_rooms 		= {}

function RoomManager:getInstance()
	if not RoomManager._instance then
		RoomManager._instance = RoomManager.new()
	end
	return RoomManager._instance
end

function RoomManager:ctor()
	RoomManager.super.ctor(self)
	math.newrandomseed()
	self._cmd_handler_map =
	{
		[Cmd.eCreateRoomReq] 	= self.create_room,
		[Cmd.eJoinRoomReq]  	= self.join_room,
		[Cmd.eExitRoomReq]  	= self.exit_room,
		[Cmd.eDessolveReq] 		= self.dessolve_room,
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

function RoomManager:create_room(s, req)
	print('hcc>> create_room')
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local body 	= req[4]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		self:send_status(s, stype, Cmd.eCreateRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> create_room 1')
		return
	end

	if not body then 
		self:send_status(s, stype, Cmd.eCreateRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> create_room 2')
		return
	end

	local player_room_id = player:get_room_id()
	if player_room_id ~= -1 then -- this player already create one room
		print('hcc>> create_room 3')
		self:send_status(s, stype, Cmd.eCreateRoomRes, uid, Respones.InvalidOpt)
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

	player:send_cmd(stype, Cmd.eCreateRoomRes, msg_body)
	print('hcc>> create_room success roonNum: ' .. self:get_total_rooms())
end

function RoomManager:exit_room(s, req)
	print("hcc>> exit_room")
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		self:send_status(s, stype, Cmd.eExitRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> exit_room 1')
		return
	end

	local room_id = player:get_room_id()

	if room_id == -1 then
		self:send_status(s, stype, Cmd.eExitRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> exit_room 2')
		return
	end

	local room = server_rooms[room_id]
	if not room then
		self:send_status(s, stype, Cmd.eExitRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> exit_room 3')
		return
	end

	local tmp_user_info = player:get_user_arrived_info()

	local ret = room:exit_player(player)
	if not ret then
		self:send_status(s, stype, Cmd.eExitRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> exit_room 4')
		return
	end
	-- send to other player
	local body_msg = {
		status = 1,
		user_info = tmp_user_info,
	}

	player:send_cmd(stype, Cmd.eExitRoomRes, body_msg)
	room:broacast_in_room(stype, Cmd.eExitRoomRes, body_msg, player)

	print("hcc>> exit_room success roomNum: " .. self:get_total_rooms())
end

function RoomManager:join_room(s, req)
	print("hcc>> join_room")
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local body 	= req[4]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		self:send_status(s, stype, Cmd.eJoinRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> join_room 1')
		return
	end
	--[[
	-- TODO
	if player:get_room_id() ~= -1 then
		self:send_status(s, stype, Cmd.eJoinRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> join_room 2')
		return
	end
	]]

	if not body then 
		self:send_status(s, stype, Cmd.eJoinRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> join_room 3')
		return
	end

	local room_id = body.room_id
	print('hcc>> room_id: '.. room_id)

	local room = server_rooms[tonumber(room_id)]
	if not room then
		self:send_status(s, stype, Cmd.eJoinRoomRes, uid, Respones.InvalidOpt)
		print('hcc>> join_room 4')
		return
	end

	local ret =  room:enter_player(player)
	if not ret then
		self:send_status(s, stype, Cmd.eJoinRoomRes, uid, Respones.InvalidOpt)
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

	player:send_cmd(stype, Cmd.eJoinRoomRes, msg_body)
	room:broacast_in_room(stype, Cmd.eUserArrived, player:get_user_arrived_info(), player)
	print('hcc>> join_room usccess roomNum: ' .. self:get_total_rooms())
end

function RoomManager:dessolve_room(s, req)
	print("hcc>> dessolve_room")
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		self:send_status(s, stype, Cmd.eDessolveRes, uid, Respones.InvalidOpt)
		print('hcc>> dessolve_room 1')
		return
	end

	local room_id = player:get_room_id()

	if room_id == -1 then
		self:send_status(s, stype, Cmd.eDessolveRes, uid, Respones.InvalidOpt)
		print('hcc>> dessolve_room 2')
		return
	end

	local room = server_rooms[room_id]
	if not room then
		self:send_status(s, stype, Cmd.eDessolveRes, uid, Respones.InvalidOpt)
		print('hcc>> dessolve_room 3')
		return
	end

	self:send_status(s, stype, Cmd.eDessolveRes, uid, Respones.OK)
	room:kick_all_players_in_room()
	self:delete_room(room_id)
	print('hcc>> dessolve_room success roomNum: '.. self:get_total_rooms())
end

function RoomManager:delete_room(room_id)
	if server_rooms[room_id] then
		server_rooms[room_id] = nil
	end
end

function RoomManager:get_total_rooms()
	local num = 0
	for _ ,v in pairs(server_rooms) do
		num = num + 1
	end
	return num
end

function RoomManager:get_room_by_room_id(room_id)
	return server_rooms[room_id]
end

return RoomManager