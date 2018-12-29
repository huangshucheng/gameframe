local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")
local mysql_game 	= require("database/mysql_game")
local redis_game 	= require("database/redis_game")
local mysql_center 	= require("database/mysql_auth_center")
local redis_center 	= require("database/redis_center")
local Player 		= require("logic_server/PlayerCell/Player")
local NetWork 		= require("logic_server/NetWork")

local PlayerManager = class('PlayerManager')

local logic_server_players 		= {} 	-- uid --> Player
local online_player_num 		= 0

function PlayerManager:getInstance()
	if not PlayerManager._instance then
		PlayerManager._instance = PlayerManager.new()
	end
	return PlayerManager._instance
end

function PlayerManager:ctor()
	self._cmd_handler_map = 
	{
		[Cmd.eLoginLogicReq] 	= self.on_login_logic_server,
		[Cmd.eUserLostConn]  	= self.on_player_disconnect,
	}
end

function PlayerManager:receive_msg(session, msg)
	if not msg then 
		return false
	end

	local ctype = msg[2]

	if not ctype then
	 	return false
	end

	if self._cmd_handler_map[ctype] then
		self._cmd_handler_map[ctype](self, session, msg)
		return true
	end
	
	return false
end

--登录逻辑服务器
function PlayerManager:on_login_logic_server(session, req)
	local uid = req[3]
	local stype = req[1]
	print('PlayerManager>> on_login_logic_server >>  uid: '.. tostring(uid))
	local p = logic_server_players[uid]
	if p then
		p:set_session(session)
		NetWork:getInstance():send_status(session, Cmd.eLoginLogicRes, uid, Respones.OK)
		print('PlayerManager>> on_login_logic_server >> user size: '..  online_player_num)
		return
	end

	p = Player.new()
	p:init(uid, session, function(status)
		if status == Respones.OK then
			logic_server_players[uid] = p
			online_player_num = online_player_num + 1
		end
		NetWork:getInstance():send_status(session, Cmd.eLoginLogicRes, uid, status)
		print('PlayerManager>> on_login_logic_server >> user size: '..  online_player_num)
	end)
end

-- 玩家离开了逻辑服务器
function PlayerManager:on_player_disconnect(session, req)
	local uid = req[3]
	local p = logic_server_players[uid]
	if not p then
		return 
	end
	if p then
		local RoomManager = require("logic_server/RoomManager")
		RoomManager:getInstance():on_player_disconnect(p)
		print("PlayerManager>> on_player_disconnect>> Player uid " .. uid .. " disconnect!")
		logic_server_players[uid] = nil
		online_player_num = online_player_num - 1
		if online_player_num <= 0 then
			online_player_num = 0
		end
	end
	print('PlayerManager>> on_player_disconnect >> user size: '..  online_player_num)
end

function PlayerManager:on_gateway_connect(session)
	logic_server_players 	= {}
	online_player_num 		= 0
end

function PlayerManager:on_gateway_disconnect(session)
	logic_server_players 	= {}
	online_player_num 		= 0
end

function PlayerManager:get_players()
	return logic_server_players
end

function PlayerManager:get_player_by_uid(uid)
	return logic_server_players[uid]
end

function PlayerManager:get_online_player_num()
	return online_player_num
end

return PlayerManager

