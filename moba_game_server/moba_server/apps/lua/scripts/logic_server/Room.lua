local Room = class("Room")

function Room:ctor()
	self._room_id = 0
	self._players = {}
	self._room_info = ''
	self._max_player = 4
end

function Room:set_room_id(room_id)
	self._room_id = room_id
end

function Room:get_room_id()
	return self._room_id
end

function Room:set_room_info(room_info)
	self._room_info = room_info
end

function Room:get_room_info()
	return self._room_info
end

function Room:get_room_players()
	return self._players
end

function Room:get_max_player()
	return self._max_player
end

function Room:set_max_player(max_player)
	self._max_player = max_player
end

function Room:enter_player(player)
	if type(player) ~= 'table' then
		return false
	end
	-- player already in room
	if self:is_player_in_room(player) then
		player:set_is_offline(false)
		print("hcc>> room: enter_player already in room , id:  " .. player:get_uid())
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
			print('hcc>> enter_player  user re_enter_room id: '.. player:get_uid() .. '  ,playerNum: ' .. self:get_room_player_num())
			return true
		end
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
	print('hcc>> 22222---------------')
	dump(seat_id_table)

	if not player:get_is_host() then
		local num = #seat_id_table
		if num >= 1 then
			local randNum = math.random(1, num)
			local rand_seat_id = seat_id_table[randNum]
			print('hcc>> 44444 seatId: ' .. rand_seat_id)
			player:set_seat_id(rand_seat_id)
		end
	end
	print("hcc>> 55555 room: enter_player  id: " .. player:get_uid() .. '  playerNum: '.. self:get_room_player_num())
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
		if player:get_is_host() then 	-- room host can back to lobby and can enter next time
			player:set_is_offline(true)
		else
			table.remove(self._players,index)
			player:exit_room_and_reset()
		end
		print("hcc>> room: exit_player " ..  'playerNum: '.. self:get_room_player_num())
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

function Room:broacast_in_room(stype, ctype, body, not_to_player)
	if stype == nil or ctype == nil then
		return
	end

	for i = 1 , #self._players do
		if self._players[i] ~= not_to_player then
			self._players[i]:send_msg(stype, ctype, body)
		end
	end
end

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

function Room:get_room_player_num()
	return #self._players
end

return Room