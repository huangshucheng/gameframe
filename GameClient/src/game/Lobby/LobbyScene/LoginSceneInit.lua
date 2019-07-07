local LoginScene 		= class('LoginScene')
local UserInfo          = require("game.clientdata.UserInfo")

local BTN_GUEST_LOGIN               = 'BTN_GUEST_LOGIN'
local BTN_LOBBY_REGISTER            = 'BTN_LOBBY_REGISTER'
local IMG_LOGIN_BG                  = 'IMG_LOGIN_BG'
local PANEL_LOGIN                   = 'PANEL_LOGIN'
local PANEL_REGISTER                = 'PANEL_REGISTER'
local BTN_LOGIN                     = 'BTN_LOGIN'
local BTN_GOTO_REGISTER             = 'BTN_GOTO_REGISTER'
local BTN_REG_CLOSE                 = 'BTN_REG_CLOSE'
local BTN_REGISTER                  = 'BTN_REGISTER'
local TEXTFIELD_ACCOUNT             = 'TEXTFIELD_ACCOUNT'
local TEXTFIELD_PWD                 = 'TEXTFIELD_PWD'
local TEXTFIELD_PWD_CONF            = 'TEXTFIELD_PWD_CONF'

function LoginScene:addUITouchEvent()
    Lobby.UIFunction.addTouchEventListener(self:getRootNode(),BTN_GUEST_LOGIN,handler(self, self.onEventBtnGuestLogin))
    Lobby.UIFunction.addTouchEventListener(self:getRootNode(),BTN_LOGIN,handler(self, self.onEventBtnLogin))
    Lobby.UIFunction.addTouchEventListener(self:getRootNode(),BTN_GOTO_REGISTER,handler(self, self.onEventBtnGoToLogin))
    Lobby.UIFunction.addTouchEventListener(self:getRootNode(),BTN_REG_CLOSE,handler(self, self.onEventBtnRegClose))
    Lobby.UIFunction.addTouchEventListener(self:getRootNode(),BTN_REGISTER,handler(self, self.onEventBtnReg))
end

function LoginScene:initUI()
    local img_panel_login_bg = self:getRootNode():getChildByName(IMG_LOGIN_BG)

    if not img_panel_login_bg then
        return
    end

    local panel_login = ccui.Helper:seekWidgetByName(img_panel_login_bg, PANEL_LOGIN)
    local panel_register = ccui.Helper:seekWidgetByName(img_panel_login_bg, PANEL_REGISTER)
    
    -- editbox
    local login_textfield_account   = Lobby.UIFunction.seekWidgetByName(panel_login, TEXTFIELD_ACCOUNT)
    local login_textfield_pwd       = Lobby.UIFunction.seekWidgetByName(panel_login, TEXTFIELD_PWD)
    local reg_textfield_account     = Lobby.UIFunction.seekWidgetByName(panel_register, TEXTFIELD_ACCOUNT)
    local reg_textfield_pwd         = Lobby.UIFunction.seekWidgetByName(panel_register, TEXTFIELD_PWD)
    local reg_textfield_pwd_conf    = Lobby.UIFunction.seekWidgetByName(panel_register, TEXTFIELD_PWD_CONF)

    local textfieldSize             = cc.size(300,51)
    local textfieldImg              = 'Lobby/LobbyRes/home_scene/user_info/120.png'
    if login_textfield_account then
        local textfdParent = login_textfield_account:getParent()
        self._login_textfield_account = ccui.EditBox:create(textfieldSize,textfieldImg) 
        self._login_textfield_account:setAnchorPoint(cc.p(0.5,0.5))
        self._login_textfield_account:setPosition(cc.p(textfdParent:getPositionX(), textfdParent:getPositionY()))
        self._login_textfield_account:setFontSize(35)
        self._login_textfield_account:setFontColor(cc.c3b(255,255,255))
        self._login_textfield_account:setReturnType(cc.KEYBOARD_RETURNTYPE_DEFAULT)
        self._login_textfield_account:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self._login_textfield_account:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD)
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
        self._login_textfield_pwd:setReturnType(cc.KEYBOARD_RETURNTYPE_DEFAULT)
        self._login_textfield_pwd:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self._login_textfield_pwd:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD)
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
        self._reg_textfield_account:setReturnType(cc.KEYBOARD_RETURNTYPE_DEFAULT)
        self._reg_textfield_account:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self._reg_textfield_account:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD)
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
        self._reg_textfield_pwd:setReturnType(cc.KEYBOARD_RETURNTYPE_DEFAULT)
        self._reg_textfield_pwd:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self._reg_textfield_pwd:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD)
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
        self._reg_textfield_pwd_conf:setReturnType(cc.KEYBOARD_RETURNTYPE_DEFAULT)
        self._reg_textfield_pwd_conf:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self._reg_textfield_pwd_conf:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD)
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

return LoginScene