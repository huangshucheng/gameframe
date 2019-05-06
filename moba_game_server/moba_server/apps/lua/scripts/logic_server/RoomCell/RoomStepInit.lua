local Room = class('Room')
local RoomDefine = require('logic_server/RoomCell/RoomDefine')

function Room:init_step_func()
	self._game_step_id = RoomDefine.GameStep.GAME_STEP_NONE
	self._game_step_handler_map =
	{
		[RoomDefine.GameStep.GAME_STEP_START_GAME] = self.step_start_game,
		[RoomDefine.GameStep.GAME_STEP_END_GAME] = self.step_end_game
	}
end

function Room:goto_game_step(game_step)
	if self._game_step_handler_map[game_step] then
		self._game_step_handler_map[game_step](self)
		self._game_step_id = game_step
	end
end

return Room