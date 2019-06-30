local GameLogic 			= class('GameLogic')

GameLogic.GameStep = {
	GAME_STEP_NONE 			= 0,											
	GAME_STEP_START_GAME 	= 1,					-- 开始游戏
	GAME_STEP_END_GAME 		= 2,					-- 结束游戏
}

return GameLogic