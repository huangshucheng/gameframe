local PopLayer = require('game.views.Base.PopLayer')
local TipsLayer = class("TipsLayer", PopLayer)

local KW_TIPS_BG 		= 'KW_TIPS_BG'
local KW_TEXT_TIPS 		= 'KW_TEXT_TIPS'

TipsLayer._csbResourcePath = 'Lobby/PopLayer/TipsLayer.csb'

function TipsLayer:ctor()
	TipsLayer.super.ctor(self)
	self._tips_text = nil
end

function TipsLayer:init(str)
    self._canTouchBackground = false  
	TipsLayer.super.init(self)

    self:getBgLayer():setVisible(false)
    
    self._tips_text = self:getCsbNode():getChildByName(KW_TEXT_TIPS)
    
    if self._tips_text  then
    	self._tips_text:setString(tostring(str))
	    local delay = cc.DelayTime:create(1)
	    local fadeout = cc.FadeOut:create(0.2)
	    local cfk = cc.CallFunc:create(function()
	    	self:showLayer(false)
    	end)
	    local seq = cc.Sequence:create(delay,fadeout,cfk)
	    self:runAction(seq) 
    end
end

return TipsLayer