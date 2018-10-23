local mysql_center = require("database/mysql_auth_center")

local Respones = require("Respones")
local Stype = require("Stype")
local Cmd = require("Cmd")

function do_login_out(s, req)
	local uid = req[3];
	Logger.debug("user ".. uid .. " login out!")

	-- todo other things
	-- end
	local msg = {Stype.Auth, Cmd.eLoginOutRes, uid, {
		status = Respones.OK,
	}}

	Session.send_msg(s, msg)
end


local login_out = {
	do_login_out = do_login_out
}

return login_out