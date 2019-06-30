local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")
local Room 				= require("logic_server/RoomCell/Room")
local PlayerManager 	= require("logic_server/PlayerManager")
local Player 			= require("logic_server/PlayerCell/Player")
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

local function generate_room_id()
	local function general_rand_id()
		local room_id = ''
		for i = 1 , 6 do
			room_id = room_id .. (math.random(0, 9))
		end
		return room_id
	end

	local id = general_rand_id()
	if not server_rooms[id] then
		return id
	else
		return generate_room_id()
	end
end

function RoomManager:on_create_room(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local body 	= req[4]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	print('on_create_room player: ' .. tostring(player))
	if not player then
		NetWork.send_status(session, Cmd.eCreateRoomRes, uid, Respones.PlayerIsNotExist)
		return
	end

	if not body then
		NetWork.send_status(session, Cmd.eCreateRoomRes, uid, Respones.RoomInfoIsNill)
		return
	end

	if self:get_is_player_uid_in_room(player) then
		NetWork.send_status(session, Cmd.eCreateRoomRes, uid, Respones.PlayerIsAlreadyInRoom)
		return
	end

	local player_room_id = player:get_room_id()
	if player_room_id ~= -1 then -- this player already create one room
		NetWork.send_status(session, Cmd.eCreateRoomRes, uid, Respones.PlayerIsAlreadyCreateOneRoom)
		return
	end
	
	player:set_is_host(true)
	player:set_seat_id(1)

	local room = Room.new()
	local roomid = generate_room_id()

	room:set_room_id(roomid)
	room:set_room_info(body.room_info)
	room:enter_player(player)
	server_rooms[tostring(roomid)] = room
	
	player:send_msg(Cmd.eCreateRoomRes, {status = Respones.OK})
	print('create_room success ,brandid: ' .. player:get_brand_id() .. ' ,roomid: ' .. roomid .. ' ,totalroomNum: ' .. self:get_total_rooms() ..' ,rule: ' .. tostring(room:get_room_info()))
end

function RoomManager:on_exit_room(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local body = req[4]
	-- dump(body,'hcc>>on_exit_room')

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork.send_status(session, Cmd.eExitRoomRes, uid, Respones.PlayerIsNotExist)
		-- print('hcc>> exit_room 1')
		return
	end

	local room_id = player:get_room_id()
	local body_msg = {
		status = Respones.OK,
		user_info = player:get_user_arrived_info(),
	}

	if room_id == -1 then
		player:send_msg(Cmd.eExitRoomRes, body_msg)
		return
	end

	local room = server_rooms[tostring(room_id)]
	if not room then
		player:send_msg(Cmd.eExitRoomRes, body_msg)
		return
	end

	if not body then
		NetWork.send_status(session, Cmd.eExitRoomRes, uid, Respones.InvalidOpt)
		return
	end

	local state = tonumber(player:get_state())
	if state == Player.STATE.psPlaying or room:get_is_start_game() then
		player:set_is_offline(true)
	end

	local ishost = player:get_is_host()
	if ishost then
		player:set_is_offline(true)
	end

	body_msg = {
		status = Respones.OK,
		user_info = player:get_user_arrived_info(),
	}

	local ret = room:exit_player(player)
	if not ret then
		NetWork.send_status(session, Cmd.eExitRoomRes, uid, Respones.InvalidOpt)
		return
	end
	player:send_msg(Cmd.eExitRoomRes, body_msg)	-- send to self player
	room:brodcast_in_room(Cmd.eExitRoomRes, body_msg, player) -- send to other player
	print("exit_room success brandid: " .. player:get_brand_id() .. ' ,totalroomNum: ' .. self:get_total_rooms())
end

function RoomManager:on_join_room(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local body 	= req[4]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork.send_status(session, Cmd.eJoinRoomRes, uid, Respones.PlayerIsNotExist)
		return
	end
	--if create one room or in room ,can not join other room ,only can back room
	local room = self:get_is_player_uid_in_room(player)
	if room then
		NetWork.send_status(session, Cmd.eJoinRoomRes, uid, Respones.PlayerIsAlreadyCreateOneRoom)
		return
	end

	if not body then 
		NetWork.send_status(session, Cmd.eJoinRoomRes, uid, Respones.RoomIdIsNill)
		return
	end

	local room_id = body.room_id
	-- print('hcc>> join_room, room_id: '.. room_id)
	local room = server_rooms[tostring(room_id)]
	if not room then
		NetWork.send_status(session, Cmd.eJoinRoomRes, uid, Respones.RoomIsNotExist)
		return
	end

	local ret =  room:enter_player(player)
	if not ret then
		NetWork.send_status(session, Cmd.eJoinRoomRes, uid, Respones.InvalidOpt)
		return
	end
	player:send_msg(Cmd.eJoinRoomRes,{status = Respones.OK})

	local users_info = {}
	table.insert(users_info,player:get_user_arrived_info())
	room:brodcast_in_room(Cmd.eUserArrivedInfos, {user_info = users_info}, player)
	print('join_room usccess brandid: ' .. player:get_brand_id() .. ' ,totalroomnum: ' .. self:get_total_rooms())
end

function RoomManager:on_dessolve_room(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork.send_status(session, Cmd.eDessolveRes, uid, Respones.PlayerIsNotExist)
		return
	end

	local room_id = player:get_room_id()
	if room_id == -1 then
		NetWork.send_status(session, Cmd.eDessolveRes, uid, Respones.PlayerIsNotInRoom)
		return
	end

	local room = server_rooms[tostring(room_id)]
	if not room then
		NetWork.send_status(session, Cmd.eDessolveRes, uid, Respones.RoomIsNotExist)
		return
	end

	local ishost = player:get_is_host()
	if not ishost then
		NetWork.send_status(session, Cmd.eDessolveRes, uid, Respones.DessolvePlayerIsNotHost)
		return
	end

	local msg = {
		status = Respones.OK
	}
	room:brodcast_in_room(Cmd.eDessolveRes, msg)
	room:kick_all_players_in_room()
	if room:get_is_start_game() then
		room:set_is_start_game(false)
	end
	self:delete_room(room_id)
	print('dessolve_room success brandid: ' .. player:get_brand_id() .. ' ,totalroomnum: ' .. self:get_total_rooms())
end

function RoomManager:on_get_create_status(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork.send_status(session, Cmd.eGetCreateStatusRes, uid, Respones.PlayerIsNotExist)
		return
	end

	local room = self:get_is_player_uid_in_room(player)
	if room then
		player:send_msg(Cmd.eGetCreateStatusRes, {status = Respones.OK})
	else
		player:send_msg(Cmd.eGetCreateStatusRes, {status = Respones.PlayerNotCreateRoomOrNotEnterRoom})
	end
end

function RoomManager:on_back_room(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]

	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork.send_status(session, Cmd.eBackRoomRes, uid, Respones.PlayerIsNotExist)
		return
	end
	
	local room = self:get_is_player_uid_in_room(player)
	if not room then
		NetWork.send_status(session, Cmd.eBackRoomRes, uid, Respones.PlayerNotEnterRoomEver)
		return
	end
	
	local ret =  room:enter_player(player)
	if not ret then
		NetWork.send_status(session, Cmd.eBackRoomRes, uid, Respones.InvalidOpt)
		return
	end
	player:send_msg(Cmd.eBackRoomRes, {status = Respones.OK})

	local users_info = {}
	table.insert(users_info,player:get_user_arrived_info())
	room:brodcast_in_room(Cmd.eUserArrivedInfos, {user_info = users_info}, player)

	print('on_back_room usccess brandid: ' .. player:get_brand_id() .. ' ,totalroomnum: ' .. self:get_total_rooms())
end

function RoomManager:on_player_disconnect(player)
	if type(player) ~= 'table' then
		return
	end

	local room_id = player:get_room_id()
	if room_id == -1 then
		return
	end

	local room = server_rooms[tostring(room_id)]
	if not room then
		return
	end

	player:set_is_offline(true)
	local body_msg = {
		user_info = player:get_user_arrived_info(),
	}
	room:brodcast_in_room(Cmd.eUserOffLine, body_msg)
	print("on_player_disconnect brandid: " .. player:get_brand_id())
end
--玩家是否卡在房间里面，没有正常退出
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
	local room = server_rooms[tostring(room_id)]
	if room then
		room:reset()
		server_rooms[tostring(room_id)] = nil
	end
end

function RoomManager:get_total_rooms()
	return table.nums(server_rooms)
end

function RoomManager:get_room_by_room_id(room_id)
	return server_rooms[tostring(room_id)]
end

return RoomManager