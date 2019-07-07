local GameScene = class("GameScene")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")

function GameScene:getRootNode()
	return self._rootNode
end

return GameScene