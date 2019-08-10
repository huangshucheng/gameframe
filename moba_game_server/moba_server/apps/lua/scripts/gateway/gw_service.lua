local game_config = require("game_config")

local server_session_man 	= {}     -- stype --> session的一个映射
local do_connecting 		= {}     -- 当前正在做连接的服务器
local g_ukey = 1	 		         -- 临时的ukey 来找client session
local client_sessions_ukey 	= {} 	 -- 临时 ukey-> session 映射表
local client_sessions_uid 	= {}     -- 登录成功后 uid->session 映射表

local Stype 				= require("Stype")
local Cmd 					= require("Cmd")
local cmd_name_map 			= require("cmd_name_map")
local Respones 				= require("Respones")

local DISCONNECT_LIMIT_TIME = 10

local function connect_to_server(stype, ip, port)
	Netbus.tcp_connect(ip, port, function(err, session)
		do_connecting[stype] = false
		if err ~= 0 then 
			Logger.error("connect error to server ["..game_config.servers[stype].desic.."]"..ip..":"..port)
			return
		end 
		server_session_man[stype] = session
		print("connect success to server ["..game_config.servers[stype].desic.."]"..ip..":"..port)
	end)
end

local function check_server_connect()
	for k, v in pairs(game_config.servers) do 
		if server_session_man[v.stype] == nil and 
		    do_connecting[v.stype] == false then 
		    do_connecting[v.stype] = true
		    print("connecting to server ["..v.desic.."]"..v.ip..":"..v.port)
		    connect_to_server(v.stype, v.ip, v.port)
		end
	end	
end

local function gw_service_init()
	for k, v in pairs(game_config.servers) do 
		server_session_man[v.stype] = nil
		do_connecting[v.stype] = false
	end
	Scheduler.schedule(check_server_connect, 1000, -1, 5000)
end

local function is_login_return_cmd(ctype)
	if ctype == Cmd.eGuestLoginRes or 
		ctype == Cmd.eUnameLoginRes then 
		return true
	end
	return false
end

-- 服务器发给客户端
local function send_to_client(server_session, raw_cmd)
	local stype, ctype, utag = RawCmd.read_header(raw_cmd)
	print('send_to_client>> uid: ' .. utag .. ' ,ctype: ' .. tostring(cmd_name_map[ctype]))
	local client_session = nil
	-- login
	if is_login_return_cmd(ctype) then
		-- print('send_to_client>> is_login_return_cmd 111')
		client_session = client_sessions_ukey[utag]
		client_sessions_ukey[utag] = nil

		if client_session == nil then 
			-- print('send_to_client>> is_login_return_cmd 222 nil')
			return
		end

		local body = RawCmd.read_body(raw_cmd)
		if body == nil then
			-- print('send_to_client>> is_login_return_cmd 333 nil')
			return
		end

		if body.status ~= Respones.OK then 
			RawCmd.set_utag(raw_cmd, 0)
			Session.send_raw_cmd(client_session, raw_cmd)
			-- print('send_to_client>> is_login_return_cmd 444')
			return
		end 

		local uid = body.uinfo.uid
		-- 判断一下，是否有已经登陆的session??
		if client_sessions_uid[uid] and client_sessions_uid[uid] ~= client_session then
			local relogin_cmd = {Stype.Auth, Cmd.eRelogin, 0, nil}
			Session.send_msg(client_sessions_uid[uid], relogin_cmd)
			Session.close(client_sessions_uid[uid])
			-- print('send_to_client>> is_login_return_cmd 555')
		end
		client_sessions_uid[uid] = client_session
		Session.set_uid(client_session, uid)

		body.uinfo.uid = 0;
		local login_res = {stype, ctype, 0, body}
		Session.send_msg(client_session, login_res)
		-- print('send_to_client>> is_login_return_cmd 666 success')
		return
	end
	-- regist
	if ctype == Cmd.eUserRegistRes then
		client_session = client_sessions_ukey[utag]
		client_sessions_ukey[utag] = nil

		if client_session == nil then 
			return
		end
		RawCmd.set_utag(raw_cmd, 0)
		Session.send_raw_cmd(client_session, raw_cmd)
		return
	end

	client_session = client_sessions_uid[utag]
	-- print('send_to_client>> is_login_return_cmd 777 session: ' .. tostring(client_session))
	if client_session then 
		RawCmd.set_utag(raw_cmd, 0)
		Session.send_raw_cmd(client_session, raw_cmd)
		print("send to client_session: " .. tostring(client_session))

		if ctype == Cmd.eLoginOutRes then -- 注销得消息，转发给其他得服务器
			Session.set_uid(client_session, 0)
			Session.set_last_recv_time(client_session, 0)
			Session.set_last_send_time(client_session, 0)
			client_sessions_uid[utag] = nil
			-- print('hcc>> Cmd.eLoginOutRes uid: ' .. utag)
		end
	end
end

local function is_login_request_cmd(ctype)
	if ctype == Cmd.eGuestLoginReq or 
		ctype == Cmd.eUnameLoginReq then 
		return true
	end

	return false
end

-- 客户端发给服务器
local function send_to_server(client_session, raw_cmd)
	local stype, ctype, utag = RawCmd.read_header(raw_cmd)
	if ctype ~= Cmd.eHeartBeatReq then
		print('send_to_server>> ctype: ' .. tostring(cmd_name_map[ctype]))
	end
	local server_session = server_session_man[stype]
	if server_session == nil then --可以回一个命令给客户端，系统错误
		return
	end

	if is_login_request_cmd(ctype) then 
		utag = Session.get_utag(client_session)
		if utag == 0 then 
			utag = g_ukey
			g_ukey = g_ukey + 1
			Session.set_utag(client_session, utag)
		end
		client_sessions_ukey[utag] = client_session
		print('send_to_server>> is login request')
		-- Session.send_raw_cmd(client_session, raw_cmd) --test websocket debug
  	elseif ctype == Cmd.eUserRegistReq then
		utag = Session.get_utag(client_session)
		if utag == 0 then 
			utag = g_ukey
			g_ukey = g_ukey + 1
			Session.set_utag(client_session, utag)
		else
		end
		client_sessions_ukey[utag] = client_session
	elseif ctype == Cmd.eLoginLogicReq then
		local uid = Session.get_uid(client_session)
		utag = uid
		if utag == 0 then
			return
		end
		local tcp_ip, tcp_port = Session.get_address(client_session)
		local body = RawCmd.read_body(raw_cmd)
		-- body.udp_ip = tcp_ip
		local login_logic_cmd = {stype, ctype, utag, body}
		Session.send_msg(server_session, login_logic_cmd)
		return
	elseif ctype == Cmd.eHeartBeatReq then
		print("Cmd.eHeartBeatReq")
		local uid = Session.get_uid(client_session)
		if uid ~= 0 then
			Session.set_last_recv_time(client_session, os.time())
		end
		return
	else
		local uid = Session.get_uid(client_session)
		utag = uid
		if utag == 0 then --该操作要先登陆
			return
		end
	end
	-- 打上utag然后转发给服务器
	RawCmd.set_utag(raw_cmd, utag)
	Session.send_raw_cmd(server_session, raw_cmd)
end

local function on_gw_recv_raw_cmd(s, raw_cmd)
	if Session.asclient(s) == 0 then --转发给服务器
		send_to_server(s, raw_cmd)
	else
		send_to_client(s, raw_cmd)
	end
end

local function on_gw_session_disconnect(s, stype)
	print('on_gw_session_disconnect ------- stype: ' .. tostring(Stype.name[stype]))
	--与网关连接的服务器的seession 断线了
	if Session.asclient(s) == 1 then 
		for k, v in pairs(server_session_man) do 
			if v == s then 
				print("gateway disconnect ["..game_config.servers[k].desic.."]")
				server_session_man[k] = nil
				return
			end
		end
		return
	end
	-- 连接到网关的客户端断线了
	-- 把客户端从临时映射表里面删除
	local utag = Session.get_utag(s)
	if client_sessions_ukey[utag] ~= nil and client_sessions_ukey[utag] == s then 
		client_sessions_ukey[utag] = nil -- 保证utag --> value 删除
 		Session.set_utag(s, 0)
 		-- print('hcc>> on_gw_session_disconnect 111 utag: ' .. uid)
	end

	-- 把客户端从uid映射表里移除
	local uid = Session.get_uid(s)
	if client_sessions_uid[uid] ~= nil and client_sessions_uid[uid] == s then 
		client_sessions_uid[uid] = nil
		-- print('hcc>> on_gw_session_disconnect 222 uid: ' .. uid)
	end

	local server_session = server_session_man[stype]
	if server_session == nil then
		return
	end
	-- 客户端uid用户掉线了，我要把这个事件告诉和网关所连接的stype类服务器
	if uid ~= 0 then 
		local user_lost = {stype, Cmd.eUserLostConn, uid, nil}
		Session.send_msg(server_session, user_lost)
		-- print('hcc>> on_gw_session_disconnect 333 uid: ' .. uid)
	end
end
-- heart beat
local function send_heart_beat()
	print('sessionSize: ' .. table.nums(client_sessions_uid))
	for _ , session in pairs(client_sessions_uid) do
		local uid = Session.get_uid(session)
		local msg = {
			Stype.Logic , Cmd.eHeartBeatRes , uid , {status = Respones.OK}
		}
		local time = os.time()
		Session.set_last_send_time(session,time)
		Session.send_msg(session, msg)

		local time_send = Session.get_last_send_time(session)
		local time_recv = Session.get_last_recv_time(session)
		if time_recv == 0 then
			time_recv = time_send
		end
		local sub = time_send - time_recv
		print('uid: '.. uid .. '  ,sendTime: '.. time_send .. ' recvTime: '.. time_recv .. '  sub: ' .. sub)
		if sub >= DISCONNECT_LIMIT_TIME then
			print('uid: '.. uid .. ' lost connect -------------')
			Session.close(session)
		end
	end
end

-- Scheduler.schedule(send_heart_beat, 1000, -1, 3000)

gw_service_init()

local gw_service = {
	on_session_recv_raw_cmd = on_gw_recv_raw_cmd,
	on_session_disconnect = on_gw_session_disconnect,
}

return gw_service