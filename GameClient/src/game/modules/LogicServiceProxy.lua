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
	local ip , port = ConfigKeyWord.get_udp_addr()
    local msg = {
        udp_ip = ip,
        udp_port = port,
    }
 	NetWork:getInstance():sendMsg(Stype.Logic,Cmd.eLoginLogicReq,msg)
end

function LogicServiceProxy:sendCreateRoom(room_info)
	if type(room_info) ~= 'string' then return end 
	local msg = {
		room_info = room_info 
	}

	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eCreateRoomReq, msg)
end

function LogicServiceProxy:sendDessolveRoom()
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eDessolveReq, nil)
end

function LogicServiceProxy:sendExitRoom(is_force)
	if is_force == nil then
		is_force = false
	end
	local msg = {
		is_force_exit = is_force
	}
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eExitRoomReq, msg)
	dump(msg,'hcc>>sendExitRoom')
end

function LogicServiceProxy:sendJoinRoom(roomid)
	if type(roomid) ~= 'string' then return end 
	local msg = {
		room_id = roomid,
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
		ready_state = 1,
	}
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eUserReadyReq, msg)
end

function LogicServiceProxy:sendUserCancelReady()
	local msg = {
		ready_state = 2,
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

return LogicServiceProxy