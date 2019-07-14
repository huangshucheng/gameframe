local GameLogic 			= class('GameLogic')

function GameLogic:step_start_game()
	print('hcc>>step_start_game...')
	--send data
	--test
	-- local function go_end()
	-- 	self:goto_game_step(self.GameStep.GAME_STEP_END_GAME)
	-- end
	-- Scheduler.schedule(go_end, 3000, 1, 0)

	------------touzi game
	self:send_touzi_num()
end

function GameLogic:step_end_game()
	print('hcc>>step_end_game...')
	self:send_game_result()

	self:get_room():on_logic_game_result()
	print('step_end_game>> playcount: ' .. self:get_play_count() .. ' ,total_play_count: ' .. self:get_total_play_count())
	if self:get_play_count() == self:get_total_play_count() then
		print('hcc>>step_end_game>> total result')
		self:send_game_total_result()
		self:get_room():on_logic_game_total_result()
	end
	self:reset_game_data()
end

return GameLogic