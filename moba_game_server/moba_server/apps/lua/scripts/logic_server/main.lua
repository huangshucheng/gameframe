Logger.init("logger/logic_server/", "logic", true)

require("database/mysql_game")
require("functions")
math.newrandomseed()

local proto_type = { PROTO_JSON = 0, PROTO_BUF = 1,}

ProtoMan.init(proto_type.PROTO_BUF)

if ProtoMan.proto_type() == proto_type.PROTO_BUF then 
  local cmd_name_map = require("cmd_name_map")
  if cmd_name_map then 
    ProtoMan.register_protobuf_cmd_map(cmd_name_map)
  end
end

local game_config 	= require("game_config")
local servers 		= game_config.servers
local Stype 		= require("Stype")

Netbus.tcp_listen(servers[Stype.Logic].port)
print("[Logic Server]>>>>> tcp Start at ".. servers[Stype.Logic].port)
Netbus.udp_listen(game_config.logic_udp.port)
print("[Logic Server]>>>>> udp Start at ".. game_config.logic_udp.port)

local logic_service = require("logic_server/logic_service")
local ret = Service.register(Stype.Logic, logic_service)
if ret then
  print("register [Logic service]: success!!!")
else
  print("register [Logic service]: failed!!!")
end


