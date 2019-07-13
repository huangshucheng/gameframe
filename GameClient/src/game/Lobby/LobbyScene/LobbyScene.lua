local LobbyScene    = class("LobbyScene")

local UserInfo              = require("game.clientdata.UserInfo")
local RoomData              = require("game.clientdata.RoomData")
local LogicServiceProxy     = require("game.modules.LogicServiceProxy")
local SystemServiceProxy    = require("game.modules.SystemServiceProxy")
local Function              = require('game.Base.Function')

LobbyScene.RESOURCE_FILENAME = 'Lobby/LobbyScene.csb'

function LobbyScene.getAllFunction(class,meathon)
    meathon = meathon or {}
    if class.super ~= nil then
        meathon = LobbyScene.getAllFunction(class.super,meathon)
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

function LobbyScene:setMetaTable()
    local scriptPath = {}
    table.insert(scriptPath,"game.Lobby.LobbyScene.LobbySceneDefine")
    table.insert(scriptPath,"game.Lobby.LobbyScene.LobbySceneShowUI")
    table.insert(scriptPath,"game.Lobby.LobbyScene.LobbySceneUI")
    table.insert(scriptPath,"game.Lobby.LobbyScene.LobbySceneInit")
    table.insert(scriptPath,"game.Lobby.LobbyScene.LobbySceneTouchEvent")
    table.insert(scriptPath,"game.Lobby.LobbyScene.LobbySceneReceiveNetMsg")
    table.insert(scriptPath,"game.Lobby.LobbyScene.LobbySceneReceiveMsg")
    local tmpmetatable = {}
    for i,v in ipairs(scriptPath) do
        local script = require(v)
        local object = script.new()
        local objectemetatable = getmetatable(object)
        for scripti,scriptv in pairs(objectemetatable) do
            tmpmetatable[scripti] = scriptv
        end
    end
    local metatable = LobbyScene.getAllFunction(self)
    for i,v in pairs(metatable) do
        tmpmetatable[i] = v
    end
    setmetatable(self, {__index = tmpmetatable}) 
    -- dump(tmpmetatable,'hcc>>LobbyScene>>tmpmetatable')
end

function LobbyScene:ctor()
    self._rootNode = nil
    self._lobbyScene = nil
end

function LobbyScene:run()
    self:setMetaTable()
    self._lobbyScene = display.newScene("LobbyScene")
    self._lobbyScene:enableNodeEvents()

    self._rootNode = cc.CSLoader:createNode(LobbyScene.RESOURCE_FILENAME)
    assert(self._rootNode, string.format("LobbyScene:run() - load resouce node from file \"%s\" failed", LobbyScene.RESOURCE_FILENAME))
    self._rootNode:setContentSize(display.size)
    ccui.Helper:doLayout(self._rootNode)
    self._lobbyScene:addChild(self._rootNode)

    display.runScene(self._lobbyScene)
    self._lobbyScene.onEnter = handler(self,self.onEnter)
    self._lobbyScene.onExit = handler(self,self.onExit)
    self:init()
end

function LobbyScene:init()
    self:initUI()
    self:initUITouchEvent()
    self:initNetEventListener()
    self:initClientEventListener()
end

function LobbyScene:onEnter()
    print('LobbyScene:onEnter')
    Lobby.showPopLayer = Function.showPopLayer
    --获取用户信息
    SystemServiceProxy:getInstance():sendGetUgameInfo()
    LogicServiceProxy:getInstance():sendGetCreateStatus()
    RoomData:getInstance():reset()
end

function LobbyScene:onExit()
    print('LobbyScene:onExit')
    -- removeEvent('HeartBeatRes')
end

return LobbyScene
