local global = global
local resMgr = global.resMgr
local scMgr = global.scMgr
local panelMgr = global.panelMgr
local gameEvent = global.gameEvent
local gevent = gevent

local _M = {}
_M = class("TestMemPanel", function() return gdisplay.newWidget() end )

local createItem = function(text, callBack)
    cc.MenuItemFont:setFontSize(32)
    local item = cc.MenuItemFont:create(text)
    item:setColor(cc.c3b(255, 255, 255))
    item:setEnabled(true)
    item:registerScriptTapHandler(callBack)

    return item
end

function _M:ctor()   

    local menu = cc.Menu:create()
    self:addChild(menu)
    menu:setPosition(cc.p(0, 0))
    menu:setAnchorPoint(cc.p(0, 0))

    local item = createItem("单机", function()

    end)
    menu:addChild(item)
    item:setPosition(cc.p(gdisplay.size.width / 2 - 40, gdisplay.size.height / 2 - 40))

    local item = createItem("联机", function()

    end)
    menu:addChild(item)
    item:setPosition(cc.p(gdisplay.size.width / 2 + 40, gdisplay.size.height / 2 - 40))

    local allItemsCfg = {
        {   
            text = "创建Texture2D", 
            func = function(sender)
                if self.allTexs == nil then
                    self.allTexs = {}
                    for i=1,900 do
                        local tex = cc.Texture2D:new()
                        tex:initWithString("arial", string.format("this is a test, index is %d", i), 30)
                        self.allTexs[i] = tex
                    end
                end
            end
        },
        {   
            text = "销毁Texture2D", 
            func = function(sender)
                if self.allTexs ~= nil then
                    for i=1,#self.allTexs do
                        local tex = self.allTexs[i]
                        printf("==========> tex index %d rc %d", i, tex:retainCount())
                        tex:release()
                    end
                    self.allTexs = nil
                end
            end
        },
        {   
            text = "创建Label", 
            func = function(sender)
                if self.allLabels == nil then
                    self.allLabels = {}
                    for i=1,900 do
                        local label = cc.Label:createSpriteForSystemFont("arial", string.format("this is a test, index is %d", i), 30)
                        label:retain()
                        self.allLabels[i] = label
                    end
                end
            end
        },
        {   
            text = "销毁Label", 
            func = function(sender)
                if self.allLabels ~= nil then
                    for i=1,#self.allLabels do
                        local label = self.allLabels[i]
                        printf("==========> label index %d rc %d", i, tex:retainCount())
                        label:release()
                    end
                    self.allLabels = nil
                end
            end
        },
        {   
            text = "Tex创建Label", 
            func = function(sender)
                if self.allTexLabels == nil then
                    self.allTexLabels = {}
                    for i=1,900 do
                        local label = cc.Label:createSpriteForSystemFont("arial", string.format("this is a test, index is %d", i), 30)
                        label:retain()
                        self.allTexLabels[i] = label
                    end
                end
            end
        },
        {   
            text = "Tex销毁Label", 
            func = function(sender)
                if self.allTexLabels ~= nil then
                    for i=1,#self.allTexLabels do
                        local label = self.allTexLabels[i]
                        printf("==========> label index %d rc %d", i, tex:retainCount())
                        label:release()
                    end
                    self.allTexLabels = nil
                end
            end
        },
    }

    for k,v in pairs(allItemsCfg) do
        local item = createItem(v.text, v.func)
        menu:addChild(item)
        item:setPosition(cc.p(gdisplay.size.width / 2, gdisplay.size.height * 0.8 - 50 * k))
    end
end

function _M:onEnter()

end

function _M:onExit()
    
end

return _M