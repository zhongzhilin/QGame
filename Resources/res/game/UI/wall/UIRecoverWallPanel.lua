--region UIRecoverWallPanel.lua
--Author : yyt
--Date   : 2016/09/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRecoverWallPanel  = class("UIRecoverWallPanel", function() return gdisplay.newWidget() end )

function UIRecoverWallPanel:ctor()
    self:CreateUI()
end

function UIRecoverWallPanel:CreateUI()
    local root = resMgr:createWidget("wall/wall_recover_sec_bg")
    self:initUI(root)
end

function UIRecoverWallPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/wall_recover_sec_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.recover_node = self.root.Node_export.recover_node_export
    self.txt_Title = self.root.Node_export.recover_node_export.txt_Title_mlan_12_export
    self.num = self.root.Node_export.recover_node_export.num_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.use_btn, function(sender, eventType) self:confirm(sender, eventType) end)
--EXPORT_NODE_END
    self.use_btn = self.Node.use_btn
    self.wallNumPanel = global.panelMgr:getPanel("UIWallNumPanel")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRecoverWallPanel:setData(data, callback)
    if data == nil then return end

    self.data = data
    self.m_recoverCall = callback
    self.use_btn:setEnabled(true)

    self.recover_node:setVisible(true)
    self.num:setString( data.diamondCost )
    self:checkDiamondEnough(data.diamondCost)  
end

function UIRecoverWallPanel:confirm(sender, eventType)

    if self.wallNumPanel.duraValue == 0 then

        global.tipsMgr:showWarning(" 城池已被烧毁！")
        self:exit_click()
        return
    end

    if self.data then   -- protect
        if self:checkDiamondEnough(self.data.diamondCost) then
            -- 魔晶恢复城防
            local diamondNum = tonumber(self.num:getString())
            global.itemApi:diamondUse(function(msg)
                
                self.m_recoverCall(msg)
                self:exit_click()
            end,5,0,self.data.buildId)
        else
            global.panelMgr:openPanel("UIRechargePanel")
        end
    else 

    end 
end

function UIRecoverWallPanel:checkDiamondEnough(num)
    if not propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.num:setColor(gdisplay.COLOR_RED)
        return false
    else
        self.num:setColor(gdisplay.COLOR_WHITE)
        return true
    end
end

function UIRecoverWallPanel:exit_click(sender, eventType)
    global.panelMgr:closePanelForBtn("UIRecoverWallPanel")
end


--CALLBACKS_FUNCS_END

return UIRecoverWallPanel

--endregion
