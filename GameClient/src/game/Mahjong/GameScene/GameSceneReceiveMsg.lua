local GameScene = class("GameScene")

local Respones          	= require("game.net.Respones")
local RoomData              = require("game.clientdata.RoomData")
local UserInfo              = require("game.clientdata.UserInfo")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local AuthServiceProxy      = require("game.modules.AuthServiceProxy")
local GameFunction          = require("game.Mahjong.Base.GameFunction")

function GameScene:initClientEventListener()
    addEvent("CheckLinkGameRes",self, self._gameScene, self.onEventCheckLinkGame)
    addEvent("RoomInfoRes",self, self._gameScene, self.onEventRoomInfo)
    addEvent("RoomIdRes",self, self._gameScene, self.onEventRoomId)
    addEvent("PlayCountRes",self, self._gameScene, self.onEventPlayCount)

    addEvent("DessolveRes",self, self._gameScene, self.onEventDessolve)
    addEvent('UserArrivedInfos',self, self._gameScene, self.onEventUserArrivedInfos)
    addEvent("ExitRoomRes",self, self._gameScene, self.onEventExitRoom)
    addEvent('JoinRoomRes',self, self._gameScene, self.onEventJoinRoom)
    addEvent('BackRoomRes',self, self._gameScene, self.onEventBackRoom)
    addEvent("AllUserState", self, self._gameScene, self.onEventUserState)
    
    addEvent('Relogin',self, self._gameScene, self.onEvnetRelogin)
    addEvent('UserOffLine',self, self._gameScene, self.onEventUserOffline)
    addEvent("LoginLogicRes",self, self._gameScene, self.onEventLoginLogic)
    addEvent("GuestLoginRes", self, self._gameScene, self.onEventGuestLogin)
    addEvent("UnameLoginRes", self, self._gameScene, self.onEventUnameLogin)
    addEvent("UserReconnectedRes", self, self._gameScene, self.onEventReconnect)
    addEvent("UserReadyRes", self, self._gameScene, self.onEventUserReady)
end

function GameScene:onEvnetRelogin(event)
    local loginScene = require("game.Lobby.LobbyScene.LoginScene"):create()
    loginScene:run()
    -- Game.showPopLayer('TipsLayer',{'帐号在其他地方登录!'})
end
-----------------------------------------------------
--
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
    RoomData:getInstance():setRoomInfo(roominfo)
    self:showRoomInfo()
    print('room_info: ' .. tostring(roominfo))
end

function GameScene:onEventRoomId(event)
    local data = event._usedata
    local room_id = data.room_id
    RoomData:getInstance():setRoomId(roomid)
    self:showRoomId()
    print('room_id: ' .. tostring(roomid))
end

function GameScene:onEventPlayCount(event)
    local data = event._usedata
    local play_count = data.playcount
    local total_play_count = data.totalplaycount
    RoomData:getInstance():setPlayCount(playcount)
    RoomData:getInstance():setTotalPlayCount(totalplaycount)
    self:showPlayCount()
    print('play_count: ' .. tostring(playcount) .. ' ,total_play_count: ' .. tostring(totalplaycount))
end

function GameScene:onEventDessolve(event)
    local data = event._usedata
    if data.status == Respones.OK then  --只有房主才能解散房间
        self:popScene()
    else
        Game.showPopLayer('TipsLayer',{"解散房间失败"})
    end
end

function GameScene:onEventExitRoom(event)
    local data = event._usedata
    if data.status == Respones.OK then
        local userinfo = data.userinfo
        local serverSeat = userinfo.seatid
        local brandid = userinfo.brandid
        local ishost = userinfo.ishost
        local isoffline = userinfo.isoffline

        if ishost or isoffline then
            RoomData:getInstance():updatePlayerByUserInfo(userinfo)
        else
            RoomData:getInstance():removePlayerBySeatId(serverSeat)
        end
        self:showAllExistUserInfo()
        if tonumber(brandid) == tonumber(UserInfo.getBrandId()) then
        end
    else
        Game.showPopLayer('TipsLayer',{"退出房间失败!"})
    end
    print('onEventExitRoom>> player count: ' .. RoomData:getInstance():getRoomPlayerCount())
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
        LogicServiceProxy:getInstance():sendReconnect()
    end
    print('onEventBackRoom>> player count: ' .. RoomData:getInstance():getRoomPlayerCount())
end

function GameScene:onEventUserArrivedInfos(event)
    local data = event._usedata
    dump(data,'hcc>>onEventUserArrivedInfos')
    if next(data.userinfo) then
        for _,info in ipairs(data.userinfo) do
            RoomData:getInstance():createPlayerByUserInfo(info)
        end
    end
    self:showAllExistUserInfo()
    self:showReadyImag()
    self:showHostImag()
    self:showReadyBtn()
    self:showRoomInfo()
    for i = 1 , 4 do
        local player = RoomData:getInstance():getPlayerBySeatId(i)
        print('onEventUserArrivedInfos>> player id ' .. i .. ' ,is>> ' .. tostring(player))
    end
    print('onEventUserArrivedInfos>> player count: ' .. RoomData:getInstance():getRoomPlayerCount())
end

function GameScene:onEventUserOffline(event)
    local data = event._usedata
    local userinfo = data.userinfo
    if next(userinfo) then
        RoomData:getInstance():updatePlayerByUserInfo(userinfo)
    end
    self:showAllExistUserInfo()
    print('onEventUserOffline>> player count: ' .. RoomData:getInstance():getRoomPlayerCount())
end

function GameScene:onEventLoginLogic(event)
    Game.popLayer('LoadingLayer')
    local data = event._usedata
    if data.status == Respones.OK then
        Game.showPopLayer('TipsLayer',{"登录逻辑服成功!"})
        LogicServiceProxy:getInstance():sendBackRoomReq()
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
       local userstate = body.userstate
       local player = RoomData:getInstance():getPlayerBySeatId(serverSeat)
       if player then
           if player:getBrandId() == brandid then
                player:setState(userstate)
                self:showReadyBtn()
                self:showReadyImag()
           end
       end
    end
end

function GameScene:onEventUserState(event)
    local body = event._usedata
    if next(body.userstate) then
        for index,state in pairs(body.userstate) do
            local player = RoomData:getInstance():getPlayerBySeatId(state.seatid)
            if player then
                player:setState(state.userstate)
            end
        end
    end
    self:showReadyImag()
    self:showReadyBtn()
end

return GameScene