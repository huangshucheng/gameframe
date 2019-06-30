local Room = class('Room')
local ToolUtils 		= require("utils/ToolUtils")

-- 房间逻辑数据
function Room:init_data()
	self._room_id 		= 0
	self._players 		= {}
	self._room_info 	= ''
	self._max_player 	= 4
	self._is_start_game = false
	self._game_logic 	= nil

	self._play_count 	= 0
	self._total_play_count = 0
end

function Room:parse_game_rule()
	local player_num = ToolUtils.getLuaStrValue(self._room_info , 'playerNum')
	if player_num ~= '' then
		self._max_player = tonumber(player_num) or 4
		print('max_player: ' .. self._max_player)
	end
	local total_play_count = ToolUtils.getLuaStrValue(self._room_info, 'playCount')
	if total_play_count ~= '' then
		self._total_play_count = total_play_count
		print('total_play_count: ' .. tostring(self._total_play_count))
	end
end

function Room:set_room_id(room_id)
	self._room_id = room_id
end

function Room:get_room_id()
	return self._room_id
end

function Room:set_room_info(room_info)
	self._room_info = room_info
	self:parse_game_rule()

	if self._game_logic then
		if self._game_logic.on_parse_game_rule then
			self._game_logic:on_parse_game_rule(room_info)
		end
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

function Room:set_total_play_count(total_play_count)
	self._total_play_count = total_play_count
end

function Room:get_total_play_count()
	return self._total_play_count
end

function Room:get_game_logic()
	return self._game_logic
end

return Room