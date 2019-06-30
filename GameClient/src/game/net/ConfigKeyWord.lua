local ConfigKeyWord = {}

ConfigKeyWord.ip 				= '192.168.2.130' -- 服务端内网ip
-- ConfigKeyWord.ip 				= '127.0.0.1'
ConfigKeyWord.port 				= 6080  --服务端 端口
ConfigKeyWord.udp_port 			= 8003  --服务端udp端口

ConfigKeyWord.local_ip          = '127.0.0.1'
ConfigKeyWord.pb_file_name 		= 'game.pb' 

local UDP_PORT_STR = 'udp_port_str'

function ConfigKeyWord.get_udp_addr()
	local local_ip 			= ConfigKeyWord.local_ip
	local local_udp_port 	= 8004
	local local_port 		= cc.UserDefault:getInstance():getStringForKey(UDP_PORT_STR,'')
	if local_port ~= '' then
		local_udp_port = local_port
	else
		local_udp_port = math.random(8000, 9999)       --port: 0->65535
		cc.UserDefault:getInstance():setStringForKey(UDP_PORT_STR,tostring(local_udp_port))
	end
	print('hcc>>ConfigKeyWord ip: ' .. local_ip .. ' ,udp_port: ' .. local_udp_port)
	return local_ip , local_udp_port
end

return ConfigKeyWord