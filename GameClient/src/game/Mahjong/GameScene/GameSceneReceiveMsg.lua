local GameScene = Game.GameScene or {}

local Respones          	= require("game.net.Respones")
local RoomData              = require("game.clientdata.RoomData")
local UserInfo              = require("game.clientdata.UserInfo")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local AuthServiceProxy      = require("game.modules.AuthServiceProxy")
local GameFunction          = require("game.Mahjong.Base.GameFunction")

function GameScene:addServerEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
end

function GameScene:addClientEventListener()
    addEvent("CheckLinkGameRes",self, self.onEventCheckLinkGame)
    addEvent("RoomInfoRes",self, self.onEventRoomInfo)
    addEvent("RoomIdRes",self, self.onEventRoomId)
    addEvent("PlayCountRes",self, self.onEventPlayCount)

    addEvent("DessolveRes",self, self.onEventDessolve)
    addEvent('UserArrivedInfos',self, self.onEventUserArrivedInfos)
    addEvent("ExitRoomRes",self, self.onEventExitRoom)
    addEvent('JoinRoomRes',self, self.onEventJoinRoom)
    addEvent('BackRoomRes',self, self.onEventBackRoom)
    addEvent("GameStart", self, self.onEventGameStart)
    
    addEvent('Relogin',self, self.onEvnetRelogin)
    addEvent('UserOffLine',self, self.onEventUserOffline)
    addEvent("LoginLogicRes",self, self.onEventLoginLogic)
    addEvent("GuestLoginRes", self, self.onEventGuestLogin)
    addEvent("UnameLoginRes", self, self.onEventUnameLogin)
    addEvent("HeartBeatRes", self, self.onEventHeartBeat)
    addEvent("UserReconnectedRes", self, self.onEventReconnect)
    addEvent("UserReadyRes", self, self.onEventUserReady)
    addEvent("LogicFrame", self, self.onEventServerLogicFrame)
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
    -- Game.showPopLayer('TipsLayer',{'帐号在其他地方登录!'})
end
-----------------------------------------------------

function GameScene:onEventCheckLinkGame(event)
    local data = event._usedata
    if data.status == Respones.OK then
        print('link game logic success')
    else
        print('link game logic failed')
    end
end

function GameScene:onEventRoomInfo(event)
    local data = event._usedata
    local room_info = data.room_info
    RoomData:getInstance():setRoomInfo(room_info)
    self:showRoomInfo()
    print('room_info: ' .. tostring(room_info))
end

function GameScene:onEventRoomId(event)
    local data = event._usedata
    local room_id = data.room_id
    RoomData:getInstance():setRoomId(room_id)
    self:showRoomId()
    print('room_id: ' .. tostring(room_id))
end

function GameScene:onEventPlayCount(event)
    local data = event._usedata
    local play_count = data.play_count
    local total_play_count = data.total_play_count
    RoomData:getInstance():setPlayCount(play_count)
    RoomData:getInstance():setTotalPlayCount(total_play_count)
    self:showPlayCount()
    print('play_count: ' .. tostring(play_count) .. ' ,total_play_count: ' .. tostring(total_play_count))
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
        local serverSeat = user_info.seatid
        local brandid = user_info.brandid
        local ishost = user_info.ishost
        local isoffline = user_info.isoffline

        if ishost or isoffline then
            RoomData:getInstance():updatePlayerByUserInfo(user_info)
        else
            RoomData:getInstance():removePlayerBySeatId(serverSeat)
        end
        self:showAllExistUserInfo()
        if tonumber(brandid) == tonumber(UserInfo.getBrandId()) then
            self:popScene()
        end
    else
        Game.showPopLayer('TipsLayer',{"退出房间失败!"})
    end
end

function GameScene:onEventJoinRoom(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
    end
end

function GameScene:onEventBackRoom(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
        RoomData:getInstance():reset()
    end
end

function GameScene:onEventUserArrivedInfos(event)
    local data = event._usedata
    dump(data,'hcc>>onEventUserArrivedInfos')
    if next(data.user_info) then
        for _,v in ipairs(data.user_info) do
            RoomData:getInstance():createPlayerByUserInfo(v)
        end
    end
    self:showAllExistUserInfo()
    self:showReadyImag()
    self:showHostImag()
    self:showReadyBtn()
    self:showRoomInfo()
    print('hcc>>onEventUserArrivedInfos')
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
        LogicServiceProxy:getInstance():sendCheckLinkGameReq()
        LogicServiceProxy:getInstance():sendReconnect()
        print('hcc>>GameScene:onEventLoginLogic')
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
    local body = event._usedata
    if body.status == Respones.OK then
    end
end

function GameScene:onEventUserReady(event)
    local body = event._usedata
    if body.status == Respones.OK then
       local brandid = body.brandid
       local serverSeat = body.seatid
       local user_state = body.user_state
       local player = RoomData:getInstance():getPlayerBySeatId(serverSeat)
       if player then
           if player:getBrandId() == brandid then
                player:setState(user_state)
                self:showReadyBtn()
                self:showReadyImag()
           end
       end
    end
end

function GameScene:onEventGameStart(event)
    local body = event._usedata    
    if next(body.users_state) then
        for serverSeat,state in pairs(body.users_state) do
            local player = RoomData:getInstance():getPlayerBySeatId(serverSeat)
            if player then
                player:setState(state)
            end
        end
    end
    self:showReadyImag()
end