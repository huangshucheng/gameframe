local HeartBeat = class('HeartBeat')
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local Respones              = require("game.net.Respones")
local Scheduler     		= require("game.utils.scheduler")

local MAX_DELAY_TIME 	= 5 	--多少秒以内没有收到消息算断开连接
local MAX_COUNT 		= 100000 

local __node 			= nil
local __schedule 		= nil
local __sendCount 		= 0
local __receiveCount 	= 0
local __lastReceiveTime = 0
local __lastSendTime  	= 0
local __lastDelayTime  	= 0

local localReset = function()
	__node 				= nil
	__sendCount 		= 0
	__receiveCount 		= 0
	__lastReceiveTime  	= 0
	__lastSendTime  	= 0
	__lastDelayTime  	= 0
    if __schedule then
    	Scheduler.unscheduleGlobal(__schedule)
    end
end

function HeartBeat:getInstance()
	if HeartBeat._instance == nil then
		HeartBeat._instance = HeartBeat:create()
	end
	return HeartBeat._instance
end

function HeartBeat:ctor()
	localReset()
end

function HeartBeat:init(node)
	self:stop()
	__node = node
	self:addEventListenner()
	return self
end
-- per 3 second send a heartbeat pkg
function HeartBeat:start()
	__schedule = Scheduler.scheduleGlobal(handler(self, self.scheduleHeartBeatUpdate), 2)
	self:sendHeartBeat()
end

function HeartBeat:scheduleHeartBeatUpdate(dt)
	self:sendHeartBeat()
	if self:checkTimeOut() then
		-- postEvent(ClientEvents.ON_NETWORK_OFF, nil)
	end
end

function HeartBeat:sendHeartBeat()
	__sendCount 	= __sendCount + 1
	__lastSendTime  = os.time()
	if __sendCount > MAX_COUNT or __receiveCount > MAX_COUNT then
		__sendCount 	= 0 
		__receiveCount 	= 0
	end
	LogicServiceProxy:getInstance():sendHeartBeat()
	print('hcc>> HeartBeat>> __sendCount: ' .. __sendCount .. '  ,__receiveCount: ' .. __receiveCount)
	print('lastDelayTime: '.. self:getLastDelayTime() .. '  , istimeout: ' ..tostring(self:checkTimeOut()))
end

function HeartBeat:addEventListenner()
	if __node then
		addEvent("HeartBeatRes", __node, self.onEventHeartBeat)
	end
end

function HeartBeat:onEventHeartBeat(event)
    local data = event._usedata
    local status = data.status
    if status == Respones.OK then
    	__receiveCount 		= __receiveCount + 1
    	__lastReceiveTime  	= os.time()
    	__lastDelayTime  	= __lastReceiveTime  - __lastSendTime 
    	print('hcc>> HeartBeat>> __lastReceiveTime: ' .. __lastReceiveTime .. '  ,__lastSendTime: ' .. __lastSendTime  .. '  ,__lastDelayTime: ' .. __lastDelayTime)
    end
end

function HeartBeat:getLastDelayTime()
    if __sendCount == __receiveCount then
        return __lastDelayTime
    end

    local currentDelayTime = os.time() - __lastReceiveTime
    if currentDelayTime < __lastDelayTime  then 
        return __lastDelayTime
    end
    return currentDelayTime
end

function HeartBeat:checkTimeOut()
	return self:getLastDelayTime() >= MAX_DELAY_TIME
end

function HeartBeat:stop()
	localReset()
end

return HeartBeat