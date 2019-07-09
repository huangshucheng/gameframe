local PopLayer = require('game.Base.PopLayer')
local TipsLayer = class("TipsLayer", PopLayer)

local KW_TIPS_BG 		= 'KW_TIPS_BG'
local KW_TEXT_TIPS 		= 'KW_TEXT_TIPS'

TipsLayer._csbResourcePath = 'Lobby/PopLayer/TipsLayer.csb'

function TipsLayer:ctor()
	TipsLayer.super.ctor(self)
end

function TipsLayer:init(str)
    self._canTouchBackground = false  
	TipsLayer.super.init(self)

    self:getBgLayer():setVisible(false)
    
    local seq = cc.Sequence:create(
    	cc.DelayTime:create(1),
    	cc.FadeOut:create(0.2),
    	cc.CallFunc:create(function()
    		self:showLayer(false)
		end))
    self:runAction(seq) 

    Lobby.UIFunction.setString(self:getCsbNode(),KW_TEXT_TIPS,tostring(str))
end

return TipsLayer