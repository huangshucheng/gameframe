local InterFace = class("InterFace")

function InterFace:ctor()

end

function InterFace:send_msg(session, msg)
	if type(session) ~= 'userdata' and type(msg) ~= 'table' then
		return
	end
	Session.send_msg(session, msg)
end

function InterFace:send_status(session, stype, ctype, uid, status)
	if session  == nil or 
		stype 	== nil or 
		ctype 	== nil or 
		uid 	== nil or 
		status 	== nil then
		return
	end

	local msg = {stype, ctype, uid, {
		status = status,
	}}

	Session.send_msg(session, msg)
end

return InterFace