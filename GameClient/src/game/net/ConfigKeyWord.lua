local ConfigKeyWord = {}

ConfigKeyWord.ip 				= '192.168.1.104' -- 服务端内网ip
-- ConfigKeyWord.ip 			= '115.193.179.90' -- 服务端外网ip
-- ConfigKeyWord.ip 				= '10.198.1.28' -- 路由器WAN口网络ip
ConfigKeyWord.port 				= 6080  --服务端 端口
ConfigKeyWord.udp_port 			= 8003  --服务端udp端口
ConfigKeyWord.local_udp_port    = 0     -- 本地端口（动态获取）
ConfigKeyWord.local_ip          = '127.0.0.1'
ConfigKeyWord.pb_file_name 		= 'game.pb' 

function ConfigKeyWord.set_local_udp_addr(ip, port)
    ConfigKeyWord.local_ip = ip
    ConfigKeyWord.local_udp_port = port
end

function ConfigKeyWord.get_local_udp_addr()
    return  ConfigKeyWord.local_ip , ConfigKeyWord.local_udp_port
end

return ConfigKeyWord