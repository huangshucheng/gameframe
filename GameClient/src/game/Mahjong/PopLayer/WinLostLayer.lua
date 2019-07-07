local PopLayer = require('game.Base.PopLayer')
local WinLostLayer = class("WinLostLayer", PopLayer)

local LogicServiceProxy = require("game.modules.LogicServiceProxy")

WinLostLayer._csbResourcePath = 'MahScene/PopLayer/WinLostLayer.csb'

local KW_IMG_BG 				= 'KW_IMG_BG'
local KW_BTN_CLOSE 				= 'KW_BTN_CLOSE'
local KW_BTN_CONTINUE           = 'KW_BTN_CONTINUE'
local KW_BTN_TOTAL_RESULT 	    = 'KW_BTN_TOTAL_RESULT'
local KW_PANEL_PLAYER 			= 'KW_PANEL_PLAYER_'
local KW_IMG_HEAD               = 'KW_IMG_HEAD'
local KW_TEXT_NAME              = 'KW_TEXT_NAME'
local KW_TEXT_ID                = 'KW_TEXT_ID'
local KW_TEXT_SCORE             = 'KW_TEXT_SCORE'

function WinLostLayer:ctor()
	WinLostLayer.super.ctor(self)
end

function WinLostLayer:init()
	self._canTouchBackground = false
	WinLostLayer.super.init(self)
end

function WinLostLayer:onCreate()
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_CONTINUE,handler(self, self.onClickEventContinue))
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_CLOSE,handler(self, self.onClickEventClose))
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_TOTAL_RESULT,handler(self, self.onClickEventTotalResult))
end

function WinLostLayer:onClickEventContinue(send, eventType)
	if not self:isShowTouchEffect(send, eventType) then return end
    print('hcc>>onClickEventContinue')
    LogicServiceProxy:getInstance():sendUserReady()
    self:showLayer(false)
end

function WinLostLayer:onClickEventClose(send, eventType)
	if not self:isShowTouchEffect(send, eventType) then return end
	self:showLayer(false)
end

function WinLostLayer:onClickEventTotalResult(send, eventType)
	if not self:isShowTouchEffect(send, eventType) then return end
 	Game.showPopLayer('TotalWinLostLayer')
end

return WinLostLayer