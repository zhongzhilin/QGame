local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionMemCell  = class("UIUnionMemCell", function() return cc.TableViewCell:create() end )
-- local UIUnionMemOne = require("game.UI.union.list.UIUnionMemOne")
-- local UIUnionMemSecA = require("game.UI.union.list.UIUnionMemSecA")
-- local UIUnionMemSecB = require("game.UI.union.list.UIUnionMemSecB")
-- local UIUnionMemSecC = require("game.UI.union.list.UIUnionMemSecC")

function UIUnionMemCell:ctor()
end

function UIUnionMemCell:CreateUI()
    self.item = require("game.UI.union.list."..self.data.uiData.file).new() 
    self:addChild(self.item)
end

function UIUnionMemCell:onClick()
	log.debug("##########UIUnionMemCell:onClick()  self.data.id=%s",self.data.id)
    if self.data.id >= 1000 then
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Close")
        self:memberDetails()
    else
        self:switch()
    end
end

function UIUnionMemCell:setData(data)
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

function UIUnionMemCell:updateUI()
    self.item:setData(self.data)
end

---------------------------------按钮功能回调----------------------------------------
--展开列表
function UIUnionMemCell:switch()
    local panel = global.panelMgr:getPanel("UIUnionMemberPanel")

    if self.data.uiData.showChildren then
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Close")
        panel:switchOff(self.data.id)
    else
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Open")
        panel:switchOn(self.data.id)
    end
end

--成员信息
function UIUnionMemCell:memberDetails()
    local panel = global.panelMgr:getPanel("UIUnionMemberPanel")
    global.panelMgr:openPanel("UIUnionMemDetails"):setData(self.data.sData,panel:getData(),self.data)
end

return UIUnionMemCell