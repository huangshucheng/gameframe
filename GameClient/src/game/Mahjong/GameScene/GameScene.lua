local GameScene     = class("GameScene")

local Function 				= require("game.Mahjong.Base.Function")
local GameSceneDefine       = require("game.Mahjong.GameScene.GameSceneDefine")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")

GameScene.RESOURCE_FILENAME = 'MahScene/MahScene.csb'

function GameScene:ctor()
    self._gameScene     = nil
    self._rootNode      = nil
end

function GameScene.getAllFunction(class,meathon)
    meathon = meathon or {}

    if class.super ~= nil then
        meathon = GameScene.getAllFunction(class.super,meathon)
    end

    local gameScenemetatable = getmetatable(class)
    if gameScenemetatable == nil then
        gameScenemetatable = class
    end
    for i,v in pairs(gameScenemetatable) do
        meathon[i] = v
    end
    return meathon
end

function GameScene:setMetaTable()
    local scriptPath = {}
    table.insert(scriptPath,"game.Mahjong.GameScene.GameSceneReceiveMsg")
    table.insert(scriptPath,"game.Mahjong.GameScene.GameSceneReceiveGameLogicMsg")
    table.insert(scriptPath,"game.Mahjong.GameScene.GameSceneReceiveNetMsg")
    table.insert(scriptPath,"game.Mahjong.GameScene.GameSceneTouchEvent")
    table.insert(scriptPath,"game.Mahjong.GameScene.GameSceneShowUI")
    table.insert(scriptPath,"game.Mahjong.GameScene.GameSceneInit")
    table.insert(scriptPath,"game.Mahjong.GameScene.GameSceneUI")
    local tmpmetatable = {}
    for i,v in ipairs(scriptPath) do
        local script = require(v)
        local object = script.new()
        local objectemetatable = getmetatable(object)
        for scripti,scriptv in pairs(objectemetatable) do
            tmpmetatable[scripti] = scriptv
        end
    end
    local metatable = GameScene.getAllFunction(self)
    for i,v in pairs(metatable) do
        tmpmetatable[i] = v
    end
    setmetatable(self, {__index = tmpmetatable}) 
    -- dump(tmpmetatable,'hcc>>tmpmetatable')
end

function GameScene:pushScene()
    self:setMetaTable()
    self._gameScene = display.newScene("GameScene")
    self._gameScene:enableNodeEvents()

    self._rootNode = cc.CSLoader:createNode(GameScene.RESOURCE_FILENAME)
    assert(self._rootNode, string.format("GameScene:pushScene() - load resouce node from file \"%s\" failed", GameScene.RESOURCE_FILENAME))
    self._rootNode:setContentSize(display.size)
    ccui.Helper:doLayout(self._rootNode)
    self._gameScene:addChild(self._rootNode)

    cc.Director:getInstance():pushScene(self._gameScene)
    self._gameScene.onEnter = handler(self,self.onEnter)
    self._gameScene.onExit = handler(self,self.onExit)
    self:init()
end

function GameScene:init()
    self:initUI()
    self:addUITouchEvent()
    self:initNetEventListener()
    self:initClientEventListener()
    self:initLogicEventListener()
end

function GameScene:popScene()
    cc.Director:getInstance():popScene()
end

function GameScene:onEnter()
	print('GameScene onEnter')
    Game.showPopLayer         = Function.showPopLayer
    Game.popLayer             = Function.popLayer
    Game.getLayer             = Function.getLayer
    LogicServiceProxy:getInstance():sendCheckLinkGameReq()
end

function GameScene:onExit()
    print('GameScene onExit')
end

function GameScene:update(dt)

end

return GameScene