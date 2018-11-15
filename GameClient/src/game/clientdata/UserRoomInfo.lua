local UserRoomInfo = {}
 
local room_user_info = {}

-- create room
--[[
	table = {
		room_info = '',
		status = 0,
		user_info = {
			ishost = 0,
			roomid = 0,
			seatid = 0,
			side = 0,
			uface = 0,
			unick = '',
			usex = 0,
		}
	}
]]

-- back or join room
--[[
	table = {
		room_info = '',
		status = 0,
		users_info = {
			1 = {user_info ...},
			2 = {},
			3 = {},
			4 = {},
			...
		}
	}
]]

function UserRoomInfo.setRoomInfo(room_info)
	room_user_info.room_info = room_info
end

function UserRoomInfo.getRoomInfo()
	return room_user_info.room_info
end

function UserRoomInfo.getRoomId()
	for k , v in pairs(room_user_info) do 
		if type(v) == 'table' then
			return v.roomid
		end
	end
end

function UserRoomInfo.setUserRoomInfoBySeatId(seatId, user_info)
	if type(seatId) ~= 'number' or (not next(user_info)) then
		return
	end
	room_user_info[seatId] = user_info
end

function UserRoomInfo.getUserRoomInfoBySeatId(seatId)
	return room_user_info[seatId]
end

function UserRoomInfo.reset()
	room_user_info = {}
end

return UserRoomInfo