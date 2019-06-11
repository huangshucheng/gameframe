local Hero = class("Hero",cc.Node)

local resourcePath = 'MahScene/Hero.csb'

Hero.STATE = { 
    idle = 1,
    move = 2,
    attack = 3,
    death = 4,
}

function Hero:ctor()
	self._state = self.STATE.idle
	self._csbResourceNode = nil
	self:init()
end

function Hero:init()
    self._csbResourceNode = cc.CSLoader:createNode(resourcePath)
    if self._csbResourceNode ~= nil then
        self:addChild(self._csbResourceNode)
        self._csbResourceNode:setPosition(cc.p(0,0))  
        self._csbResourceNode:setAnchorPoint(display.CENTER)
    end
end

function Hero:getState()
	return self._state
end

function Hero:setState(state)
	self._state = state
end

function Hero:destroy()
    self:removeSelf()
end

return Hero