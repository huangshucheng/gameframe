local GameScene = class("GameScene")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")

function GameScene:initUI()
    local panel_user = nil
    local index = 0

    local typea = type(self:getRootNode())

    repeat
        index = index + 1
        panel_user = Lobby.UIFunction.seekWidgetByName(self:getRootNode(),GameSceneDefine.KW_PANEL_USER_INFO .. index)
        if panel_user then
            panel_user:setVisible(false)
        end
    until panel_user == nil
end

function GameScene:addUITouchEvent()
    Lobby.UIFunction.addTouchEventListener(self:getRootNode(),GameSceneDefine.KW_BTN_SET,handler(self, self.onTouchSettingBtn))
    Lobby.UIFunction.addTouchEventListener(self:getRootNode(),GameSceneDefine.KW_BTN_READY,handler(self, self.onTouchReadyBtn))
end

function GameScene:initGameUITouzi()
    local gameLayer = Lobby.UIFunction.seekWidgetByName(self:getRootNode(),GameSceneDefine.KW_GAME_LAYER)
    if gameLayer then
        local gameCsb = cc.CSLoader:createNode(GameSceneDefine.KW_CSB_GAME_TOUZI)
        if gameCsb then
            gameLayer:addChild(gameCsb)
            gameCsb:setName(GameSceneDefine.KW_CSB_GAME_TOUZI_NAME)
        end
    end
end

function GameScene:initGameUITouZiTouchEvent()
    local btnBomb = nil
    local index = 0
    repeat
        index = index + 1
        btnBomb = Lobby.UIFunction.seekWidgetByName(self:getGameTouziNode(),'KW_BOMB_' .. index)
        if btnBomb then
            btnBomb.index = index
            btnBomb:addTouchEventListener(handler(self, self.onTouchTouZi))
        end
        print('initGameUITouZiTouchEvent index: ' .. index)
    until btnBomb == nil
end


return GameScene