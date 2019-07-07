local UIFunction = class('UIFunction')
Lobby = Lobby or {}

local function seekWidgetByName(root, strKeyword)
    if not root then
        return nil 
    end
    
    if root:getName() == strKeyword then 
        return root 
    end

    local children = root:getChildren()
    for i = 1 , #children do
        local node = seekWidgetByName(children[i],strKeyword)
        if node then
            return node
        end
    end
    return nil
end

function UIFunction.seekWidgetByName(root,strKeyword)
    if root == nil or strKeyword == nil then
        return nil
    end
    return seekWidgetByName(root,strKeyword)
end
--[[
function UIFunction.seekWidgetByName(root,strKeyword)        
    if root == nil then
        return nil
    end
    local node = root:getChildByName(strKeyword)
    if node then
        return node
    else
        return ccui.Helper:seekWidgetByName(root,strKeyword)
    end
end
]]
--封装监听函数
function UIFunction.addTouchEventListener(node, name, func)
    if node == nil then
        return
    end
    local findNode = UIFunction.seekWidgetByName(node,name)
    if findNode ~= nil then
        findNode:addTouchEventListener(func)
        return true
    end
    return false
end

function UIFunction.setString(root, name, string)
    if root == nil or name == nil then
        return
    end
    string = tostring(string) or ''

    local text = UIFunction.seekWidgetByName(root,name)
    if text then
        if text.setString then
            text:setString(string)
        elseif text.setText then
            text:setText(string)
        end
        return true
    end
    return false
end

function UIFunction.setVisible(root, name, visible)
    if root == nil then
        return
    end
    local findNode = UIFunction.seekWidgetByName(root,name)
    if findNode ~= nil then
        findNode:setVisible(visible)
        return true 
    end
    return false
end

function UIFunction.loadTexture(root,name,pngKeyword,type)
    if root == nil then
        return
    end
    if pngKeyword == nil then
        return
    end
    if not type then
        type = ccui.TextureResType.localType    -- or ccui.TextureResType.plistType
    end
    local findNode = UIFunction.seekWidgetByName(root,name)
    if findNode ~= nil then
        if findNode.loadTexture then
            findNode:loadTexture(string.format("%s",pngKeyword),type)
            return true
        end
    end
    return false
end

function UIFunction.setColor(root,name,color3b)
    if root == nil then
        return
    end
    local findNode = UIFunction.seekWidgetByName(root,name)
    if findNode ~= nil then
        if findNode.setColor then
            findNode:setColor(color3b)
        end
        if findNode.setTextColor then
            findNode:setTextColor(color3b)
        end
        return true
    end
    return false
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

function UIFunction.isShowTouchEffect(send, eventType)
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

Lobby.UIFunction = UIFunction

return UIFunction