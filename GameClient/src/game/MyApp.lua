
local MyApp 		= class("MyApp", cc.load("mvc").AppBase)
local ProtoMan 		= require("game.utils.ProtoMan")
local NetWork       = require("game.net.NetWork")

GT = {}

local Function 		= require('game.views.Base.Function')
local RootLayer  	= require('game.views.Base.RootLayer')
local UIFunction 	= require('game.views.Base.UIFunction')
local RootLayer 	= require('game.views.Base.RootLayer')

function MyApp:onCreate()
    math.randomseed(os.time())

    ProtoMan:getInstance():regist_pb()
    NetWork:getInstance():start()

    GT.showPopLayer 		= Function.showPopLayer
    GT.getPopLayerClass 	= Function.getPopLayerClass
    GT.popLayer 			= Function.popLayer
    GT.getLayer 			= Function.getLayer
    GT.clearLayers 			= Function.clearLayers

    GT.seekWidgetByName 	= UIFunction.seekWidgetByName
end

return MyApp
