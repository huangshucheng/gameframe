
local MyApp 		= class("MyApp", cc.load("mvc").AppBase)
local ProtoMan 		= require("game.utils.ProtoMan")
local NetWork       = require("game.net.NetWork")

function MyApp:onCreate()
    math.randomseed(os.time())
    ProtoMan:getInstance():regist_pb()
    NetWork:getInstance():start()

    -- local glView = cc.Director:getInstance():getOpenGLView()
    -- glView:setDesignResolutionSize(1280, 720, cc.ResolutionPolicy.EXACT_FIT)

end

return MyApp
