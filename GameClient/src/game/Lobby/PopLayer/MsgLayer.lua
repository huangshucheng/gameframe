local PopLayer = require('game.Base.PopLayer')
local MsgLayer = class("MsgLayer", PopLayer)

local Respones 			= require("game.net.Respones")
local SystemServiceProxy = require("game.modules.SystemServiceProxy")

MsgLayer._csbResourcePath = 'Lobby/PopLayer/MsgLayer.csb'

local IMG_BG 					= 'IMG_BG'
local BTN_CLOSE 				= 'BTN_CLOSE'
local KW_MSG_LIST 				= 'KW_MSG_LIST'
local MSG_ITEM 				    = 'MSG_ITEM'
local KW_TEXT_ID 				= 'KW_TEXT_ID'
local KW_TEXT_MSG 				= 'KW_TEXT_MSG'

function MsgLayer:ctor()
	MsgLayer.super.ctor(self)
end

function MsgLayer:init()
	self._canTouchBackground = true
	MsgLayer.super.init(self)
    SystemServiceProxy:getInstance():sendGetSystemMsg()
end

function MsgLayer:onCreate()
	local list_view = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(),KW_MSG_LIST)
	local msg_item = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(),MSG_ITEM)
	if list_view and msg_item then
		list_view:removeAllChildren()
		list_view:setItemModel(msg_item)
	end
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),BTN_CLOSE,handler(self, self.onClickEventClose))
end

function MsgLayer:onClickEventClose(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
    self:showLayer(false)
end

function MsgLayer:addClientEventListener()
	addEvent('GetSysMsgRes', self,self,self.onEventGetSysMsgRes)
end

function MsgLayer:onEventGetSysMsgRes(event)
   local data = event._usedata
    if not data then
        return
    end
    local list_view = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(),KW_MSG_LIST)
	Lobby.popLayer('LoadingLayer')
    if data.status == Respones.OK then
        local ver_num = data.ver_num
        local sys_msgs = data.sys_msgs
        print('ver_num  '.. ver_num)
        for i,v in ipairs(sys_msgs) do
            if list_view then
                list_view:pushBackDefaultItem()
                local products = list_view:getItems()
                local infoItem = products[#products]
                infoItem:setVisible(true)
                infoItem:setSwallowTouches(false)
                Lobby.UIFunction.setString(infoItem,KW_TEXT_ID,i)
                Lobby.UIFunction.setString(infoItem,KW_TEXT_MSG,v)
            end  
        end
    end
end

return MsgLayer