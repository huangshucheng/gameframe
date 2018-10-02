
local MyApp = class("MyApp", cc.load("mvc").AppBase)
local ProtoMan = require("game.utils.ProtoMan")

function MyApp:onCreate()
    math.randomseed(os.time())
    ProtoMan:getInstance():regist_pb()
end

return MyApp
