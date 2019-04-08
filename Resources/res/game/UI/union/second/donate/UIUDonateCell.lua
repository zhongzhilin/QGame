local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUDonateCell  = class("UIUDonateCell", function() return cc.TableViewCell:create() end )

function UIUDonateCell:ctor()
end

function UIUDonateCell:CreateUI()

    self.item = require("game.UI.union.second.donate."..self.data.uiData.file).new() 
    self:addChild(self.item)
end

function UIUDonateCell:onClick()
    if self.data.isChild then
        --子节点不能点击，只能点击按钮
    else
        self:switch()
    end
end

function UIUDonateCell:setData(data)
    self.data = data
    if not self.item  then
        self:CreateUI()
    elseif self.item and (data.uiData.file ~= self.item.__cname) then
        --res类型不同则删除重新来过
        self.item:removeFromParent()
        self:CreateUI()
    end
    self:updateUI()
end

function UIUDonateCell:updateUI()
    self.item:setData(self.data)
end

function UIUDonateCell:switch()
    local panel = global.panelMgr:getPanel("UIUDonatePanel")
    if self.data.uiData.showChildren then
        panel:switchOff(self.data.id)
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Close")
    else
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Open")
        panel:switchOn(self.data.id)
    end
end

return UIUDonateCell