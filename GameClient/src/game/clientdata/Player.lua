local Player = class('Player')

Player.STATE = {
    psNull			= 0,        -- 空
    psWait 			= 1,        -- 等待(按下开始按钮前)
    psReady 		= 2,        -- 准备(按下开始按钮后)
    psPlaying 		= 3,      	-- 游戏(正在进行游戏)
    psEscape 		= 4,       	-- 逃跑(游戏被中断)
    psExitEarly 	= 5,    	-- 提前退出
    psSeeing 		= 6,		-- 旁观
} 

function Player:ctor()
	self:reset()
end

function Player:reset()
	self._areaid 	= 0
	self._brandid 	= 0
	self._ishost 	= false
	self._isoffline = false
	self._numberid 	= 0
	self._roomid 	= 0
	self._seatid 	= 0
	self._side 		= 0
	self._uface 	= 1
	self._unick 	= ''
	self._usex 		= 0 
	self._state 	= 0
end

function Player:setUInfo(uinfo)
	if not next(uinfo) then return end
	self._areaid 	= uinfo.areaid
	self._brandid 	= uinfo.brandid
	self._ishost 	= uinfo.ishost
	self._isoffline = uinfo.isoffline
	self._numberid 	= uinfo.numberid
	self._roomid 	= uinfo.roomid
	self._seatid 	= uinfo.seatid
	self._side 		= uinfo.side
	self._uface 	= uinfo.uface
	self._unick 	= uinfo.unick
	self._usex 		= uinfo.usex
	self._state 	= uinfo.user_state
end

function Player:getSeat()
	return self._seatid
end

function Player:getBrandId()
	return self._brandid
end

function Player:getUNick()
	return self._unick
end

function Player:getAreaId()
	return self._areaid
end

function Player:getIsHost()
	return self._ishost
end

function Player:getIsOffline()
	return self._isoffline
end

function Player:getNumberId()
	return self._numberid
end

function Player:getRoomId()
	return self._roomid
end

function Player:getSide()
	return self._side
end

function Player:getUFace()
	return self._uface
end

function Player:getUSex()
	return self._usex
end

function Player:getState()
	return self._state
end

function Player:setState(state)
	self._state = state
end

function Player:getLocalSeat()
	return require('game.Mahjong.Base.GameFunction').serverSeatToLocal(self._seatid)
end

function Player:getServerSeat()
	return self._seatid
end

return Player