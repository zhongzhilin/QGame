local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionShareBRCell  = class("UIUnionShareBRCell", function() return cc.TableViewCell:create() end )
local UIUnionShareBRItem = require("game.UI.union.list.UIUnionShareBRItem")

function UIUnionShareBRCell:ctor()
    self:CreateUI()
end

function UIUnionShareBRCell:CreateUI()

    self.item = UIUnionShareBRItem.new() 
    self:addChild(self.item)
end

function UIUnionShareBRCell:onClick()
	-- 查看战报 
    local reportId = self.data.szParam

    global.chatApi:getBattleInfo( reportId ,function(msg)
        msg.tagMail = msg.tagMail or {}
        local panel = global.panelMgr:openPanel("UIMailBattlePanel")
        panel:setData(msg.tagMail)
    end)
end

function UIUnionShareBRCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionShareBRCell:updateUI()
    self.item:setData(self.data)
end

return UIUnionShareBRCell