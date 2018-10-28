local PopLayer = require('game.views.Base.PopLayer')
local SetLayer = class("SetLayer", PopLayer)

local AuthServiceProxy 	= require("game.modules.AuthServiceProxy")

SetLayer._csbResourcePath = 'MahScene/PopLayer/SetLayer.csb'

local KW_IMG_BG 				= 'KW_IMG_BG'
local KW_BTN_CLOSE 				= 'KW_BTN_CLOSE'
local KW_BTN_EXIT               = 'KW_BTN_EXIT'

function SetLayer:ctor()
	SetLayer.super.ctor(self)
end

function SetLayer:init()
	self._canTouchBackground = true

	SetLayer.super.init(self)
end

function SetLayer:onCreate()
	local img_bg = self:getCsbNode():getChildByName(KW_IMG_BG)
	if not img_bg then return end

	local btn_close = ccui.Helper:seekWidgetByName(img_bg,KW_BTN_CLOSE)
	if btn_close then
		btn_close:addClickEventListener(handler(self,function()
			self:showLayer(false)
		end))
	end

    local btn_logout = ccui.Helper:seekWidgetByName(img_bg,KW_BTN_EXIT)
    if btn_logout then
        btn_logout:addClickEventListener(handler(self,function(sender, eventType)
            self:enterScene('game.Lobby.LobbyScene.LobbyScene')
        end))
    end
end

return SetLayer