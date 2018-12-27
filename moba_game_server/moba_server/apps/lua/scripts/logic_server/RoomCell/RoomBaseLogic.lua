local Room = class('Room')
local Player 			= require("logic_server/PlayerCell/Player")
local Cmd 				= require("Cmd")

function Room:check_game_start()
	if self:get_is_start_game() == true then
		return
	end
	local ready_player_count = self:get_player_count_by_state(Player.STATE.psReady)
	if ready_player_count == self:get_max_player() then
		-- start game
		self:set_is_start_game(true)
		self:set_all_player_state(Player.STATE.psPlaying)
		-- send start game and user state
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
		print('hcc>>testGameStart start game, ready count: '.. tostring(ready_player_count))
		self:start_game_step(Room.GameStep.GAME_STEP_START_GAME)
	else
		print('hcc>>testGameStart not start game, ready count: '.. tostring(ready_player_count))
	end
end

return Room