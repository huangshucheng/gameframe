local Room = class('Room')
local Player 			= require("logic_server/PlayerCell/Player")

function Room:enter_player(player)
	if type(player) ~= 'table' then
		return false
	end
	-- player already in room
	if self:is_player_in_room(player) then
		player:set_is_offline(false)
		print("room: enter_player already in room , brandid:  " .. player:get_brand_id())
		return true
	end
	-- player reconnect to logic and enter room
	local uid = player:get_uid()
	for i = 1 , #self._players do
		local r_uid = self._players[i]:get_uid()
		if r_uid == uid then
			local old_player = self._players[i]
			self._players[i] = player
			self._players[i]:copy_room_info(old_player)
			self._players[i]:set_is_offline(false)
			print('enter_player re_enter_room brandid: '.. player:get_brand_id() .. '  ,playerNum: ' .. self:get_room_player_num())
			return true
		end
	end
	-- looking player TODO

	-- too many players
	if #self._players >= self._max_player then
		return false
	end

	table.insert(self._players, player)
	player:set_room_id(self._room_id)
	player:set_is_offline(false)

	local tmp_seat_id_tb = {}
	for i = 1 , #self._players do
		local seatid = self._players[i]:get_seat_id()
		if seatid ~= -1 then
			tmp_seat_id_tb[#tmp_seat_id_tb + 1] = seatid
		end
	end

	local seat_id_table = {}
	for n = 1 , self._max_player do
		seat_id_table[#seat_id_table + 1] = n
	end

	for j = 1 , #tmp_seat_id_tb do
		local seatid = tmp_seat_id_tb[j]
		for k = 1 , self._max_player do
			if seatid == seat_id_table[k] then
				table.remove(seat_id_table,k)
			end
		end
	end

	if not player:get_is_host() then
		local num = #seat_id_table
		if num >= 1 then
			local randNum = math.random(1, num)
			local rand_seat_id = seat_id_table[randNum]
			-- print('hcc>> seatid: ---------------------------' .. rand_seat_id )
			player:set_seat_id(rand_seat_id)
		end
	end
	-- print("hcc>> 55555 room: enter_player  id: " .. player:get_uid() .. '  playerNum: '.. self:get_room_player_num())
	return true
end

function Room:exit_player(player)
	if type(player) ~= 'table' then
		return false
	end

	local index = nil
	for i = 1 ,#self._players do
		if self._players[i] == player then
			index = i
			break
		end
	end

	if index then
		if player:get_is_host() or self:get_is_start_game() then 	-- room host can back to lobby and can enter next time
			player:set_is_offline(true)
		else
			table.remove(self._players,index)
			player:exit_room_and_reset()
		end
		print("room: exit_player brandid: " .. player:get_brand_id() ..  ' ,playerNum: '.. self:get_room_player_num())
		return true
	end
	return false
end

function Room:kick_all_players_in_room()
	if #self._players <= 0 then
		return
	end

	for i = 1 , #self._players do
		self._players[i]:exit_room_and_reset()
	end

	self._players = {}
end
--玩家是否在房间里面，正常退出和进入
function Room:is_player_in_room(player)
	if type(player) ~= 'table' then
		return false
	end
	for i = 1 , #self._players do
		if self._players[i] == player then
			return true
		end
	end
end
--玩家是否卡在房间里面，没有正常退出
function Room:is_player_uid_in_room(player)
	if type(player) ~= 'table' then
		return false
	end
	for i = 1 , #self._players do
		if player:get_uid() == self._players[i]:get_uid() then
			return true
		end
	end
	return false
end

function Room:get_player_count_by_state(state)
	local count = 0
	for i = 1 , #self._players do
		if self._players[i]:get_state() == state then
			count = count + 1
		end
	end
	return count
end

function Room:set_all_player_state(state)
	for i = 1 , #self._players do
		self._players[i]:set_state(state)
	end
end
-- 发送消息给房间所有人
function Room:brodcast_in_room(ctype, body, not_to_player)
	if ctype == nil then
		return
	end

	for i = 1 , #self._players do
		if self._players[i] ~= not_to_player then
			self._players[i]:send_msg(ctype, body)
		end
	end
end

function Room:get_player_by_seat_id(seat_id)
	for i = 1 , #self._players do
		local player = self._players[i]
		if player:get_seat_id() == seat_id then
			return player
		end
	end
end

function Room:check_game_start()
	if self:get_is_start_game() == true then
		return
	end
	local ready_player_count = self:get_player_count_by_state(Player.STATE.psReady)
	-- if ready_player_count >= 4 then
	if ready_player_count == self:get_max_player() then
		-- start game
		self:set_is_start_game(true)
		self:set_all_player_state(Player.STATE.psPlaying)
		self:send_game_start()
		self:send_user_state()
		print('testGameStart start game, ready count: '.. tostring(ready_player_count))
		if self._game_logic.on_game_start then
			self._game_logic:on_game_start()
		end
	else
		print('testGameStart not start game, ready count: '.. tostring(ready_player_count))
	end
end

function Room:on_logic_end_game()
	self:set_all_player_state(Player.STATE.psWait)
	self:send_user_state()
end

function Room:reset()

end

return Room