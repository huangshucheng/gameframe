local Function = class("Function")
GT = GT or {}

local CURRENT_MOUDEL_NAME = ...

function Function.showPopLayer(layerClassName,initArvg,...)
    local PopLayerClass = import("game.views.PopLayer."..layerClassName,CURRENT_MOUDEL_NAME)
    local popclass = PopLayerClass.new()
    popclass:init(unpack(initArvg or {}))
    popclass:showLayer(true)
    GT.RootLayer:getInstance():pushLayer(popclass)    

    popclass:setStartCloseLayerFunc(function()
         GT.RootLayer:getInstance():popLayer(layerClassName)
    end)  
    return popclass  
end

function Function.popLayer(layerClassName)
    GT.RootLayer:getInstance():popLayer(layerClassName)
end

function Function.getLayer(layerClassName)
    return GT.RootLayer:getInstance():getLayer(layerClassName)
end

function Function.getPopLayerClass(layerClassName)
    local PopLayerClass = import("game.views.PopLayer."..layerClassName,CURRENT_MOUDEL_NAME)
    return PopLayerClass
end

function Function.clearLayers()
    return GT.RootLayer:getInstance():clearLayers()
end

return Function