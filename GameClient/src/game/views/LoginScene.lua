local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.Cmd")
local Stype             = require("game.net.Stype")
local Respones          = require("game.net.Respones")
local UserInfo          = require("game.clientdata.UserInfo")

LoginScene.RESOURCE_FILENAME = 'Lobby/LoginScene.csb'

local BTN_GUEST_LOGIN = 'BTN_GUEST_LOGIN'
local BTN_LOBBY_REGISTER = 'BTN_LOBBY_REGISTER'
local IMG_LOGIN_BG = 'IMG_LOGIN_BG'
local PANEL_LOGIN = 'PANEL_LOGIN'
local PANEL_REGISTER = 'PANEL_REGISTER'
local BTN_LOGIN = 'BTN_LOGIN'
local BTN_GOTO_REGISTER = 'BTN_GOTO_REGISTER'
local BTN_REG_CLOSE = 'BTN_REG_CLOSE'
local BTN_REGISTER = 'BTN_REGISTER'
local TEXTFIELD_ACCOUNT = 'TEXTFIELD_ACCOUNT'
local TEXTFIELD_PWD = 'TEXTFIELD_PWD'
local TEXTFIELD_PWD_CONF = 'TEXTFIELD_PWD_CONF'

function LoginScene:onCreate()
    local btn_guest_login = self:getResourceNode():getChildByName(BTN_GUEST_LOGIN)
    local btn_lobby_register = self:getResourceNode():getChildByName(BTN_LOBBY_REGISTER)

    if btn_guest_login then
        btn_guest_login:addClickEventListener(handler(self,self.onEventBtnGuestLogin))
    end

    local img_panel_login_bg = self:getResourceNode():getChildByName(IMG_LOGIN_BG)

    if not img_panel_login_bg then
        return
    end

    local panel_login = ccui.Helper:seekWidgetByName(img_panel_login_bg, PANEL_LOGIN)
    local panel_register = ccui.Helper:seekWidgetByName(img_panel_login_bg, PANEL_REGISTER)

    if (not panel_login) or (not panel_register) then
        return
    end

    local btn_login = ccui.Helper:seekWidgetByName(panel_login, BTN_LOGIN)
    if btn_login then
        btn_login:addClickEventListener(handler(self,self.onEventBtnLogin))     
    end
    local btn_goto_reg = ccui.Helper:seekWidgetByName(panel_login, BTN_GOTO_REGISTER)
    if btn_goto_reg then
       btn_goto_reg:addClickEventListener(handler(self,self.onEventBtnGoToLogin))  
    end

    local btn_reg_close = ccui.Helper:seekWidgetByName(panel_register, BTN_REG_CLOSE)
    if btn_reg_close then
       btn_reg_close:addClickEventListener(handler(self,self.onEventBtnRegClose))
    end
    local btn_reg = ccui.Helper:seekWidgetByName(panel_register, BTN_REGISTER)
    if btn_reg then
        btn_reg:addClickEventListener(handler(self,self.onEventBtnReg))
    end
    -- editbox
    local login_textfield_account   = ccui.Helper:seekWidgetByName(panel_login, TEXTFIELD_ACCOUNT)
    local login_textfield_pwd       = ccui.Helper:seekWidgetByName(panel_login, TEXTFIELD_PWD)
    local reg_textfield_account     = ccui.Helper:seekWidgetByName(panel_register, TEXTFIELD_ACCOUNT)
    local reg_textfield_pwd         = ccui.Helper:seekWidgetByName(panel_register, TEXTFIELD_PWD)
    local reg_textfield_pwd_conf    = ccui.Helper:seekWidgetByName(panel_register, TEXTFIELD_PWD_CONF)

    local textfieldSize             = cc.size(300,51)
    local textfieldImg              = 'Lobby/LobbyRes/home_scene/user_info/120.png'

    if login_textfield_account then
        local textfdParent = login_textfield_account:getParent()
        self._login_textfield_account = ccui.EditBox:create(textfieldSize,textfieldImg) 
        self._login_textfield_account:setAnchorPoint(cc.p(0.5,0.5))
        self._login_textfield_account:setPosition(cc.p(textfdParent:getPositionX(), textfdParent:getPositionY()))
        self._login_textfield_account:setFontSize(35)
        self._login_textfield_account:setFontColor(cc.c3b(255,255,255))
        -- self._login_textfield_account:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        self._login_textfield_account:setPlaceHolder('请输入帐号')
        textfdParent:getParent():addChild(self._login_textfield_account)
        textfdParent:removeSelf()
    end

    if login_textfield_pwd then
        local textfdParent = login_textfield_pwd:getParent()
        self._login_textfield_pwd = ccui.EditBox:create(textfieldSize,textfieldImg) 
        self._login_textfield_pwd:setAnchorPoint(cc.p(0.5,0.5))
        self._login_textfield_pwd:setPosition(cc.p(textfdParent:getPositionX(), textfdParent:getPositionY()))
        self._login_textfield_pwd:setFontSize(35)
        self._login_textfield_pwd:setFontColor(cc.c3b(255,255,255))
        -- self._login_textfield_pwd:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        self._login_textfield_pwd:setPlaceHolder('请输入密码')
        textfdParent:getParent():addChild(self._login_textfield_pwd)
        textfdParent:removeSelf()
    end

     if reg_textfield_account then
        local textfdParent = reg_textfield_account:getParent()
        self._reg_textfield_account = ccui.EditBox:create(textfieldSize,textfieldImg) 
        self._reg_textfield_account:setAnchorPoint(cc.p(0.5,0.5))
        self._reg_textfield_account:setPosition(cc.p(textfdParent:getPositionX(), textfdParent:getPositionY()))
        self._reg_textfield_account:setFontSize(35)
        self._reg_textfield_account:setFontColor(cc.c3b(255,255,255))
        -- self._reg_textfield_account:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        self._reg_textfield_account:setPlaceHolder('请输入帐号')
        textfdParent:getParent():addChild(self._reg_textfield_account)
        textfdParent:removeSelf()
    end

    if reg_textfield_pwd then
        local textfdParent = reg_textfield_pwd:getParent()
        self._reg_textfield_pwd = ccui.EditBox:create(textfieldSize,textfieldImg) 
        self._reg_textfield_pwd:setAnchorPoint(cc.p(0.5,0.5))
        self._reg_textfield_pwd:setPosition(cc.p(textfdParent:getPositionX(), textfdParent:getPositionY()))
        self._reg_textfield_pwd:setFontSize(35)
        self._reg_textfield_pwd:setFontColor(cc.c3b(255,255,255))
        -- self._reg_textfield_pwd:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        self._reg_textfield_pwd:setPlaceHolder('请输入密码')
        textfdParent:getParent():addChild(self._reg_textfield_pwd)
        textfdParent:removeSelf()
    end

    if reg_textfield_pwd_conf then
        local textfdParent = reg_textfield_pwd_conf:getParent()
        self._reg_textfield_pwd_conf = ccui.EditBox:create(textfieldSize,textfieldImg) 
        self._reg_textfield_pwd_conf:setAnchorPoint(cc.p(0.5,0.5))
        self._reg_textfield_pwd_conf:setPosition(cc.p(textfdParent:getPositionX(), textfdParent:getPositionY()))
        self._reg_textfield_pwd_conf:setFontSize(35)
        self._reg_textfield_pwd_conf:setFontColor(cc.c3b(255,255,255))
        -- self._reg_textfield_pwd_conf:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        self._reg_textfield_pwd_conf:setPlaceHolder('请确认密码')
        textfdParent:getParent():addChild(self._reg_textfield_pwd_conf)
        textfdParent:removeSelf()
    end

    -- load local data
    if self._login_textfield_account then
        self._login_textfield_account:setText(UserInfo.getUserAccount())
    end

    if self._login_textfield_pwd then
        self._login_textfield_pwd:setText(UserInfo.getUserPwd())
    end
end

function LoginScene:addEventListenner()
    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
    addEvent(ServerEvents.ON_SERVER_EVENT_MSG_SEND, self, self.onEventMsgSend)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT, self, self.onEventNetConnect)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL, self, self.onEventNetConnectFail)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSE, self, self.onEventClose)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_CLOSED, self, self.onEventClosed)
    addEvent(ServerEvents.ON_SERVER_EVENT_NET_NETLOWER, self, self.onEventNetLower)
end

function LoginScene:onEventData(event)
    local data = event._usedata
    if not data then
        return
    end
    dump(data)
    if data.ctype == Cmd.eGuestLoginRes then
       if data.body then
            local uinfo = data.body.uinfo
            UserInfo.setUserName(uinfo.unick)
            UserInfo.setUserface(uinfo.uface)
            UserInfo.setUserSex(uinfo.usex)
            UserInfo.setUserVip(uinfo.uvip)
            UserInfo.setUserId(uinfo.uid)
            UserInfo.setUserIsGuest(true)
            UserInfo.flush()

            if data.body.status == Respones.OK then
                 self:getApp():enterScene('LobbyScene')
            end
       end
    end
    if data.ctype == Cmd.eUnameLoginRes then
        local uinfo = data.body.uinfo
        UserInfo.setUserName(uinfo.unick)
        UserInfo.setUserface(uinfo.uface)
        UserInfo.setUserSex(uinfo.usex)
        UserInfo.setUserVip(uinfo.uvip)
        UserInfo.setUserId(uinfo.uid)
        UserInfo.flush()

        if data.body.status == Respones.OK then
             self:getApp():enterScene('LobbyScene')
        end

    end
end

function LoginScene:onEventMsgSend(envet)
    
end

function LoginScene:onEventNetConnect(envet)
    
end

function LoginScene:onEventNetConnectFail(envet)

end

function LoginScene:onEventClose(envet)

end

function LoginScene:onEventClosed(envet)

end

function LoginScene:onEventNetLower(envet)

end

function LoginScene:onEventBtnGuestLogin(sender,eventType)
    local keystr = UserInfo.getUserGuestKey()
    if keystr == '' or keystr == nil then
        keystr = math.random(100000, 999999) .. '8JvrDstUNDuTNnnCKFEw' .. math.random(100000, 999999)
        UserInfo.setUserGuestKey(keystr)
        UserInfo.flush()
    end
    print('loginKey: ' .. keystr)
    NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eGuestLoginReq,{guest_key = keystr})
end

function LoginScene:onEventBtnRegister(sender, eventType)
    
end

function LoginScene:onEventBtnLogin(sender, eventType)
    local accountStr    = self._login_textfield_account:getText()
    local pwdStr        = self._login_textfield_pwd:getText()
    print('login...' .. ' ' .. accountStr .. '  ' .. pwdStr)
    if accountStr == '' or pwdStr == '' then
        return
    end

    NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eUnameLoginReq,{uname = accountStr,upwd = pwdStr}) 
    UserInfo.setUserAccount(accountStr)
    UserInfo.setUserPwd(pwdStr)
end

function LoginScene:onEventBtnReg(sender, eventType)
    print('reg...')
end

function LoginScene:onEventBtnGoToLogin(sender,eventType)
    local img_panel_login_bg = self:getResourceNode():getChildByName(IMG_LOGIN_BG)
    if img_panel_login_bg then
        local panel_login = ccui.Helper:seekWidgetByName(img_panel_login_bg, PANEL_LOGIN)
        if panel_login then
            panel_login:setVisible(false)
        end

        local panel_register = ccui.Helper:seekWidgetByName(img_panel_login_bg, PANEL_REGISTER)
        if panel_register then
            panel_register:setVisible(true)
        end
    end
    
end

function LoginScene:onEventBtnRegClose(sender, eventType)
    local img_panel_login_bg = self:getResourceNode():getChildByName(IMG_LOGIN_BG)
    if img_panel_login_bg then
        local panel_login = ccui.Helper:seekWidgetByName(img_panel_login_bg, PANEL_LOGIN)
        if panel_login then
            panel_login:setVisible(true)
        end

        local panel_register = ccui.Helper:seekWidgetByName(img_panel_login_bg, PANEL_REGISTER)
        if panel_register then
            panel_register:setVisible(false)
        end
    end
end

function LoginScene:onEnter()
    print('LoginScene:onEnter')
end

function LoginScene:onExit()
    print('LoginScene:onExit')
end

return LoginScene
