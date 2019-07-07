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

return GameScene