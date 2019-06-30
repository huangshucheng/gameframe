local RoomDefine = class("RoomDefine")

-- 静态定义

RoomDefine.RoomType = {
	FK_Room 	= 1,	--房卡
	PP_Room 	= 2,	--匹配
	BS_Room 	= 3,	--比赛
}

return RoomDefine