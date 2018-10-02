function addEvent(eventname,target,callBack)
   local listener = cc.EventListenerCustom:create(eventname,handler(target, callBack))
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, target)
end

function postEvent(eventname,data)
    local event = cc.EventCustom:new(eventname)
    event._usedata = data
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

ServerEvents = ServerEvents or {}

ServerEvents.ON_SERVER_EVENT_DATA		    		= "on_server_event_data"
ServerEvents.ON_SERVER_EVENT_MSG_SEND  				= "on_server_event_msg_send"
ServerEvents.ON_SERVER_EVENT_NET_CONNECT 			= "on_server_event_net_connect"
ServerEvents.ON_SERVER_EVENT_NET_CONNECT_FAIL 		= "on_server_event_net_connect_fail"
ServerEvents.ON_SERVER_EVENT_NET_CLOSE  			= "on_server_event_net_close"
ServerEvents.ON_SERVER_EVENT_NET_CLOSED  			= "on_server_event_net_closed"
ServerEvents.ON_SERVER_EVENT_NET_NETLOWER  			= "on_server_event_net_netlower"


-- for use
--[[
    postEvent(GameEvents.E_GAME_INIT,leftChariId)
	addEvent(GameEvents.E_GAME_INIT, self, self.onGameReset)
]]
