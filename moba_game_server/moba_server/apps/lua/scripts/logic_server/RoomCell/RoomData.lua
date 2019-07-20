local Room = class('Room')

-- 房间逻辑数据
function Room:init_data()
	self._room_id 		= 0
	self._players 		= {}
	self._room_info 	= ''
	self._max_player 	= 4
	self._is_start_game = false 	--一整盘游戏是否开始,大结算才会重置
	self._game_logic 	= nil

	self._play_count 	= 0
	self._total_play_count = 0
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
	self._play_count = tonumber(count)
end

function Room:set_total_play_count(total_play_count)
	self._total_play_count = tonumber(total_play_count)
end

function Room:get_total_play_count()
	return self._total_play_count
end

function Room:get_game_logic()
	return self._game_logic
end

return Room