

local MainScene = class("MainScene", cc.load("mvc").ViewBase)

local ByteArray         = require("game.utils.ByteArray")
local NetEngine         = require("game.net.NetEngineNew")
local ProtoMan          = require("game.utils.ProtoMan")
local cmd_name_map      = require("game.net.cmd_name_map")

local tmpStr = ''
function MainScene:onCreate()

     self._lb = cc.Label:createWithSystemFont("Hello World", "Arial", 25)
     self._lb:move(display.cx + 200, display.cy)
     self._lb:addTo(self)

    self._net = NetEngine:getInstance()
    self._net:start()
    local func = function (args)
        local maxsize = 65536
        local maxsize = 4096
        local msg = 'a'
        for i = 1 , maxsize do
            msg = msg .. 'c'
        end
        msg = 'cocos,hello,hcc!!!!'
        
        local LoginReq = {      
            name    = msg,
            age     = 25,  
            email   = '827773271@qq.com',
            int_set = 1000,
        }
        
        self._net:sendMsg(1,1,LoginReq)
    end

     --local scheduler = require("game.utils.scheduler")
     --scheduler.performWithDelayGlobal(func, 1)
    ccui.Button:create("img_btn.png"):move(display.cy,display.cy):addTo(self):addClickEventListener(function(send,eventType)
        func()
    end)

    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)

    -- self:testProtoBuf()
    --self:testByteArray()
    -- local test = ''
    -- assert(test , 'test must be not nil')
end

function MainScene:onEventData(event)
    local data = event._usedata
    dump(data)
    local bd = nil
    if data.body then
        dump(data.body)
        if self._lb then
            local _str = data.body.name
            tmpStr = tmpStr .. tostring(_str) .. '\n'
            self._lb:setString(tmpStr)
        end
    end
end

function MainScene:testProtoBuf()
    local pbFilePath = cc.FileUtils:getInstance():fullPathForFilename("game.pb")
    print("PB file path: "..pbFilePath)
    
    local buffer = read_protobuf_file_c(pbFilePath)
    protobuf.register(buffer) --注:protobuf 是因为在protobuf.lua里面使用module(protobuf)来修改全局名字
    
    local stringbuffer = protobuf.encode("LoginReq",      
        {      
            name    = "hcc",     
            age     = 25,   
            email   = '827773271@qq.com',
            int_set = 0,
        })           
    
    
    local slen = string.len(stringbuffer)
    print("slen = "..slen)
    
    local temp = ""
    for i = 1, slen do
        temp = temp .. string.format("0xX, ", string.byte(stringbuffer, i))
    end
    print(temp)
    local result = protobuf.decode("LoginReq", stringbuffer)
    print("result name: "..result.name)
    print("result age: "..result.age)
    print("result email: "..result.email)
    print("result int_set: "..result.int_set)
end

function MainScene:testByteArray()
    local _string = 'hccfuckyou'
    local c_byte = ByteArray.new(ByteArray.ENDIAN_LITTLE)    --小尾
    c_byte:writeStringBytes(_string)
    c_byte:setPos(1)
    local content_len = c_byte:getLen()
    local avlen = c_byte:getAvailable()
    print('len_1:---> ' .. content_len .. '   av: ' .. avlen)
       
    c_byte:setPos(3)
    local content_len = c_byte:getLen()
    local avlen = c_byte:getAvailable()
    print('len_1:---> ' .. content_len .. '   av: ' .. avlen)

    local tmpstr = c_byte:toString()
    local bytes = c_byte:getBytes()
    print('bytesstr: ' .. bytes)

    print('str:---> ' .. tmpStr) 

end

return MainScene
