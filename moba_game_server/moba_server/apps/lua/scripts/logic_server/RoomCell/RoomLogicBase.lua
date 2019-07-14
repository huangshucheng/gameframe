local Room = class('Room')

function Room:on_game_logic_cmd(...)
	if self._game_logic then
		if self._game_logic.on_game_logic_cmd then
			self._game_logic:on_game_logic_cmd(...)
		end
	end
end

return Room