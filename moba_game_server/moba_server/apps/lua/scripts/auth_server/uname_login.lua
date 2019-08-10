local mysql_center = require("database/mysql_auth_center")
local redis_center = require("database/redis_center")

local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")

local function login(s, req)
	local utag = req[3]
	local uname_login_req = req[4]
	dump(uname_login_req, "hcc>>uname_login_req")
	-- 检查参数
	-- if string.len(uname_login_req.uname) <= 0 or string.len(uname_login_req.upwd) ~= 32 then 	-- TODO md5 check 
	if string.len(uname_login_req.uname) <= 0 then 	-- TODO md5 check 
	   	local msg = {Stype.Auth, Cmd.eUnameLoginRes, utag, {
			status = Respones.InvalidParams,
		}}

		Session.send_msg(s, msg)
		return
	end
	-- 检查用户名和密码是否正确
	mysql_center.get_uinfo_by_uname_upwd(uname_login_req.uname, uname_login_req.upwd, function (err, uinfo)
		if err then
			local msg = {Stype.Auth, Cmd.eUnameLoginRes, utag, {
				status = Respones.SystemErr,
			}}

			Session.send_msg(s, msg)
			return
		end

		if uinfo == nil then -- 没有查到对应的 用户,返回不存在用户，或密码错误
			local msg = {Stype.Auth, Cmd.eUnameLoginRes, utag, {
				status = Respones.UnameOrUpwdError,
			}}

			Session.send_msg(s, msg)
			return
		end

		if uinfo.status ~= 0 then --账号被查封
			local msg = {Stype.Auth, Cmd.eUnameLoginRes, utag, {
				status = Respones.UserIsFreeze,
			}}

			Session.send_msg(s, msg)
			return
		end

		redis_center.set_uinfo_inredis(uinfo.uid, uinfo)
		local msg = { Stype.Auth, Cmd.eUnameLoginRes, utag, {
			status = Respones.OK,
			uinfo = {
				unick = uinfo.unick,
				uface = uinfo.uface,
				usex  = uinfo.usex,
				uvip  = uinfo.uvip,
				uid = uinfo.uid, 
				brandid = uinfo.brandid,
				numberid = uinfo.numberid,
				areaid = uinfo.areaid,
			}
		}}
		Session.send_msg(s, msg)
		print('authserver>> username login, id: ' .. tostring(msg[4].uinfo.uid))
	end)
end
--test 
local testProto = function(s,req)
	local utag = req[3]	or 0
	local body = req[4]
	dump(body, "hcc>>testProto")
	-- 返回给客户端
	local msg = { Stype.Auth, Cmd.eUserGameInfo, utag, body}
	-- local msg = { Stype.Auth, Cmd.eUnameLoginRes, utag, {
	-- 		status = Respones.OK,
	-- 		uinfo = {
	-- 			unick = "hcc",
	-- 			uface = 1,
	-- 			usex  = 2,
	-- 			uvip  = 3,
	-- 			uid = 4, 
	-- 			brandid = "111111",
	-- 			numberid = "222222",
	-- 			areaid = "7109",
	-- 		}
	-- 	}}
	-- dump(msg,"hcc>>testProto>>ugame_info utag: " .. tostring(utag))
	Session.send_msg(s, msg)
end

local uname_login = {
	login = login,
	testProto = testProto,
}

return uname_login
