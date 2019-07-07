local PopLayer = class("PopLayer",function()
    return display.newLayer()
end)

function PopLayer:ctor()
    self:enableNodeEvents()
    self._csbResourceNode       = nil
    self._canTouchBackground    = true
    self:setName(self.__cname)
end

function PopLayer:init()
    if self._csbResourceNode then
        self._csbResourceNode:removeSelf()
        self._csbResourceNode = nil
    end

    local popLayer = ccui.Layout:create() 
    popLayer:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    popLayer:setBackGroundColor(cc.c3b(0,0,0))  
    popLayer:setTouchEnabled(true)
    popLayer:setContentSize(cc.size(2000,2000))
    popLayer:setAnchorPoint(cc.p(0,0))
    popLayer:setPosition(cc.p(0,0))
    popLayer:setOpacity(100)
    popLayer:setName('__popLayer')
    popLayer:addTouchEventListener(handler(self,self.onTouchEventBackground))
    self:addChild(popLayer,-1)

    self._csbResourceNode = cc.CSLoader:createNode(self._csbResourcePath)
    if self._csbResourceNode ~= nil then
        self:addChild(self._csbResourceNode)  
        self._csbResourceNode:setAnchorPoint(display.CENTER)
        self._csbResourceNode:setPosition(display.center)
        self._csbResourceNode:setContentSize(display.size)
        ccui.Helper:doLayout(self._csbResourceNode)
    else
        print('warning:PopLayer:init() >> self._csbResourceNode is nil')
    end
    if self.onCreate then self:onCreate() end
    if self.addClientEventListener then self:addClientEventListener() end
end

function PopLayer:showLayer(render)
    if render then
        local runScene = display.getRunningScene()
        if runScene then 
            local layer = runScene:getChildByName(self:getName())
            if layer then
                layer:setVisible(render)
            else
                runScene:addChild(self, 999)
                self:setName(self.__cname)
            end
        end
    else
        self:removeSelf()
    end
end

function PopLayer:onTouchEventBackground(send,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    if self._canTouchBackground == false then
        return
    end
    
    self:showLayer(false)
end

function PopLayer:setBgOpacity(opacity)
    local bg = self:getChildByName('__popLayer')
    if bg then
        bg:setOpacity(opacity)
    end
end

function PopLayer:getBgLayer()
    return self:getChildByName('__popLayer')
end

function PopLayer:getCsbNode()
    return self._csbResourceNode
end

function PopLayer:isShowTouchEffect(send, eventType)
    if not send or not eventType then
        return false
    end
    if eventType == ccui.TouchEventType.began then
        send:setScale(0.9)
        send:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        send:setScale(1)
        send:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return false
    end 
    return true
end

return PopLayer