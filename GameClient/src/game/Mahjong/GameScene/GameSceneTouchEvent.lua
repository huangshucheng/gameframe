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
    --test
    --[[
    local room_id = RoomData:getInstance():getRoomId()
    local seat_id = GameFunction.getSelfSeat()
    local opts_table = {}
    local opts_1 = {
        seatid = seat_id,
        opt_type = 0,
        x = 999,
        y = 999,
    }
    table.insert(opts_table,opts_1)
    table.insert(opts_table,opts_1)
    local msg = {
        frameid = 0,
        roomid = room_id,
        seatid = seat_id,
        opts = opts_table,
    }
    LogicServiceProxy:getInstance():sendNextFrame(msg)
    ]]
end

function GameScene:onTouchReadyBtn(sender, eventType)
	LogicServiceProxy:getInstance():sendUserReady()
    print('hcc>> click ready....')
end