local GameScene = class("GameScene")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")

function GameScene:getRootNode()
	return self._rootNode
end

function GameScene:getGameTouziNode()
	return Lobby.UIFunction.seekWidgetByName(self._rootNode,GameSceneDefine.KW_CSB_GAME_TOUZI_NAME)
end

return GameScene