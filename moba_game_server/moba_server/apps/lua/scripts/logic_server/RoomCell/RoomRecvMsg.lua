local Room = class('Room')

local Respones 		= require("Respones")
local Stype 		= require("Stype")
local Cmd 			= require("Cmd")
local cmd_name_map 	= require("cmd_name_map")
local Player 		= require("logic_server/PlayerCell/Player")

--游戏逻辑消息
function Room:on_game_msg_cmd(ctype,body,player)
	if self._game_logic then
		self._game_logic:on_game_msg_cmd(ctype,body,player)
	end
end

return Room