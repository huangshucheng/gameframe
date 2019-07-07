local LoginScene = class('LoginScene')

local UserInfo          = require("game.clientdata.UserInfo")

local AuthServiceProxy  = require("game.modules.AuthServiceProxy")

local IMG_LOGIN_BG                  = 'IMG_LOGIN_BG'
local PANEL_LOGIN                   = 'PANEL_LOGIN'
local PANEL_REGISTER                = 'PANEL_REGISTER'

function LoginScene:onEventBtnGuestLogin(send,eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    local keystr = UserInfo.getUserGuestKey()
    if keystr == '' or keystr == nil then
        keystr = math.random(100000, 999999) .. '8JvrDstUNDuTNnnCKFEw' .. math.random(100000, 999999)
        UserInfo.setUserGuestKey(keystr)
        UserInfo.flush()
    end
    print('loginKey: ' .. keystr)
    AuthServiceProxy:getInstance():sendGuestLogin(keystr)
    UserInfo.setLoginType('guest')
    Lobby.showPopLayer('LoadingLayer')
end

function LoginScene:onEventBtnLogin(send, eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    local accountStr    = self._login_textfield_account:getText()
    local pwdStr        = self._login_textfield_pwd:getText()
    print('login...' .. ' ' .. accountStr .. '  ' .. pwdStr)
    if accountStr == '' or pwdStr == '' then
        Lobby.showPopLayer('TipsLayer',{"帐号或密码错误!"})
        return
    end

    AuthServiceProxy:getInstance():sendUnameLogin(accountStr,pwdStr)
    UserInfo.setUserAccount(accountStr)
    UserInfo.setUserPwd(pwdStr)
    UserInfo.setLoginType('uname')
    Lobby.showPopLayer('LoadingLayer')
end

function LoginScene:onEventBtnReg(send, eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    local accountStr    = self._reg_textfield_account:getText()
    local pwdStr        = self._reg_textfield_pwd:getText()
    local pwdStrConf    = self._reg_textfield_pwd_conf:getText()
    -- todo: NO space,chinese,daxiaoxie
    print(accountStr , pwdStr , pwdStrConf)
    if accountStr == '' or pwdStr == '' or pwdStrConf == '' then
        Lobby.showPopLayer('TipsLayer',{"帐号或密码错误!"})
        return
    end

    if pwdStr ~= pwdStrConf then
        Lobby.showPopLayer('TipsLayer',{"两次密码不一样!"})
        return
    end

    if string.len(accountStr) < 6 or string.len(pwdStr) < 6 or string.len(pwdStrConf) < 6 then
        Lobby.showPopLayer('TipsLayer',{"密码需要大于6位!"})
        return
    end

    AuthServiceProxy:getInstance():sendRegist(accountStr, pwdStr)
    Lobby.showPopLayer('LoadingLayer')
end

function LoginScene:onEventBtnGoToLogin(send,eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    Lobby.UIFunction.setVisible(self:getRootNode(),PANEL_LOGIN,false)
    Lobby.UIFunction.setVisible(self:getRootNode(),PANEL_REGISTER,true)
end

function LoginScene:onEventBtnRegClose(send, eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    Lobby.UIFunction.setVisible(self:getRootNode(),PANEL_LOGIN,true)
    Lobby.UIFunction.setVisible(self:getRootNode(),PANEL_REGISTER,false)
end

return LoginScene
