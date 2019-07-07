local PopLayer = require('game.Base.PopLayer')
local TotalWinLostLayer = class("TotalWinLostLayer", PopLayer)

TotalWinLostLayer._csbResourcePath = 'MahScene/PopLayer/TotalWinLostLayer.csb'

local KW_IMG_BG 				= 'KW_IMG_BG'
local KW_BTN_CLOSE 				= 'KW_BTN_CLOSE'
local KW_PANEL_PLAYER 			= 'KW_PANEL_PLAYER_'
local KW_IMG_HEAD               = 'KW_IMG_HEAD'
local KW_TEXT_NAME              = 'KW_TEXT_NAME'
local KW_TEXT_ID                = 'KW_TEXT_ID'
local KW_TEXT_SCORE             = 'KW_TEXT_SCORE'
local KW_BTN_EXIT               = 'KW_BTN_EXIT'

function TotalWinLostLayer:ctor()
	TotalWinLostLayer.super.ctor(self)
end

function TotalWinLostLayer:init()
	self._canTouchBackground = false
	TotalWinLostLayer.super.init(self)
end

function TotalWinLostLayer:onCreate()
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_CLOSE,handler(self, self.onClickEventClose))
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_EXIT,handler(self, self.onClickEventExit))
end

function TotalWinLostLayer:onClickEventClose(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
	self:showLayer(false)
end

function TotalWinLostLayer:onClickEventExit(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
    cc.Director:getInstance():popScene()
end

return TotalWinLostLayer