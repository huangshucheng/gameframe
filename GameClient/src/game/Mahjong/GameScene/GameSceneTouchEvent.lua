local GameScene = Game.GameScene or {}

local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local RoomData              = require("game.clientdata.RoomData")
local GameFunction          = require("game.Mahjong.Base.GameFunction")

function GameScene:onTouchSettingBtn(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        sender:setScale(0.9)
        sender:setColor(cc.c3b(160,160,160))
    elseif eventType == ccui.TouchEventType.ended or
        eventType == ccui.TouchEventType.canceled then
        sender:setScale(1)
        sender:setColor(cc.c3b(255,255,255))
    end
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    Game.showPopLayer('SetLayer')
end

function GameScene:onTouchReadyBtn(sender, eventType)
	LogicServiceProxy:getInstance():sendUserReady()
    print('hcc>> click ready....')
end