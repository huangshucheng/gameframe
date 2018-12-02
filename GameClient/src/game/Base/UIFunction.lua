local UIFunction = class('UIFunction')
Lobby = Lobby or {}

function UIFunction.seekWidgetByName(root,strKeyword)        
    if root == nil then
        return nil
    end
    return ccui.Helper:seekWidgetByName(root,strKeyword)
end

function UIFunction.playNodeAnimation(targetPosLayer,pos,aniPath,armatureKeyWord,aniKeyWord,loop,callBackFunc)
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

Lobby.UIFunction = UIFunction

return UIFunction