local GameLogic 			= class('GameLogic')

local GameDefine = require('logic_server/GameLogic/GameDefine')

function GameLogic:init_step_func()
	self._game_step_id = GameDefine.GameStep.GAME_STEP_NONE
	self._game_step_handler_map =
	{
		[GameDefine.GameStep.GAME_STEP_START_GAME]  	= self.step_start_game,
		[GameDefine.GameStep.GAME_STEP_END_GAME] 		= self.step_end_game,
	}
end

function GameLogic:goto_game_step(game_step_id)
	if self._game_step_handler_map[game_step_id] then
		self._game_step_handler_map[game_step_id](self)
		self._game_step_id = game_step_id
	end
end

return GameLogic