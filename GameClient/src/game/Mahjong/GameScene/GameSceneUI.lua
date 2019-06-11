local GameScene = Game.GameScene or {}
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")
local Hero                  = require("game.Mahjong.UI.Hero")

function GameScene:getJoyStick()
	if self._joystick == nil then
		self:showJoystick()
	end
	return self._joystick
end

function GameScene:getTouchLayer()
	return self:getResourceNode():getChildByName(GameSceneDefine.KW_TOUCH_LAYER)
end

function GameScene:getHero(seatid)
	if self._hero_list[seatid] == nil then
		local touch_layer = self:getTouchLayer()
		if touch_layer then
			self._hero_list[seatid] = Hero:create()
			touch_layer:addChild(self._hero_list[seatid])
			local posX = math.random(200, 900)
			local posY = math.random(200, 600)
			print('hcc>> posX: '.. posX .. ' ,posY: ' .. posY)
			self._hero_list[seatid]:setPosition(cc.p(posX , posY))
		end
	end
	return self._hero_list[seatid]
end

function GameScene:destoryHero(seatid)
	local hero = self._hero_list[seatid]
	if hero then
		hero:destroy()
		self._hero_list[seatid] = nil
	end
end

function GameScene:showHero()
    if self._hero == nil then
        local touch_layer = self:getTouchLayer()
        if touch_layer then
            self._hero = Hero:create()
            touch_layer:addChild(self._hero)
            self._hero:setPosition(cc.p(640,320))
        end
    end
end