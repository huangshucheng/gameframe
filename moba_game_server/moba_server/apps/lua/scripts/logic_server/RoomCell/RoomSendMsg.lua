local Room = class('Room')

local Cmd 				= require("Cmd")

function Room:send_game_start()
	self:brodcast_in_room(Cmd.eGameStart,{status = 1})
end

function Room:send_user_state()
	local tmp_users_state = {}
	local players = self:get_room_players()
	for i = 1 , #players do
		tmp_users_state[#tmp_users_state + 1] = {seatid = players[i]:get_seat_id() , user_state = players[i]:get_state()}
	end
	local msg = {
		users_state = tmp_users_state
	}
	self:brodcast_in_room(Cmd.eAllUserState, msg)
end

function Room:send_play_count()
	local msg = {
		play_count = self:get_play_count(),
		total_play_count = self:get_total_play_count()
	}
	self:brodcast_in_room(Cmd.ePlayCountRes,msg)
end

return Room