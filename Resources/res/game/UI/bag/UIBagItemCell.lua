local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData

local panelMgr = global.panelMgr
local UIBagTableView = require("game.UI.bag.UIBagTableView")
local UIBagItemCell  = class("UIBagItemCell", function() return cc.TableViewCell:create() end )
local UIBagItem = require("game.UI.bag.UIBagItem")
local UIBagUseBoard = require("game.UI.bag.UIBagUseBoard")

function UIBagItemCell:ctor()
    
    self:CreateUI()
end

function UIBagItemCell:CreateUI()

    self.item = UIBagItem.new()    
    self:addChild(self.item)
end

function UIBagItemCell:onClick()
    
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_itemsel")
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

function UIBagItemCell:setData(data)

    self.data = data
    self:updateUI()

    self.isShowUse = (UIBagTableView:getChooseSort() == self.data.sort)

    if self.isShowUse then
        self.item:showUse()
    else
        self.item:hideUse()
    end
end

function UIBagItemCell:updateUI()
    self.item:setData(self.data)
end

function UIBagItemCell:getData()
	
	return self.data
end

return UIBagItemCell