local Stype = require("Stype")

local remote_servers = {}

-- 注册服务所部署的IP地址和端口
remote_servers[Stype.Auth] = {
	stype 	= Stype.Auth,
	ip 		= "127.0.0.1",
	port 	= 8000,
	desic 	= "Auth server",
}

remote_servers[Stype.System] = {
	stype 	= Stype.System,
	ip 		= "127.0.0.1",
	port 	= 8001,
	desic 	= "System server",
}

remote_servers[Stype.Logic] = {
	stype 	= Stype.Logic,
	ip 		= "127.0.0.1",
	port 	= 8002, 
	desic 	= "Logic Server"
}

local game_config = {
	gateway_tcp_ip 		= "127.0.0.1",
	gateway_tcp_port 	= 6080,

	gateway_ws_ip 		= "127.0.0.1",
	gateway_ws_port 	= 6081,

	servers = remote_servers,

	auth_mysql = {
		host 		= "127.0.0.1", 		-- 数据库所在的host
		port 		= 3306,        		-- 数据库所在的端口
		db_name 	= "auth_center",  	-- 数据库的名字
		uname 		= "root",      		-- 登陆数据库的账号
		upwd 		= "123456",     	-- 登陆数据库的密码
	},

	game_mysql = {
		host 		= "127.0.0.1", 		-- 数据库所在的host
		port 		= 3306,        		-- 数据库所在的端口
		db_name 	= "moba_game",  	-- 数据库的名字
		uname 		= "root",      		-- 登陆数据库的账号
		upwd 		= "123456",     	-- 登陆数据库的密码
	},

	center_redis = {
		host 		= "127.0.0.1", 		-- redis所在的host
		port 		= 6379, 			-- reidis 端口
		db_index 	= 1, 				-- 数据index
	}, 


	game_redis = {
		host 		= "127.0.0.1", 
		port 		= 6379, 
		db_index 	= 2,
	},

	rank_redis = {
		host 		= "127.0.0.1",
		port 		= 6379,
		db_index 	= 3,
	},
}

return game_config
