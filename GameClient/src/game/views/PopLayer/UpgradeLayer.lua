local UpgradeLayer = class("UpgradeLayer", cc.load("mvc").ViewBase)

UpgradeLayer.RESOURCE_FILENAME = 'Lobby/PopLayer/UpgradeLayer.csb'

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.Cmd")
local Stype             = require("game.net.Stype")
local Respones 			= require("game.net.Respones")
local UserInfo 			= require("game.clientdata.UserInfo")

local IMG_BG = 'IMG_BG'
local BTN_CLOSE = 'BTN_CLOSE'
local BTN_COMMIT = 'BTN_COMMIT'
local TEXTFIELD_ACCOUNT = 'TEXTFIELD_ACCOUNT'
local TEXTFIELD_PWD = 'TEXTFIELD_PWD'
local TEXTFIELD_PWD_CONF = 'TEXTFIELD_PWD_CONF'

function UpgradeLayer:ctor()
	self._textfield_account = nil
	self._textfield_pwd = nil
	self._textfield_pwd_conf = nil

	self._text_account = ''
	self._text_pwd = ''

	UpgradeLayer.super.ctor(self,app,name)
end

function UpgradeLayer:onCreate()
	self._canTouchBackground = true

	local img_bg = self:getResourceNode():getChildByName(IMG_BG)
	if not img_bg then
		return
	end
	local btn_close = ccui.Helper:seekWidgetByName(img_bg,BTN_CLOSE)
	if btn_close then
		btn_close:addClickEventListener(handler(self,function()
			self:removeSelf()
		end))
	end

	local btn_commit = ccui.Helper:seekWidgetByName(img_bg,BTN_COMMIT) 
	if btn_commit then
		btn_commit:addClickEventListener(handler(self,self.onEventBtnCommint))
	end

 	local textfield_account = ccui.Helper:seekWidgetByName(img_bg,TEXTFIELD_ACCOUNT)
 	local textfield_pwd = ccui.Helper:seekWidgetByName(img_bg,TEXTFIELD_PWD)
 	local textfield_pwd_conf = ccui.Helper:seekWidgetByName(img_bg,TEXTFIELD_PWD_CONF)

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

function UpgradeLayer:addEventListenner()
	addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
end

function UpgradeLayer:onEventData(event)
   local data = event._usedata
    if not data then
        return
    end
    local ctype = data.ctype
    if ctype == Cmd.eAccountUpgradeRes then
    	local body = data.body
        if body.status == Respones.OK then
        	UserInfo.setUserAccount(self._text_account)
        	UserInfo.setUserPwd(self._text_pwd)
        	UserInfo.setUserIsGuest(false)
        	UserInfo.flush()
        	postEvent(ClientEvents.ON_ASYC_USER_INFO)
        	self:removeSelf()
        end
    end
end

function UpgradeLayer:onEventBtnCommint(sender, evnetType)
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
		return
	end

	self._text_account = text_account
	self._text_pwd = text_pwd

	print('upgrade: ' , text_account , text_pwd, text_pwd_conf)

	local msg = {
		uname = text_account,
		upwd_md5 = text_pwd,		-- TODO save as md5 value
		-- upwd_md5 = '8JvrDstUNDuTNnnCKFEw4pKFsn666666',
	}
	NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eAccountUpgradeReq,msg)
end

return UpgradeLayer