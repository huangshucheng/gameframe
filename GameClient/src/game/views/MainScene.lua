local MainScene = class("MainScene", cc.load("mvc").ViewBase)

local ByteArray         = require("game.utils.ByteArray")
local NetWork           = require("game.net.NetWork")
local ProtoMan          = require("game.utils.ProtoMan")
local cmd_name_map      = require("game.net.cmd_name_map")
local Cmd               = require("game.net.Cmd")
local Stype             = require("game.net.Stype")

local resFileName       = 'LoginScene.csb'

function MainScene:onCreate()

    self.m_rootNode = cc.CSLoader:createNode(resFileName)
    self.m_rootNode:setContentSize(display.size)
    ccui.Helper:doLayout(self.m_rootNode)
    self:addChild(self.m_rootNode)

    local btn_guest_login = self.m_rootNode:getChildByName('BTN_GUEST_LOGIN')
    if btn_guest_login then
        btn_guest_login:addClickEventListener(handler(self,self.onEventBtnGuestLogin))
    end

    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
end

function MainScene:onEventBtnGuestLogin(sender,eventType)
    local rdstr = math.random(100000, 999999)
    local keystr = tostring(rdstr) .. '8JvrDstUNDuTNnnCKFEw4pKFsn'
    print("rdstr: ".. keystr )
    keystr = '8JvrDstUNDuTNnnCKFEw4pKFsn666666'
    NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eGuestLoginReq,{guest_key = keystr})
end

function MainScene:onEventData(event)
    local data = event._usedata
    if not data then
        return
    end
    dump(data)
    if data.ctype == Cmd.eGuestLoginRes then
        -- self:on_login_return(data.body)
    end
end

return MainScene
