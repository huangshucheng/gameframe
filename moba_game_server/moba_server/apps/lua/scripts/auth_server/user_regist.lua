local mysql_center = require("database/mysql_auth_center")
local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")

local function _do_create_account(s, utag, uname, upwdmd5)
	mysql_center.do_create_account(uname, upwdmd5, function (err, ret)
		if err then
			local msg = {Stype.Auth, Cmd.eUserRegistRes, utag, {
				status = Respones.SystemErr,
			}}

			Session.send_msg(s, msg)
			return
		end

		local msg = {Stype.Auth, Cmd.eUserRegistRes, utag, {
			status = Respones.OK,
		}}

		Session.send_msg(s, msg) 
	end)
end

local function regist(s, req)
	local utag = req[3]
	local user_regist_req = req[4]		--{uname='' , upwdmd5 = ''}
	-- print("hcc >> regist: uname: " .. user_regist_req.uname .. ' upwdmd5: ' .. user_regist_req.upwdmd5)
	dump(user_regist_req,"user_regist_req")
	local uname 	= user_regist_req.uname
	local upwdmd5 	= user_regist_req.upwdmd5

	-- 检查参数
	-- if string.len(uname_login_req.uname) <= 0 or string.len(uname_login_req.upwd) ~= 32 then 	-- TODO md5 check 
	local nameLen = string.len(uname)
	local upwd_md5Len = string.len(upwdmd5)
	if nameLen < 6 or nameLen > 32 or upwd_md5Len < 6 or upwd_md5Len > 32 then 	-- TODO md5 check 
	   	local msg = {Stype.Auth, Cmd.eUserRegistRes, utag, {
			status = Respones.InvalidParams,
		}}
		Session.send_msg(s, msg)
		return
	end

	mysql_center.check_uname_exist(uname, function (err, ret)
		if err then 
			local msg = {Stype.Auth, Cmd.eUserRegistRes, utag, {
				status = Respones.SystemErr,
			}}

			Session.send_msg(s, msg)
			return
		end

		if ret then -- uname已经被占用了
			local msg = {Stype.Auth, Cmd.eUserRegistRes, utag, {
				status = Respones.UnameIsExist,
			}}

			Session.send_msg(s, msg)
			return 
		end
		 _do_create_account(s, utag, uname, upwdmd5)
	end)
end

local user_regist = {
	regist = regist,
}

return user_regist
