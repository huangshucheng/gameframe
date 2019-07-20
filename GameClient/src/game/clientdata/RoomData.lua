--[[
	房间数据，包括房间号，规则，房间内的玩家信息
]]

local RoomData 	= class('RoomData')
local Player 	= require('game.clientdata.Player')
local UserInfo 	= require('game.clientdata.UserInfo')
local ToolUtils = require('game.utils.ToolUtils')

function RoomData:getInstance()
	if RoomData._instance == nil then
		RoomData._instance = RoomData.new()
	end
	return RoomData._instance
end

function RoomData:ctor()
	self._room_info = ''
	self._room_id 	= ''
	self._play_count = 0
	self._total_play_count = 0
	self._players 	= {}	-- seatid -> player
end

function RoomData:getChars()
	local playerNum = ToolUtils.getLuaStrValue(self._room_info,'playerNum')
	return tonumber(playerNum) or 4
end

function RoomData:setRoomInfo(room_info)
	self._room_info = room_info
end

function RoomData:getRoomInfo()
	return self._room_info
end

function RoomData:getRoomId()
	return self._room_id
end

function RoomData:setRoomId(room_id)
	self._room_id = room_id
end

function RoomData:getSelfPlayer()
	for _ , player in pairs(self._players) do
		if tonumber(player:getBrandId()) == tonumber(UserInfo.getBrandId()) then
			return player
		end
	end
end

function RoomData:createPlayerByUserInfo(user_info)
	if not next(user_info) then return end
	local seatid = tonumber(user_info.seatid)
	if seatid then
		local player = Player:create()
		player:setUInfo(user_info)
		self._players[seatid] = player
	end
end

function RoomData:updatePlayerByUserInfo(user_info)
	if not next(user_info) then return end
	local seatid = tonumber(user_info.seatid)
	if seatid then
		local player = self._players[seatid]
		if player then
			player:setUInfo(user_info)
		end
	end
end

function RoomData:removePlayerBySeatId(seat_id)
	if type(seat_id) ~= 'number' then
		return
	end
	local player = self._players[seat_id]
	if player then
		player:reset()
		self._players[seat_id] = nil
	end
end

function RoomData:getPlayerBySeatId(seat_id)
	return self._players[tonumber(seat_id)]
end

function RoomData:reset()
	self._players = {}
	self._room_info = ''
	self._room_id 	= ''
end

function RoomData:setPlayCount(play_count)
	self._play_count = play_count
end

function RoomData:getPlayCount()
	return self._play_count
end

function RoomData:setTotalPlayCount(total_play_count)
	self._total_play_count = total_play_count
end

function RoomData:getTotalPlayCount()
	return self._total_play_count
end

function RoomData:getRoomPlayerCount()
	local num = 0
	for _,v in pairs(self._players) do
		num = num + 1
	end
	return num
end

return RoomData