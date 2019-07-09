local CURRENT_MODULE_NAME = ...
local LobbyScene = class("LobbyScene")

local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local SocketUDP             = require('game.net.NetWorkUDP')
local Scheduler             = require("game.utils.scheduler")

function LobbyScene:onTouchJoinRoomBtn(send,eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    Lobby.showPopLayer('JoinRoomLayer')
end

function LobbyScene:onTouchCreateRoomBtn(send,eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
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
    local playCount = 3
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
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    LogicServiceProxy:getInstance():sendBackRoomReq()
    Lobby.showPopLayer('LoadingLayer')
end

function LobbyScene:onTouchEventHeadImgBg(send,eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    Lobby.showPopLayer('MyCenterLayer')
end

function LobbyScene:onTouchSettingBtn(send, eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    Lobby.showPopLayer('SetLayer')
end

function LobbyScene:onTouchMessageBtn(send, eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    Lobby.showPopLayer("RankLayer")
    -- SystemServiceProxy:getInstance():sendGetLoginBonues()--登录奖励  TODO
    --test 
    --[[
    local str = ''
    for i = 1 , 1000 do
        str = str .. i
    end 
    -- local msg = {content = "hcc udp test!!!!!!!!!!!!!!!!!!!!"}
    local msg = {content = str}
    --local Cmd = require("game.net.protocol.Cmd")
    
    if self.tickScheduler == nil then
        self.tickScheduler = Scheduler.scheduleUpdateGlobal(handler(self, function()
            -- LogicServiceProxy:getInstance():sendUdpTest(msg)        
        end))
    end
    ]]
    LogicServiceProxy:getInstance():sendLoginLogicServer()
end

function LobbyScene:onTouchMailBtn(send, eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    Lobby.showPopLayer("MsgLayer")
end

return LobbyScene