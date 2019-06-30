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

return GameLogic