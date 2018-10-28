local AuthServiceProxy = class(AuthServiceProxy)

local NetWork           = require("game.net.NetWork")
local Cmd               = require("game.net.protocol.Cmd")
local Stype             = require("game.net.Stype")

function AuthServiceProxy:getInstance()
	if not AuthServiceProxy._instance then
		AuthServiceProxy._instance = AuthServiceProxy.new()
	end
	return AuthServiceProxy._instance 
end

function AuthServiceProxy:ctor()

end

function AuthServiceProxy:sendGuestLogin(keyStr)
	if type(keyStr) ~= 'string' or string.len(keyStr) ~= 32 then
		return
	end
	NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eGuestLoginReq,{guest_key = keyStr})
end

function AuthServiceProxy:sendUnameLogin(unameStr, upwdStr)
	if type(unameStr) ~= 'string' or type(upwdStr) ~= 'string' then
		return
	end
	NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eUnameLoginReq,{uname = unameStr, upwd = upwdStr})
end

function AuthServiceProxy:sendRegist(unameStr, upwd_md5Str)
	if type(unameStr) ~= 'string' or type(upwd_md5Str) ~= 'string' then
		return
	end
	NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eUserRegistReq,{uname = unameStr, upwd_md5 = upwd_md5Str}) 
end

function AuthServiceProxy:sendEditProfile(unickStr, ufaceStr, usexStr)
	if type(unickStr) ~= 'string' or type(ufaceStr) ~= 'number' or type(usexStr) ~= 'number' then
		return
	end
	local msg = {
		unick = unickStr,
		uface = ufaceStr,
		usex = usexStr,
	}
	NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eEditProfileReq,msg)
end

function AuthServiceProxy:sendLoginOut()
	NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eLoginOutReq,nil)
end

function AuthServiceProxy:sendUpgrade(unameStr, upwd_md5Str)
	if type(unameStr) ~= 'string' or type(upwd_md5Str) ~= 'string' then
		return
	end
	NetWork:getInstance():sendMsg(Stype.Auth,Cmd.eAccountUpgradeReq,{uname = unameStr, upwd_md5 = upwd_md5Str})
end

return AuthServiceProxy