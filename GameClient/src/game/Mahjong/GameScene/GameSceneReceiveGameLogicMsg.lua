local GameScene = class("GameScene")
local RoomData              = require("game.clientdata.RoomData") -- require use .

function GameScene:initLogicEventListener()
    addEvent("GameStart", self, self._gameScene, self.onEventGameStart)
    addEvent("GameResult", self, self._gameScene, self.onEventGameResult)
    addEvent("GameTotalResult", self, self._gameScene, self.onEventGameTotalResult)
    addEvent("TouZiNumRes", self, self._gameScene, self.onEventGameTouziNum)
    addEvent("ClickTouZiBombRes", self, self._gameScene, self.onEventGameClickBombSeat)
end

function GameScene:onEventGameStart(event)
    local body = event._usedata
    print('onEventGameStart status: ' .. tostring(body.status))
    --test game touzi
    self:showGameTouZi(true)
end

function GameScene:onEventGameResult(event)
	-- Game.showPopLayer('WinLostLayer')
	print('onEventGameResult>> player count: ' .. RoomData:getInstance():getRoomPlayerCount())
end

function GameScene:onEventGameTotalResult(event)
	Game.showPopLayer('TotalWinLostLayer')

end

function GameScene:onEventGameTouziNum(event)
	self:showGameTouZi(true)
	local data = event._usedata
	local touzi_nums = data.touzi_nums
	local bomb_nums = data.bomb_nums
	self:refreshTouziNum(touzi_nums,bomb_nums)
	for i = 1 , 4 do
		local player = RoomData:getInstance():getPlayerBySeatId(i)
		print('player id ' .. i .. ' ,is>> ' .. tostring(player))
	end
	print('onEventGameTouziNum>> player count: ' .. RoomData:getInstance():getRoomPlayerCount())
end

function GameScene:onEventGameClickBombSeat(event)
	local data = event._usedata
	local seatid = data.seatid
	local player = RoomData:getInstance():getPlayerBySeatId(seatid)
	print('>>>> player: ' .. tostring(player))
	Game.showPopLayer('TipsLayer',{"玩家:[ " .. tostring(player:getUNick()) .. ' ]踩中炸弹!!!'})
end

return GameScene