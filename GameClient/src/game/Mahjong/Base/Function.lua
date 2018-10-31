local Function = class("Function")
GT = GT or {}

local CURRENT_MOUDEL_NAME = ...

function Function.showPopLayer(layerClassName,initArvg, ...)
    local luaFullPath  =  cc.FileUtils:getInstance():fullPathForFilename("game/Mahjong/PopLayer/" .. layerClassName .. ".lua")
    local luacFullPath =  cc.FileUtils:getInstance():fullPathForFilename("game/Mahjong/PopLayer/" .. layerClassName .. ".luac")

    if  cc.FileUtils:getInstance():isFileExist(luaFullPath) 
        or cc.FileUtils:getInstance():isFileExist(luacFullPath) then
        local layerFile = import("game.Mahjong.PopLayer."..layerClassName,CURRENT_MODULE_NAME)
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
    else
        return GT.showPopLayer(layerClassName,initArvg, ...)
    end   
end

return Function