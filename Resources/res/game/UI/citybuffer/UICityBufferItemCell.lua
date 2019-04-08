

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UICityBufferItemCell  = class("UICityBufferItemCell", function() return cc.TableViewCell:create() end )
local UIUnionBtnItem = require("game.UI.citybuffer.CityBufferItem")

function UICityBufferItemCell:ctor()
    self:CreateUI()
end

function UICityBufferItemCell:CreateUI()
    self.item = UIUnionBtnItem.new() 
    self:addChild(self.item)
end

 
function UICityBufferItemCell:ShowSelect()
    local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 行军加速道具使用
    panel:setData(nil,self.data,panel.TYPE_BUFF_ADD, nil)
end 
  

function UICityBufferItemCell:onClick()
        self:ShowSelect()
 
end

function UICityBufferItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end


function UICityBufferItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UICityBufferItemCell