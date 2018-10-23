local RootLayer = class("RootLayer")
GT = GT or {}

function RootLayer:ctor()
    self._popLayers = {}
    self._topLayerInstance = nil
    self._rootNode = nil
end

function RootLayer:getInstance()
    if RootLayer._topLayerInstance == nil then
        RootLayer._topLayerInstance = RootLayer.new()
    end
    return RootLayer._topLayerInstance
end

function RootLayer:init()         
    if self._rootNode == nil then
        self._rootNode = cc.Layer:create()   
        self._rootNode:setAnchorPoint(cc.p(0,0))     
        self._rootNode:setPosition(cc.p(0,0))
        self._rootNode:setContentSize(display.size)    
        self._rootNode:retain()
        self:moveToRunningScene()
    end 
end

function RootLayer:moveToRunningScene() 
    local runScene = display.getRunningScene()
    if runScene ~= self._rootNode:getParent() then
        self._rootNode:removeSelf()
        runScene:addChild(self._rootNode,9999)
    end
end

function RootLayer:pushLayer(layer)
    local layerName = layer.__cname
    if layerName ~= nil then  
        for i = #self._popLayers,1,-1 do
            local name = self._popLayers[i]:getName()
            if self._popLayers[i]:getName() == layerName then
                self._popLayers[i]:removeSelf()
                table.remove(self._popLayers,i)
            end
        end
    end
    
    self._rootNode:addChild(layer)  
    table.insert(self._popLayers,layer)
    self:moveToRunningScene()
end

function RootLayer:popLayer(layername)    
    local removeLayerIndex = #self._popLayers  
    
    local className = layername or self._popLayers[#self._popLayers].__cname
    for i = #self._popLayers,1,-1 do
        if self._popLayers[i].__cname == className then
            removeLayerIndex = i
            break
        end
    end
    
    if self._popLayers[removeLayerIndex] == nil then
        return
    end
    if self._popLayers[removeLayerIndex].__cname ~= className and 
        self._popLayers[removeLayerIndex].__cname ~= string.match(className,self._popLayers[removeLayerIndex].__cname) then
        return
    end

    if self._popLayers[removeLayerIndex] then
        self._popLayers[removeLayerIndex]:removeSelf()
        table.remove(self._popLayers,removeLayerIndex)
    end
end

function RootLayer:getLayer(layername)    
    for i = #self._popLayers,1,-1 do
        if self._popLayers[i].__cname == layername then
            return self._popLayers[i]
        end
    end  
end

function RootLayer:getTopLayer()
    return self._popLayers[#self._popLayers]
end

function RootLayer:clearLayers()
    for i = #self._popLayers,1,-1 do
        self:popLayer(self._popLayers[i].__cname)
    end
end

function RootLayer:getAllLayers()
    return self._popLayers
end

function RootLayer:getLayerCount()
    local count = 0
    for k,v in pairs(self._popLayers) do
        count = count + 1
    end
    return count
end

GT.RootLayer = RootLayer

return RootLayer