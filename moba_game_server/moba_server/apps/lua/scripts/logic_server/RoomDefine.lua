local Room = logic_server_global_table.Room or {}

Room.GameStep = {
	GAME_STEP_NONE 			= 0,											
	GAME_STEP_START_GAME 	= 1,					-- 开始游戏
	GAME_STEP_ANTE			= 2,					-- 下注
	GAME_STEP_SPECF_MAH		= 3,					-- 做牌
	GAME_STEP_THROW_CHIP_1	= 4,					-- 掷骰子(定位骰子)
	GAME_STEP_THROW_CHIP_2	= 5,					-- 掷骰子(开牌骰子)
	GAME_STEP_TAKE_FIRST	= 6,					-- 抓牌
	GAME_STEP_THROW_CHIP_3	= 7,					-- 掷骰子(财神骰子)
	GAME_STEP_OPEN_MAH 		= 8,					-- 翻开
	GAME_STEP_FIRST_REPLACE = 9,					-- 刚开始的补花
	GAME_STEP_PLAY_MAH		= 10,					-- 开始打麻将
	GAME_STEP_WIN_LOST		= 11,					-- 结算
	GAME_STEP_END_GAME		= 12,					-- 结束游戏
	GAME_STEP_COUNT			= 13,
	GAME_STEP_USER 			= 14,
}

Room.GameSubStep = {
	GAME_SUB_STEP_NONE 		= 0,	
	GAME_SUB_STEP_WAIT_RESP = 1,				-- 等待回应
	GAME_SUB_STEP_WAIT 		= 2,				-- 等待
	GAME_SUB_STEP_TAKE 		= 3,				-- 抓牌
	GAME_SUB_STEP_PLAY		= 4,				-- 打牌
	GAME_SUB_STEP_CHOW 		= 5,				-- 吃
	GAME_SUB_STEP_PUNG		= 6,				-- 碰
	GAME_SUB_STEP_TKONG 	= 7,				-- 补杠
	GAME_SUB_STEP_MKONG 	= 8,				-- 直杠
	GAME_SUB_STEP_CKONG		= 9,				-- 暗杠
	GAME_SUB_STEP_CANCEL 	= 10,				-- 放弃
	GAME_SUB_STEP_REPLACE	= 11,				-- 补花
	GAME_SUB_STEP_TWAIT 	= 12,				-- 抓听
	GAME_SUB_STEP_CWAIT 	= 13,				-- 吃听
	GAME_SUB_STEP_PWAIT 	= 14,				-- 碰听
	GAME_SUB_STEP_HU 		= 15,				-- 和
	GAME_SUB_STEP_DRAWN 	= 16,				-- 荒牌
	GAME_SUB_STEP_HU_WAIT 	= 17,				-- 查叫
	GAME_SUB_STEP_COUNT 	= 18,
	GAME_SUB_STEP_USER 		= 19,
}