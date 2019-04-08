local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UISetLanguageCell  = class("UISetLanguageCell", function() return cc.TableViewCell:create() end )
local UILanguageItem = require("game.UI.set.UILanguageItem")

function UISetLanguageCell:ctor()
    self:CreateUI()
end

function UISetLanguageCell:CreateUI()

    self.item = UILanguageItem.new() 
    self:addChild(self.item)
end

function UISetLanguageCell:onClick()
    local panel = global.panelMgr:openPanel("UIPromptPanel")                
    panel:setData("LanguageSwitch", function()
		global.panelMgr:getPanel("UISetLanguagePanel"):refersh(self.data.id)
		global.languageData:setCurrentLanguage(self.data.symbol)
		global.funcGame.RestartGame()
    end)
end

function UISetLanguageCell:setData(data)
    self.data = data
    self:updateUI()
end

function UISetLanguageCell:updateUI()
    self.item:setData(self.data)
end

return UISetLanguageCell