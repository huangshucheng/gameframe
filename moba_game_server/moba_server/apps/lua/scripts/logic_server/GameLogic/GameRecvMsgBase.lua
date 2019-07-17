local GameLogic 			= class('GameLogic')
local Cmd                   = require('Cmd')
local cmd_name_map          = require('cmd_name_map')
local Player 				= require("logic_server/PlayerCell/Player")
local Respones 				= require("Respones")

--命令类型，数据，发送过来的玩家
function GameLogic:on_game_logic_cmd(ctype,body,player)
    dump(body,'on_game_logic_cmd ctype>> ' .. tostring(cmd_name_map[ctype]))
    
-------------------------------------------------------
-- base msg
-------------------------------------------------------

	if ctype == Cmd.eCheckLinkGameReq then
		self:on_msg_check_link_game(body,player)
	elseif ctype == Cmd.eUserReconnectedReq then
		self:on_msg_reconnect(body,player)
	elseif ctype == Cmd.eUserReadyReq then
		self:on_msg_user_ready(body,player)
	end
-------------------------------------------------------
--game logic msg
-------------------------------------------------------

    if ctype == Cmd.eClickTouZiNumReq then
    	self:on_msg_click_touzi(body,player)
    end
end

-- check enter room , then  send room info,user info ,only someone self
function GameLogic:on_msg_check_link_game(body,player)
	if not player then return end
	local room_id = player:get_room_id()
	print('hcc>> on_msg_check_link_game, room_id: '.. room_id)
	print('on_msg_check_link_game ,brandid: ' .. player:get_brand_id() .. ' ,room_id: ' .. room_id)
	-- send other player info and selfinfo to selfplayer
	local users_info = {}
	local players = self:get_room_players()
	for i = 1 , #players do
		users_info[#users_info + 1] = players[i]:get_user_arrived_info()
	end
	player:send_msg(Cmd.eCheckLinkGameRes, {status = Respones.OK})
	player:send_msg(Cmd.eRoomInfoRes, {room_info = self:get_room_info()})
	player:send_msg(Cmd.eRoomIdRes,{room_id = self:get_room_id()})
	player:send_msg(Cmd.ePlayCountRes,{play_count = self:get_play_count(),total_play_count = self:get_total_play_count()})
	player:send_msg(Cmd.eUserArrivedInfos,{user_info = users_info})
end

-- user reconnect ,send room info ,user info game data
function GameLogic:on_msg_reconnect(body,player)
	if not player then return end
	local ret =  self:get_room():enter_player(player)
	if not ret then
		return
	end
	print('on_reconnect,brandid: ' .. player:get_brand_id())
	player:send_msg(Cmd.eUserReconnectedRes, {status = Respones.OK})
	player:send_msg(Cmd.eRoomInfoRes, {room_info = self:get_room_info()})
	player:send_msg(Cmd.eRoomIdRes,{room_id = self:get_room_id()})
	player:send_msg(Cmd.ePlayCountRes,{play_count = self:get_play_count(),total_play_count = self:get_total_play_count()})
	self:get_room():send_user_state()
	self:get_room():send_user_arrived_infos()
end

function GameLogic:on_msg_user_ready(body,player)
	if not player then return end
	local room_id = player:get_room_id()
	if room_id == -1 then
		return
	end
	local ready_state = body.ready_state

	--TODO 判断服务玩家状态，一样就返回，不然玩家可以一直点击准备
	-- if player:get_state() == ready_state then
	-- 	print('on_user_ready same state: ' .. ready_state)
	-- 	return
	-- end
	print('on_user_ready, brandid: ' .. player:get_brand_id() .. ' ,ready_state: ' .. ready_state)

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
	self:brodcast_in_room(Cmd.eUserReadyRes, msg_body)
	self:get_room():check_game_start()
end

return GameLogic