local HeartBeat = class('HeartBeat')
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local NetWork               = require("game.net.NetWork")
local Scheduler     = require("game.utils.scheduler")

local MAX_DELAY_TIME 	= 6 	--多少秒以内没有收到消息算断开连接

function HeartBeat:getInstance()
	if HeartBeat._instance == nil then
		HeartBeat._instance = HeartBeat:create()
	end
	return HeartBeat._instance
end

function HeartBeat:ctor()
	self.__heartBeatCount 	= 0

	if self.timeScheduler then
		Scheduler.unscheduleGlobal(self.timeScheduler)	
	end
	self.timeScheduler = Scheduler.scheduleGlobal(handler(self,self.scheduleHeartBeatUpdate), 1)
end

function HeartBeat:scheduleHeartBeatUpdate()
	self.__heartBeatCount = self.__heartBeatCount + 1
	if self:isTimeOut() then
		if NetWork:getInstance():getIsConnected() then
			print('scheduleHeartBeatUpdate>> true')
			NetWork:getInstance():setIsConnected(false)
		end
		postEvent(ClientEvents.ON_NETWORK_OFF)
		print('scheduleHeartBeatUpdate>> timeOut............')	
	end
	print('scheduleHeartBeatUpdate>> count: ' .. self.__heartBeatCount)
end

function HeartBeat:isTimeOut()
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

function HeartBeat:resetHeartBeatCount()
	self.__heartBeatCount = 0 -- 留下一秒去连接登陆服
end

return HeartBeat