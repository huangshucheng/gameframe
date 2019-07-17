local Respones 		= require("Respones")
local Stype 		= require("Stype")
local Cmd 			= require("Cmd")
local cmd_name_map 	= require("cmd_name_map")
local PlayerManager = require("logic_server/PlayerManager")
local RoomManager   = require("logic_server/RoomManager")
local GameManager 	= require("logic_server/GameManager")

local function on_logic_recv_cmd(session, msg)
	local ret = nil
	--[[
	     接受消息步骤：根据uid判断玩家是否存在->判断房间存在->消息发给房间内具体某个玩家
	]]
	--玩家管理，负责创建和销毁玩家
	ret = PlayerManager:getInstance():receive_msg(session, msg)
	if ret then 
		print('PlayerManager>>message----> ' .. tostring(cmd_name_map[msg[2]]))
		return
	end
	--房间管理，接收房间类有关消息（创房间，解散相关）
	ret = RoomManager:getInstance():receive_msg(session, msg)
	if ret then
		print('RoomManager>>message----> ' .. tostring(cmd_name_map[msg[2]]))
		return
	end
	-- 游戏管理，处理游戏逻辑
	ret = GameManager:getInstance():receive_msg(session, msg) --游戏管理
	if ret then
		print('GameManager>>message----> ' .. tostring(cmd_name_map[msg[2]]))
		return
	end
end
--网关断开了逻辑服务
local function on_gateway_disconnect(session, stype) 
	PlayerManager:getInstance():on_gateway_disconnect(session)
end
--网关连上了逻辑服务
local function on_gateway_connect(session, stype)
	PlayerManager:getInstance():on_gateway_connect(session)
end
--定时器，游戏内使用
local function logic_timer()
	GameManager:getInstance():on_timer()
end

Scheduler.schedule(logic_timer, 1000, -1, 1000)

local logic_service = {
	on_session_recv_cmd 		= on_logic_recv_cmd,
	on_session_disconnect 		= on_gateway_disconnect,
	on_session_connect 			= on_gateway_connect
}

return logic_service