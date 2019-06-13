local Room = class('Room')

-- 房间逻辑数据

function Room:ctor()

end

function Room:init_first_data()
	self._room_id 		= 0
	self._players 		= {}
	self._room_info 	= ''
	self._max_player 	= 4
	self._is_start_game = false

	self._play_count = 0
end

function Room:init_every_data()

end

function Room:set_room_id(room_id)
	self._room_id = room_id
end

function Room:get_room_id()
	return self._room_id
end

function Room:set_room_info(room_info)
	self._room_info = room_info
	if self.parse_game_rule then
		self:parse_game_rule()
	end
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

function Room:get_room_player_num()
	return #self._players
end

function Room:get_is_start_game()
	return self._is_start_game
end

function Room:set_is_start_game(is_start)
	self._is_start_game = is_start
end

function Room:get_play_count()
	return self._play_count
end

function Room:set_play_count(count)
	self._play_count = count
end

return Room