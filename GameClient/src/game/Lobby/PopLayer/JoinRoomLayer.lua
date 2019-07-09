local PopLayer = require('game.Base.PopLayer')
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
	for i = 1 , 6 do
		local text = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(), KW_TEXT_NUM .. i)
		if text then
			text:setString('')
			self._numberList[i] = text
		end
	end

	for j = 0 , 9 do
		local btn = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(), KW_BTN .. j)
		if btn then
			self._numberBtnList[j] = btn
			btn.tmpNum = j
		end
		Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN .. j,handler(self, self.onBtnEventNumber))
	end

	Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_CLOSE,handler(self, self.onClickEventClose))
	Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_CLEAR,handler(self, self.onBtnEventClear))
end

function JoinRoomLayer:onClickEventClose(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
    self:showLayer(false)
end

function JoinRoomLayer:addClientEventListener()

end

function JoinRoomLayer:onBtnEventClear(send, eventType)
	if not self:isShowTouchEffect(send, eventType) then return end
	for i = 1 , 6 do
		Lobby.UIFunction.setString(self:getCsbNode(),KW_TEXT_NUM .. i , '')
	end
	self._text_index = 1
end

function JoinRoomLayer:onBtnEventNumber(send, eventType)
	if not self:isShowTouchEffect(send, eventType) then return end
	local tmpNum = send.tmpNum
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