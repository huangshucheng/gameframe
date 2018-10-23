local PopLayer = require('game.views.Base.PopLayer')
local SetLayer = class("SetLayer", PopLayer)

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.Cmd")
local Stype             = require("game.net.Stype")

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
	local img_bg = self:getCsbNode():getChildByName(IMG_BG)
	if not img_bg then return end

	local btn_close = ccui.Helper:seekWidgetByName(img_bg,BTN_CLOSE)
	if btn_close then
		btn_close:addClickEventListener(handler(self,function()
			self:showLayer(false)
		end))
	end

    local btn_logout = ccui.Helper:seekWidgetByName(img_bg,BTN_LOGOUT)
    if btn_logout then
        btn_logout:addClickEventListener(handler(self,function(sender, eventType)
            NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eLoginOutReq,nil)
            GT.showLayer("LoadingLayer")
        end))
    end
end

function SetLayer:addClientEventListener()
	addEvent('LoginOutRes', self, self.onEventLoginOutRes)
end

function SetLayer:onEventLoginOutRes(event)
	GT.popLayer('LoadingLayer')
end

return SetLayer