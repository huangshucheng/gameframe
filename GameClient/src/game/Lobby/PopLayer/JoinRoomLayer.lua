local PopLayer = require('game.Base.PopLayer')
local JoinRoomLayer = class("JoinRoomLayer", PopLayer)

local Respones 				= require("game.net.Respones")
local LogicServiceProxy 	= require("game.modules.LogicServiceProxy")

JoinRoomLayer._csbResourcePath = 'Lobby/PopLayer/JoinRoomLayer.csb'

local KW_IMG_BG 				= 'KW_IMG_BG'
local KW_BTN_CLOSE 				= 'KW_BTN_CLOSE'
local KW_BTN_CLEAR 				= 'KW_BTN_CLEAR'
local KW_BTN_DELETE				= 'KW_BTN_DELETE'
local KW_PANEL_NUM 				= 'KW_PANEL_NUM'
local KW_TEXT_NUM 				= 'KW_TEXT_NUM_'
local KW_BTN 					= 'KW_BTN_'

local KW_TOTAL_ROOM_NUM_COUNT = 6

function JoinRoomLayer:ctor()
	JoinRoomLayer.super.ctor(self)
end

function JoinRoomLayer:init()
	self._canTouchBackground    = true
    self._text_index 			= 1
	JoinRoomLayer.super.init(self)
	
end

function JoinRoomLayer:onCreate()
	for i = 1 , KW_TOTAL_ROOM_NUM_COUNT do
		local text = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(), KW_TEXT_NUM .. i)
		if text then
			text:setString('')
		end
	end

	for j = 0 , 9 do
		local btn = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(), KW_BTN .. j)
		if btn then
			btn.btnNum = j
		end
		Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN .. j,handler(self, self.onBtnEventNumber))
	end
	Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_CLOSE,handler(self, self.onClickEventClose))
	Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_CLEAR,handler(self, self.onBtnEventClear))
	Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),KW_BTN_DELETE,handler(self, self.onBtnEventDelete))
end

function JoinRoomLayer:onClickEventClose(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
    self:showLayer(false)
end

function JoinRoomLayer:addClientEventListener()

end

function JoinRoomLayer:onBtnEventClear(send, eventType)
	if not self:isShowTouchEffect(send, eventType) then return end
	for i = 1 , KW_TOTAL_ROOM_NUM_COUNT do
		Lobby.UIFunction.setString(self:getCsbNode(),KW_TEXT_NUM .. i , '')
	end
	self._text_index = 1
end

function JoinRoomLayer:onBtnEventDelete(send, eventType)
	if not self:isShowTouchEffect(send, eventType) then return end
	for i = KW_TOTAL_ROOM_NUM_COUNT , 1 , -1 do
		local textNode = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(),KW_TEXT_NUM .. i)
		local text = textNode:getString()
		if text ~= '' then
			textNode:setString('')
			self._text_index = i
			break
		end
	end
end

function JoinRoomLayer:onBtnEventNumber(send, eventType)
	if not self:isShowTouchEffect(send, eventType) then return end
	local btnNum = send.btnNum
	print("hcc btn num: " .. tostring(btnNum))
	if not btnNum then 
		return
	end
	Lobby.UIFunction.setString(self:getCsbNode(),KW_TEXT_NUM .. tostring(self._text_index) ,btnNum)
	if self._text_index == KW_TOTAL_ROOM_NUM_COUNT then
		local room_id = ''
		for i = 1 , 6 do
			local text =  Lobby.UIFunction.seekWidgetByName(self:getCsbNode(), KW_TEXT_NUM .. i)
			if text then
				room_id = room_id .. text:getString()
			end
		end
		print('roomID: ' .. room_id)
		LogicServiceProxy:getInstance():sendJoinRoom(room_id)
	end
	self._text_index = self._text_index + 1
end

return JoinRoomLayer