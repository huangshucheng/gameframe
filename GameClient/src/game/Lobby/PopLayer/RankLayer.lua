local PopLayer = require('game.Base.PopLayer')
local RankLayer = class("RankLayer", PopLayer)

local Respones 			= require("game.net.Respones")
local SystemServiceProxy = require("game.modules.SystemServiceProxy")

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

	RankLayer.super.init(self)

    SystemServiceProxy:getInstance():sendGetWorldRankChip()
end

function RankLayer:onCreate()
    Lobby.UIFunction.addTouchEventListener(self:getCsbNode(),BTN_CLOSE,handler(self, self.onClickEventClose))

	local list_view = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(),KW_RANK_LIST)
	local rank_item = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(),RANK_ITEM)
	if list_view and rank_item then
		list_view:removeAllChildren()
		list_view:setItemModel(rank_item)
	end
end

function RankLayer:onClickEventClose(send, eventType)
    if not self:isShowTouchEffect(send, eventType) then return end
    self:showLayer(false)
end

function RankLayer:addClientEventListener()
	addEvent('GetWorldRankUchipRes', self, self, self.onEventWorldRankUchipRes)
end

function RankLayer:onEventWorldRankUchipRes(event)
   local data = event._usedata
    if not data then
        return
    end
    local list_view = Lobby.UIFunction.seekWidgetByName(self:getCsbNode(),KW_RANK_LIST)
	Lobby.popLayer('LoadingLayer')
    if data.status == Respones.OK then
        local rank_info = data.rank_info
        for i,v in ipairs(rank_info) do
   			if list_view then
   			    list_view:pushBackDefaultItem()
              	local products = list_view:getItems()
                local uinfoItem = products[#products]
                uinfoItem:setVisible(true)
                uinfoItem:setSwallowTouches(false)        --单个子item node
                Lobby.UIFunction.setString(uinfoItem,KW_TEXT_RANK,i)
                Lobby.UIFunction.setString(uinfoItem,KW_TEXT_UCHIP,v.uchip)
                Lobby.UIFunction.setString(uinfoItem,KW_TEXT_NAME,v.unick)
                Lobby.UIFunction.setString(uinfoItem,KW_TEXT_UVIP, 'VIP ' .. v.uvip)
                Lobby.UIFunction.loadTexture(uinfoItem,IMG_HEAD,string.format('Lobby/LobbyRes/rectheader/1%d.png',v.uface))
			end     	
        end
    end
end

function RankLayer:onEnter()
end

return RankLayer