local Stype = require("Stype")
local Cmd 	= require("Cmd")
local guest = require("auth_server/guest")
require("functions")

local edit_profile 		= require("auth_server/edit_profile")
local account_upgrade 	= require("auth_server/account_upgrade");
local uname_login 		= require("auth_server/uname_login")
local login_out 		= require("auth_server/login_out")
local user_regist 		= require("auth_server/user_regist")

local auth_service_handlers = {}
auth_service_handlers[Cmd.eGuestLoginReq] 		= guest.login
auth_service_handlers[Cmd.eEditProfileReq] 		= edit_profile.do_edit_profile
auth_service_handlers[Cmd.eAccountUpgradeReq] 	= account_upgrade.do_upgrade
auth_service_handlers[Cmd.eUnameLoginReq] 		= uname_login.login
auth_service_handlers[Cmd.eLoginOutReq] 		= login_out.do_login_out
auth_service_handlers[Cmd.eUserRegistReq] 		= user_regist.regist
auth_service_handlers[Cmd.eUserGameInfo] 		= uname_login.testProto

local function on_auth_recv_cmd(s, msg)
	if auth_service_handlers[msg[2]] then 
		auth_service_handlers[msg[2]](s, msg)
	end
end

local function on_auth_session_disconnect(s, stype) 
	print('authserver>> on_auth_session_disconnect:  ' .. tostring(stype))
end

local auth_service = {
	on_session_recv_cmd = on_auth_recv_cmd,
	on_session_disconnect = on_auth_session_disconnect,
}

return auth_service