local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIDownSelectCell  = class("UIDownSelectCell", function() return cc.TableViewCell:create() end )
local UIDownSelectItem = require("game.UI.common.selectItemView.UIDownSelectItem")

function UIDownSelectCell:ctor(csbPath,delegate)
	self.m_delegate = delegate
    self:CreateUI(csbPath)
end

function UIDownSelectCell:CreateUI(csbPath)

    self.item = UIDownSelectItem.new(csbPath) 
    self:addChild(self.item)
end

function UIDownSelectCell:onClick()
	self.m_delegate:onItemSelectedHandler(self.item)
end

function UIDownSelectCell:setData(data,itemUpdateCall)
    self.data = data
    if itemUpdateCall then
    	--自定义item更新函数
        self.item.data = self.data
    	itemUpdateCall(self.data,self.item)
    else
    	self:updateUI()
    end
end

function UIDownSelectCell:updateUI()
    self.item:setData(self.data)
end

return UIDownSelectCell