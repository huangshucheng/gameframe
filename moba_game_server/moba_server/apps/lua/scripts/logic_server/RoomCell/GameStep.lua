local Room 			= class('Room')
local Stype 		= require("Stype")
local Cmd 			= require("Cmd")
local RoomConfig 	= require('logic_server/RoomCell/RoomConfig')

function Room:step_start_game()
	print('hcc>>step_start_game...')

end

function Room:step_end_game()
	print('hcc>>step_start_game...')
end

return Room