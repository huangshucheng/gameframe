local Room = class('Room')
local Cmd                   = require('Cmd')
local cmd_name_map          = require('cmd_name_map')
local Player 				= require("logic_server/PlayerCell/Player")
local Respones 				= require("Respones")

function Room:on_game_logic_cmd(ctype,body,player)
	if self._game_logic then
		self._game_logic:on_game_logic_cmd(ctype,body,player)
	end
end

function Room:on_room_logic_cmd(...)
	
end

return Room