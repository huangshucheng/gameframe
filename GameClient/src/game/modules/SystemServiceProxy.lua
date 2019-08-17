local SystemServiceProxy = class('SystemServiceProxy')

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.protocol.Cmd")
local Stype             = require("game.net.Stype")

function SystemServiceProxy:getInstance()
	if not SystemServiceProxy._instance then
		SystemServiceProxy._instance = SystemServiceProxy.new()
	end
	return SystemServiceProxy._instance 
end

function SystemServiceProxy:ctor()

end

function SystemServiceProxy:sendGetUgameInfo()
	NetWork:getInstance():sendMsg(Stype.System,Cmd.eGetUgameInfoReq,nil)
	--test
	-- NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eGetUgameInfoReq,nil) --test
	-- local msg = { 
	-- 	uchip = "string,uchip",
	-- 	uexp = "黄数城,uexp",
	-- 	uvip  = 102,
	-- 	uchip2  = 103,
	-- 	uchip3 = 104, 
	-- 	udata1  = 105,
	-- 	udata2  = true,
	-- 	udata3 = false,
	-- }

	-- NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eUserGameInfo,msg) --test
end

function SystemServiceProxy:sendGetSystemMsg()
	NetWork:getInstance():sendMsg(Stype.System,Cmd.eGetSysMsgReq,{vernum = 1})
end

function SystemServiceProxy:sendGetWorldRankChip()
	NetWork:getInstance():sendMsg(Stype.System,Cmd.eGetWorldRankUchipReq,nil)
end

function SystemServiceProxy:sendGetLoginBonues()
	NetWork:getInstance():sendMsg(Stype.System,Cmd.eRecvLoginBonuesReq,nil)
end

return SystemServiceProxy