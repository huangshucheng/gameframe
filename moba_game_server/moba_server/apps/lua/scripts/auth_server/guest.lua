local mysql_center = require("database/mysql_auth_center")
local redis_center = require("database/redis_center")
local Respones 	= require("Respones")
local Stype 	= require("Stype")
local Cmd 		= require("Cmd")

local function login(s, req)
	local utag = req[3];
	local g_key = req[4].guestkey
	dump(req,"guestLogin")
	print('authserver>> guest login, utag: ' .. tostring(utag) .. " ,g_key: " .. g_key)
	-- 判断gkey的合法性，是否为字符串，并且长度为32
	if type(g_key) ~= "string" or string.len(g_key) ~= 32 then 
		local msg = {Stype.Auth, Cmd.eGuestLoginRes, utag, {
			status = Respones.InvalidParams,
		}}
		print('guest login 111')
		Session.send_msg(s, msg)
		return
	end

	mysql_center.get_guest_uinfo(g_key, function (err, uinfo)
		if err then -- 告诉客户端系统错误信息;
			local msg = {Stype.Auth, Cmd.eGuestLoginRes, utag, {
				status = Respones.SystemErr,
			}}

			Session.send_msg(s, msg)
			print('guest login 222')
			return
		end

		if uinfo == nil then -- 没有查到对应的 g_key的信息
			mysql_center.insert_guest_user(g_key, function(err, ret)
				if err then -- 告诉客户端系统错误信息;
					local msg = {Stype.Auth, Cmd.eGuestLoginRes, utag, {
						status = Respones.SystemErr,
					}}
					print('guest login 333')
					Session.send_msg(s, msg)
					return
				end

				login(s, req)
			end)
			return
		end

		-- 找到了gkey所对应的游客数据;
		if uinfo.status ~= 0 then --账号被查封
			local msg = {Stype.Auth, Cmd.eGuestLoginRes, utag, {
				status = Respones.UserIsFreeze,
			}}
			print('guest login 444')
			Session.send_msg(s, msg)
			return
		end

		if uinfo.is_guest ~= 1 then  --账号已经不是游客账号了
			local msg = {Stype.Auth, Cmd.eGuestLoginRes, utag, {
				status = Respones.UserIsNotGuest,
			}}
			print('guest login 555')
			Session.send_msg(s, msg)
			return
		end

		redis_center.set_uinfo_inredis(uinfo.uid, uinfo)
		local msg = { Stype.Auth, Cmd.eGuestLoginRes, utag, {
			status = Respones.OK,
			uinfo = uinfo,
		}}
		print('guest login 666')
		Session.send_msg(s, msg)
	end)
end

local guest = {
	login = login
}

return guest
