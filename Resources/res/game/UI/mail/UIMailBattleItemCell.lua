local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local panelMgr = global.panelMgr
local UIMailTableView = require("game.UI.mail.UIMailTableView")
local UIMailBattleItemCell  = class("UIMailBattleItemCell", function() return cc.TableViewCell:create() end )
local UIBagItem = require("game.UI.bag.UIBagItem")
local UIBagUseBoard = require("game.UI.bag.UIBagUseBoard")

function UIMailBattleItemCell:ctor()
    
    self:CreateUI()
end

function UIMailBattleItemCell:CreateUI()

    self.item = UIBagItem.new()    
    self:addChild(self.item)
end

function UIMailBattleItemCell:onClick()
    
    self.isShowUse = not self.isShowUse

    local bagPanel = panelMgr:getPanel("UIBagPanel")

    bagPanel:showUse(self.data.sort,not self.isShowUse)

    local useBoard = UIBagUseBoard:getInstance()

    local y = useBoard:convertToWorldSpace(cc.p(0,0)).y
    if y < 0 then

        local off = bagPanel.tableView:getContentOffset()
        off.y = off.y - y
        bagPanel.tableView:setContentOffset(off, true)
    end
end

function UIMailBattleItemCell:setData(data)

    self.data = data
    self:updateUI()

    self.isShowUse = (UIBagTableView:getChooseSort() == self.data.sort)

    if self.isShowUse then
        self.item:showUse()
    else
        self.item:hideUse()
    end
end

function UIMailBattleItemCell:updateUI()
    self.item:setData(self.data)
end

function UIMailBattleItemCell:getData()
	
	return self.data
end

return UIMailBattleItemCell