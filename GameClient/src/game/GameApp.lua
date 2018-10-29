local GameApp 		= class("GameApp")
local ProtoMan 		= require("game.utils.ProtoMan")
local NetWork       = require("game.net.NetWork")

GT = {}

local Function 		= require('game.views.Base.Function')
local UIFunction 	= require('game.views.Base.UIFunction')

function GameApp:ctor()
    math.randomseed(os.time())

    ProtoMan:getInstance():regist_pb()
    NetWork:getInstance():start()

    GT.showPopLayer 		= Function.showPopLayer
    GT.popLayer 			= Function.popLayer
    GT.getLayer 			= Function.getLayer
    GT.clearLayers 			= Function.clearLayers
end

function GameApp:showScene(transition, time, more)
    local scene = display.newScene()
    local gameLayer = require("game.Lobby.LobbyScene.LoginScene"):create()
    scene:addChild(gameLayer)
    display.runScene(scene, transition, time, more)
end

return GameApp
