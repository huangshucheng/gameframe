local PopLayer = require('game.views.Base.PopLayer')
local JoinRoomLayer = class("JoinRoomLayer", PopLayer)

local Respones 			= require("game.net.Respones")
local SystemServiceProxy = require("game.modules.SystemServiceProxy")

JoinRoomLayer._csbResourcePath = 'Lobby/PopLayer/JoinRoomLayer.csb'

local KW_IMG_BG 				= 'KW_IMG_BG'
local KW_BTN_CLOSE 				= 'KW_BTN_CLOSE'

function JoinRoomLayer:ctor()
	JoinRoomLayer.super.ctor(self)
end

function JoinRoomLayer:init()
	self._canTouchBackground    = true
    self._numberList            = {}
    self._numberBtnList         = {}
	JoinRoomLayer.super.init(self)
	
end

function JoinRoomLayer:onCreate()
	local img_bg = self:getCsbNode():getChildByName(KW_IMG_BG)
	if not img_bg then return end

	local btn_close = ccui.Helper:seekWidgetByName(img_bg,KW_BTN_CLOSE)
	if btn_close then
		btn_close:addClickEventListener(handler(self,function()
			self:showLayer(false)
		end))
	end

end

function JoinRoomLayer:addClientEventListener()

end

return JoinRoomLayer