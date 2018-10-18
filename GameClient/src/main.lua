
cc.FileUtils:getInstance():setPopupNotify(false)

local path = cc.FileUtils:getInstance():getWritablePath()
cc.FileUtils:getInstance():addSearchPath(path.."/src/")
cc.FileUtils:getInstance():addSearchPath(path.."/res/")
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require "game.utils.GameEventEnum"
require "game.utils.protobuf.protobuf"

local function main()
    require("game.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end