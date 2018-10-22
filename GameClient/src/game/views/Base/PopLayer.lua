local PopLayer = class("PopLayer",cc.Layer)

function PopLayer:ctor()
    self:enableNodeEvents()
    self._csbResourceNode       = nil
    self._isRender              = false
    self._canTouchBackground    = true

    self._afterCloseLayerFunc   = function()end
    self._startCloseLayerFunc   = function()end
    self._startShowLayerFunc    = function()end
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
        print('hcc>> waring:PopLayer:init() >> self._csbResourceNode is nil')
    end
    self._isRender = false
    if self.onCreate then self:onCreate() end
    if self.addEventListenner then self:addEventListenner() end
end

function PopLayer:showLayer(render)
    if self._isRender == render then
        return
    end
    self._isRender = render
    if render then
        self._startShowLayerFunc()
    else
        self._startCloseLayerFunc()
    end
end

function PopLayer:isShow()
    return self._isRender
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

function PopLayer:setAfterCloseLayerFunc(func)
    self._afterCloseLayerFunc = func
end

function PopLayer:setStartCloseLayerFunc(func)
    self._startCloseLayerFunc = func
end

function PopLayer:setStartShowLayerFunc(func)
    self._startShowLayerFunc = func
end

function PopLayer:getCsbNode()
    return self._csbResourceNode
end

return PopLayer