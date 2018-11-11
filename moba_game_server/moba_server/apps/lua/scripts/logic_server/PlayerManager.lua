local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")
local mysql_game 	= require("database/mysql_game")
local redis_game 	= require("database/redis_game")
local mysql_center 	= require("database/mysql_auth_center")
local redis_center 	= require("database/redis_center")
local Player 		= require("logic_server/Player")
local InterFace 	= require("logic_server/InterFace")

local PlayerManager = class('PlayerManager', InterFace)

local logic_server_players 		= {} 	-- uid --> Player
local online_player_num 		= 0

function PlayerManager:getInstance()
	if not PlayerManager._instance then
		PlayerManager._instance = PlayerManager.new()
	end
	return PlayerManager._instance
end

function PlayerManager:ctor()
	PlayerManager.super.ctor(self)
	self._cmd_handler_map = 
	{
		[Cmd.eLoginLogicReq] 	= self.login_logic_server,
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
-- {stype, ctype, utag, body}
function PlayerManager:login_logic_server(s, req)
	print('PlayerManager:login_logic_server>>  '.. tostring(self))
	local uid = req[3]
	local stype = req[1]

	local p = logic_server_players[uid]
	if p then
		p:set_session(s)
		self:send_status(s, stype, Cmd.eLoginLogicRes, uid, Respones.OK)
		print('login_logic_server111 >> user size: '..  online_player_num)
		return
	end

	p = Player:create()
	p:init(uid, s, function(status)
		if status == Respones.OK then
			logic_server_players[uid] = p
			online_player_num = online_player_num + 1
		end
		self:send_status(s, stype, Cmd.eLoginLogicRes, uid, status)
		print('login_logic_server333 >> user size: '..  online_player_num)
	end)
	print('login_logic_server222 >> user size: '..  online_player_num)
end

-- 玩家离开了逻辑服务器
function PlayerManager:on_player_disconnect(s, req)
	local uid = req[3]
	local p = logic_server_players[uid]
	if not p then
		return 
	end
	if p then
		print("Player uid " .. uid .. " disconnect!")
		logic_server_players[uid] = nil
		online_player_num = online_player_num - 1
		if online_player_num <= 0 then
			online_player_num = 0
		end
	end
	print('on_player_disconnect >> user size: '..  online_player_num)
end

function PlayerManager:on_gateway_connect(s)
	logic_server_players 	= {}
	online_player_num 		= 0
end

function PlayerManager:on_gateway_disconnect(s) 
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

