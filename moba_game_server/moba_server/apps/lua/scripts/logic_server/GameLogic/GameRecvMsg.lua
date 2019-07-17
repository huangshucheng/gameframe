local GameLogic 			= class('GameLogic')
local Cmd                   = require('Cmd')
local cmd_name_map          = require('cmd_name_map')

function GameLogic:on_msg_click_touzi(body,player)
	local seatid = tonumber(body.seatid)
	local touzi_num = tonumber(body.touzi_num)

	local is_bomb_func = function(tnum)
		local bomb_num = self:get_bomb_nums()
		for _,bn in ipairs(bomb_num) do
			if bn == tnum then
				return true
			end
		end
		return false
 	end

 	if is_bomb_func(touzi_num) then
 		self:send_click_bomb_seatid(seatid)
 		self:goto_game_step(self.GameStep.GAME_STEP_END_GAME)
 	else
 		local tmpidx = nil
 		local tnum = self:get_touzi_nums()

		dump(tnum,'set_touzi_nums . before')

 		for idx,tn in ipairs(tnum) do
 			if touzi_num == tn then
 				tmpidx = idx
 				break
 			end
 		end
 		if tmpidx then
 			tnum[tmpidx] = 0
 			self:set_touzi_nums(tnum)
 			self:send_touzi_num()
 			dump(tnum,'set_touzi_nums . after')
 		end
 	end
end

return GameLogic