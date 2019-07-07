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

return GameScene