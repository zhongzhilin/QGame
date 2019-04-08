local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUBuildCell  = class("UIUBuildCell", function() return cc.TableViewCell:create() end )

function UIUBuildCell:ctor()
end

function UIUBuildCell:CreateUI()

    self.item = require("game.UI.union.second.build."..self.data.uiData.file).new() 
    self:addChild(self.item)
end

function UIUBuildCell:onClick()


    if self.data.isChild then
        --子节点不能点击，只能点击按钮
        print("子节点不能点击，只能点击按钮")
     else
        self:switch()
    end
end

function UIUBuildCell:setData(data)
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

function UIUBuildCell:updateUI()
    self.item:setData(self.data)
end

function UIUBuildCell:getId()
    if self.data.isChild then
        return 0
    else
        return self.data.id
    end
end

function UIUBuildCell:switch()
    local panel = global.panelMgr:getPanel("UIUBuildPanel")
    if self.data.uiData.showChildren then
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Close")
        panel:switchOff(self.data.id,self)
    else
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Open")
        panel:switchOn(self.data.id,self)
    end
end

return UIUBuildCell