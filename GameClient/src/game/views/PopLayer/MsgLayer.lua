local PopLayer = require('game.views.Base.PopLayer')
local MsgLayer = class("MsgLayer", PopLayer)

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.Cmd")
local Stype             = require("game.net.Stype")
local Respones 			= require("game.net.Respones")

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
	self._list_view = nil

	MsgLayer.super.init(self)
	
    NetWork:getInstance():sendMsg(Stype.System,Cmd.eGetSysMsgReq,{ver_num = 1})
end

function MsgLayer:onCreate()
	local img_bg = self:getCsbNode():getChildByName(IMG_BG)
	if not img_bg then return end

	local btn_close = ccui.Helper:seekWidgetByName(img_bg,BTN_CLOSE)
	if btn_close then
		btn_close:addClickEventListener(handler(self,function()
			self:showLayer(false)
		end))
	end

	self._list_view = ccui.Helper:seekWidgetByName(img_bg,KW_MSG_LIST)
	local msg_item = ccui.Helper:seekWidgetByName(img_bg,MSG_ITEM)
	if not msg_item then return end

	if self._list_view then
		self._list_view:removeAllChildren()
		self._list_view:setItemModel(msg_item)
	end
end

function MsgLayer:addClientEventListener()
	addEvent('GetSysMsgRes', self, self.onEventGetSysMsgRes)
end

function MsgLayer:onEventGetSysMsgRes(event)
   local data = event._usedata
    if not data then
        return
    end
	GT.popLayer('LoadingLayer')
    if data.status == Respones.OK then
        local ver_num = data.ver_num
        local sys_msgs = data.sys_msgs
        print('ver_num  '.. ver_num)
        for i,v in ipairs(sys_msgs) do
            if self._list_view then
                self._list_view:pushBackDefaultItem()
                local products = self._list_view:getItems()
                local infoItem = products[#products]
                infoItem:setVisible(true)
                infoItem:setSwallowTouches(false)
                local text_id   = ccui.Helper:seekWidgetByName(infoItem,KW_TEXT_ID)
                local text_msg  = ccui.Helper:seekWidgetByName(infoItem,KW_TEXT_MSG)
                if text_id then text_id:setString(tostring(i)) end
                if text_msg then text_msg:setString(tostring(v)) end
            end  
        end
    end
end

return MsgLayer