local GameLogic 			= class('GameLogic')

function GameLogic:init_data()
	self._room 				= nil
	self._game_step_id 		= nil
	self._game_step_handler_map = nil
end

function GameLogic:set_room(room)
	self._room = room
end

function GameLogic:get_room()
	return self._room
end

function GameLogic:get_players()
	return self._room:get_room_players()
end

function GameLogic:get_max_player()
	return self._room:get_max_player()
end

function GameLogic:reset()
	
end

return GameLogic