local Respones 		= require("Respones")
local Stype 		= require("Stype")
local Cmd 			= require("Cmd")
local mysql_game 	= require("database/mysql_game")
local redis_game 	= require("database/redis_game")
local redis_center 	= require("database/redis_center")
local NetWork 		= require("logic_server/NetWork")

local Player = class("Player")

Player.STATE = {
    psNull			= 0,        -- 空
    psWait 			= 1,        -- 等待(按下开始按钮前)
    psReady 		= 2,        -- 准备(按下开始按钮后)
    psPlaying 		= 3,      	-- 游戏(正在进行游戏)
    psEscape 		= 4,       	-- 逃跑(游戏被中断)
    psExitEarly 	= 5,    	-- 提前退出
    psSeeing 		= 6,		-- 旁观
} 

function Player:ctor()
	
end

function Player:init(uid, s, ret_handler)
	self._session 	= s
	self._uid 		= uid
	self._room_id 	= -1 -- 玩家所在的room, -1,不在任何room
	self._seatid 	= -1 -- 玩家在比赛中的序列号
	self._matchid 	= -1 -- 玩家所在的比赛房间的id
	self._side 		= -1 -- 玩家在游戏里面所在的边, 0(lhs), 1(rhs) 
	self._heroid 	= -1 -- 玩家的英雄号 [1, 5]
	self._is_robot 		= false    -- 玩家是否为机器人
	self._is_host   	= false    -- 是否房主
	self._is_offline 	= false    -- 是否掉线
	self._ugame_info 	= nil 	   -- 玩家游戏信息（金币，经验）
	self._uinfo 		= nil 	   -- 玩家帐号信息（名称，头像）
	self._state 		= 0

	self._client_ip 		= nil 			-- 玩家对应客户端的 udp的ip地址
	self._client_udp_port 	= 0 			-- 玩家对应的客户端udp 的port
	self._sync_frameid 		= 0 			-- 玩家同步到那一帧

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
		brandid = self._uinfo.brandid,
		numberid = self._uinfo.numberid,
		areaid  = self._uinfo.areaid,
		seatid 	= self._seatid,
		side 	= self._side,
		roomid  = self._room_id,
		ishost  = self._is_host,
		isoffline = self._is_offline,
		userstate = self._state,
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
	self._is_offline 	= false
	self._state   		= 0
end

function Player:exit_room_and_reset()
	self._room_id = -1
	self._matchid = -1
	self._seatid  = -1
	self._is_host = false
	self._state   = 0
	self._sync_frameid 	= 0
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

function Player:get_is_offline()
	return self._is_offline
end

function Player:set_is_offline(is_offline)
	self._is_offline = is_offline
end

function Player:set_state(state)
	self._state = state
end

function Player:get_state()
	return self._state
end

function Player:get_brand_id()
	return self._uinfo.brandid
end

function Player:get_number_id()
	return self._uinfo.numberid
end

function Player:set_session(s)
	self._session = s
end

function Player:send_msg(ctype, body)
	if not self._session or self._is_robot then 
		return
	end

	local msg = {Stype.Logic, ctype, self._uid, body}
	NetWork.send_msg(self._session, msg)
end

function Player:copy_room_info(player)
	if type(player) ~= 'table' then
		return
	end

	self._uid 	  = player._uid
	self._room_id = player._room_id
	self._matchid = player._matchid
	self._seatid  = player._seatid
	self._side 	  = player._side
	self._heroid  = player._heroid
	self._is_robot = player._is_robot
	self._is_host  = player._is_host
	self._is_offline = player._is_offline
	self._state 	= player._state
	self._sync_frameid = player._sync_frameid
end

function Player:get_uid()
	return self._uid
end

function Player:set_udp_addr(ip, port)
	self._client_ip = ip
	self._client_udp_port = port
end

function Player:get_sync_frameid()
	return self._sync_frameid
end

function Player:set_sync_frameid(frameid)
	self._sync_frameid = frameid	
end

function Player:udp_send_cmd(stype, ctype, body) 
	if not self._session or self._is_robot then --玩家已经断线或是机器人
		return
	end

	if not self._client_ip or self._client_udp_port == 0 then 
		return
	end
	local msg = {stype, ctype, 0, body}
	Session.udp_send_msg(self._client_ip, self._client_udp_port, msg)
	-- print('hcc>>udp_send_cmd, ip: ' .. self._client_ip .. ' ,port: ' .. self._client_udp_port)
end

return Player

