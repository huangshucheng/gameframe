local GameScene = class("GameScene")

function GameScene:initLogicEventListener()
    addEvent("GameStart", self, self._gameScene, self.onEventGameStart)
    addEvent("GameResult", self, self._gameScene, self.onEventGameResult)
    addEvent("GameTotalResult", self, self._gameScene, self.onEventGameTotalResult)
end

function GameScene:onEventGameStart(event)
    local body = event._usedata
    print('onEventGameStart status: ' .. tostring(body.status))
end

function GameScene:onEventGameResult(event)
	Game.showPopLayer('WinLostLayer')
end

function GameScene:onEventGameTotalResult(event)
	Game.showPopLayer('TotalWinLostLayer')
end

return GameScene