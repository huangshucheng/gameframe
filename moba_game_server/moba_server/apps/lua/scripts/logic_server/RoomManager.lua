-- local Respones 	= require("Respones")
-- local Stype 	= require("Stype")
-- local Cmd 		= require("Cmd")
-- local mysql_game 	= require("database/mysql_game")
-- local redis_game 	= require("database/redis_game")
-- local mysql_center 	= require("database/mysql_auth_center")
-- local redis_center 	= require("database/redis_center")

local RoomManager 	= class("RoomManager")

local rooms 		= {}
local totalRooms 	= 0

function RoomManager:getInstance()
	if not RoomManager._instance then
		RoomManager._instance = RoomManager.new()
	end
	return RoomManager._instance
end

function RoomManager:ctor()
	math.newrandomseed()
end

function RoomManager:generate_room_Id()
	local roomId = ''
	for i = 1 , 5 do
		roomId = roomId .. tostring(math.floor(math.random(0, 9)))
	end
	return roomId
end

function RoomManager:create_room(player, config, ret_handler)

end

function RoomManager:exit_room(player, ret_handler)

end

function RoomManager:join_room(player, ret_handler)

end

return RoomManager