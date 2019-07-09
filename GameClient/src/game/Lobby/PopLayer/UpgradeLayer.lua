local PopLayer = require('game.Base.PopLayer')
local UpgradeLayer = class("UpgradeLayer", PopLayer)

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.protocol.Cmd")
local Stype             = require("game.net.Stype")
local Respones 			= require("game.net.Respones")
local UserInfo 			= require("game.clientdata.UserInfo")
local AuthServiceProxy  = require("game.modules.AuthServiceProxy")

local IMG_BG                = 'IMG_BG'
local BTN_CLOSE             = 'BTN_CLOSE'
local BTN_COMMIT            = 'BTN_COMMIT'
local TEXTFIELD_ACCOUNT     = 'TEXTFIELD_ACCOUNT'
local TEXTFIELD_PWD         = 'TEXTFIELD_PWD'
local TEXTFIELD_PWD_CONF    = 'TEXTFIELD_PWD_CONF'

UpgradeLayer._csbResourcePath = 'Lobby/PopLayer/UpgradeLayer.csb'

function UpgradeLayer:ctor()
	UpgradeLayer.super.ctor(self)
    self._textfield_account     = nil
    self._textfield_pwd         = nil
    self._textfield_pwd_conf    = nil

    self._text_account  = ''
    self._text_pwd      = ''
end

function UpgradeLayer:init()
    self._canTouchBackground = false
    UpgradeLayer.super.init(self)
end

function UpgradeLayer:onCreate()
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),BTN_CLOSE,handler(self, self.onClickEventClose))
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),BTN_COMMIT,handler(self, self.onEventBtnCommint))

 	local textfield_account = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(),TEXTFIELD_ACCOUNT)
 	local textfield_pwd = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(),TEXTFIELD_PWD)
 	local textfield_pwd_conf = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(),TEXTFIELD_PWD_CONF)

 	local textfieldSize             = cc.size(300,51)
    local textfieldImg              = 'Lobby/LobbyRes/home_scene/user_info/120.png'

    if textfield_account then
        local textfdParent = textfield_account:getParent()
        self._textfield_account = ccui.EditBox:create(textfieldSize,textfieldImg) 
        self._textfield_account:setAnchorPoint(cc.p(0.5,0.5))
        self._textfield_account:setPosition(cc.p(textfdParent:getPositionX(), textfdParent:getPositionY()))
        self._textfield_account:setFontSize(35)
        self._textfield_account:setFontColor(cc.c3b(255,255,255))
        self._textfield_account:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        self._textfield_account:setPlaceHolder('输入帐号')
        textfdParent:getParent():addChild(self._textfield_account)
        textfdParent:removeSelf()
    end

    if textfield_pwd then
        local textfdParent = textfield_pwd:getParent()
        self._textfield_pwd = ccui.EditBox:create(textfieldSize,textfieldImg) 
        self._textfield_pwd:setAnchorPoint(cc.p(0.5,0.5))
        self._textfield_pwd:setPosition(cc.p(textfdParent:getPositionX(), textfdParent:getPositionY()))
        self._textfield_pwd:setFontSize(35)
        self._textfield_pwd:setFontColor(cc.c3b(255,255,255))
        self._textfield_pwd:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        self._textfield_pwd:setPlaceHolder('输入密码')
        textfdParent:getParent():addChild(self._textfield_pwd)
        textfdParent:removeSelf()
    end

    if textfield_pwd_conf then
        local textfdParent = textfield_pwd_conf:getParent()
        self._textfield_pwd_conf = ccui.EditBox:create(textfieldSize,textfieldImg) 
        self._textfield_pwd_conf:setAnchorPoint(cc.p(0.5,0.5))
        self._textfield_pwd_conf:setPosition(cc.p(textfdParent:getPositionX(), textfdParent:getPositionY()))
        self._textfield_pwd_conf:setFontSize(35)
        self._textfield_pwd_conf:setFontColor(cc.c3b(255,255,255))
        self._textfield_pwd_conf:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        self._textfield_pwd_conf:setPlaceHolder('确认密码')
        textfdParent:getParent():addChild(self._textfield_pwd_conf)
        textfdParent:removeSelf()
    end
end

function UpgradeLayer:addClientEventListener()
	addEvent('AccountUpgradeRes', self, self, self.onEventAccountUpgradeRes)
end

function UpgradeLayer:onEventAccountUpgradeRes(event)
   local data = event._usedata
    if not data then
        return
    end
    if data.status == Respones.OK then
    	UserInfo.setUserAccount(self._text_account)
    	UserInfo.setUserPwd(self._text_pwd)
    	UserInfo.setUserIsGuest(false)
    	UserInfo.flush()
    	postEvent(ClientEvents.ON_ASYC_USER_INFO)
    	self:showLayer(false)
        Lobby.showPopLayer('TipsLayer',{"升级成功"})
    else
        Lobby.showPopLayer('TipsLayer',{"升级失败"})
    end
end

function UpgradeLayer:onClickEventClose(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
    self:showLayer(false)
end

function UpgradeLayer:onEventBtnCommint(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
	if (not self._textfield_account) or 
		(not self._textfield_pwd) or 
		(not self._textfield_pwd_conf)  then
		return
	end

	local text_account 	= self._textfield_account:getText()
	local text_pwd 		= self._textfield_pwd:getText()
	local text_pwd_conf = self._textfield_pwd_conf:getText()

	if text_account == '' or
		text_pwd == '' or 
		text_pwd_conf == '' or 
	 	text_pwd ~=  text_pwd_conf then
        Lobby.showPopLayer('TipsLayer',{"帐号或密码错误!"})
		return
	end

	self._text_account = text_account
	self._text_pwd = text_pwd      -- TODO save as md5 value

	print('upgrade: ' , text_account , text_pwd, text_pwd_conf)

    AuthServiceProxy:getInstance():sendUpgrade(text_account,text_pwd)
end

return UpgradeLayer