local Function = class("Function")
GT = GT or {}

local CURRENT_MOUDEL_NAME = ...

function Function.showPopLayer(layerClassName,initArvg,...)
    local PopLayerClass = import("game.Lobby.PopLayer."..layerClassName,CURRENT_MOUDEL_NAME)
    local popclass = PopLayerClass.new()
    popclass:init(unpack(initArvg or {}))
    popclass:showLayer(true)
    return popclass
end

return Function