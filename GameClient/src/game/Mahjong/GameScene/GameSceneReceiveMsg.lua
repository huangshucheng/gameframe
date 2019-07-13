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
            -- self:popScene()
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
        for _,info in ipairs(data.user_info) do
            RoomData:getInstance():createPlayerByUserInfo(info)
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

function GameScene:onEventUserState(event)
    local body = event._usedata
    if next(body.users_state) then
        for index,state in pairs(body.users_state) do
            local player = RoomData:getInstance():getPlayerBySeatId(state.seatid)
            if player then
                player:setState(state.user_state)
            end
        end
    end
    self:showReadyImag()
    self:showReadyBtn()
end

return GameScene