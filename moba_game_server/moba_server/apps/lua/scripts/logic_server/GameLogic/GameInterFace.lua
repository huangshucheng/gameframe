local GameLogic 			= class('GameLogic')

function GameLogic:brodcast_in_room(ctype, body, not_to_player)
    local room = self:get_room()
    if room then
        if room.brodcast_in_room then
            room:brodcast_in_room(ctype,body,not_to_player)
        end
    end
end

return GameLogic