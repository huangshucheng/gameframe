local PopLayer = require('game.views.Base.PopLayer')
local MyCenterLayer = class("MyCenterLayer", PopLayer)

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.protocol.Cmd")
local Stype             = require("game.net.Stype")
local Respones 			= require("game.net.Respones")
local UserInfo 			= require("game.clientdata.UserInfo")
local AuthServiceProxy 	= require("game.modules.AuthServiceProxy")

MyCenterLayer._csbResourcePath = 'Lobby/PopLayer/MyCenterLayer.csb'

local IMG_BG 					= 'IMG_BG'
local BTN_CLOSE 				= 'BTN_CLOSE'
local BTN_UPGRADE 				= 'BTN_UPGRADE'
local BTN_MODIFY 				= 'BTN_MODIFY'
local BTN_LOGOUT 				= 'BTN_LOGOUT'
local CHECK_BOY 				= 'CHECK_BOY'
local CHECK_GIRL 				= 'CHECK_GIRL'
local PANEL_HEAD_BG 			= 'PANEL_HEAD_BG'
local IMG_HEAD 					= 'IMG_HEAD'
local TEXTFIELD_NAME 			= 'TEXTFIELD_NAME'

function MyCenterLayer:ctor()
	self._login_textfield_name = nil
	self._checkbox_boy = nil
	self._checkbox_girl = nil
	self._img_head = nil
	self._user_sex = 1
	self._head_img_index = 1
	MyCenterLayer.super.ctor(self)

end

function MyCenterLayer:init()
	self._canTouchBackground = true
	MyCenterLayer.super.init(self)
end

function MyCenterLayer:onCreate()
	
	local img_bg = self:getCsbNode():getChildByName(IMG_BG)
	if not img_bg then return end

	local btn_close = ccui.Helper:seekWidgetByName(img_bg,BTN_CLOSE)
	if btn_close then
		btn_close:addClickEventListener(handler(self,function()
			self:showLayer(false)
		end))
	end
	local btn_modify = ccui.Helper:seekWidgetByName(img_bg,BTN_MODIFY)
	if btn_modify then
		btn_modify:addClickEventListener(handler(self,self.onEventBtnModify))
	end

	local btn_upgrade = ccui.Helper:seekWidgetByName(img_bg,BTN_UPGRADE)
	if btn_upgrade then
		btn_upgrade:addClickEventListener(handler(self,function()
		    GT.showPopLayer('UpgradeLayer')
		end))
	end

	local panel_head_bg = ccui.Helper:seekWidgetByName(img_bg,PANEL_HEAD_BG)
	if panel_head_bg then
		panel_head_bg:addClickEventListener(handler(self,function(sender, eventType)
			self._head_img_index = self._head_img_index + 1
			if self._head_img_index > 9 then
				self._head_img_index = 1
			end
		    if self._img_head then
    			self._img_head:loadTexture(string.format('Lobby/LobbyRes/rectheader/1%d.png',self._head_img_index))
    		end
		end))
	end

	local login_textfield_name 		= ccui.Helper:seekWidgetByName(img_bg,TEXTFIELD_NAME)
    local textfieldSize             = cc.size(300,51)
    local textfieldImg              = 'Lobby/LobbyRes/home_scene/user_info/120.png'
    if login_textfield_name then
        local textfdParent = login_textfield_name:getParent()
        self._login_textfield_name = ccui.EditBox:create(textfieldSize,textfieldImg) 
        self._login_textfield_name:setAnchorPoint(cc.p(0.5,0.5))
        self._login_textfield_name:setPosition(cc.p(textfdParent:getPositionX(), textfdParent:getPositionY()))
        self._login_textfield_name:setFontSize(35)
        self._login_textfield_name:setFontColor(cc.c3b(255,255,255))
        self._login_textfield_name:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
        self._login_textfield_name:setReturnType(cc.KEYBOARD_RETURNTYPE_DEFAULT)
        self._login_textfield_name:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self._login_textfield_name:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD)
        textfdParent:getParent():addChild(self._login_textfield_name)
        textfdParent:removeSelf()
    end

    self._checkbox_boy = ccui.Helper:seekWidgetByName(img_bg,CHECK_BOY)
    self._checkbox_girl = ccui.Helper:seekWidgetByName(img_bg,CHECK_GIRL)

    if (not self._checkbox_boy) or (not self._checkbox_girl)  then
    	return
    end

    local setSex = function(isBoy)
    	if isBoy == true then
			self._checkbox_boy:setSelected(true)
			self._checkbox_girl:setSelected(false)
		else
			self._checkbox_girl:setSelected(true)
			self._checkbox_boy:setSelected(false)
    	end
    end

	self._checkbox_boy:addEventListener(handler(self,function(sender,eventType)
		-- if eventType == ccui.CheckBoxEventType.selected then
		-- elseif eventType == ccui.CheckBoxEventType.unselected then
		-- end
		setSex(true)
	end))

	self._checkbox_girl:addEventListener(handler(self,function(sender,eventType)
		setSex(false)
	end))

	local btn_logout = ccui.Helper:seekWidgetByName(img_bg,BTN_LOGOUT)
	if btn_logout then
		btn_logout:addClickEventListener(handler(self,self.onEventBtnLoginOut))
	end
    -- load data
    if self._login_textfield_name then
    	self._login_textfield_name:setText(UserInfo.getUserName())
    end
    self._img_head = ccui.Helper:seekWidgetByName(img_bg,IMG_HEAD)
    if self._img_head then
    	self._img_head:loadTexture(string.format('Lobby/LobbyRes/rectheader/1%s.png',UserInfo.getUserface()))
    end

	local sex = UserInfo.getUserSex()
	if tonumber(sex) == 1 then
		setSex(true)
	else
		setSex(false)
	end

	if btn_upgrade then
		btn_upgrade:setVisible(UserInfo.getUserIsGuest())
	end

	self._head_img_index = tonumber(UserInfo.getUserface())
end

function MyCenterLayer:addClientEventListener()
	addEvent('LoginOutRes', self, self.onEventLoginOutRes)
	addEvent('EditProfileRes', self, self.onEventEditProFileRes)
	addEvent(ClientEvents.ON_ASYC_USER_INFO, self, self.onEventAsycUserInfo)
end

function MyCenterLayer:onEventLoginOutRes(event)
   local data = event._usedata
    if not data then
        return
    end
    GT.popLayer('LoadingLayer')
	if data.status == Respones.OK then
		self:showLayer(false)
	end
end

function MyCenterLayer:onEventEditProFileRes(event)
   local data = event._usedata
    if not data then
        return
    end

	GT.popLayer('LoadingLayer')
    
    if data.status == Respones.OK then
    	UserInfo.setUserName(self._login_textfield_name:getText())
    	UserInfo.setUserSex(self._user_sex)
    	UserInfo.setUserface(self._head_img_index)
    	UserInfo.flush()
    	postEvent(ClientEvents.ON_ASYC_USER_INFO)
    	GT.showPopLayer('TipsLayer',{"修改成功"})
    end
end

function MyCenterLayer:onEventBtnModify(sender,eventType)
	local namestr = ''

	if self._login_textfield_name then
		namestr = self._login_textfield_name:getText()
	end

	if self._checkbox_girl and self._checkbox_boy then
		local isboysel = self._checkbox_boy:isSelected()
		local isgirlsel =  self._checkbox_girl:isSelected()
		if isboysel then
			self._user_sex = 1
		elseif isgirlsel then
			self._user_sex = 0
		end
	end

	if namestr == '' then
		return
	end
	AuthServiceProxy:getInstance():sendEditProfile(namestr, self._head_img_index, self._user_sex)
	GT.showPopLayer('LoadingLayer')
end

function MyCenterLayer:onEventBtnLoginOut(sender, eventType)
	AuthServiceProxy:getInstance():sendLoginOut()
	GT.showPopLayer('LoadingLayer')
end

function MyCenterLayer:onEventAsycUserInfo(event)
    local uname = UserInfo.getUserName()
    if uname and uname ~= '' then
        self._login_textfield_name:setText(tostring(uname))
    end

    local isguest = UserInfo.getUserIsGuest()

	local img_bg = self:getCsbNode():getChildByName(IMG_BG)
	local btn_upgrade = ccui.Helper:seekWidgetByName(img_bg,BTN_UPGRADE)
	btn_upgrade:setVisible(isguest) 

    if self._img_head then
        self._img_head:loadTexture(string.format('Lobby/LobbyRes/rectheader/1%s.png',UserInfo.getUserface()))
    end
end

return MyCenterLayer