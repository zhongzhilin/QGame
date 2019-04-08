--region UITransferItem1.lua
--Author : zzl
--Date   : 2018/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END
local CountSliderControl = require("game.UI.common.UICountSliderControl")

local UITransferItem1  = class("UITransferItem1", function() return gdisplay.newWidget() end )

function UITransferItem1:ctor()
    
end

function UITransferItem1:CreateUI()
    local root = resMgr:createWidget("resource/res_transport_node")
    self:initUI(root)
end

function UITransferItem1:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_transport_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.res_icon = self.root.res_icon_export
    self.slider = self.root.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.slider_export.cur)

--EXPORT_NODE_END

    self.slider.cur = self.cur
    self.sliderControl = CountSliderControl.new(self.slider,handler(self, self.sliserCall))
    self.icon = self.res_icon
    self.sliderControl:setcheckCall(function (per) 
        return global.panelMgr:getPanel("UITransferPanel"):checkCall(self.data.id ,per)
    end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITransferItem1:setData(data , call)
    self.data =data 
    self.sliderControl:setMaxCount(data.max or 1 )
    self.sliderControl:setMinCount(0)
    self.call = call 
end 

function UITransferItem1:sliserCall(per)
    if self.call then 
        self.call(self.data.id , per)
    end 
end 



--CALLBACKS_FUNCS_END


function UITransferItem1:getCurCount()
    return self.sliderControl:getCurCount()
end 

return UITransferItem1

--endregion
