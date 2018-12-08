local GameScene = Game.GameScene or {}

local Cmd               	= require("game.net.protocol.Cmd")
local Respones          	= require("game.net.Respones")
local cmd_name_map      	= require("game.net.protocol.cmd_name_map")
local RoomData              = require("game.clientdata.RoomData")
local UserInfo              = require("game.clientdata.UserInfo")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local AuthServiceProxy      = require("game.modules.AuthServiceProxy")

function GameScene:addServerEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
end

function GameScene:addClientEventListener()
    addEvent("DessolveRes",self, self.onEventDessolve)
    addEvent("ExitRoomRes",self, self.onEventExitRoom)
    addEvent('Relogin',self, self.onEvnetRelogin)
    addEvent('JoinRoomRes',self, self.onEventJoinRoom)
    addEvent('BackRoomRes',self, self.onEventBackRoom)
    addEvent('UserArrived',self, self.onEventUserArrived)
    addEvent('UserOffLine',self, self.onEventUserOffline)
    addEvent("LoginLogicRes",self, self.onEventLoginLogic)
    addEvent("GuestLoginRes", self, self.onEventGuestLogin)
    addEvent("UnameLoginRes", self, self.onEventUnameLogin)
    addEvent("HeartBeatRes", self, self.onEventHeartBeat)
    addEvent("UserReconnectedRes", self, self.onEventReconnect)
end

function GameScene:onEventNetConnect(event)
    Game.showPopLayer('TipsLayer',{"网络连接成功!"})
    Game.popLayer('LoadingLayer')
    --重新登录
    local loginType = UserInfo.getLoginType()
    if loginType == 'uname' then
        local name  = UserInfo.getUserAccount() 
        local pwd   = UserInfo.getUserPwd()
        AuthServiceProxy:getInstance():sendUnameLogin(name,pwd)
    elseif loginType == 'guest' then
        local guestkey = UserInfo.getUserGuestKey()
        AuthServiceProxy:getInstance():sendGuestLogin(guestkey)
    end
end

function GameScene:onEventNetConnectFail(event)
    Game.showPopLayer('TipsLayer',{"网络连接失败!"}) 
    Game.showPopLayer('LoadingLayer')
end

function GameScene:onEventClose(event)
    Game.showPopLayer('LoadingLayer')
end

function GameScene:onEventClosed(event)
    Game.showPopLayer('LoadingLayer')
end

function GameScene:onEvnetRelogin(event)
    self:enterScene('game.Lobby.LobbyScene.LoginScene')
    Game.showPopLayer('TipsLayer',{'帐号在其他地方登录!'})
end

function GameScene:onEventDessolve(event)
    local data = event._usedata
    if data.status == Respones.OK then  --只有房主才能解散房间
        RoomData:getInstance():reset()
        self:popScene()
    else
        Game.showPopLayer('TipsLayer',{"解散房间失败"})
    end
end

function GameScene:onEventExitRoom(event)
    local data = event._usedata
    if data.status == Respones.OK then
        local user_info = data.user_info
        local seatid = user_info.seatid
        local brandid = user_info.brandid
        local ishost = user_info.ishost

        if ishost then
            RoomData:getInstance():updatePlayerByUserInfo(user_info)
        else
            RoomData:getInstance():removePlayerBySeatId(seatid)
        end
        if tonumber(brandid) == tonumber(UserInfo.getBrandId()) then
            self:popScene()
        end
    else
        Game.showPopLayer('TipsLayer',{"退出房间失败!"})
    end
    self:showAllExistUserInfo()
end

function GameScene:onEventJoinRoom(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
        RoomData:getInstance():setRoomInfo(data.room_info)
        local users_info = data.users_info
        if next(users_info) then
            for _,info in ipairs(users_info) do
                RoomData:getInstance():createPlayerByUserInfo(info)
            end
        end
    end
    self:showAllExistUserInfo()
end

function GameScene:onEventBackRoom(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
        RoomData:getInstance():reset()
        RoomData:getInstance():setRoomInfo(data.room_info)
        local users_info = data.users_info
        if next(users_info) then
            for _,info in ipairs(users_info) do
                RoomData:getInstance():createPlayerByUserInfo(info)
            end
        end
        LogicServiceProxy:getInstance():sendReconnect()
    end
    self:showRoomInfo()
    self:showAllExistUserInfo()
end

function GameScene:onEventUserArrived(event)
    local data = event._usedata
    if next(data) then
        RoomData:getInstance():createPlayerByUserInfo(data)
    end
    self:showAllExistUserInfo()
end

function GameScene:onEventUserOffline(event)
    local data = event._usedata
    local user_info = data.user_info
    if next(user_info) then
        RoomData:getInstance():updatePlayerByUserInfo(user_info)
    end
    self:showAllExistUserInfo()
end

function GameScene:onEventLoginLogic(event)
    Game.popLayer('LoadingLayer')
    local data = event._usedata
    if data.status == Respones.OK then
        Game.showPopLayer('TipsLayer',{"登录逻辑服成功!"})
        LogicServiceProxy:getInstance():sendBackRoomReq()
    else
        Game.showPopLayer('TipsLayer',{"登录逻辑服failed!"})
        LogicServiceProxy:getInstance():sendLoginLogicServer()  
    end
end

function GameScene:onEventGuestLogin(event)
    local body = event._usedata
    Game.popLayer('LoadingLayer')
    if body then
        if body.status == Respones.OK then
            UserInfo.setUInfo(body.uinfo)
            UserInfo.setUserIsGuest(true)
            LogicServiceProxy:getInstance():sendLoginLogicServer()
            Game.showPopLayer('TipsLayer',{"游客登录成功!"})
        else
            Game.showPopLayer('TipsLayer',{"游客登录失败，您帐号已升级成正式帐号!"})
        end
    end
end

function GameScene:onEventUnameLogin(event)
    local body = event._usedata
    Game.popLayer('LoadingLayer')
    if body.status == Respones.OK then
        UserInfo.setUInfo(body.uinfo)
        LogicServiceProxy:getInstance():sendLoginLogicServer()
        Game.showPopLayer('TipsLayer',{"登录成功!"})
    else
        Game.showPopLayer('TipsLayer',{"登录失败,帐号或密码错误!"})
    end
end

function GameScene:onEventHeartBeat(event)
    local body = event._usedata
    if body.status == Respones.OK then
        LogicServiceProxy:getInstance():sendHeartBeat()
    end
end

function GameScene:onEventReconnect(event)
    print('hcc>> GameScene:onEventReconnect...........111')        
    local body = event._usedata
    if body.status == Respones.OK then
        print('hcc>> GameScene:onEventReconnect...........222')        
    end
end