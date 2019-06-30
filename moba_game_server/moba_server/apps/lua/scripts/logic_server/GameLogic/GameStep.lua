local GameLogic 			= class('GameLogic')

function GameLogic:step_start_game()
	print('hcc>>step_start_game...')
	--send data
	-- local data_array = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}
	-- local num = math.random(1,#data_array)

	local function go_end()
		self:goto_game_step(self.GameStep.GAME_STEP_END_GAME)
	end
	Scheduler.schedule(go_end, 3000, 1, 0)
end

function GameLogic:step_end_game()
	print('hcc>>step_end_game...')
	self:send_game_result()
	self:get_room():on_logic_end_game()
end

return GameLogic