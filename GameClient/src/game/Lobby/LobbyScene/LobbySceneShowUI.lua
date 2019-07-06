local CURRENT_MODULE_NAME = ...
local LobbyScene = class("LobbyScene")

local UserInfo              = require("game.clientdata.UserInfo")
local LobbySceneDefine      = require('game.Lobby.LobbyScene.LobbySceneDefine')

function LobbyScene:showUserInfo()
    local img_top_bg = self:getRootNode():getChildByName(LobbySceneDefine.IMG_TOP_BG)
    if img_top_bg then
        local user_name_text 	= ccui.Helper:seekWidgetByName(img_top_bg, LobbySceneDefine.TEXT_USER_NAME)
        local user_id_text 		= ccui.Helper:seekWidgetByName(img_top_bg, LobbySceneDefine.TEXT_USER_ID)
        local img_head 			= ccui.Helper:seekWidgetByName(img_top_bg, LobbySceneDefine.IMG_HEAD)
        if user_name_text then
            user_name_text:setString(UserInfo.getUserName())    
        end 
        if user_id_text then
			user_id_text:setString('ID:' .. UserInfo.getBrandId())
        end
        if img_head then
            img_head:loadTexture(string.format('Lobby/LobbyRes/rectheader/1%s.png',UserInfo.getUserface()))
        end
    end
end

return LobbyScene