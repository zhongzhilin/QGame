local global = global
local resMgr = global.resMgr
local scMgr = global.scMgr
local panelMgr = global.panelMgr
local gameEvent = global.gameEvent
local gevent = gevent

local _M = {}
_M = class("TestDemoPanel", function() return gdisplay.newWidget() end )

local createItem = function(text, callBack)
    cc.MenuItemFont:setFontSize(32)
    local item = cc.MenuItemFont:create(text)
    item:setColor(cc.c3b(255, 255, 255))
    item:setEnabled(true)
    item:registerScriptTapHandler(callBack)

    return item
end

local createInput = function(text, fontSize)
    local editBoxSize = { width = 200, height = 40 }
    local textEdit = ccui.EditBox:create(editBoxSize, "Dbg_green_edit.png")
    textEdit:setFontName("Arial")
    textEdit:setText(text)
    textEdit:setFontSize(fontSize)
    textEdit:setFontColor(cc.c3b(255,0,0))
    textEdit:setPlaceHolder(defstr)
    textEdit:setPlaceholderFontColor(cc.c3b(255,255,255))
    textEdit:setMaxLength(32)
    textEdit:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    return textEdit
end

function _M:ctor()    

    local textEdit = createInput("10011", 23)
    textEdit:setPosition(gdisplay.size.width / 2, gdisplay.size.height / 2 + 10)
    self:addChild(textEdit)

    local svrEdit = createInput("10.1.161.81", 23)
    svrEdit:setPosition(gdisplay.size.width / 2, gdisplay.size.height / 2 + 60)
    self:addChild(svrEdit)

    local menu = cc.Menu:create()
    self:addChild(menu)
    menu:setPosition(0, 0)
    menu:setAnchorPoint(0, 0)

    self.battleScene = nil
    local item = createItem("单机", function()
        log.debug("==============> 单机")
        if self.battleScene == nil then
            local stageIdStr = textEdit:getText()
            local stageId = tonumber(stageIdStr)
            local scene = scMgr:gotoBattleScene()
            scene:RunBattle(true, stageId)
            self.battleScene = scene
        end
    end)
    menu:addChild(item)
    item:setPosition(gdisplay.size.width / 2 - 40, gdisplay.size.height / 2 - 40)

    local item = createItem("联机", function()
        log.debug("==============> 联机")
        if self.battleScene == nil then
            local scene = scMgr:gotoBattleScene()
            scene:RunBattle()
            self.battleScene = scene
        end
    end)
    menu:addChild(item)
    item:setPosition(gdisplay.size.width / 2 + 40, gdisplay.size.height / 2 - 40)
    
end

function _M:onEnter()
    global.luaCfg:Load() 
end

function _M:onExit()
    self.battleScene = nil
end

return _M