local PopLayer = require('game.views.Base.PopLayer')
local JoinRoomLayer = class("JoinRoomLayer", PopLayer)

local Respones 				= require("game.net.Respones")
local LogicServiceProxy 	= require("game.modules.LogicServiceProxy")

JoinRoomLayer._csbResourcePath = 'Lobby/PopLayer/JoinRoomLayer.csb'

local KW_IMG_BG 				= 'KW_IMG_BG'
local KW_BTN_CLOSE 				= 'KW_BTN_CLOSE'
local KW_BTN_CLEAR 				= 'KW_BTN_CLEAR'
local KW_PANEL_NUM 				= 'KW_PANEL_NUM'
local KW_TEXT_NUM 				= 'KW_TEXT_NUM_'
local KW_BTN 					= 'KW_BTN_'

function JoinRoomLayer:ctor()
	JoinRoomLayer.super.ctor(self)
end

function JoinRoomLayer:init()
	self._canTouchBackground    = true
    self._numberList            = {}
    self._numberBtnList         = {}
    self._text_index 			= 1
	JoinRoomLayer.super.init(self)
	
end

function JoinRoomLayer:onCreate()
	local img_bg = self:getCsbNode():getChildByName(KW_IMG_BG)
	if not img_bg then return end

	local btn_close = ccui.Helper:seekWidgetByName(img_bg, KW_BTN_CLOSE)
	if btn_close then
		btn_close:addClickEventListener(handler(self,function()
			self:showLayer(false)
		end))
	end

	local btn_clear = ccui.Helper:seekWidgetByName(img_bg, KW_BTN_CLEAR)
	if btn_clear then
		btn_clear:addClickEventListener(handler(self,self.onBtnEventClear))
	end

	for i = 1 , 6 do
		local text = ccui.Helper:seekWidgetByName(img_bg, KW_TEXT_NUM .. i)
		if text then
			text:setString('')
			self._numberList[i] = text
		end
	end

	for j = 0 , 9 do
		local btn = ccui.Helper:seekWidgetByName(img_bg, KW_BTN .. j)
		if btn then
			self._numberBtnList[j] = btn
			btn:addClickEventListener(handler(self,self.onBtnEventNumber))
			btn.tmpNum = j
		end
	end
end

function JoinRoomLayer:addClientEventListener()

end

function JoinRoomLayer:onBtnEventClear(sender, eventType)
	print('hcc clear')
	for i = 1 , 6 do
		self._numberList[i]:setString('')
	end
	self._text_index = 1
end

function JoinRoomLayer:onBtnEventNumber(sender, eventType)
	local tmpNum = sender.tmpNum
	print("hcc btn num: " .. tostring(tmpNum))
	if not tmpNum then 
		return
	end

	if self._numberList[self._text_index] then
		self._numberList[self._text_index]:setString(tmpNum)
	end

	if self._text_index == 6 then
		local room_id = ''
		for i = 1 , 6 do
			room_id = room_id ..  self._numberList[i]:getString()	
		end
		print('roomID: ' .. room_id)
		LogicServiceProxy:getInstance():sendJoinRoom(room_id)
	end
	self._text_index = self._text_index + 1
end

return JoinRoomLayer