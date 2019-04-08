local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local panelMgr = global.panelMgr

local UICollectItemCell  = class("UICollectItemCell", function() return cc.TableViewCell:create() end )
local UICollectItem = require("game.UI.world.widget.UICollectItem")
local UICollectTableView = require("game.UI.world.widget.UICollectTableView")
local UICollectUseBoard = require("game.UI.world.widget.UICollectUseBoard")

function UICollectItemCell:ctor()
    self:CreateUI()
end

function UICollectItemCell:CreateUI()

    self.item = UICollectItem.new()    
    self:addChild(self.item)
end

function UICollectItemCell:onClick()
    

    self.isShowUse = not self.isShowUse

    local listPanel = panelMgr:getPanel("UICollectListPanel")
    listPanel:showUse(self.data.lID, not self.isShowUse)

    local useBoard = UICollectUseBoard:getInstance()

    local y = useBoard:convertToWorldSpace(cc.p(0,0)).y
    if y < 0 then

        local off = listPanel.tableView:getContentOffset()
        off.y = off.y - y
        listPanel.tableView:setContentOffset(off, true)
    end
    
    if self.isShowUse then 
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Open")
    else 
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Close")
    end 

end

function UICollectItemCell:setData(data)

    self.data = data
    self:updateUI()

    self.isShowUse = (UICollectTableView:getChooseSort() == self.data.lID)

    if self.isShowUse then
        self.item:showUse()
    else
        self.item:hideUse()
    end
end

function UICollectItemCell:updateUI()
    self.item:setData(self.data)
end

function UICollectItemCell:getData()
	
	return self.data
end

return UICollectItemCell