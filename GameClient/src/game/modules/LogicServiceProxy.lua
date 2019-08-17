local LogicServiceProxy = class('LogicServiceProxy')

local NetWork           = require("game.net.NetWork")
local NetWorkUDP 		= require("game.net.NetWorkUDP")
local Cmd               = require("game.net.protocol.Cmd")
local Stype             = require("game.net.Stype")
local ConfigKeyWord     = require("game.net.ConfigKeyWord")

function LogicServiceProxy:getInstance()
	if not LogicServiceProxy._instance then
		LogicServiceProxy._instance = LogicServiceProxy.new()
	end
	return LogicServiceProxy._instance 
end

function LogicServiceProxy:ctor()

end

function LogicServiceProxy:sendLoginLogicServer()
 	NetWork:getInstance():sendMsg(Stype.Logic,Cmd.eLoginLogicReq)
end

function LogicServiceProxy:sendCreateRoom(roominfo)
	if type(roominfo) ~= 'string' then return end 
	local msg = {
		roominfo = roominfo 
	}

	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eCreateRoomReq, msg)
end

function LogicServiceProxy:sendDessolveRoom()
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eDessolveReq, nil)
end

function LogicServiceProxy:sendExitRoom()
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eExitRoomReq)
	dump(msg,'hcc>>sendExitRoom')
end

function LogicServiceProxy:sendJoinRoom(roomid)
	if type(roomid) ~= 'string' then return end 
	local msg = {
		roomid = roomid,
	}
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eJoinRoomReq, msg)
end

function LogicServiceProxy:sendGetCreateStatus()
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eGetCreateStatusReq, nil)
end

function LogicServiceProxy:sendBackRoomReq()
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eBackRoomReq, nil)
end

function LogicServiceProxy:sendHeartBeat()
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eHeartBeatReq, nil)
end

function LogicServiceProxy:sendReconnect()
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eUserReconnectedReq, nil)
end

function LogicServiceProxy:sendUserReady()
	local msg = {
		readystate = 1,
	}
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eUserReadyReq, msg)
end

function LogicServiceProxy:sendUserCancelReady()
	local msg = {
		readystate = 2,
	}
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eUserReadyReq, msg)
end

--test
function LogicServiceProxy:sendUdpTest(msg)
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eUdpTest, msg)
end

function LogicServiceProxy:sendNextFrame(msg)
	NetWorkUDP:getInstance():sendMsg(Stype.Logic, Cmd.eNextFrameOpts, msg)
end

function LogicServiceProxy:sendCheckLinkGameReq()
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eCheckLinkGameReq)
end

function LogicServiceProxy:sendTouZiNum(seatid, num)
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eClickTouZiNumReq,{seatid = seatid,touzi_num = num})
end

return LogicServiceProxy