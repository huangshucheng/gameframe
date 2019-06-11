local JoyStick = class("JoyStick", cc.Layer)

local resourcePath = 'MahScene/JoyStick.csb'

local KW_JOYSTICK_BG 		= 'KW_JOYSTICK_BG'
local KW_JOYSTICK_CENTER 	= 'KW_JOYSTICK_CENTER'
local MAX_RADIS = 100

function JoyStick:ctor()
	self._csbResourceNode = nil
	self._dir = cc.p(0,0)
	self._joystick = nil
	self._joystickBg = nil
	self:init()
	self:setTouchEnabled(true)
end

function JoyStick:init()
    self._csbResourceNode = cc.CSLoader:createNode(resourcePath)
    if self._csbResourceNode ~= nil then
        self:addChild(self._csbResourceNode)
        self._csbResourceNode:setPosition(cc.p(200,200))  
        self._csbResourceNode:setAnchorPoint(display.CENTER)

        self._joystickBg = self._csbResourceNode:getChildByName(KW_JOYSTICK_BG)
    	self._joystick = self._csbResourceNode:getChildByName(KW_JOYSTICK_CENTER)
    end

   local function onTouchBegan(touch, event) 
        if self:onTouchBegan(touch,event) then
            return true 
        else
            return false
        end
    end
	local function onTouchMoved(touch, event)self:onTouchMoved(touch,event) end
    local function onTouchEnded(touch, event)self:onTouchEnded(touch,evnet) end
    local function onTouchCanceled(touch, event)self:onTouchCanceled(touch,evnet) end
    -- 监听触摸 
	self._touchListener = cc.EventListenerTouchOneByOne:create() 
	self._touchListener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	self._touchListener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED) 
	self._touchListener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED) 
	self._touchListener:registerScriptHandler(onTouchCanceled, cc.Handler.EVENT_TOUCH_CANCELLED) 
	local eventDispatcher = self:getEventDispatcher() 
	eventDispatcher:addEventListenerWithSceneGraphPriority(self._touchListener, self)
end

function JoyStick:onTouchBegan(touch, event)
    if not self._csbResourceNode then return false end
    local location = touch:getLocation()
    local locationInNode =  self._csbResourceNode:convertToNodeSpace(location)
    local len =  cc.pGetLength(locationInNode)
    self._dir = cc.p(locationInNode.x / len , locationInNode.y / len)
    if len > MAX_RADIS then
    	locationInNode.x = MAX_RADIS*locationInNode.x / len
    	locationInNode.y = MAX_RADIS*locationInNode.y / len
    end
	if self._joystick then
		self._joystick:setPosition(cc.p(locationInNode))
	end
	return true
end

function JoyStick:onTouchMoved(touch, event)
    if not self._csbResourceNode then return end
    local location = touch:getLocation()
    local locationInNode =  self._csbResourceNode:convertToNodeSpace(location)
    local len =  cc.pGetLength(locationInNode)
    self._dir = cc.p(locationInNode.x / len , locationInNode.y / len)
    if len > MAX_RADIS then
    	locationInNode.x = MAX_RADIS*locationInNode.x / len
    	locationInNode.y = MAX_RADIS*locationInNode.y / len
    end
	if self._joystick then
		self._joystick:setPosition(cc.p(locationInNode))
	end
end

function JoyStick:onTouchEnded(touch, event)
    self:resetPos()
	self._dir = cc.p(0,0)
end

function JoyStick:onTouchCanceled(touch, event)
    self:resetPos()
	self._dir = cc.p(0,0)
end

function JoyStick:resetPos()
	if self._joystick then
		self._joystick:setPosition(cc.p(0,0))
	end
end

function JoyStick:getDir()
	return self._dir
end

function JoyStick:getPointLen()
	return cc.pGetLength(self._dir)
end

function JoyStick:setDir(x,y)
	self._dir = cc.p(x,y)
end

return JoyStick