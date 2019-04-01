local RoomDefine = class("RoomDefine")

-- 静态定义

RoomDefine.RoomType = {
	FK_Room 	= 1,	--房卡
	PP_Room 	= 2,	--匹配
	BS_Room 	= 3,	--比赛
}

RoomDefine.GameStep = {
	GAME_STEP_NONE 			= 0,											
	GAME_STEP_START_GAME 	= 1,					-- 开始游戏
	GAME_STEP_END_GAME 		= 3,					-- 结束游戏
}


return RoomDefine