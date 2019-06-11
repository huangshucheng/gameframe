local RoomData = class('RoomData')

-- 房间逻辑数据

function RoomData:ctor()

end

function RoomData:init_first_data()
	self._room_id 		= 0
	self._players 		= {}
	self._room_info 	= ''
	self._max_player 	= 4
	self._is_start_game = false
end

function RoomData:init_every_data()

end

return RoomData