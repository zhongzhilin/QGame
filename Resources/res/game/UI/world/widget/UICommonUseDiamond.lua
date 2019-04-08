--region UICommonUseDiamond.lua
--Author : untory
--Date   : 2018/03/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICommonUseDiamond  = class("UICommonUseDiamond", function() return gdisplay.newWidget() end )

function UICommonUseDiamond:ctor()
    self:CreateUI()
end

function UICommonUseDiamond:CreateUI()
    local root = resMgr:createWidget("lord/common_buy")
    self:initUI(root)
end

function UICommonUseDiamond:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "lord/common_buy")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.gray_spite = self.root.Node_export.use_btn.gray_spite_export
    self.diamond = self.root.Node_export.use_btn.diamond_export
    self.txt_Title = self.root.Node_export.node.txt_Title_mlan_16_export
    self.cost = self.root.Node_export.node.cost_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.use_btn, function(sender, eventType) self:confirm(sender, eventType) end)
--EXPORT_NODE_END
end

function UICommonUseDiamond:setData(titiel,desc,cost,callback)
    self.txt_Title:setString(titiel)
    self.cost:setString(desc)
    self.callback = callback
    self:checkDiamondEnough(cost)
end


function UICommonUseDiamond:checkDiamondEnough(num)

    self.needDiamond = num
    self.diamond:setString(num)

    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then

        self.diamond:setTextColor(gdisplay.COLOR_RED)
        
        return false
    else

        self.diamond:setTextColor(cc.c3b(255, 184, 34))
        return true
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UICommonUseDiamond:exit_click(sender, eventType)

    global.panelMgr:closePanelForBtn('UICommonUseDiamond')
end

function UICommonUseDiamond:confirm(sender, eventType)

    if self:checkDiamondEnough(self.needDiamond) then
        self.callback()
        global.panelMgr:closePanelForBtn('UICommonUseDiamond')
    else
        global.panelMgr:openPanel("UIRechargePanel")
        self:exit_click()
    end
end
--CALLBACKS_FUNCS_END

return UICommonUseDiamond

--endregion
