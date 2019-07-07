local GameLogic 			= class('GameLogic')

function GameLogic:on_parse_game_rule(game_rule)
	print("GameLogic>>on_parse_game_rule: " .. game_rule)
	print("GameLogic>>room rule_info: " .. self:get_room():get_room_info())
end

function GameLogic:on_game_start()
	print('GameLogic>>:on_game_start')
	-- init data
	self:goto_game_step(self.GameStep.GAME_STEP_START_GAME)
end

function GameLogic:brodcast_in_room(ctype, body, not_to_player)
    local room = self:get_room()
    if room then
        if room.brodcast_in_room then
            room:brodcast_in_room(ctype,body,not_to_player)
        end
    end
end

return GameLogic