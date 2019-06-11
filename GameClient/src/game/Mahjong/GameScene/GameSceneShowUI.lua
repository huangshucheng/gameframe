local GameScene = Game.GameScene or {}

local RoomData              = require("game.clientdata.RoomData")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")
local ToolUtils             = require("game.utils.ToolUtils")
local GameFunction 			= require("game.Mahjong.Base.GameFunction")
local Player 				= require("game.clientdata.Player")
local JoyStick              = require("game.Mahjong.UI.JoyStick")
local Hero                  = require("game.Mahjong.UI.Hero")

local MAX_PLAYER_NUM = 4
local HERO_MOVE_SPEED = 200
local LOGIC_FRAME_TIME = 66
local FLOAT_SCALE = 100000000

function GameScene:showUserInfoBySeatId(seatId) --serverSeat
    local localSeat = GameFunction.serverSeatToLocal(seatId)
    local player = RoomData:getInstance():getPlayerBySeatId(seatId)
    print('hcc>> serverSeat: '.. seatId .. '  ,localseat: ' .. localSeat)
    if player then
        local seat =  GameFunction.serverSeatToLocal(player:getServerSeat())
        local infoPanel = self._panel_user_info_table[seat]
        if infoPanel then
            infoPanel:setVisible(true)
            local textName      = ccui.Helper:seekWidgetByName(infoPanel,GameSceneDefine.KW_TEXT_NAME)
            local textScore     = ccui.Helper:seekWidgetByName(infoPanel,GameSceneDefine.KW_TEXT_SCORE)
            local imgOffLine    = ccui.Helper:seekWidgetByName(infoPanel,GameSceneDefine.KW_IMG_OFFINLE)
            local imgHead       = ccui.Helper:seekWidgetByName(infoPanel,GameSceneDefine.KW_IMG_HEAD)
            if textName then
                textName:setString(player:getUNick())
            end
            if textScore then
                textScore:setString('1000')    --TODO
            end
            if imgOffLine then
                imgOffLine:setVisible(player:getIsOffline())
            end
            if imgHead then
                imgHead:loadTexture(string.format('MahScene/MahRes/rectheader/1%d.png',tonumber(player:getUFace())))
            end
        end
    else
        local infoPanel = self._panel_user_info_table[localSeat]
        if infoPanel then
            infoPanel:setVisible(false)
        end
        print('localseat: ' .. localSeat .. " false")
    end
end

function GameScene:showAllExistUserInfo()
    for serverSeat = 1 , MAX_PLAYER_NUM do
        self:showUserInfoBySeatId(serverSeat)
    end
end

function GameScene:showRoomInfo()
    local panel_top = self:getResourceNode():getChildByName(GameSceneDefine.KW_PANEL_TOP)
    if panel_top then
        local btn_room_num = panel_top:getChildByName(GameSceneDefine.KW_ROOM_NUM)
        local text_room_rule = panel_top:getChildByName(GameSceneDefine.KW_TEXT_RULE)
        if btn_room_num then
            local roomid = RoomData:getInstance():getRoomId()
            if roomid then
                btn_room_num:setString('房间号:' .. roomid)
            end
        end

        if text_room_rule then
            local roomRule = RoomData:getInstance():getRoomInfo()
            if roomRule then
                local playerNum = ToolUtils.getLuaStrValue(roomRule,"playerNum")
                local playCount = ToolUtils.getLuaStrValue(roomRule,"playCount")
                local isAAPay = ToolUtils.getLuaStrValue(roomRule,"isAAPay")
                local baseScore = ToolUtils.getLuaStrValue(roomRule,"baseScore")
                print('hcc>> rule: ' .. playerNum .. "  ," .. playCount .. " ," .. isAAPay .. ' ,' .. baseScore)

                local strRule = ''
                local payStr = ((tostring(isAAPay) == '1') and "AA支付") or "房主支付"

                strRule = strRule .. "人数:" .. tostring(playerNum) .. ","
                strRule = strRule .. "局数:" .. tostring(playCount) .. ","
                strRule = strRule .. "底分:" .. tostring(baseScore) .. ","
                strRule = strRule .. tostring(payStr)
                text_room_rule:setString(strRule)
             end 
        end
    end
end

function GameScene:showReadyBtn()
	local selfPlayer = GameFunction.getSelfPlayer()
	if not selfPlayer then
		return
	end
	
	local showFunc = function(isShow)
		local panel_btn = self:getResourceNode():getChildByName(GameSceneDefine.KW_PANEL_BOTTON_BTN)
		if panel_btn then
			local ready_btn = panel_btn:getChildByName(GameSceneDefine.KW_BTN_READY)
			if ready_btn  then
			 	ready_btn:setVisible(isShow)
			 end
		end
	end

	local state = selfPlayer:getState()
	local show = (state < Player.STATE.psReady) and true or false
	showFunc(show)
end

function GameScene:showReadyImag()
    local showFunc = function(localSeat, isShow)
        local infoPanel = self._panel_user_info_table[localSeat]
        if infoPanel then
            local ready_img = infoPanel:getChildByName(GameSceneDefine.KW_IMG_READY)
            if ready_img  then
                ready_img:setVisible(isShow)
             end
        end
    end

    for sSeat = 1 , MAX_PLAYER_NUM do
        local localSeat = GameFunction.serverSeatToLocal(sSeat)
        local player = RoomData:getInstance():getPlayerBySeatId(sSeat)
        if player then
            local isShow = player:getState() == Player.STATE.psReady
            showFunc(player:getLocalSeat(), isShow)
        else
            showFunc(localSeat, false)
        end
    end
end

function GameScene:showJoystick()
    if self._joystick == nil then
        local touch_layer = self:getTouchLayer()
        if touch_layer then
            self._joystick =  JoyStick:create()
            touch_layer:addChild(self._joystick)
        end
    end
end

function GameScene:showHeroPos(dt)
    if true then return end
    local hero = self:getHero()
    if hero then
        local joystick = self:getJoyStick()
        if joystick then
            local dir = joystick:getDir()
            local state = hero:getState()
            if dir.x == 0 and dir.y == 0 then
                if state == hero.STATE.move then
                    hero:setState(hero.STATE.idle)
                end
                return
            end

            if state == hero.STATE.idle then
                hero:setState(hero.STATE.move)
            end
            local vx = dir.x * HERO_MOVE_SPEED
            local vy = dir.y * HERO_MOVE_SPEED
            local sx = vx * dt + hero:getPositionX()
            local sy = vy * dt + hero:getPositionY()
            hero:setPosition(cc.p(sx,sy))
            local r = math.atan2(dir.y,dir.x)
            local degree = r * 180 / math.pi
            degree = 360 - degree + 90
            hero:setRotation(degree)
        end
    end
end   

function GameScene:do_joystick_event(opt)
    local dt = LOGIC_FRAME_TIME / 1000
    local seatid = opt.seatid
    local x = opt.x
    local y = opt.y
    local seatid = opt.seatid
    -- print('hcc>>dt: ' .. dt , x , y) --0.066
    -- if true then return end
    ------------
    local hero = self:getHero(seatid)
    if hero then
        local dir = cc.p(x / FLOAT_SCALE , y / FLOAT_SCALE)
        local state = hero:getState()
        if dir.x == 0 and dir.y == 0 then
            if state == hero.STATE.move then
                hero:setState(hero.STATE.idle)
            end
            return
        end

        if state == hero.STATE.idle then
            hero:setState(hero.STATE.move)
        end
        local vx = dir.x * HERO_MOVE_SPEED
        local vy = dir.y * HERO_MOVE_SPEED
        local sx = vx * dt + hero:getPositionX()
        local sy = vy * dt + hero:getPositionY()
        hero:setPosition(cc.p(sx,sy))
        local r = math.atan2(dir.y,dir.x)
        local degree = r * 180 / math.pi
        degree = 360 - degree + 90
        hero:setRotation(degree)
    end
    ------------
end

function GameScene:sync_last_joystic_event(opt)
    self:do_joystick_event(opt)
end 

function GameScene:on_handler_frame_event(unsync_frames)
    -- print('hcc<<tiem event: ' .. os.time())
    -- dump(unsync_frames,'hcc>>on_handler_frame_event',5)
    local frameid = unsync_frames.frameid
    local opts = unsync_frames.opts
    if next(opts) then
        for index = 1 , #opts do
            local _opt = opts[index]
            local opt_type = _opt.opt_type
            if opt_type == 0 then
                self:sync_last_joystic_event(_opt)
            end
        end
    end
end

function GameScene:on_sync_last_logic_frame(last_frame_opt)
    -- dump(last_frame_opt,'hcc>>on_sync_last_logic_frame',5)
end