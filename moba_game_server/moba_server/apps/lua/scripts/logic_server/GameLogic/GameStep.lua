local GameLogic 			= class('GameLogic')

function GameLogic:step_start_game()
	print('hcc>>step_start_game...')
	--send data
	-- local data_array = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}
	-- local num = math.random(1,#data_array)
end

function GameLogic:step_end_game()
	print('hcc>>step_end_game...')
end

return GameLogic