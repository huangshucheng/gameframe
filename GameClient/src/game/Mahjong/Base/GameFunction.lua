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

    if serverSeat >= 1 and serverSeat <= chairCount then
        localSeat = ((serverSeat - selfSeat + chairCount) % chairCount) + GameFunction.getSelfLocalSeat()
        if chairCount == 2 and localSeat == 2 then
            localSeat = 3
        end
    end
    return localSeat
end

function GameFunction.localSeatToServer(localSeat)
	local serverSeat = INVALID_SEAT
	local chairCount = GameFunction.getChairs()
	local selfSeat 	 = GameFunction.getSelfSeat()

	if localSeat >= 1 and localSeat <= chairCount then
		serverSeat = (chairCount - localSeat + selfSeat) % chairCount + GameFunction.getSelfLocalSeat()
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
    return 1
end
-- 自己Player对象
function GameFunction.getSelfPlayer()
	return RoomData:getInstance():getSelfPlayer()
end

return GameFunction