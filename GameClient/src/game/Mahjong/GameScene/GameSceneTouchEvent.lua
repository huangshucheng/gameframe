local GameScene = class("GameScene")

local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local RoomData              = require("game.clientdata.RoomData")
local GameFunction          = require("game.Mahjong.Base.GameFunction")

function GameScene:onTouchSettingBtn(send, eventType)
   if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
    Game.showPopLayer('SetLayer')
    -- Game.showPopLayer('WinLostLayer')
    -- Game.showPopLayer('TotalWinLostLayer')
end

function GameScene:onTouchReadyBtn(send, eventType)
    if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
	LogicServiceProxy:getInstance():sendUserReady()
    print('hcc>> click ready....')
end

function GameScene:onTouchTouZi(send, eventType)
	if not Lobby.UIFunction.isShowTouchEffect(send, eventType) then return end
	local index = send.index
	print('hcc>>onTouchTouZi ' .. tostring(index))
	local selfSeat = GameFunction.getSelfSeat()
	print('slefseat: ' .. selfSeat)
	LogicServiceProxy:getInstance():sendTouZiNum(selfSeat, index)
end

return GameScene