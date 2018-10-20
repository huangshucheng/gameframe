local UIFunction = class('UIFunction')
GT = GT or {}

function UIFunction.seekWidgetByName(root,strKeyword)        
    if root == nil then
        return nil
    end
    return ccui.Helper:seekWidgetByName(root,strKeyword)
end

function UIFunction.playAniWithTargetPos(lastArmature,targetPosLayer,targetPosAniKey,aniPath,armatureKeyWord,aniKeyWord,loop,callBackFunc)
    if aniPath == nil then
        return
    end   
    if armatureKeyWord == nil then
        return
    end   
    if aniKeyWord == nil or aniKeyWord == "" then
        return
    end

    if lastArmature == nil then
        local findNode = UIFunction.seekWidgetByName(targetPosLayer,targetPosAniKey)
        if findNode == nil then
            return
        end

        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(aniPath)
        lastArmature = ccs.Armature:create(armatureKeyWord)
        if lastArmature then
            findNode:addChild(lastArmature)
            lastArmature:setAnchorPoint(cc.p(0.5,0.5));
        end
    end

    if lastArmature ~= nil then
        lastArmature:getAnimation():play(aniKeyWord,-1,loop)
        if callBackFunc ~= nil then
            lastArmature:getAnimation():setMovementEventCallFunc(callBackFunc)
        end
        return lastArmature
    end

end

function UIFunction.playNodeAniWithTargetPos(targetPosLayer,pos,aniPath,armatureKeyWord,aniKeyWord,loop,callBackFunc)
    if aniPath == nil then
        return
    end

    if armatureKeyWord == nil then
        return
    end   
    if aniKeyWord == nil or aniKeyWord == "" then
        return
    end

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(aniPath)
    local lastArmature = ccs.Armature:create(armatureKeyWord)
    if lastArmature then
        targetPosLayer:addChild(lastArmature)
        lastArmature:setAnchorPoint(cc.p(0.5,0.5))
        lastArmature:setPosition(pos)
    end

    if lastArmature ~= nil then
        lastArmature:getAnimation():play(aniKeyWord,-1,loop)
        if callBackFunc ~= nil then
            lastArmature:getAnimation():setMovementEventCallFunc(callBackFunc)
        end
        return lastArmature
    end
end

function UIFunction.playAniWithTargetPosNew(lastArmature,targetPosLayer,targetPosAniKey,aniPath,armatureKeyWord,aniKeyWord,loop,callBackFunc)
    if aniPath == nil then
        return
    end   
    if not cc.FileUtils:getInstance():isFileExist(aniPath .. armatureKeyWord .. ".ExportJson") then 
        return 
    end
    if armatureKeyWord == nil then
        return
    end   
    if aniKeyWord == nil or aniKeyWord == "" then
        return
    end
    if targetPosAniKey == nil or targetPosAniKey == "" then
        return
    end

    if lastArmature == nil then
        local findNode = UIFunction.seekWidgetByName(targetPosLayer,targetPosAniKey)
        if findNode == nil then
            return
        end  
        
        local pngPath = aniPath .. armatureKeyWord .. ".png"
        local plistPath = aniPath .. armatureKeyWord .. ".plist"
        local jsonPath = aniPath .. armatureKeyWord .. ".ExportJson"
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(pngPath, plistPath, jsonPath)
        local lastArmature1 = ccs.Armature:create(armatureKeyWord)
        if lastArmature1 then
            findNode:addChild(lastArmature1)
            lastArmature1:setAnchorPoint(cc.p(0.5, 0.5))
            lastArmature1:getAnimation():play(aniKeyWord, -1, 1)    
        end         
    end
end

function UIFunction.playAniWithTargetPosChanged(lastArmature,targetPosLayer,targetPosAniKey,aniPath,armatureKeyWord,aniKeyWord,loop,callBackFunc)
    if aniPath == nil then
        return
    end   
    if not cc.FileUtils:getInstance():isFileExist(aniPath .. armatureKeyWord .. ".ExportJson") then 
        return 
    end
    if armatureKeyWord == nil then
        return
    end   
    if aniKeyWord == nil or aniKeyWord == "" then
        return
    end
    if targetPosAniKey == nil or targetPosAniKey == "" then
        return
    end
        
    if lastArmature == nil then
        local findNode = UIFunction.seekWidgetByName(targetPosLayer,targetPosAniKey)
        if findNode == nil then
            return
        end  
        local index = 0
        while true do 
            if cc.FileUtils:getInstance():isFileExist(aniPath .. armatureKeyWord .. index .. ".plist") then
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(
                    aniPath .. armatureKeyWord .. index .. ".png", 
                    aniPath .. armatureKeyWord .. index .. ".plist", 
                    aniPath .. armatureKeyWord .. ".ExportJson")
            else 
                break
            end
            index = index + 1
        end
        local lastArmature1 = ccs.Armature:create(armatureKeyWord)
        if lastArmature1 then
            findNode:addChild(lastArmature1)
            lastArmature1:setAnchorPoint(cc.p(0.5, 0.5))
            lastArmature1:getAnimation():play(aniKeyWord, -1, 1)    
        end         
    end
end

GT.UIFunction = UIFunction

return UIFunction