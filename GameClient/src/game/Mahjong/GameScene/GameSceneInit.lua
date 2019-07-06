local GameScene = class("GameScene")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")

function GameScene:initUI()
    local panel_user = nil
    local index = 0
    repeat
        index = index + 1
        panel_user = self._rootNode:getChildByName(GameSceneDefine.KW_PANEL_USER_INFO .. index)
        if panel_user then
            panel_user:setVisible(false)
        end
    until panel_user == nil
end

function GameScene:addUITouchEvent()
    local btn_setting = self._rootNode:getChildByName(GameSceneDefine.KW_BTN_SET)
    if btn_setting then
        btn_setting:addTouchEventListener(handler(self,self.onTouchSettingBtn))
    end

    local panel_btn = self._rootNode:getChildByName(GameSceneDefine.KW_PANEL_BOTTON_BTN)
    if panel_btn then
        local ready_btn = panel_btn:getChildByName(GameSceneDefine.KW_BTN_READY)
        if ready_btn  then
            ready_btn:addClickEventListener(handler(self, self.onTouchReadyBtn))
         end
    end
end

return GameScene