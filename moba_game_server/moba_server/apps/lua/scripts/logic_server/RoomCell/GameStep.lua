local Room 			= class('Room')
local Stype 		= require("Stype")
local Cmd 			= require("Cmd")
local RoomConfig 	= require('logic_server/RoomCell/RoomConfig')

local LOGIC_FRAME_TIME = 66 -- 逻辑帧的时间间隔  1 ~ 15FPS

function Room:step_start_game()
	print('hcc>>step_start_game...')

	-- 5秒以后 开始第一个帧事件, 1000 --> 20 FPS ---> 50
	self.frameid = 1
	self.match_frames = {} -- 保存的是游戏开始依赖所有的帧操作;
	self.next_frame_opt = {frameid = self.frameid, opts = {}} -- 当前的帧玩家操作;

	self.frame_timer = Scheduler.schedule(function() 
		self:on_logic_frame()
	end, 1000, -1, LOGIC_FRAME_TIME)
	-- end
end

function Room:step_end_game()
	print('hcc>>step_end_game...')
	if self.frame_timer then
		Scheduler.cancel(self.frame_timer)
		self.frame_timer = nil
	end
end

function Room:on_logic_frame()
	print('hcc>>on_logic_frame....')
	table.insert(self.match_frames, self.next_frame_opt)
	local players = self:get_room_players()
	for i = 1, #players do 
		local player = players[i]
		if player then
			self:send_unsync_frames(player)
		end 
	end
	self.frameid = self.frameid + 1
	self.next_frame_opt = {frameid = self.frameid, opts = {}}
end

function Room:send_unsync_frames(player)
	local opt_frams = {}
	print("hcc>> send_unsync_frames...", player:get_sync_frameid(), #self.match_frames)

	for i = (player:get_sync_frameid() + 1), #self.match_frames do 
		table.insert(opt_frams, self.match_frames[i])
	end
	-- local body = { frameid = self.frameid, unsync_frames = opt_frams}
	local body = {frameid = self.frameid}
	player:udp_send_cmd(Stype.Logic, Cmd.eLogicFrame, body)
end

return Room