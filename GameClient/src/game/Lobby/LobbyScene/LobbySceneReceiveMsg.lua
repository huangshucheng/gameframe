local LobbyScene = Lobby.LobbyScene or {}

local Cmd                   = require("game.net.protocol.Cmd")
local Respones              = require("game.net.Respones")
local cmd_name_map          = require("game.net.protocol.cmd_name_map")
local UserInfo              = require("game.clientdata.UserInfo")
local RoomData              = require("game.clientdata.RoomData")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local AuthServiceProxy      = require("game.modules.AuthServiceProxy")
local LobbySceneDefine      = require('game.Lobby.LobbyScene.LobbySceneDefine')
local NetWorkUDP            = require("game.net.NetWorkUDP")

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
    addEvent("BackRoomRes", self, self.onEventBackRoom)

    addEvent("GetCreateStatusRes", self, self.onEvnetGetCreateStatus)
    addEvent("HeartBeatRes", self, self.onEventHeartBeat)
    addEvent("UdpTest", self, self.onEventUdpTest)
end

function LobbyScene:onEventEditProfile(event)
    Lobby.popLayer('LoadingLayer')
end

function LobbyScene:onEventAccountUpgrade(event)
    Lobby.popLayer('LoadingLayer')
end

function LobbyScene:onEventReLogin(event)
    self:enterScene('game.Lobby.LobbyScene.LoginScene')
    Lobby.popLayer('LoadingLayer')
    Lobby.showPopLayer('TipsLayer',{'帐号在其他地方登录!'})
end

function LobbyScene:onEventLoginOut(event)
    self:enterScene('game.Lobby.LobbyScene.LoginScene')
    Lobby.popLayer('LoadingLayer')
end

function LobbyScene:onEventGetUgameInfo(event)
    Lobby.popLayer('LoadingLayer')
    local body = event._usedata
    if not body then return end
    if body.status == Respones.OK then
        local img_top_bg = self:getResourceNode():getChildByName(LobbySceneDefine.IMG_TOP_BG)
        if img_top_bg then
            local coin_text         = ccui.Helper:seekWidgetByName(img_top_bg, LobbySceneDefine.TEXT_COIN)
            local diamond_text      = ccui.Helper:seekWidgetByName(img_top_bg, LobbySceneDefine.TEXT_DIAMOND)
            if coin_text then
                coin_text:setString(tostring(body.uinfo.uchip))
            end
            if diamond_text then
                diamond_text:setString(tostring(body.uinfo.uchip2))
            end
        end
    end
end

function LobbyScene:onEventRecvLoginBonues(event)
    Lobby.popLayer('LoadingLayer')
end

function LobbyScene:onEventLoginLogic(event)
    Lobby.popLayer('LoadingLayer')
    local data = event._usedata
    if data.status == Respones.OK then
        Lobby.showPopLayer('TipsLayer',{"登录逻辑服成功!"})
        LogicServiceProxy:getInstance():sendGetCreateStatus()
        -- NetWorkUDP:getInstance():start() --UDP test
    else
        Lobby.showPopLayer('TipsLayer',{"登录逻辑服failed!"})
        LogicServiceProxy:getInstance():sendLoginLogicServer()        
    end
end

function LobbyScene:onEventNetConnect(envet)
    Lobby.showPopLayer('TipsLayer',{"网络连接成功!"})
    Lobby.popLayer('LoadingLayer')
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
        Lobby.showPopLayer('TipsLayer',{"网络连接失败!"})
        Lobby.showPopLayer('LoadingLayer')
end

function LobbyScene:onEventClose(envet)
        Lobby.showPopLayer('LoadingLayer')
end

function LobbyScene:onEventClosed(envet)
        Lobby.showPopLayer('LoadingLayer')
end

function LobbyScene:onEventAsycUserInfo(event)
    local uname = UserInfo.getUserName()
    local img_top_bg = self:getResourceNode():getChildByName(LobbySceneDefine.IMG_TOP_BG)
    if img_top_bg then
        local user_name_text = ccui.Helper:seekWidgetByName(img_top_bg, LobbySceneDefine.TEXT_USER_NAME)
        local img_head = ccui.Helper:seekWidgetByName(img_top_bg, LobbySceneDefine.IMG_HEAD)
        if uname and uname ~= '' and user_name_text then
            user_name_text:setString(tostring(uname))    
        end 
        if img_head then
            img_head:loadTexture(string.format('Lobby/LobbyRes/rectheader/1%s.png',UserInfo.getUserface()))
        end
    end
end

function LobbyScene:onEventCreateRoom(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
        self:pushScene('game.Mahjong.GameScene.GameScene')
    else
        Lobby.showPopLayer('TipsLayer',{"创建房间失败"})
    end
    Lobby.popLayer('LoadingLayer')
end

function LobbyScene:onEventJoinRoom(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
        self:pushScene('game.Mahjong.GameScene.GameScene')
    else
        Lobby.showPopLayer('TipsLayer',{"加入房间失败"})
    end
    Lobby.popLayer('LoadingLayer')
end

function LobbyScene:onEventBackRoom(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
        self:pushScene('game.Mahjong.GameScene.GameScene')
    else
        Lobby.showPopLayer('TipsLayer',{"返回房间失败"})
    end
    Lobby.popLayer('LoadingLayer')
end

function LobbyScene:onEvnetGetCreateStatus(event)
    local data = event._usedata
    local status = data.status
    local img_back_room = nil
    local img_create_room = nil

    local panel_center = self:getResourceNode():getChildByName(LobbySceneDefine.PANEL_CENTER)
    if panel_center then
        img_back_room         = panel_center:getChildByName(LobbySceneDefine.IMG_BACK_ROOM)
        img_create_room       = panel_center:getChildByName(LobbySceneDefine.IMG_CREATE_ROOM)
    end
    if status == Respones.OK then
        if img_back_room then
            img_back_room:setVisible(true)
        end
        if img_create_room then
            img_create_room:setVisible(false)
        end
    else
        if img_back_room then
            img_back_room:setVisible(false)
        end
        if img_create_room then
            img_create_room:setVisible(true)
        end
    end
end

function LobbyScene:onEventGuestLogin(event)
    local body = event._usedata
    Lobby.popLayer('LoadingLayer')
    if body then
        if body.status == Respones.OK then
            UserInfo.setUInfo(body.uinfo)
            UserInfo.setUserIsGuest(true)
            LogicServiceProxy:getInstance():sendLoginLogicServer()
            Lobby.showPopLayer('TipsLayer',{"游客登录成功!"})
        else
            Lobby.showPopLayer('TipsLayer',{"游客登录失败，您帐号已升级成正式帐号!"})
        end
    end
end

function LobbyScene:onEventUnameLogin(event)
    local body = event._usedata
    Lobby.popLayer('LoadingLayer')
    if body.status == Respones.OK then
        UserInfo.setUInfo(body.uinfo)
        LogicServiceProxy:getInstance():sendLoginLogicServer()
        Lobby.showPopLayer('TipsLayer',{"登录成功!"})
    else
        Lobby.showPopLayer('TipsLayer',{"登录失败,帐号或密码错误!"})
    end
end

function LobbyScene:onEventHeartBeat(event)
    local body = event._usedata
    if body.status == Respones.OK then
        LogicServiceProxy:getInstance():sendHeartBeat()
    end
end

function LobbyScene:onEventUdpTest(event)
    local body = event._usedata
    print('hcc>>onEventUdpTest: ' .. body.content)
end
