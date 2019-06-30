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

function Room:send_user_arrived_infos()
	local players = self:get_room_players()
	local users_info = {}
	for i = 1 , #players do
		users_info[#users_info + 1] = players[i]:get_user_arrived_info()
	end
	self:brodcast_in_room(Cmd.eUserArrivedInfos,{user_info = users_info})
end

return Room