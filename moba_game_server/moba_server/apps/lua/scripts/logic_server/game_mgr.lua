local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")
local mysql_game 	= require("database/mysql_game")
local redis_game 	= require("database/redis_game")
local mysql_center 	= require("database/mysql_auth_center")
local redis_center 	= require("database/redis_center")
local Player 		= require("logic_server/Player")

local logic_server_players 		= {} 	-- uid --> Player
local online_player_num 		= 0

local function send_status(s, stype, ctype, uid, status)
	if not s then return end

	local msg = {stype, ctype, uid, {
		status = status,
	}}

	Session.send_msg(s, msg)
end

--登录逻辑服务器
-- {stype, ctype, utag, body}
local function login_logic_server(s, req)
	local uid = req[3]
	local stype = req[1]

	local p = logic_server_players[uid]
	if p then
		p:set_session(s)
		send_status(s, stype, Cmd.eLoginLogicRes, uid, Respones.OK)
		print('login_logic_server111 >> user size: '..  online_player_num)
		return
	end

	p = Player:new()
	p:init(uid, s, function(status)
		if status == Respones.OK then
			logic_server_players[uid] = p
			online_player_num = online_player_num + 1
		end
		send_status(s, stype, Cmd.eLoginLogicRes, uid, status)
		print('login_logic_server333 >> user size: '..  online_player_num)
	end)
	print('login_logic_server222 >> user size: '..  online_player_num)
end

-- 玩家离开了逻辑服务器
local function on_player_disconnect(s, req)
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

local function on_gateway_connect(s)
	--[[
	for k, v in pairs(logic_server_players) do 
		v:set_session(s)	--TODO 有问题
	end
	]]
	logic_server_players 	= {}
	online_player_num 		= 0
	print('on_gateway_connect----------')
end

local function on_gateway_disconnect(s) 
	--[[
	for k, v in pairs(logic_server_players) do 
		v:set_session(nil) 	--TODO 可能有问题
	end
	]]
	logic_server_players 	= {}
	online_player_num 		= 0
	print('on_gateway_disconnect-------------')
end

local game_mgr = {
	login_logic_server 		= login_logic_server,
	on_player_disconnect 	= on_player_disconnect,
	on_gateway_disconnect 	= on_gateway_disconnect,
	on_gateway_connect 		= on_gateway_connect,
}

return game_mgr

