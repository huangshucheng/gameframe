local LobbyScene = Lobby.LobbyScene or {}

local LogicServiceProxy     = require("game.modules.LogicServiceProxy")

function LobbyScene:onTouchJoinRoomBtn(send,eventType)
    if eventType == ccui.TouchEventType.began then
        send:setScale(0.9)
        send:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        send:setScale(1)
        send:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    Lobby.showPopLayer('JoinRoomLayer')
end

function LobbyScene:onTouchCreateRoomBtn(send,eventType)
    if eventType == ccui.TouchEventType.began then
        send:setScale(0.9)
        send:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        send:setScale(1)
        send:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    --[[    
    local str = 'start<< '
    for idx = 1 , 500 do
        str = str .. idx
    end
    str = str .. '  end>>'
    ]]
    --[[
        rule:
        playerNum='4';maxQuanShu='2';
    ]]
    local playerNum = 4
    local playCount = 8
    local isAAPay = 1
    local baseScore = 1
    local gamerule = "playerNum='" .. playerNum .. "';"
                    .. "playCount='" .. playCount.. "';" 
                    .. "isAAPay='" .. isAAPay.. "';" 
                    .. "baseScore='" .. baseScore .. "';"
    print("gamerule: " .. gamerule)
    LogicServiceProxy:getInstance():sendCreateRoom(gamerule)
    Lobby.showPopLayer('LoadingLayer')
end

function LobbyScene:onTouchBackRoomBtn(send,eventType)
    if eventType == ccui.TouchEventType.began then
        send:setScale(0.9)
        send:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        send:setScale(1)
        send:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    LogicServiceProxy:getInstance():sendBackRoomReq()
    Lobby.showPopLayer('LoadingLayer')
end

function LobbyScene:onTouchEventHeadImgBg(send,eventType)
      if eventType == ccui.TouchEventType.began then
        send:setScale(0.9)
        send:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        send:setScale(1)
        send:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    Lobby.showPopLayer('MyCenterLayer')
end

function LobbyScene:onTouchSettingBtn(send, eventType)
    Lobby.showPopLayer('SetLayer')
end

local SocketUDP = require('game.net.SocketUDP')
local udp       = SocketUDP.new()
function LobbyScene:onTouchMessageBtn(send, evnetType)
    -- Lobby.showPopLayer("RankLayer")
    -- SystemServiceProxy:getInstance():sendGetLoginBonues()--登录奖励  TODO
    --test 
    -- LogicServiceProxy:getInstance():sendUdpTest()
    local msg = {
        content = "hccloveyou"
    }
    local Cmd                   = require("game.net.protocol.Cmd")
    if udp then
        udp:sendMsg(3,Cmd.eUdpTest,msg)
    end
end

function LobbyScene:onTouchMailBtn(send, evnetType)
    Lobby.showPopLayer("MsgLayer")
end
