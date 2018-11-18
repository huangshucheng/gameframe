local BaseScene = class("BaseScene", cc.Node)

function BaseScene:ctor(name)
	self:enableNodeEvents()
	self.name_ = name
	self.resourceNode_ = nil

    local res = rawget(self.class, "RESOURCE_FILENAME")
    if res then
        self:createResourceNode(res)
    end

    if self.onCreate then self:onCreate() end
    if self.addServerEventListener then self:addServerEventListener() end
    if self.addClientEventListener then self:addClientEventListener() end
end

function BaseScene:getName()
    return self.name_
end

function BaseScene:getResourceNode()
    return self.resourceNode_
end

function BaseScene:createResourceNode(resourceFilename)
    if self.resourceNode_ then
        self.resourceNode_:removeSelf()
        self.resourceNode_ = nil
    end

    self.resourceNode_ = cc.CSLoader:createNode(resourceFilename)
    assert(self.resourceNode_, string.format("ViewBase:createResourceNode() - load resouce node from file \"%s\" failed", resourceFilename))
    self:addChild(self.resourceNode_)

    self.resourceNode_:setContentSize(display.size)
    ccui.Helper:doLayout(self.resourceNode_)
end

function BaseScene:enterScene(scenePath)
    local gameLayer = require(scenePath):create()
    if gameLayer then
    	local scene = display.newScene()
	    scene:addChild(gameLayer)
    	display.runScene(scene)
    end
end

function BaseScene:pushScene(scenePath)
    local gameLayer = require(scenePath):create()
    if gameLayer then
        local scene = display.newScene()
        scene:addChild(gameLayer)
        cc.Director:getInstance():pushScene(scene)
    end
end

function BaseScene:popScene()
    cc.Director:getInstance():popScene()
end

return BaseScene