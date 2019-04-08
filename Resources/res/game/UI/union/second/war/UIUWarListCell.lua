local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUWarListCell  = class("UIUWarListCell", function() return cc.TableViewCell:create() end )

function UIUWarListCell:ctor()
end

function UIUWarListCell:CreateUI()
    self.item = require("game.UI.union.second.war."..self.data.uiData.file).new() 
    self:addChild(self.item)
end

function UIUWarListCell:onClick()
end

function UIUWarListCell:setData(data)
    self.data = data
    if self.item then
        dump(self.item.data,"item data")
        print("##### self.item.__cname="..self.item.__cname)
    end
    if not self.item  then
        self:CreateUI()
    elseif self.item and (data.uiData.file ~= self.item.__cname) then
        --res类型不同则删除重新来过
        self.item:removeFromParent()
        self:CreateUI()
    end
    self:updateUI()
end

function UIUWarListCell:updateUI()
    self.item:setData(self.data)
end

---------------------------------按钮功能回调----------------------------------------

return UIUWarListCell