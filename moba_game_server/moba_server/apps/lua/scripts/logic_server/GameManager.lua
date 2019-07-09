local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")

local PlayerManager 	= require("logic_server/PlayerManager")
local RoomManager 		= require("logic_server/RoomManager")
local Player 			= require("logic_server/PlayerCell/Player")
local NetWork 			= require("logic_server/NetWork")

local GameManager 	= class("GameManager")

function GameManager:getInstance()
	if not GameManager._instance then
		GameManager._instance = GameManager.new()
	end
	return GameManager._instance
end

function GameManager:on_timer()
	--local  c1 = collectgarbage("count")
	--print('GameManager>> on_timer  memory: ' .. tostring(c1))
end

function GameManager:ctor()
	self._cmd_handler_map =
	{
		[Cmd.eCheckLinkGameReq] 	= self.on_check_link_game,
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
-- check enter room , then  send room info,user info ,only someone self
function GameManager:on_check_link_game(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork.send_status(session, Cmd.eCheckLinkGameRes, uid, Respones.PlayerIsNotExist)
		return
	end
	player:send_msg(Cmd.eCheckLinkGameRes, {status = Respones.OK})
	local room_id = player:get_room_id()
	-- print('hcc>> on_check_link_game, room_id: '.. room_id)
	print('on_check_link_game uid: ' .. uid .. ' ,brandid: ' .. player:get_brand_id() .. ' ,room_id: ' .. room_id)
	local room = RoomManager:getInstance():get_room_by_room_id(room_id)
	if not room then
		NetWork.send_status(session, Cmd.eCheckLinkGameRes, uid, Respones.RoomIsNotExist)
	 	return
	end
	-- send other player info and selfinfo to selfplayer
	local users_info = {}
	local players = room:get_room_players()
	for i = 1 , #players do
		users_info[#users_info + 1] = players[i]:get_user_arrived_info()
	end
	player:send_msg(Cmd.eRoomInfoRes, {room_info = room:get_room_info()})
	player:send_msg(Cmd.eRoomIdRes,{room_id = room:get_room_id()})
	player:send_msg(Cmd.ePlayCountRes,{play_count = room:get_play_count(),total_play_count = room:get_total_play_count()})
	player:send_msg(Cmd.eUserArrivedInfos,{user_info = users_info})
end
-- user reconnect ,send room info ,user info game data
function GameManager:on_reconnect(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork.send_status(session, Cmd.eUserReconnectedRes, uid, Respones.PlayerIsNotExist)
		return
	end

	local room = RoomManager:getInstance():get_is_player_uid_in_room(player)
	if not room then
		NetWork.send_status(session, Cmd.eUserReconnectedRes, uid, Respones.PlayerNotEnterRoomEver)
		return
	end
	
	local ret =  room:enter_player(player)
	if not ret then
		NetWork.send_status(session, Cmd.eUserReconnectedRes, uid, Respones.InvalidOpt)
		return
	end
	print('on_reconnect uid: ' .. uid .. ' ,brandid: ' .. player:get_brand_id())
	player:send_msg(Cmd.eUserReconnectedRes, {status = Respones.OK})

	player:send_msg(Cmd.eRoomInfoRes, {room_info = room:get_room_info()})
	player:send_msg(Cmd.eRoomIdRes,{room_id = room:get_room_id()})
	player:send_msg(Cmd.ePlayCountRes,{play_count = room:get_play_count(),total_play_count = room:get_total_play_count()})
	room:send_user_state()
	room:send_user_arrived_infos()
end

function GameManager:on_user_ready(session, req)
	if not req then return end
	local stype = req[1]
	local ctype = req[2]
	local uid 	= req[3]
	local body 	= req[4]
	
	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		NetWork.send_status(session, Cmd.eUserReadyRes, uid, Respones.PlayerIsNotExist)
		return
	end
	if not body then return end
	local room_id = player:get_room_id()
	if room_id == -1 then
		NetWork.send_status(session, Cmd.eUserReadyRes, uid, Respones.PlayerIsNotInRoom)
		return
	end
	local room = RoomManager:getInstance():get_room_by_room_id(room_id)
	if not room then 
		NetWork.send_status(session, Cmd.eUserReadyRes, uid, Respones.RoomIsNotExist)
		return
	end
	local ready_state = body.ready_state


	if player:get_state() == ready_state then
		print('on_user_ready same state: ' .. ready_state)
		return
	end
	print('on_user_ready uid: ' .. uid .. ' ,brandid: ' .. player:get_brand_id() .. ' ,ready_state: ' .. ready_state)

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
	room:brodcast_in_room(Cmd.eUserReadyRes, msg_body)
	room:check_game_start()
end

return GameManager