local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUTaskCell  = class("UIUTaskCell", function() return cc.TableViewCell:create() end )

function UIUTaskCell:ctor()
end

function UIUTaskCell:CreateUI()

    self.item = require("game.UI.union.second.task."..self.data.uiData.file).new() 
    self:addChild(self.item)
end

function UIUTaskCell:onClick()
    if self.data.isChild then
    --子节点不能点击，只能点击按钮
    print("子节点不能点击，只能点击按钮")
    else
        self:switch()
    end
end

function UIUTaskCell:setData(data)
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

function UIUTaskCell:updateUI()
    self.item:setData(self.data)
end

function UIUTaskCell:switch()
    local panel = global.panelMgr:getPanel("UIUTaskPanel")

    if self.data.uiData.showChildren then
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Close")
        panel:switchOff(self.data.id)
            print("close")

    else
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Open")
        panel:switchOn(self.data.id)
            print("ui_Open")
        
    end
end

return UIUTaskCell