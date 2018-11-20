--[[
心跳包，在游戏过程中，每过一段时间，客户端会向服务器发送一个很短或者空的数据，
根据判断是否有返回的数据，可以知道，是否正在连接。介绍不多说，我们看代码
我们可以看到，在一开始函数初始化的时候，我们添加了Start方法初始化各个计数器的值，
然后添加了Update方法开始计时，每隔固定的时间，
客户端会发送消息给服务器，根据发送消息的时间及接受时的延时时间差，
确认连接正常，如果超出规定时间，判断连接失败，
进行重连方法。如果连接成功，计数器清零，准备进行下一次的心跳包发送
]]

local IDispose=require("Core/IDispose")
local HeartbeatCtrl = class("HeartbeatCtrl",IDispose);

HeartbeatCtrl.MAX_DELAY_TIME=30--检测心跳的时间
--心跳包控制器
function HeartbeatCtrl:ctor()
    self:EventInit()
    self:SocketInit()
end

function HeartbeatCtrl:SocketInit()
    _G_Socket:AddPropertyEvent(SocketStatic.SERVER_LOGIN,HeartbeatCtrl.Start,self)
    _G_Socket:AddPropertyEvent(rpc_info.rpc_dict.keepAlive,HeartbeatCtrl.HeartbeatCallBack,self)
end

function HeartbeatCtrl:RemoveSocket()
    _G_Socket:RemovePropertyEvent(SocketStatic.SERVER_LOGIN,HeartbeatCtrl.Start,self)
    _G_Socket:RemovePropertyEvent(rpc_info.rpc_dict.keepAlive,HeartbeatCtrl.HeartbeatCallBack,self)
end

function HeartbeatCtrl:EventInit()

    _G_Dispatcher:AddPropertyEvent(GameStatic.START_ENTER_GAME,HeartbeatCtrl.Stop,self);
    _G_Dispatcher:AddPropertyEvent(GameStatic.SERVER_SHUT_DOWN,HeartbeatCtrl.Stop,self);
end

function HeartbeatCtrl:RemoveEvent()

    _G_Dispatcher:RemovePropertyEvent(GameStatic.START_ENTER_GAME,HeartbeatCtrl.Stop,self);
    _G_Dispatcher:RemovePropertyEvent(GameStatic.SERVER_SHUT_DOWN,HeartbeatCtrl.Stop,self);
end

function HeartbeatCtrl:Start()
    -- print("===========================    开启心跳       ========================")
    self.sendCount=0
    self.receiveCount=0
    self.lastReceiveTime=0
    self.lastSendTime=0
    self.lastDelayTime=0
    self.timer = Timer.New(function()self:Heartbeat() end,25,-1,false)
    self.timer:Start()
    self:Heartbeat()

    FixedUpdateBeat:Add(self.Update, self)
end

function HeartbeatCtrl:Update(deltaTime,unscaledDeltaTime)
    if self:CheckTimeOut()==true then 
        self:Stop()
        self:TimerClean()
        --[[_G_Dispatcher:AddPropertyEvent(GameStatic.RE_CONNECT_SERVER_SUCESS,HeartbeatCtrl.ReConnectServerSucess,self)
        PreloadTip.instance:ShowStayTips("连接中断，正在尝试重新连接...");--]]
        Network.ConnectFailed()  
        -- local data = {}
        -- data.text = "断开连接，是否重新连接游戏？"
        -- data.callback = function() Game.EnterGame() end
        -- CommonPopup(data)
    end
end

function HeartbeatCtrl:ReConnectServerSucess()
    PreloadTip.instance:Reset()
    _G_CtrlManager.ins.login:SendEnterGame()
    self:Start()
    _G_Dispatcher:RemvoePropertyEvent(GameStatic.RE_CONNECT_SERVER_SUCESS,HeartbeatCtrl.ReConnectServerSucess,self)

end

function HeartbeatCtrl:Stop()
    self:TimerClean()
    FixedUpdateBeat:Remove(self.Update, self)
end

function HeartbeatCtrl:HeartbeatCallBack(eventType,dispatch)
    self.receiveCount=self.receiveCount+1
    self.lastReceiveTime=os.time()
    self.lastDelayTime = self.lastReceiveTime - self.lastSendTime;

    local serverTime=dispatch.now
    _G_TimerManager:SetServerTime(serverTime)
end

--获取上一次的延时信息
function HeartbeatCtrl:GetLastDelayTime()
    if self.sendCount == self.receiveCount then
        return self.lastDelayTime;
    end

    local currentDelayTime = os.time() - self.lastSendTime;
    if currentDelayTime < self.lastDelayTime then 
        return self.lastDelayTime;
    end
    
    return currentDelayTime;
end

function HeartbeatCtrl:Heartbeat()
    self.sendCount=self.sendCount+1
    self.lastSendTime=os.time()
    
    local id = rpc_info.rpc_dict.keepAlive
    local data = {}
    Network.SendMessage(id,data)
end

function HeartbeatCtrl:CheckTimeOut()
    -- print(self:GetLastDelayTime(),self.sendCount,self.receiveCount)
    -- if not self.test then 
    --     self.test=true
    --     return true
    -- end
    return self:GetLastDelayTime() > HeartbeatCtrl.MAX_DELAY_TIME
end

function HeartbeatCtrl:TimerClean()
    if self.timer then 
        self.timer:Stop();
        self.timer=nil
    end
end

function HeartbeatCtrl:Dispose()
    self:RemoveSocket()
    self:RemoveEvent()
    self:TimerClean()
end

return HeartbeatCtrl