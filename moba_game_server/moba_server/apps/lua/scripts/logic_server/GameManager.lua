local Respones 		= require("Respones")
local Stype 		= require("Stype")
local Cmd 			= require("Cmd")
local cmd_name_map 	= require("cmd_name_map")

local PlayerManager 	= require("logic_server/PlayerManager")
local RoomManager 		= require("logic_server/RoomManager")
local Player 			= require("logic_server/PlayerCell/Player")
local NetWork 			= require("logic_server/NetWork")

local GameManager 	= class("GameManager")

function GameManager:getInstance()
	if not GameManager._instance then
		GameManager._instance = GameManager.new()
	end
	return GameManager._instance
end

function GameManager:on_timer()
	--local  c1 = collectgarbage("count")
	--print('GameManager>> on_timer  memory: ' .. tostring(c1))
end

function GameManager:receive_msg(session, msg)
	if not msg then 
		return false
	end
	local stype = msg[1]
	local ctype = msg[2]
	local uid 	= msg[3]
	local body 	= msg[4]

	if not ctype then
	 	return false
	end

	--先有palyer 再有room
	local player = PlayerManager:getInstance():get_player_by_uid(uid)
	if not player then
		print('GameManager>> ctype:' .. tostring(cmd_name_map[ctype]) ..  ' ,uid: ' .. tostring(uid) .. ' player is nil ')
		return false
	end

	local room = RoomManager:getInstance():get_room_by_room_id(player:get_room_id())
	if not room then
		print('GameManager>> numid: ' .. player:get_brand_id()  .. ' ,ctype:' .. tostring(cmd_name_map[ctype]) .. ' ,uid: ' .. tostring(uid) .. ' room is nil')
	 	return false
	end

	if room.on_game_logic_cmd then
		room:on_game_logic_cmd(ctype,body,player)
	end
	return true
end

return GameManager