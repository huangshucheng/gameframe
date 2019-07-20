local GameLogic 			= class('GameLogic')
local GameDataLogic 		= require('logic_server/GameLogic/GameDataLogic')

---房间，游戏，配置相关数据

function GameLogic:init_data()
	self._room 				= nil
	self._game_step_id 		= nil
	self._game_step_handler_map = nil
	self._game_logic_data 		= GameDataLogic.new()
end

-----------------------------------------------------------
--room data
-----------------------------------------------------------

function GameLogic:set_room(room)
	self._room = room
end

function GameLogic:get_room()
	return self._room
end

function GameLogic:get_room_players()
	return self._room:get_room_players()
end

function GameLogic:get_max_player()
	return tonumber(self._room:get_max_player())
end

function GameLogic:get_play_count()
	return tonumber(self._room:get_play_count())
end

function GameLogic:get_total_play_count()
	return tonumber(self._room:get_total_play_count())
end

function GameLogic:get_room_info()
	return self._room:get_room_info()
end

function GameLogic:get_room_id()
	return self._room:get_room_id()
end

function GameLogic:get_is_start_game()
	return self._room:get_is_start_game()
end

-----------------------------------------------------------
-- logic data
-----------------------------------------------------------

function GameLogic:get_logic_data()
	return self._game_logic_data
end

function GameLogic:get_game_step_id()
	return self._game_step_id
end

return GameLogic