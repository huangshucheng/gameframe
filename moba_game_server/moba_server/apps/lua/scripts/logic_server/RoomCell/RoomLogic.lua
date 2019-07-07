local Room = class('Room')
local Player 			= require("logic_server/PlayerCell/Player")

function Room:check_game_start()
	local ready_player_count = self:get_player_count_by_state(Player.STATE.psReady)
	-- if ready_player_count >= 4 then
	if ready_player_count == self:get_max_player() then
		-- start game
		if not self:get_is_start_game() then
			self:set_is_start_game(true)
		end
		-- send play count
		self:set_play_count(self:get_play_count()+1)
		self:send_play_count()
		-- send player state
		self:set_all_player_state(Player.STATE.psPlaying)
		self:send_user_state()
		-- send game start
		self:send_game_start()
		
		print('testGameStart start game, ready count: '.. tostring(ready_player_count) .. ' ,playcount: ' .. self:get_play_count())
		if self._game_logic.on_game_start then
			self._game_logic:on_game_start()
		end
	else
		print('testGameStart not start game, ready count: '.. tostring(ready_player_count))
	end
end

function Room:on_logic_game_result()
	self:set_all_player_state(Player.STATE.psWait)
	self:send_user_state()
end

function Room:on_logic_game_total_result()
	self:set_is_start_game(false)
	self:kick_all_players_in_room()
	self:deleteRoom()
end

return Room