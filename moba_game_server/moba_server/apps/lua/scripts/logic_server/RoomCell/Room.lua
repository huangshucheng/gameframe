local Room = class("Room")

function Room:ctor()
	self:setMetaTable()
	self:init()
end

function Room.getAllFunction(class,meathon)
    meathon = meathon or {}
    if class.super ~= nil then
        meathon = Room.getAllFunction(class.super,meathon)
    end

    local metatable = getmetatable(class)
    if metatable == nil then
        metatable = class
    end
    for i,v in pairs(metatable) do
        meathon[i] = v
    end
    return meathon
end

function Room:setMetaTable()
    local scriptPath = {}
    local path = 'logic_server/RoomCell'
    table.insert(scriptPath, path .. "/RoomData")
    table.insert(scriptPath, path .. "/RoomLogic")
    table.insert(scriptPath, path .. "/RoomSendMsg")
    table.insert(scriptPath, path .. "/RoomInterFace")
    table.insert(scriptPath, path .. "/RoomRecvMsgBase")
    table.insert(scriptPath, path .. "/RoomRecvMsg")

    local tmpmetatable = {}
    for i,v in ipairs(scriptPath) do
        local script = require(v)
        local object = script.new()
        local objectemetatable = getmetatable(object)
        for scripti,scriptv in pairs(objectemetatable) do
            tmpmetatable[scripti] = scriptv
        end
    end
    local metatable = Room.getAllFunction(self)
    for i,v in pairs(metatable) do
        tmpmetatable[i] = v
    end
    setmetatable(self, {__index = tmpmetatable}) 
end

function Room:init()
	if self.init_data then
		self:init_data()
	end
	-- set room instance
	local GameLogic = require('logic_server/GameLogic/GameLogic')
	if GameLogic then
		self._game_logic = GameLogic.new()
		if self._game_logic then
			if self._game_logic.set_room then
				self._game_logic:set_room(self)
			end
		end
	end
end

return Room