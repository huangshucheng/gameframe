local Room 			= class('Room')
local Stype 		= require("Stype")
local Cmd 			= require("Cmd")
local RoomConfig 	= require('logic_server/RoomCell/RoomConfig')

-- frame sync script

local LOGIC_FRAME_TIME = 66 -- 逻辑帧的时间间隔  1 ~ 15FPS   
-- local LOGIC_FRAME_TIME = 66 -- 逻辑帧的时间间隔  1 ~ 15FPS   
-- local LOGIC_FRAME_TIME = 500 -- 逻辑帧的时间间隔  1 ~ 15FPS   
-- server:66毫秒发送一次，1秒发送15次 ,client:1秒刷新60次

function Room:step_start_game()
	print('hcc>>step_start_game...')
	-- 5秒以后 开始第一个帧事件, 1000 --> 20 FPS ---> 50
	self.frameid = 1
	self.match_frames = {} -- 保存的是游戏开始依赖所有的帧操作;
	self.next_frame_opt = {frameid = self.frameid, opts = {}} -- 当前的帧玩家操作;

	self.frame_timer = Scheduler.schedule(function() 
		self:on_logic_frame()
	end, 100, -1, LOGIC_FRAME_TIME)
end

function Room:step_end_game()
	if self.frame_timer then
		Scheduler.cancel(self.frame_timer)
		self.frame_timer = nil
	end
end

function Room:on_logic_frame()
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
	print('\n\n')
end

function Room:send_unsync_frames(player)
	local opt_frams = {}
	local unsyc_frame_size = #self.match_frames - player:get_sync_frameid() - 1
	print("SvrSend>>seatid: " .. player:get_seat_id() ..  " ,sync_id: " .. tostring(player:get_sync_frameid()) .. ' ,total: ' .. tostring(#self.match_frames) .. ' ,unsync: ' .. tostring(unsyc_frame_size))

	for i = (player:get_sync_frameid() + 1), #self.match_frames do --未同步帧
		table.insert(opt_frams, self.match_frames[i])
	end
	local body = { frameid = self.frameid, unsync_frames = opt_frams}
	player:udp_send_cmd(Stype.Logic, Cmd.eLogicFrame, body) --发送未同步的帧
end

function Room:on_next_frame_event(next_frame_opts)
	local seatid = next_frame_opts.seatid
	print('OnClint>>seatid: ' .. seatid .. ' ,nextfid: ' .. next_frame_opts.frameid .. ' ,curfid: ' .. self.frameid .. ' ,nextFsize: ' .. #next_frame_opts.opts)

	local player = self:get_player_by_seat_id(seatid)
	if not player then 
		return
	end
	-- 当前客户端已经同步了哪个
	if player:get_sync_frameid() < next_frame_opts.frameid - 1 then
		player:set_sync_frameid(next_frame_opts.frameid - 1)
	end

	if (next_frame_opts.frameid ~= self.frameid) then -- 帧事件直接丢弃
		return
	end
	for i = 1, #next_frame_opts.opts do 
		table.insert(self.next_frame_opt.opts, next_frame_opts.opts[i])
	end
end

return Room