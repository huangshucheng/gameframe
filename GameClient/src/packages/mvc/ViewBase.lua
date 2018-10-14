
local ViewBase = class("ViewBase", cc.Node)

function ViewBase:ctor(app, name)
    self:enableNodeEvents()
    self.app_ = app
    self.name_ = name
    self._haveBackGroud = true
    self._canTouchBackground = false

    -- check CSB resource file
    local res = rawget(self.class, "RESOURCE_FILENAME")
    if res then
        self:createResourceNode(res)
    end

    local binding = rawget(self.class, "RESOURCE_BINDING")
    if res and binding then
        self:createResourceBinding(binding)
    end
    
    if self.onCreate then self:onCreate() end
    if self.addEventListenner then self:addEventListenner() end
end

function ViewBase:getApp()
    return self.app_
end

function ViewBase:getName()
    return self.name_
end

function ViewBase:getResourceNode()
    return self.resourceNode_
end

function ViewBase:createResourceNode(resourceFilename)
    if self.resourceNode_ then
        self.resourceNode_:removeSelf()
        self.resourceNode_ = nil
    end

    if self._haveBackGroud then
        self._popLayer = ccui.Layout:create() 
        self._popLayer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
        self._popLayer:setBackGroundColor(cc.c3b(0,0,0)) 
        self._popLayer:setTouchEnabled(self._haveBackGroud)
       
        self._popLayer:setContentSize(cc.size(2000,2000))
        self._popLayer:setAnchorPoint(cc.p(0,0))      
        self._popLayer:setPosition( cc.p(0,0))
        self._popLayer:setOpacity(100)
        self:addChild(self._popLayer,-1)
        self._popLayer:addTouchEventListener(handler(self,self.onTouchEventBackground))
    end

    self.resourceNode_ = cc.CSLoader:createNode(resourceFilename)
    assert(self.resourceNode_, string.format("ViewBase:createResourceNode() - load resouce node from file \"%s\" failed", resourceFilename))
    self:addChild(self.resourceNode_)

    self.resourceNode_:setContentSize(display.size)
    ccui.Helper:doLayout(self.resourceNode_)
end

function ViewBase:createResourceBinding(binding)
    assert(self.resourceNode_, "ViewBase:createResourceBinding() - not load resource node")
    for nodeName, nodeBinding in pairs(binding) do
        local node = self.resourceNode_:getChildByName(nodeName)
        if nodeBinding.varname then
            self[nodeBinding.varname] = node
        end
        for _, event in ipairs(nodeBinding.events or {}) do
            if event.event == "touch" then
                node:onTouch(handler(self, self[event.method]))
            end
        end
    end
end

function ViewBase:showWithScene(transition, time, more)
    self:setVisible(true)
    local scene = display.newScene(self.name_)
    scene:addChild(self)
    display.runScene(scene, transition, time, more)
    return self
end

function ViewBase:onTouchEventBackground(send,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    if self._canTouchBackground == false then
        return
    end
    
    self:setVisible(false)
end

return ViewBase
