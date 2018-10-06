local MainScene = class("MainScene", cc.load("mvc").ViewBase)

local ByteArray         = require("game.utils.ByteArray")
local NetWork           = require("game.net.NetWork")
local ProtoMan          = require("game.utils.ProtoMan")
local cmd_name_map      = require("game.net.cmd_name_map")
local cmd_opcode_map    = require("game.net.cmd_opcode_map")

local resFileName       = 'MainScene.csb'
local sendString        = "hccteststring!!"

function MainScene:onCreate()

     -- self._lb = cc.Label:createWithSystemFont("Hello World", "Arial", 25)
     -- self._lb:move(display.cx + 200, display.cy)
     -- self._lb:addTo(self)

    self._net = NetWork:getInstance()
    self._net:start()

     --local scheduler = require("game.utils.scheduler")
     --scheduler.performWithDelayGlobal(func, 1)
    -- ccui.Button:create("img_btn.png"):move(display.cy,display.cy):addTo(self):addClickEventListener(function(send,eventType)
    -- end)

    self.m_rootNode = cc.CSLoader:createNode(resFileName)
    self.m_rootNode:setContentSize(display.size)
    ccui.Helper:doLayout(self.m_rootNode)
    self:addChild(self.m_rootNode)

    local btn_enter = self.m_rootNode:getChildByName('btn_enter_room')
    local btn_exit = self.m_rootNode:getChildByName('btn_exit_room')
    local btn_send = self.m_rootNode:getChildByName('btn_send')
    self.list_view = self.m_rootNode:getChildByName('list_view')
    self.list_item = self.m_rootNode:getChildByName('panel_item')
    if btn_enter then
        btn_enter:addClickEventListener(handler(self,self.onBtnEventEnterTalkRoom))
    end
    if btn_exit then
        btn_exit:addClickEventListener(handler(self,self.onBtnEventExitTalkRoom))
    end
    if btn_send then
        btn_send:addClickEventListener(handler(self,self.onBtnEventSendMessage))
    end

    addEvent(ServerEvents.ON_SERVER_EVENT_DATA, self, self.onEventData)
end

function MainScene:onEventData(event)
    local data = event._usedata
    if not data then
        return
    end
    dump(data)
    if data.ctype == cmd_opcode_map.LoginRes then
        self:on_login_return(data.body)
    elseif data.ctype == cmd_opcode_map.ExitRes then
        self:on_exit_return(data.body)
    elseif data.ctype == cmd_opcode_map.SendMsgRes then
        self:on_send_msg_return(data.body)
    elseif data.ctype == cmd_opcode_map.OnUserLogin then
        self:on_other_user_enter(data.body)
    elseif data.ctype == cmd_opcode_map.OnUserExit then
        self:on_other_user_exit(data.body)
    elseif data.ctype == cmd_opcode_map.OnSendMsg then
        self:on_other_user_send_msg(data.body)
    end
end

function MainScene:on_login_return(data)
    print('MainScene:on_login_return')
    if data.status == 1 then
        self:add_status_option("enter talkroom success !")
    elseif data.status == -1 then
        self:add_status_option("already in then talkroom !")
    end
end

function MainScene:on_exit_return(data)
    print('MainScene:on_exit_return')
    if data.status == 1 then
        self:add_status_option("exit talkroom success !")
    elseif  data.status == -1 then
        self:add_status_option("you are not in the talkroom !")
    end
end

function MainScene:on_send_msg_return(data)
    print(' MainScene:on_send_msg_return')
    if data.status == 1 then
       self:add_status_option(sendString) 
    elseif data.status == -1 then
        self:add_status_option("send failed,you are not in the talkroom !")
    end
end

function MainScene:on_other_user_enter(data)
    print('MainScene:on_other_user_enter')
    self:add_status_option(tostring(data.ip) .. ': ' .. tostring(data.port) .. '  enter talkroom!')
end

function MainScene:on_other_user_exit(data)
    print('MainScene:on_other_user_exit')

    self:add_status_option(tostring(data.ip) .. ': ' .. tostring(data.port) .. '  exit talkroom!')
end

function MainScene:on_other_user_send_msg(data)
    print('MainScene:on_other_user_send_msg')
    self:add_status_option(tostring(data.ip) .. ': ' .. tostring(data.port) .. ' say: ' .. tostring(data.content))
end

function MainScene:onBtnEventEnterTalkRoom(sender,eventType)
    self._net:sendMsg(1,cmd_opcode_map.LoginReq,nil)
end

function MainScene:onBtnEventExitTalkRoom(sender,eventType)
    self._net:sendMsg(1,cmd_opcode_map.ExitReq,nil)
end

function MainScene:onBtnEventSendMessage(sender,eventType)
    self._net:sendMsg(1,cmd_opcode_map.SendMsgReq,{content = sendString})
end

function MainScene:add_status_option(string)
    if self.list_view and self.list_item then
        local item = self.list_item:clone()
        item:getChildByName('text_item'):setString(tostring(string))
        self.list_view:pushBackCustomItem(item)
        self.list_view:jumpToBottom()
    end
end

return MainScene
