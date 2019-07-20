local GameLogic 		= class('GameLogic')
local ToolUtils 		= require("utils/ToolUtils")
local Cmd               = require("Cmd")

function GameLogic:parse_game_rule()
	print('GameLogic>>:parse_game_rule')
	local playerNum = ToolUtils.getLuaStrValue(self:get_room_info() , 'playerNum')
	local total_play_count = ToolUtils.getLuaStrValue(self:get_room_info(), 'playCount')
end

function GameLogic:on_game_start()
	print('GameLogic>>:on_game_start')
	-- init data
	self:goto_game_step(self.GameStep.GAME_STEP_START_GAME)
end

function GameLogic:on_user_reconnect(player)
	if self:get_game_step_id() == self.GameStep.GAME_STEP_START_GAME then
		local tmp_touzi_nums = self:get_logic_data():get_touzi_nums()
		local tmp_bomb_nums =  self:get_logic_data():get_bomb_nums()
		local msg = {touzi_nums = tmp_touzi_nums , bomb_nums = tmp_bomb_nums}
		player:send_msg(Cmd.eTouZiNumRes, msg)
		print('on_user_reconnect>> ' .. player:get_brand_id() )
	end
end

return GameLogic