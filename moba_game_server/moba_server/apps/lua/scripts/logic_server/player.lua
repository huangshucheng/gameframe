local Respones = require("Respones")
local Stype = require("Stype")
local Cmd = require("Cmd")
local mysql_game = require("database/mysql_game")
local redis_game = require("database/redis_game")
local redis_center = require("database/redis_center")

local Player = {}

function Player:new(instant) 
	if not instant then 
		instant = {}
	end
	setmetatable(instant, {__index = self})
	return instant
end

function Player:init(uid, s, ret_handler)
	self._session 	= s
	self._uid 		= uid
	self._zid 		= -1 -- 玩家所在的空间, -1,不在任何游戏场
	self._matchid 	= -1 -- 玩家所在的比赛房间的id
	self._seatid 	= -1 -- 玩家在比赛中的序列号
	self._side 		= -1 -- 玩家在游戏里面所在的边, 0(lhs), 1(rhs) 
	self._heroid 	= -1 -- 玩家的英雄号 [1, 5]
	self._is_robot 		= false    -- 玩家是否为机器人
	self._ugame_info 	= nil 	   -- 玩家游戏信息（金币，经验）
	self._uinfo 		= nil 	   -- 玩家帐号信息（名称，头像）

	-- 数据库理面读取玩家的基本信息;
	mysql_game.get_ugame_info(uid, function (err, ugame_info)
		if err then
			if ret_handler then 
				ret_handler(Respones.SystemErr) 
			end
			return
		end
		self._ugame_info = ugame_info

		redis_center.get_uinfo_inredis(uid, function (err, uinfo)
			if err then 
				if ret_handler then 
					ret_handler(Respones.SystemErr) 
				end
				return
			end

			self._uinfo = uinfo

			if ret_handler then 
				ret_handler(Respones.OK) 
			end
		end)
		
	end)
end

function Player:get_user_arrived_info()
	local body = {
		unick 	= self._uinfo.unick,
		uface 	= self._uinfo.uface,
		usex 	= self._uinfo.usex,
		seatid 	= self._seatid,
		side 	= self._side,
	}
	return body
end

function Player:reset()
	self._session 		= nil
	self._uid 			= -1
	self._zid 			= -1
	self._matchid 		= -1
	self._seatid 		= -1
	self._side 			= -1
	self._heroid 		= -1
	self._ugame_info 	= nil
	self._uinfo 		= nil
	self._is_robot 		= false
end

function Player:set_session(s)
	self._session = s
end

function Player:send_cmd(stype, ctype, body)
	if not self._session or self._is_robot then 
		return
	end

	local msg = {stype, ctype, self._uid, body}
	Session.send_msg(self._session, msg)
end

return Player

