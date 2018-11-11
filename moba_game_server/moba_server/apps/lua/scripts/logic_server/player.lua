local Respones = require("Respones")
local Stype = require("Stype")
local Cmd = require("Cmd")
local mysql_game = require("database/mysql_game")
local redis_game = require("database/redis_game")
local redis_center = require("database/redis_center")
local InterFace = require("logic_server/InterFace")

local Player = class("Player", InterFace)

function Player:ctor()
	Player.super.ctor(self)
end

function Player:init(uid, s, ret_handler)
	self._session 	= s
	self._uid 		= uid
	self._room_id 	= -1 -- 玩家所在的room, -1,不在任何room
	self._seatid 	= -1 -- 玩家在比赛中的序列号
	self._is_host   = false

	self._matchid 	= -1 -- 玩家所在的比赛房间的id
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
		roomid  = self._room_id,
		ishost  = self._is_host,
	}
	return body
end

function Player:reset()
	self._session 		= nil
	self._uid 			= -1
	self._room_id 		= -1
	self._matchid 		= -1
	self._seatid 		= -1
	self._side 			= -1
	self._heroid 		= -1
	self._ugame_info 	= nil
	self._uinfo 		= nil
	self._is_robot 		= false
	self._is_host 		= false
end

function Player:exit_room_and_reset()
	self._room_id = -1
	self._matchid = -1
	self._seatid  = -1
	self._is_host = false
end

function Player:set_room_id(room_id)
	self._room_id = room_id
end

function Player:reset_room_id()
	self._room_id = -1
end

function Player:get_room_id()
	return self._room_id	
end

function Player:set_seat_id(seat_id)
	self._seatid = seat_id
end

function Player:get_seat_id()
	return self._seatid
end

function Player:set_is_host(is_host)
	self._is_host = is_host
end

function Player:get_is_host()
	return self._is_host
end

function Player:set_session(s)
	self._session = s
end

function Player:send_cmd(stype, ctype, body)
	if not self._session or self._is_robot then 
		return
	end

	local msg = {stype, ctype, self._uid, body}
	self:send_msg(self._session, msg)
end

function Player:getUID()
	return self._uid
end

return Player

