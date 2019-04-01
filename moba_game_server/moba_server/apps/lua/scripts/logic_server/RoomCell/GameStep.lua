local Room = class('Room')

local RoomConfig = require('logic_server/RoomCell/RoomConfig')

function Room:step_start_game()
	print('hcc>>step_start_game...')
end

return Room