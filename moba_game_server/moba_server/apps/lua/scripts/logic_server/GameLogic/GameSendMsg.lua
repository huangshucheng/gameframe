local GameLogic 			= class('GameLogic')
local Cmd                   = require("Cmd")

function GameLogic:send_game_result()
    local msg = {score = {1,2,3,4}}
    self:brodcast_in_room(Cmd.eGameResult,msg)
end

function GameLogic:send_game_total_result()
    local msg = {score = {1,2,3,4}}
    self:brodcast_in_room(Cmd.eGameTotalResult,msg) 
end

function GameLogic:send_touzi_num()
	local msg = {touzi_nums = self:get_touzi_nums() , bomb_nums = self:get_bomb_nums()}
	self:brodcast_in_room(Cmd.eTouZiNumRes, msg)
end

function GameLogic:send_click_bomb_seatid(seatid)
	self:brodcast_in_room(Cmd.eClickTouZiBombRes, {seatid = seatid})
end

return GameLogic