local NetWork = class("NetWork")
local Stype 		= require("Stype")

function NetWork:getInstance()
	if not NetWork._instance then
		NetWork._instance = NetWork.new()
	end
	return NetWork._instance
end

function NetWork:ctor()

end

function NetWork:send_msg(session, msg)
	if type(session) ~= 'userdata' and type(msg) ~= 'table' then
		return
	end
	Session.send_msg(session, msg)
end

function NetWork:send_status(session, ctype, uid, status)
	if session  == nil or 
		ctype 	== nil or 
		uid 	== nil or 
		status 	== nil then
		return
	end

	local msg = {Stype.Logic, ctype, uid, {
		status = status,
	}}

	Session.send_msg(session, msg)
end

return NetWork