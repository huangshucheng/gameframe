local Function = class("Function")
GT = GT or {}

local CURRENT_MOUDEL_NAME = ...

function Function.showPopLayer(layerClassName,initArvg, ...)
    local luaFullPath  =  cc.FileUtils:getInstance():fullPathForFilename("game/Mahjong/PopLayer/" .. layerClassName .. ".lua")
    local luacFullPath =  cc.FileUtils:getInstance():fullPathForFilename("game/Mahjong/PopLayer/" .. layerClassName .. ".luac")

    if  cc.FileUtils:getInstance():isFileExist(luaFullPath) 
        or cc.FileUtils:getInstance():isFileExist(luacFullPath) then
        local PopLayerClass = import("game.Mahjong.PopLayer."..layerClassName,CURRENT_MODULE_NAME)
        local popclass = PopLayerClass.new()
        popclass:init(unpack(initArvg or {}))
        popclass:showLayer(true)
        GT.RootLayer:getInstance():pushLayer(popclass)          
        popclass:setStartCloseLayerFunc(function()
             GT.RootLayer:getInstance():popLayer(layerClassName)
        end)  
        return popclass 
    else
        return GT.showPopLayer(layerClassName,initArvg, ...)
    end   
end

return Function