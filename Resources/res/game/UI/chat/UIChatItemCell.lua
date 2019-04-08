local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIChatItemCell  = class("UIChatItemCell", function() return cc.TableViewCell:create() end )

function UIChatItemCell:ctor()
end

function UIChatItemCell:CreateUI()
    local itemFile = global.chatData:getChatItem(self.data.itemType)
    self.item = require("game.UI.chat.item."..itemFile).new() 
    self:addChild(self.item)

end

function UIChatItemCell:onClick()
end

function UIChatItemCell:setData(data)
    self.data = data

    if not self.item  then
        self:CreateUI()
    elseif self.item and (data.itemType ~= self.item.data.itemType) then
        --res类型不同则删除重新来过
        self.item:removeFromParent()
        self:CreateUI()
    end
    self:updateUI()
end

function UIChatItemCell:updateUI()
    self.item:setData(self.data)
end


return UIChatItemCell