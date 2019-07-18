local GameLogic 			= class('GameLogic')

function GameLogic:parse_game_rule()
	print('GameLogic>>:parse_game_rule')
end

function GameLogic:on_game_start()
	print('GameLogic>>:on_game_start')
	-- init data
	self:goto_game_step(self.GameStep.GAME_STEP_START_GAME)
end

return GameLogic