local EventProtocol = require("framework.cc.components.behavior.EventProtocol")
local SocketTCP = require("framework.cc.net.SocketTCP")
local MsgProtocol = require("net.MsgProtocol")
local NetEngine = class("NetEngine", EventProtocol)
local socket = require "socket"
-- cc.utils.init = require("framework.cc.utils.init")

local ByteArray = require("framework.cc.utils.ByteArray")

local PRINT_DEBUG = true

NetEngine.MSG_SEND = "MSG_SEND"
NetEngine.MSG_RECEIVE = "MSG_RECEIVE"

function NetEngine:ctor()
    NetEngine.super.ctor(self)
    print("---------------netEngine初始化-------------------")
    -- self.ip = "192.168.60.225" -- 内网
    self.ip = IP -- 内网
    -- self.ip = "192.168.60.223"
    self.port = PORT
    self.key="123456"
    self.isEncrypt=false
    print("[debug:]==>this")

    print("[debug:] self.ip ==> ",self.ip)
    print("[debug:] self.port ==> ",self.port)

    self.socket = SocketTCP.new(self.ip,self.port,true)
    self.socket:setReconnTime(0)
    self:addEventLIstenner()

    self.lastDealStr=""
end

function NetEngine:onConnect(stats)
    self:showNetDebug("---------------netEngine 连接成功-------------------")
    self:dispatchEvent({name="NET_ONCONNECT", stats=stats})
    self.mLastRecvHeartbeat=os.time()
    -- self:handleHeart()
end

function NetEngine:onConnectFail()
    self:showNetDebug("---------------netEngine 连接失败-------------------")
    self:dispatchEvent({name="NET_ONCONNECT_FAIL"})
end

function NetEngine:start()
   self.mLastRecvHeartbeat=os.time()
   self.socket:connect()
end

function NetEngine:reConnect()
    self.socket = SocketTCP.new(self.ip,self.port,false)
    self.socket:connect()
    self.mLastRecvHeartbeat=os.time()
end

function NetEngine:addEventLIstenner()
    if self.socket then
        self.socket:addEventListener(SocketTCP.EVENT_CONNECTED, handler(self, self.onConnect))
        self.socket:addEventListener(SocketTCP.EVENT_DATA, handler(self, self.onMessage))
        self.socket:addEventListener(SocketTCP.EVENT_CLOSE, handler(self, self.onClose))
        self.socket:addEventListener(SocketTCP.EVENT_CLOSED, handler(self, self.onClosed))
        self.socket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.onConnectFail))
    end
end

function NetEngine:stop()
   self.socket:disconnect()
end

function NetEngine:onClose()
    print("onClose")
    self:dispatchEvent({name="NET_ONCLOSE"})
    self:showNetDebug("---------------netEngine 中断连接-------------------")
end

function NetEngine:onClosed()
    print("onClose")
    self:dispatchEvent({name="NET_ONCLOSED"})
    self:showNetDebug("---------------netEngine 断开连接-------------------")
end

function NetEngine:isConnected()
    return self.socket.isConnected
end

function NetEngine:handleHeart()
    -- body
   local function callback(dt)
        self:sendHeartBeat()
    end
    -- 20秒发送一次
    self.connectDataSchedule = cc.Director:getInstance():getScheduler():scheduleScriptFunc(callback, 20, false)
end

-- 接收数据
function NetEngine:onMessage(event)
    if event.data == nil then
        return
    end
    local ba =ByteArray.new(ByteArray.ENDIAN_BIG)
    ba:writeBuf(event.data)
    ba:setPos(1)
--  有连包的情况，所以要读取数据长度
    if  ba:getAvailable() <= ba:getLen() then
        --todo
        self:decodeData(event)
    end
end

function NetEngine:decodeData(event)
    -- body
    if event == nil then
        return
    end
    local repData = event.data

    if  self.isEncrypt then
        local msg_byte = ByteArray.new(ByteArray.ENDIAN_BIG)
        msg_byte:writeBuf(event.data)
        msg_byte:setPos(1)
        local len = msg_byte:readInt()
        local data = msg_byte:readString(len)
        repData = crypto.decodeBase64(data)
        print(repData)
    end
    -- self.lastDealStr=""
    local str = self.lastDealStr..repData
    while true do
        local x1,x2 = string.find(str,"}{")
        if x1 == nil then
            self:receiveMsg(str)
            break
        end
        local s = string.sub(str,1,x1)
        self:receiveMsg(s)
        str = string.sub(str,x2,-1)
    end
end

function NetEngine:receiveMsg(packet)
    local t = json.decode(packet)
    if t == nil then
        print("发生断包问题，后续处理"..packet)
        self.lastDealStr = packet
        if self.lastDealStr == nil then
            self.lastDealStr = ""
        end
        return
    else
        self.lastDealStr = ""
    end
    local opcode = t.resultCode
    local data = t.content
    local content = json.decode(data)
    local eventName= ""
    eventName = MsgProtocol[opcode]

    if type(opcode) == "number" then
        if PRINT_DEBUG then
            print(data)
        end
        if eventName ~= nil then
            self:showNetDebug("---------------接收协议" .. eventName)
        else
           self:showNetDebug("---------------接收协议" .. opcode)
        end
        -- dump(t)
        if opcode == HEARTBEAT_RESULT_CODE then
            --todo
            local resultType = content.result
            if not resultType then
                print("收到消息")
                self.mLastRecvHeartbeat = os.time()
                self.delayTimeStart = socket.gettime()
                local t = {heart="0x01"}
                self:send(HEARTBEAT_FUNC_CODE, t)
            else
                local deleyTime = socket.gettime() - self.delayTimeStart
                self:dispatchEvent({name="NET_DELAY", msg=deleyTime * 1000})
                print("时间延迟 " .. (socket.gettime() - self.delayTimeStart))
            end
        end
        print("分发消息 ======= ",eventName)
        self:dispatchMsg(eventName, content, packet)
    else
        --printInfo("------------Recv Msg id : %d",opcode
    end
end

-- 发送数据
function NetEngine:send(msgtype, param)
    if type(msgtype) ~= "number" or msgtype == "" then
        printError("NetEngine:send() - invalid msg type")
        return
    end
    local data = json.encode(param)
    local content={functionCode=msgtype,content=data}
    local json = json.encode(content)
    print("[debug:] msgtype ==> ",msgtype)
    if PRINT_DEBUG then
        printInfo("==========SendMsg %s ===================", msgtype)
        print(json)
        printInfo("========================================", msgtype)
    end
    if  self.isEncrypt then
        local json=crypto.encodeBase64(json)
        self:sendMsg(json)
    else
        self:sendMsg(json)
    end
end

function NetEngine:sendMsg(packet)
    print("==========SendMsg ==================="..packet)
    -- 长度计算
    local c_byte = ByteArray.new(ByteArray.ENDIAN_BIG)
    c_byte:writeStringBytes(packet)
    c_byte:setPos(1)
    local content_len = c_byte:getAvailable()
    -- 写入数据流
    local msg_byte = ByteArray.new(ByteArray.ENDIAN_BIG)
    msg_byte:writeInt(content_len)
    msg_byte:writeStringBytes(packet)
    self.socket:send(msg_byte:getPack())
    self:dispatchEvent({name=self.MSG_SEND, data=packet})
end

function NetEngine:dispatchMsg(eventName, msg, packet)
    if eventName == nil then
        return
    end
    if PRINT_DEBUG then
        -- print(eventName)
        -- dump(msg)
    end
    self:dispatchEvent({name=eventName, msg=msg, error=0})

    -- if msg:isValidInRecord() then
    --     self:dispatchEvent({name=self.MSG_RECEIVE, data=packet})
    -- end
end

function NetEngine:showNetDebug(msg)
    --app:showTips(msg)
     print(msg)
end

function NetEngine:disconnect()
    -- body
    self.socket:disconnect()
end

function NetEngine:sendHeartBeat()
    if self.socket == nil or not self.socket.isConnected then
       cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.connectDataSchedule)
        return
    end

    if  os.time() - self.mLastRecvHeartbeat > 75 then
        print("时间大于75,关闭连接")
        self:disconnect()
        return
        --todo
    end

    if  os.time() - self.mLastRecvHeartbeat >30 then
        print("时间大于30,关闭连接")
         self:dispatchEvent({name="NET_ONNETLOWER"})
        --todo
    end

    local t = {heart="0x01"}
    self:send(HEARTBEAT_FUNC_CODE, t)
end

function NetEngine:printTable(table, prefix)
    prefix = prefix or ""
    for k,v in pairs(table) do
        if type(v) == "table" then
            printInfo("%s%s=", prefix, tostring(k))
            if not table["class"] then
                self:printTable(v, prefix.."  ")
            end
        else
            printInfo("%s%s=%s", prefix, tostring(k), tostring(v))
        end
    end
end

return NetEngine