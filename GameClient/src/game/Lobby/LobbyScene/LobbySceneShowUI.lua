local CURRENT_MODULE_NAME = ...
local LobbyScene = class("LobbyScene")

local UserInfo              = require("game.clientdata.UserInfo")
local LobbySceneDefine      = require('game.Lobby.LobbyScene.LobbySceneDefine')

function LobbyScene:showUserInfo()
    Lobby.UIFunction.setString(self:getRootNode(),LobbySceneDefine.TEXT_USER_NAME,UserInfo.getUserName())
    Lobby.UIFunction.setString(self:getRootNode(),LobbySceneDefine.TEXT_USER_ID,'ID:' .. UserInfo.getBrandId())
    Lobby.UIFunction.loadTexture(self:getRootNode(),LobbySceneDefine.IMG_HEAD,string.format('Lobby/LobbyRes/rectheader/1%s.png',UserInfo.getUserface()))
end

return LobbyScene