local GameScene = class("GameScene")
local RoomData = require("game/clientdata/RoomData")

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
	Game.showPopLayer('WinLostLayer')
end

function GameScene:onEventGameTotalResult(event)
	Game.showPopLayer('TotalWinLostLayer')
end

function GameScene:onEventGameTouziNum(event)
	local data = event._usedata
	local touzi_nums = data.touzi_nums
	local bomb_nums = data.bomb_nums
	self:refreshTouziNum(touzi_nums,bomb_nums)
end

function GameScene:onEventGameClickBombSeat(event)
	local data = event._usedata
	local seatid = data.seatid
	local player = RoomData:getInstance():getPlayerBySeatId(seatid) -- TODO player is nil
	Game.showPopLayer('TipsLayer',{"玩家seatid:[" .. tostring(seatid) .. ']踩中炸弹!!!'})
end

return GameScene