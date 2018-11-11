local Room = class("Room")

function Room:ctor()
	self._room_id = 0
	self._players = {}
	self._room_info = ''
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

function Room:is_player_in_room(player)
	for i = 1 , #self._players do
		if self._players[i] == player then
			return true
		end
	end
end

function Room:enter_player(player)
	if not player then 
		return false
	end

	if self:is_player_in_room(player) then
		print("hcc>> room: enter_player already in room , id:  " .. player:getUID())
		return true
	end

	table.insert(self._players, player)
	player:set_room_id(self._room_id)
	if not player:get_is_host() then
		player:set_seat_id(#self:get_room_players() + 1)
	end
	print("hcc>> room: enter_player  id: " .. player:getUID() .. '  playerNum: '.. self:get_room_player_num())
	return true
end

function Room:exit_player(player)
	if not player then 
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
		if not player:get_is_host() then
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

	for _ , player in ipairs(self._players) do
		player:exit_room_and_reset()
	end
	self._players = {}
end

function Room:broacast_in_room(stype, ctype, body, not_to_player)
	if stype == nil or ctype == nil then
		return
	end

	for _ , player in pairs(self._players) do
		if player ~= not_to_player then
			player:send_cmd(stype, ctype, body)
			print("hcc>> player:send_cmd .. id:  " .. player:getUID())
		end
	end
end

function Room:get_room_player_num()
	return #self._players
end

return Room