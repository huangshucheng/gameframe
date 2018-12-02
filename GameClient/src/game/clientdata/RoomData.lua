--[[
	房间数据，包括房间号，规则，房间内的玩家信息
]]

local RoomData 	= class('RoomData')
local Player 	= require('game.clientdata.Player')
local UserInfo 	= require('game.clientdata.UserInfo')
local ToolUtils = require('game.utils.ToolUtils')

local MAX_PLAYER_NUM = 4

function RoomData:getInstance()
	if RoomData._instance == nil then
		RoomData._instance = RoomData.new()
	end
	return RoomData._instance
end

function RoomData:ctor()
	self._room_info = ''
	self._room_id 	= ''
	self._players 	= {}	-- seatid -> player
end

function RoomData:getChars()
	local playerNum = ToolUtils.getLuaStrValue(self._room_info,'playerNum')
	return tonumber(playerNum) or MAX_PLAYER_NUM
end

function RoomData:setRoomInfo(room_info)
	self._room_info = room_info
end

function RoomData:getRoomInfo()
	return self._room_info
end

function RoomData:getRoomId()
	if self._room_id == '' then
		for _ , player in pairs(self._players) do 
			if player then
				self._room_id = player:getRoomId()
				break
			end
		end
	end
	return self._room_id
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
	local seatid = user_info.seatid
	if seatid then
		local player = Player:create()
		player:setUInfo(user_info)
		self._players[seatid] = player
	end
end

function RoomData:updatePlayerByUserInfo(user_info)
	if not next(user_info) then return end
	local seatid = user_info.seatid
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
	return self._players[seat_id]
end

function RoomData:reset()
	self._players = {}
	self._room_info = ''
	self._room_id 	= ''
end

return RoomData