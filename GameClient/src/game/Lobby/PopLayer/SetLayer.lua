local PopLayer = require('game.Base.PopLayer')
local SetLayer = class("SetLayer", PopLayer)

local AuthServiceProxy 	= require("game.modules.AuthServiceProxy")

SetLayer._csbResourcePath = 'Lobby/PopLayer/SetLayer.csb'

local IMG_BG 					= 'IMG_BG'
local BTN_CLOSE 				= 'BTN_CLOSE'
local BTN_LOGOUT                = 'BTN_LOGOUT'

function SetLayer:ctor()
	SetLayer.super.ctor(self)
end

function SetLayer:init()
	self._canTouchBackground = true

	SetLayer.super.init(self)
end

function SetLayer:onCreate()
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),BTN_CLOSE,handler(self, self.onClickEventClose))
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),BTN_LOGOUT,handler(self, self.onClickEventLoginOut))
end

function SetLayer:onClickEventClose(send, eventType)
	if not self:isShowTouchEffect(send, eventType) then return end
	self:showLayer(false)
end

function SetLayer:onClickEventLoginOut(send, eventType)
	if not self:isShowTouchEffect(send, eventType) then return end
    AuthServiceProxy:getInstance():sendLoginOut()
    Lobby.showPopLayer("LoadingLayer")
end

function SetLayer:addClientEventListener()
	addEvent('LoginOutRes', self, self, self.onEventLoginOutRes)
end

function SetLayer:onEventLoginOutRes(event)
	Lobby.popLayer('LoadingLayer')
end

return SetLayer