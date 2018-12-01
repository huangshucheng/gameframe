local LobbyScene = GT.LobbyScene or {}

local Cmd                   = require("game.net.protocol.Cmd")
local Respones              = require("game.net.Respones")
local cmd_name_map          = require("game.net.protocol.cmd_name_map")
local UserInfo              = require("game.clientdata.UserInfo")
local RoomData              = require("game.clientdata.RoomData")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local AuthServiceProxy      = require("game.modules.AuthServiceProxy")

function LobbyScene:addServerEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
end

function LobbyScene:addClientEventListener()
    addEvent(ClientEvents.ON_ASYC_USER_INFO, self, self.onEventAsycUserInfo)
    addEvent("GuestLoginRes", self, self.onEventGuestLogin)
    addEvent("UnameLoginRes", self, self.onEventUnameLogin)
    addEvent("EditProfileRes",self, self.onEventEditProfile)
    addEvent("AccountUpgradeRes",self, self.onEventAccountUpgrade)
    addEvent("Relogin",self, self.onEventReLogin)
    addEvent("LoginOutRes",self, self.onEventLoginOut)
    addEvent("GetUgameInfoRes",self, self.onEventGetUgameInfo)
    addEvent("RecvLoginBonuesRes",self, self.onEventRecvLoginBonues)
    addEvent("LoginLogicRes",self, self.onEventLoginLogic)
    addEvent("CreateRoomRes", self, self.onEventCreateRoom)
    addEvent("JoinRoomRes", self, self.onEventJoinRoom)
    addEvent("GetCreateStatusRes", self, self.onEvnetGetCreateStatus)
    addEvent("BackRoomRes", self, self.onEventBackRoom)
    addEvent("HeartBeatRes", self, self.onEventHeartBeat)
end

function LobbyScene:onEventEditProfile(event)
    GT.popLayer('LoadingLayer')
end

function LobbyScene:onEventAccountUpgrade(event)
    GT.popLayer('LoadingLayer')
end

function LobbyScene:onEventReLogin(event)
    self:enterScene('game.Lobby.LobbyScene.LoginScene')
    GT.popLayer('LoadingLayer')
    GT.showPopLayer('TipsLayer',{'帐号在其他地方登录!'})
end

function LobbyScene:onEventLoginOut(event)
    self:enterScene('game.Lobby.LobbyScene.LoginScene')
    GT.popLayer('LoadingLayer')
end

function LobbyScene:onEventGetUgameInfo(event)
    GT.popLayer('LoadingLayer')
    local body = event._usedata
    if not body then return end
    if body.status == Respones.OK then
        if self._coin_text and self._diamond_text then
            self._coin_text:setString(tostring(body.uinfo.uchip))
            self._diamond_text:setString(tostring(body.uinfo.uchip2))
        end
    end
end

function LobbyScene:onEventRecvLoginBonues(event)
    GT.popLayer('LoadingLayer')
end

function LobbyScene:onEventLoginLogic(event)
    GT.popLayer('LoadingLayer')
    local data = event._usedata
    if data.status == Respones.OK then
        GT.showPopLayer('TipsLayer',{"登录逻辑服成功!"})
        LogicServiceProxy:getInstance():sendGetCreateStatus()
    else
        GT.showPopLayer('TipsLayer',{"登录逻辑服failed!"})
        LogicServiceProxy:getInstance():sendLoginLogicServer()        
    end
end

function LobbyScene:onEventNetConnect(envet)
    GT.showPopLayer('TipsLayer',{"网络连接成功!"})
    GT.popLayer('LoadingLayer')
    --重新登录
    local loginType = UserInfo.getLoginType()
    print('loginType: '.. loginType)
    if loginType == 'uname' then
        local name  = UserInfo.getUserAccount() 
        local pwd   = UserInfo.getUserPwd()
        AuthServiceProxy:getInstance():sendUnameLogin(name,pwd)
    elseif loginType == 'guest' then
        local guestkey = UserInfo.getUserGuestKey()
        AuthServiceProxy:getInstance():sendGuestLogin(guestkey)
    end
end

function LobbyScene:onEventNetConnectFail(envet)
        GT.showPopLayer('TipsLayer',{"网络连接失败!"})
        GT.showPopLayer('LoadingLayer')
end

function LobbyScene:onEventClose(envet)
        -- GT.showPopLayer('TipsLayer',{"网络连接关闭111!"})
        GT.showPopLayer('LoadingLayer')
end

function LobbyScene:onEventClosed(envet)
        -- GT.showPopLayer('TipsLayer',{"网络连接关闭222!"})
        GT.showPopLayer('LoadingLayer')
end

function LobbyScene:onEventAsycUserInfo(event)
    local uname = UserInfo.getUserName()
    if uname and uname ~= '' then
        self._user_name_text:setString(tostring(uname))
    end

    if self._img_head then
        self._img_head:loadTexture(string.format('Lobby/LobbyRes/rectheader/1%s.png',UserInfo.getUserface()))
    end
end

function LobbyScene:onEventCreateRoom(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
        local seatid = data.user_info.seatid
        RoomData:getInstance():createPlayerByUserInfo(data.user_info)
        RoomData:getInstance():setRoomInfo(data.room_info)
        self:pushScene('game.Mahjong.GameScene.GameScene')
    else
        GT.showPopLayer('TipsLayer',{"创建房间失败"})
    end
    GT.popLayer('LoadingLayer')
end

function LobbyScene:onEventJoinRoom(event)
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
        self:pushScene('game.Mahjong.GameScene.GameScene')
    else
        GT.showPopLayer('TipsLayer',{"加入房间失败"})
    end
    GT.popLayer('LoadingLayer')
end

function LobbyScene:onEvnetGetCreateStatus(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
        if self._img_back_room then
            self._img_back_room:setVisible(true)
        end
        if self._img_create_room then
            self._img_create_room:setVisible(false)
        end
    else
        if self._img_back_room then
            self._img_back_room:setVisible(false)
        end
        if self._img_create_room then
            self._img_create_room:setVisible(true)
        end
    end
end

function LobbyScene:onEventBackRoom(event)
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
        self:pushScene('game.Mahjong.GameScene.GameScene')
    else
        GT.showPopLayer('TipsLayer',{"返回房间失败"})
    end
    GT.popLayer('LoadingLayer')
end

function LobbyScene:onEventGuestLogin(event)
    local body = event._usedata
    GT.popLayer('LoadingLayer')
    if body then
        if body.status == Respones.OK then
            UserInfo.setUInfo(body.uinfo)
            UserInfo.setUserIsGuest(true)
            LogicServiceProxy:getInstance():sendLoginLogicServer()
            GT.showPopLayer('TipsLayer',{"游客登录成功!"})
        else
            GT.showPopLayer('TipsLayer',{"游客登录失败，您帐号已升级成正式帐号!"})
        end
    end
end

function LobbyScene:onEventUnameLogin(event)
    local body = event._usedata
    GT.popLayer('LoadingLayer')
    if body.status == Respones.OK then
        UserInfo.setUInfo(body.uinfo)
        LogicServiceProxy:getInstance():sendLoginLogicServer()
        GT.showPopLayer('TipsLayer',{"登录成功!"})
    else
        GT.showPopLayer('TipsLayer',{"登录失败,帐号或密码错误!"})
    end
end

function LobbyScene:onEventHeartBeat(event)
    local body = event._usedata
    if body.status == Respones.OK then
        LogicServiceProxy:getInstance():sendHeartBeat()
    end
end