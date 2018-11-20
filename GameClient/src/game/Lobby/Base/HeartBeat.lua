local HeartBeat = class('HeartBeat')
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local Respones              = require("game.net.Respones")
local Scheduler     		= require("game.utils.scheduler")

local MAX_DELAY_TIME = 5

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
    print('hcc>> HeartBeat ctor -----')
end

function HeartBeat:init(node)
	self:reset()
	__node = node
	self:addEventListenner()
	return self
end
-- per 3 second send a heartbeat pkg
function HeartBeat:start()
	__schedule = Scheduler.scheduleGlobal(handler(self, self.scheduleHeartBeatUpdate), 3)
	self:sendHeartBeat()
end

function HeartBeat:scheduleHeartBeatUpdate(dt)
	self:sendHeartBeat()
	print('send HeartBeat....... ' .. tostring(dt))
	print('lastDelayTime: '.. self:getLastDelayTime() .. '  , istimeout: ' ..tostring(self:checkTimeOut()))
end

function HeartBeat:sendHeartBeat()
	__sendCount 	= __sendCount + 1
	__lastSendTime   = os.time()

	LogicServiceProxy:getInstance():sendHeartBeat()
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
    	print('hcc>> HeartBeat>> receiveCount: ' .. __receiveCount .. '  lastRecvTime: ' .. __lastReceiveTime  .. '  lastDelayTime: ' .. __lastDelayTime)
    end
end

function HeartBeat:getLastDelayTime()
    if __sendCount == __receiveCount then
    	print('hcc>>111 sendcoutn: '.. __sendCount .. '   recvcoutn: ' .. __receiveCount .. '  lastDelayTime: ' .. __lastDelayTime)
        return __lastDelayTime
    end

    local currentDelayTime = os.time() - __lastSendTime 
    print('hcc>>222 currentDelayTime: '.. currentDelayTime .. '  lastDelayTime: '.. __lastDelayTime)
    if currentDelayTime < __lastDelayTime  then 
    	print('hcc>>333 __lastDelayTime: '.. __lastDelayTime)
        return __lastDelayTime
    end
	print('hcc>>444 __lastDelayTime: '.. currentDelayTime)
    return currentDelayTime
end

function HeartBeat:checkTimeOut()
	return self:getLastDelayTime() > MAX_DELAY_TIME
end

function HeartBeat:reset()
	localReset()
end

return HeartBeat