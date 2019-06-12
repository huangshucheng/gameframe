local PopLayer = require('game.Base.PopLayer')
local SetLayer = class("SetLayer", PopLayer)

local AuthServiceProxy 	= require("game.modules.AuthServiceProxy")
local LogicServiceProxy = require("game.modules.LogicServiceProxy")

SetLayer._csbResourcePath = 'MahScene/PopLayer/SetLayer.csb'

local KW_IMG_BG 				= 'KW_IMG_BG'
local KW_BTN_CLOSE 				= 'KW_BTN_CLOSE'
local KW_BTN_EXIT               = 'KW_BTN_EXIT'
local KW_BTN_BACK 				= 'KW_BTN_BACK'
local KW_BTN_DESSOLVE 			= 'KW_BTN_DESSOLVE'

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
	--[[
	   退出房间:
	   非房主>> 直接退出到大厅
	   房主>> 信息还在房间，相当于在房间断线,可以返回房间 （目前房主不能返回大厅）
	]]
    local btn_exit = ccui.Helper:seekWidgetByName(img_bg,KW_BTN_EXIT)
    if btn_exit then
        btn_exit:addClickEventListener(handler(self,function(sender, eventType)
            LogicServiceProxy:getInstance():sendExitRoom(true)
        end))
    end
    --[[
     返回大厅
	  非房主：直接退出到大厅
	  房主：信息还在房间，相当于在房间断线,可以返回房间 （目前房主不能返回大厅）
    ]]
    local btn_back = ccui.Helper:seekWidgetByName(img_bg,KW_BTN_BACK)
    if btn_back then
        btn_back:addClickEventListener(handler(self,function(sender, eventType)
            LogicServiceProxy:getInstance():sendExitRoom(true)
        end))
    end
    --[[
       解散房间:
		非房主：不能解散房间，只能退出房间
		房主：可以解散房间
    ]]
    local btn_dsv = ccui.Helper:seekWidgetByName(img_bg,KW_BTN_DESSOLVE)
    if btn_dsv then
        btn_dsv:addClickEventListener(handler(self,function(sender, eventType)
            LogicServiceProxy:getInstance():sendDessolveRoom()
        end))
    end
end

return SetLayer