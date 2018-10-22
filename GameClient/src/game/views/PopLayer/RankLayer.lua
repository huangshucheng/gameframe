local PopLayer = require('game.views.Base.PopLayer')
local RankLayer = class("RankLayer", PopLayer)

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.Cmd")
local Stype             = require("game.net.Stype")
local Respones 			= require("game.net.Respones")

RankLayer._csbResourcePath = 'Lobby/PopLayer/RankLayer.csb'

local IMG_BG 					= 'IMG_BG'
local BTN_CLOSE 				= 'BTN_CLOSE'
local KW_RANK_LIST 				= 'KW_RANK_LIST'
local RANK_ITEM 				= 'RANK_ITEM'
local IMG_HEAD 					= 'IMG_HEAD'
local KW_TEXT_RANK 				= 'KW_TEXT_RANK'
local KW_TEXT_NAME 				= 'KW_TEXT_NAME'
local KW_TEXT_UCHIP 			= 'KW_TEXT_UCHIP'
local KW_TEXT_UVIP 				= 'KW_TEXT_UVIP'


function RankLayer:ctor()
	RankLayer.super.ctor(self)
end

function RankLayer:init()
	self._canTouchBackground = true
	self._list_view = nil

	RankLayer.super.init(self)

	NetWork:getInstance():sendMsg(Stype.System,Cmd.eGetWorldRankUchipReq,nil)
	GT.showPopLayer('LoadingLayer')
end

function RankLayer:onCreate()
	local img_bg = self:getCsbNode():getChildByName(IMG_BG)
	if not img_bg then return end

	local btn_close = ccui.Helper:seekWidgetByName(img_bg,BTN_CLOSE)
	if btn_close then
		btn_close:addClickEventListener(handler(self,function()
			self:showLayer(false)
		end))
	end

	self._list_view = ccui.Helper:seekWidgetByName(img_bg,KW_RANK_LIST)
	local rank_item = ccui.Helper:seekWidgetByName(img_bg,RANK_ITEM)
	if not rank_item then return end

	if self._list_view then
		self._list_view:removeAllChildren()
		self._list_view:setItemModel(rank_item)
	end
end

function RankLayer:addEventListenner()
	addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
end

function RankLayer:onEventData(event)
   local data = event._usedata
    if not data then
        return
    end
    local ctype = data.ctype
    if ctype == Cmd.eGetWorldRankUchipRes then
    	GT.popLayer('LoadingLayer')
        local body = data.body
        if body.status == Respones.OK then
            local rank_info = body.rank_info
            for i,v in ipairs(rank_info) do
       			if self._list_view then
       			    self._list_view:pushBackDefaultItem()
                  	local products = self._list_view:getItems()
                    local uinfoItem = products[#products]
                    uinfoItem:setVisible(true)
                    uinfoItem:setSwallowTouches(false)        --单个子item node
                    local text_rank = ccui.Helper:seekWidgetByName(uinfoItem,KW_TEXT_RANK)
                    local text_uchip = ccui.Helper:seekWidgetByName(uinfoItem,KW_TEXT_UCHIP)
                    local img_head = ccui.Helper:seekWidgetByName(uinfoItem,IMG_HEAD)
                    local text_name = ccui.Helper:seekWidgetByName(uinfoItem,KW_TEXT_NAME)
                    local text_uvip = ccui.Helper:seekWidgetByName(uinfoItem,KW_TEXT_UVIP)
                    if text_rank then text_rank:setString(tostring(i)) end
                    if text_uchip then text_uchip:setString(tostring(v.uchip)) end
                    if text_name then text_name:setString(tostring(v.unick)) end
                    if text_uvip then text_uvip:setString(tostring('VIP'.. v.uvip)) end
                    if img_head and v.uface >= 1 and v.uface <= 9 then
                     	img_head:loadTexture(string.format('Lobby/LobbyRes/rectheader/1%d.png',v.uface))
                    end
				end     	
            end
        end
    end
end

function RankLayer:onEnter()
end

return RankLayer