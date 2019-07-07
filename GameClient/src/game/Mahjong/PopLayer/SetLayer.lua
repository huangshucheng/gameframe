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
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_CLOSE,handler(self, self.onClickEventClose))
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_EXIT,handler(self, self.onClickEventExit))
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_DESSOLVE,handler(self, self.onClickEventDessolve))
end

function SetLayer:onClickEventClose(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
    self:showLayer(false)
end

function SetLayer:onClickEventExit(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
    LogicServiceProxy:getInstance():sendExitRoom(true)
    cc.Director:getInstance():popScene()
end

function SetLayer:onClickEventDessolve(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
    LogicServiceProxy:getInstance():sendDessolveRoom()
end

return SetLayer