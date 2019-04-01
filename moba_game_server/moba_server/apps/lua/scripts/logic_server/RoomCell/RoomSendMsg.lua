local Room = class('Room')

local Cmd 				= require("Cmd")

function Room:send_game_start()
	local states = {}
	local players = self:get_room_players()
	for i = 1 , #players do
		local seatId = tonumber(players[i]:get_seat_id())
		states[seatId] = players[i]:get_state()
	end
	local msg = {
		users_state = states
	}
	self:broacast_in_room(Cmd.eGameStart, msg, nil)

end

return Room