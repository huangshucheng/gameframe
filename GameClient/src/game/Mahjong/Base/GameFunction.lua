local GameFunction = {}
local RoomData              = require("game.clientdata.RoomData")

local INVALID_SEAT = -1

function GameFunction.getChairs()
    return RoomData:getInstance():getChars()
end

function GameFunction.serverSeatToLocal(serverSeat)
    local localSeat  = INVALID_SEAT
    local chairCount = GameFunction.getChairs()
    local selfSeat   = GameFunction.getSelfSeat()
    local selfLocalSeat = GameFunction.getSelfLocalSeat()

    if serverSeat >= 1 and serverSeat <= chairCount then
        localSeat = (chairCount + selfSeat - serverSeat + 1) % chairCount + 1
        if chairCount == 2 and localSeat == 1 then
            localSeat = 4
        end
    end
    return localSeat
end

function GameFunction.localSeatToServer(localSeat)
    local serverSeat = INVALID_SEAT
    local chairCount = GameFunction.getChairs()
    local selfSeat   = GameFunction.getSelfSeat()
    local selfLocalSeat = GameFunction.getSelfLocalSeat()

    serverSeat = (chairCount + selfSeat - localSeat + 1) % chairCount + 1
    if chairCount == 2 and serverSeat == 1 then
        serverSeat = 4
    end
    return serverSeat
end

-- 自己在服务端的seat
function GameFunction.getSelfSeat()
	local player = GameFunction.getSelfPlayer()
	if player then
		return player:getSeat()
	end
	return INVALID_SEAT
end
-- 自己在本地的seat
function GameFunction.getSelfLocalSeat()
    return 2
end
-- 自己Player对象
function GameFunction.getSelfPlayer()
	return RoomData:getInstance():getSelfPlayer()
end

return GameFunction