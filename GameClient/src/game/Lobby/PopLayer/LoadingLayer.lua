local PopLayer = require('game.Base.PopLayer')
local LoadingLayer = class("LoadingLayer", PopLayer)

function LoadingLayer:ctor()
	LoadingLayer.super.ctor(self)
end

function LoadingLayer:init()
	LoadingLayer.super.init(self)

    local node = cc.Node:create() 
    node:setAnchorPoint(cc.p(0,0))      
    node:setPosition(cc.p( 0, 0))
    self:addChild(node)
    GT.UIFunction.playNodeAnimation(node,cc.p(display.cx,display.cy),"animation/loading_mini/loading_mini.ExportJson","loading_mini","loading",1) 
    self._canTouchBackground = false    

    local delay = cc.DelayTime:create(5)
    local callfuck = cc.CallFunc:create(function()
    	-- self:showLayer(false)
	end)
	self:runAction(cc.Sequence:create(delay,callfuck))
end

return LoadingLayer