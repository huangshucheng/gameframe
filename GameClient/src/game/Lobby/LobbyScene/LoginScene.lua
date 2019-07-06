local LoginScene    = class("LoginScene")
local Function      = require('game.Base.Function')

LoginScene.RESOURCE_FILENAME = 'Lobby/LoginScene.csb'

function LoginScene:ctor()
    self._rootNode = nil
    self._loginScene = nil
end

function LoginScene.getAllFunction(class,meathon)
    meathon = meathon or {}

    if class.super ~= nil then
        meathon = LoginScene.getAllFunction(class.super,meathon)
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

function LoginScene:setMetaTable()
    local scriptPath = {}
    table.insert(scriptPath,"game.Lobby.LobbyScene.LoginSceneReceiveMsg")
    table.insert(scriptPath,"game.Lobby.LobbyScene.LoginSceneInit")
    table.insert(scriptPath,"game.Lobby.LobbyScene.LoginSceneTouchEvent")
    local tmpmetatable = {}
    for i,v in ipairs(scriptPath) do
        local script = require(v)
        local object = script.new()
        local objectemetatable = getmetatable(object)
        for scripti,scriptv in pairs(objectemetatable) do
            tmpmetatable[scripti] = scriptv
        end
    end
    local metatable = LoginScene.getAllFunction(self)
    for i,v in pairs(metatable) do
        tmpmetatable[i] = v
    end
    setmetatable(self, {__index = tmpmetatable}) 
    dump(tmpmetatable,'hcc>>LoginScene>>tmpmetatable')
end

function LoginScene:run()
    self:setMetaTable()
    self._loginScene = display.newScene("LoginScene")
    self._loginScene:enableNodeEvents()

    self._rootNode = cc.CSLoader:createNode(LoginScene.RESOURCE_FILENAME)
    assert(self._rootNode, string.format("LoginScene:run() - load resouce node from file \"%s\" failed", LoginScene.RESOURCE_FILENAME))
    self._rootNode:setContentSize(display.size)
    ccui.Helper:doLayout(self._rootNode)
    self._loginScene:addChild(self._rootNode)

    display.runScene(self._loginScene)
    self._loginScene.onEnter = handler(self,self.onEnter)
    self._loginScene.onExit = handler(self,self.onExit)
    self:init()
end

function LoginScene:init()
    self:addUITouchEvent()
    self:initUI()
    self:initNetEventListener()
    self:initClientEventListener()
end

function LoginScene:onEnter()
    print('LoginScene:onEnter')
    Lobby.showPopLayer         = Function.showPopLayer
end

function LoginScene:onExit()
    print('LoginScene:onExit')
end

return LoginScene
