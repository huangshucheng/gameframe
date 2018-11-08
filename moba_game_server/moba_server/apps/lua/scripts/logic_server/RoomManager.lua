local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")
-- local mysql_game 	= require("database/mysql_game")
-- local redis_game 	= require("database/redis_game")
-- local mysql_center 	= require("database/mysql_auth_center")
-- local redis_center 	= require("database/redis_center")

local Room 				= require("logic_server/Room")

local RoomManager 	= class("RoomManager")

local server_rooms 		= {}
local tatal_rooms 		= 0

function RoomManager:getInstance()
	if not RoomManager._instance then
		RoomManager._instance = RoomManager.new()
	end
	return RoomManager._instance
end

function RoomManager:ctor()
	math.newrandomseed()

	self._cmd_handler_map =
	{
		[Cmd.eCreateRoomReq] 	= self.create_room,
		[Cmd.eJoinRoomReq]  	= self.join_room,
		[Cmd.eExitRoomReq]  	= self.exit_room,
	}
end

function RoomManager:receive_msg(session, msg)
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

function RoomManager:generate_room_id()
	local roomId = ''
	for i = 1 , 5 do
		roomId = roomId .. tostring(math.floor(math.random(0, 9)))
	end
	return roomId
end

function RoomManager:create_room(s, req)
	-- local room = Room:create()
	-- ...
end

function RoomManager:exit_room(s, req)

end

function RoomManager:join_room(s, req)

end

function RoomManager:delete_room(room_id)
	if server_rooms[room_id] then
		server_rooms[room_id] = nil
	end
end

function RoomManager:get_total_rooms()
	return tatal_rooms
end

function RoomManager:get_room_by_room_id(room_id)
	return server_rooms[room_id]
end

return RoomManager