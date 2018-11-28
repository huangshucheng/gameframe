local UserInfo = {}

local USER_NAME 	= 'USER_NAME'
local USER_SEX 		= 'USER_SEX'
local USER_FACE 	= 'USER_FACE'
local USER_VIP 		= 'USER_VIP'
local USER_ID 		= 'USER_ID'
local USER_ACCOUNT  = 'USER_ACCOUNT'
local USER_PWD 		= 'USER_PWD'
local USER_IS_GUEST = 'USER_IS_GUEST'
local USER_GUEST_KEY = 'USER_GUEST_KEY'
local USER_LOGIN_TYPE = 'USER_LOGIN_TYPE'

local logintype = {
	'uname',
	'guest',
	'wechat',
}

local __userName = ''

function UserInfo.setUserNameEx(uname)
	__userName = uname
end

function UserInfo.getUserNameEx()
	return __userName
end

function UserInfo.setUserName(uname)
	if uname == nil or uname == '' then
		return
	end
	UserInfo.setUserNameEx(uname)
	cc.UserDefault:getInstance():setStringForKey(USER_NAME, tostring(uname))
end

function UserInfo.getUserName()
	return cc.UserDefault:getInstance():getStringForKey(USER_NAME)
end

function UserInfo.setUserSex(usex)
	if usex == nil then
		return
	end
	cc.UserDefault:getInstance():setStringForKey(USER_SEX, tostring(usex))
end

function UserInfo.getUserSex()
	return cc.UserDefault:getInstance():getStringForKey(USER_SEX)
end

function UserInfo.setUserface(uface)
	if uface == nil then
		return
	end
	cc.UserDefault:getInstance():setStringForKey(USER_FACE, tostring(uface))
end

function UserInfo.getUserface()
	return cc.UserDefault:getInstance():getStringForKey(USER_FACE)
end

function UserInfo.setUserVip(uvip)
	if uvip == nil then
		return
	end
	cc.UserDefault:getInstance():setStringForKey(USER_VIP, tostring(uvip))
end

function UserInfo.getUserVip()
	return cc.UserDefault:getInstance():getStringForKey(USER_VIP)
end

function UserInfo.setUserId(uid)
	if uid == nil then
		return
	end
	cc.UserDefault:getInstance():setStringForKey(USER_ID, tostring(uid))
end

function UserInfo.getUserId()
	return cc.UserDefault:getInstance():getStringForKey(USER_ID)
end

function UserInfo.setUserPwd(pwd)
	if pwd == nil  then
		return
	end
	cc.UserDefault:getInstance():setStringForKey(USER_PWD, tostring(pwd))
end

function UserInfo.getUserPwd()
	return cc.UserDefault:getInstance():getStringForKey(USER_PWD)
end

function UserInfo.setUserAccount(account)
	if account == nil  then
		return
	end
	cc.UserDefault:getInstance():setStringForKey(USER_ACCOUNT, tostring(account))
end

function UserInfo.getUserAccount()
	return cc.UserDefault:getInstance():getStringForKey(USER_ACCOUNT)
end

function UserInfo.setUserIsGuest(isguest)
	if isguest == nil  then
		return
	end
	cc.UserDefault:getInstance():setBoolForKey(USER_IS_GUEST, isguest)
end

function UserInfo.getUserIsGuest()
	return cc.UserDefault:getInstance():getBoolForKey(USER_IS_GUEST,true)
end

function UserInfo.setUserGuestKey(key)
	if key == nil then
		return
	end
	cc.UserDefault:getInstance():setStringForKey(USER_GUEST_KEY, tostring(key))
end

function UserInfo.getUserGuestKey()
	return cc.UserDefault:getInstance():getStringForKey(USER_GUEST_KEY,'')
end

function UserInfo.setLoginType(type)
	cc.UserDefault:getInstance():setStringForKey(USER_LOGIN_TYPE, tostring(type))
end

function UserInfo.getLoginType()
	return cc.UserDefault:getInstance():getStringForKey(USER_LOGIN_TYPE,'')
end

function UserInfo.flush()
	cc.UserDefault:getInstance():flush()
end


return UserInfo