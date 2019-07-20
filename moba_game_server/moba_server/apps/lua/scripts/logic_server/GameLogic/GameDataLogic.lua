local GameDataLogic 			= class('GameDataLogic')

--游戏逻辑数据

local touzi_nums_table = {
	1,2,3,4,5,6,7,8,
	9,10,11,12,13,14,15,16,
	17,18,19,20,21,22,23,24,
	25,26,27,28,29,30,31,32
}

function GameDataLogic:ctor()
	----logic data
	self._touzi_nums 	= clone(touzi_nums_table)
	local randnum = math.random(1,#touzi_nums_table)
	self._bomb_nums 	= {randnum}
end

--每一盘重置
function GameDataLogic:reset_logic_data()
	self._touzi_nums 	= clone(touzi_nums_table)
	local randnum = math.random(1,#touzi_nums_table)
	self._bomb_nums 	= {randnum}
end

-----------------------------------------------------------
--logic data interface
-----------------------------------------------------------
function GameDataLogic:get_touzi_nums()
	return self._touzi_nums
end

function GameDataLogic:set_touzi_nums(nums)
	self._touzi_nums = nums
end

function GameDataLogic:get_bomb_nums()
	return self._bomb_nums
end

function GameDataLogic:set_bomb_nums(nums)
	self._bomb_nums = nums
end

return GameDataLogic