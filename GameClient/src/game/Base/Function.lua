local Function = class("Function")
Lobby = Lobby or {}

local CURRENT_MOUDEL_NAME = ...

function Function.showPopLayer(layerClassName,initArvg,...)
    if type(layerClassName) ~= 'string' then return end
    local layerFile = import("game.Lobby.PopLayer." .. layerClassName, CURRENT_MOUDEL_NAME)
    local runScene  = display.getRunningScene()
    if runScene then
        local layer = runScene:getChildByName(layerClassName)
        if not layer then
            local popclass = layerFile.new()
            popclass:init(unpack(initArvg or {}))
            runScene:addChild(popclass, 999)
            return popclass
        else
            return layer
        end
    end
end

function Function.popLayer(layerClassName)
    if type(layerClassName) ~= 'string' then return end
    local runScene = display.getRunningScene()
    if runScene then 
        local layer = runScene:getChildByName(layerClassName)
        if layer then
            layer:removeSelf()
        end
    end
end

function Function.getLayer(layerClassName)
    if type(layerClassName) ~= 'string' then return end
    local runScene = display.getRunningScene()
    if runScene then 
        return runScene:getChildByName(layerClassName)
    end
end

return Function