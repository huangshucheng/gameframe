local LogicServiceProxy = class(LogicServiceProxy)

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.protocol.Cmd")
local Stype             = require("game.net.Stype")

function LogicServiceProxy:getInstance()
	if not LogicServiceProxy._instance then
		LogicServiceProxy._instance = LogicServiceProxy.new()
	end
	return LogicServiceProxy._instance 
end

function LogicServiceProxy:ctor()

end

function LogicServiceProxy:sendLoginLogicServer()
 	NetWork:getInstance():sendMsg(Stype.Logic,Cmd.eLoginLogicReq,nil)
end

return LogicServiceProxy