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

function LogicServiceProxy:sendExitRoom()
	NetWork:getInstance():sendMsg(Stype.Logic, Cmd.eExitRoomReq, nil)
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

return LogicServiceProxy