local HeartBeat = class('HeartBeat')
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")

local MAX_DELAY_TIME 	= 6 	--多少秒以内没有收到消息算断开连接

function HeartBeat:getInstance()
	if HeartBeat._instance == nil then
		HeartBeat._instance = HeartBeat:create()
	end
	return HeartBeat._instance
end

function HeartBeat:ctor()
	self.__heartBeatCount 	= 0
	local delay = cc.DelayTime:create(1)
	local seq = cc.Sequence:create(delay,cc.CallFunc:create(handler(self, self.scheduleHeartBeatUpdate)))
	local scene = display.getRunningScene()
	if scene then
		scene:runAction(cc.RepeatForever:create(seq))
	end
end

function HeartBeat:scheduleHeartBeatUpdate()
	self.__heartBeatCount = self.__heartBeatCount + 1
	if self:checkTimeOut() then
		postEvent(ClientEvents.ON_NETWORK_OFF)
		print('scheduleHeartBeatUpdate>> timeOut............')	
	end
	print('scheduleHeartBeatUpdate>> count: ' .. self.__heartBeatCount)
end

function HeartBeat:checkTimeOut()
	if self.__heartBeatCount >= MAX_DELAY_TIME then
		self.__heartBeatCount = MAX_DELAY_TIME
		return true
	end
	return false
end

function HeartBeat:onHeartBeat()
	self.__heartBeatCount = 0
	LogicServiceProxy:getInstance():sendHeartBeat()
	print('onEventHeartBeat>> count: ' .. self.__heartBeatCount)
end

return HeartBeat