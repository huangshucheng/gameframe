local LobbyScene = GT.LobbyScene or {}

local Cmd                   = require("game.net.protocol.Cmd")
local Respones              = require("game.net.Respones")
local cmd_name_map          = require("game.net.protocol.cmd_name_map")
local UserInfo              = require("game.clientdata.UserInfo")
local UserRoomInfo          = require("game.clientdata.UserRoomInfo")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")


function LobbyScene:addServerEventListener()
    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
end

function LobbyScene:addClientEventListener()
    addEvent(ClientEvents.ON_ASYC_USER_INFO, self, self.onEventAsycUserInfo)
    addEvent("EditProfileRes",self, self.onEventEditProfile)
    addEvent("AccountUpgradeRes",self, self.onEventAccountUpgrade)
    addEvent("Relogin",self, self.onEventReLogin)
    addEvent("UnameLoginRes",self, self.onEventUnameLogin)
    addEvent("LoginOutRes",self, self.onEventLoginOut)
    addEvent("GetUgameInfoRes",self, self.onEventGetUgameInfo)
    addEvent("RecvLoginBonuesRes",self, self.onEventRecvLoginBonues)
    addEvent("LoginLogicRes",self, self.onEventLoginLogic)
    addEvent("CreateRoomRes", self, self.onEventCreateRoom)
    addEvent("JoinRoomRes", self, self.onEventJoinRoom)
    addEvent("GetCreateStatusRes", self, self.onEvnetGetCreateStatus)
    addEvent("BackRoomRes", self, self.onEventBackRoom)
end

function LobbyScene:onEventData(event)
    local data = event._usedata
    if not data then return end
    dump(data)
    postEvent(cmd_name_map[data.ctype], data.body)  -- post all client event to evety poplayer
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

function LobbyScene:onEventUnameLogin(event)
    GT.popLayer('LoadingLayer')
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
    GT.showPopLayer('TipsLayer',{"登录逻辑服成功!"})
    -- request player create room status
    LogicServiceProxy:getInstance():sendGetCreateStatus()
end

function LobbyScene:onEventNetConnect(envet)
        GT.showPopLayer('TipsLayer',{"网络连接成功!"})
end

function LobbyScene:onEventNetConnectFail(envet)
        GT.showPopLayer('TipsLayer',{"网络连接失败!"}) 
end

function LobbyScene:onEventClose(envet)
        GT.showPopLayer('TipsLayer',{"网络连接关闭111!"})
end

function LobbyScene:onEventClosed(envet)
        GT.showPopLayer('TipsLayer',{"网络连接关闭222!"})
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
        UserRoomInfo.setUserRoomInfoBySeatId(seatid, data.user_info)
        UserRoomInfo.setRoomInfo(data.room_info)
        self:pushScene('game.Mahjong.GameScene.GameScene')
    else
        GT.showPopLayer('TipsLayer',{"创建房间失败"})
    end
end

function LobbyScene:onEventJoinRoom(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
        UserRoomInfo.setRoomInfo(data.room_info)
        local users_info = data.users_info
        if next(users_info) then
            for i,v in ipairs(users_info) do
                UserRoomInfo.setUserRoomInfoBySeatId(v.seatid, v)
            end
        end
        self:pushScene('game.Mahjong.GameScene.GameScene')
    else
        GT.showPopLayer('TipsLayer',{"加入房间失败"})
    end
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
        UserRoomInfo.setRoomInfo(data.room_info)
        local users_info = data.users_info
        if next(users_info) then
            for i,v in ipairs(users_info) do
                UserRoomInfo.setUserRoomInfoBySeatId(v.seatid, v)
            end
        end
        self:pushScene('game.Mahjong.GameScene.GameScene')
    else
        GT.showPopLayer('TipsLayer',{"返回房间失败"})
    end
end