local Room = class('Room')

--游戏逻辑消息
function Room:on_game_msg_cmd(ctype,body,player)
	if self._game_logic then
		if self._game_logic.on_game_msg_cmd then
			self._game_logic:on_game_msg_cmd(ctype,body,player)
		end
	end
end

return Room