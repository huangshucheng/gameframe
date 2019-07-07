local LobbyScene = class("LobbyScene")
local LobbySceneDefine      = require('game.Lobby.LobbyScene.LobbySceneDefine')

function LobbyScene:initUI()
    self:showUserInfo()
end

function LobbyScene:initUITouchEvent()
    local panel_center = Lobby.UIFunction.seekWidgetByName(self:getRootNode(),LobbySceneDefine.PANEL_CENTER)
    if panel_center then
        Lobby.UIFunction.addTouchEventListener(panel_center,LobbySceneDefine.IMG_JOIN_ROOM,handler(self, self.onTouchJoinRoomBtn))
        Lobby.UIFunction.addTouchEventListener(panel_center,LobbySceneDefine.IMG_BACK_ROOM,handler(self, self.onTouchBackRoomBtn))
        Lobby.UIFunction.addTouchEventListener(panel_center,LobbySceneDefine.IMG_CREATE_ROOM,handler(self, self.onTouchCreateRoomBtn))
    end

    local img_top_bg = Lobby.UIFunction.seekWidgetByName(self:getRootNode(),LobbySceneDefine.IMG_TOP_BG)
    if img_top_bg then
        Lobby.UIFunction.addTouchEventListener(img_top_bg,LobbySceneDefine.PANEL_HEAD_BG,handler(self, self.onTouchEventHeadImgBg))
        Lobby.UIFunction.addTouchEventListener(img_top_bg,LobbySceneDefine.BTN_SESTTING,handler(self, self.onTouchSettingBtn))
        Lobby.UIFunction.addTouchEventListener(img_top_bg,LobbySceneDefine.BTN_MESSAGE,handler(self, self.onTouchMessageBtn))
        Lobby.UIFunction.addTouchEventListener(img_top_bg,LobbySceneDefine.BTN_MAIL,handler(self, self.onTouchMailBtn))
    end
end

return LobbyScene