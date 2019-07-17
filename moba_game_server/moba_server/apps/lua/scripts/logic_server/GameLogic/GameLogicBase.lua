local GameLogic 			= class('GameLogic')

function GameLogic:on_parse_game_rule(game_rule)
	-- print("GameLogic>>on_parse_game_rule: " .. game_rule)
	-- print("GameLogic>>room rule_info: " .. self:get_room():get_room_info())
end

function GameLogic:on_game_start()
	print('GameLogic>>:on_game_start')
	-- init data
	self:goto_game_step(self.GameStep.GAME_STEP_START_GAME)
end

return GameLogic