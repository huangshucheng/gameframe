local GameLogic 			= class('GameLogic')

function GameLogic:init_data()
	self._room 				= nil
	self._game_step_id 		= nil
	self._game_step_handler_map = nil

	----logic data
	self._touzi_nums = 	{
		1,2,3,4,5,6,7,8,
		9,10,11,12,13,14,15,16,
		17,18,19,20,21,22,23,24,
		25,26,27,28,29,30,31,32
	}
	self._bomb_nums = {1,2}
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
	return tonumber(self._room:get_max_player())
end

function GameLogic:get_play_count()
	return tonumber(self._room:get_play_count())
end

function GameLogic:get_total_play_count()
	return tonumber(self._room:get_total_play_count())
end

function GameLogic:reset_game_data()
	self:reset_touzi_nums()
end
----- logic data
function GameLogic:get_touzi_nums()
	return self._touzi_nums
end

function GameLogic:set_touzi_nums(nums)
	self._touzi_nums = nums
end

function GameLogic:get_bomb_nums()
	return self._bomb_nums
end

function GameLogic:set_bomb_nums(nums)
	self._bomb_nums = nums
end

function GameLogic:reset_touzi_nums()
	self._touzi_nums = 	{
		1,2,3,4,5,6,7,8,
		9,10,11,12,13,14,15,16,
		17,18,19,20,21,22,23,24,
		25,26,27,28,29,30,31,32
	}
	self._bomb_nums = {1,2}
end

return GameLogic