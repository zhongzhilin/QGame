--region UIDeviceDetailFPanel.lua
--Author : yyt
--Date   : 2016/10/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local funcGame = global.funcGame
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDeviceDetailFPanel  = class("UIDeviceDetailFPanel", function() return gdisplay.newWidget() end )

function UIDeviceDetailFPanel:ctor()
    self:CreateUI()
end

function UIDeviceDetailFPanel:CreateUI()
    local root = resMgr:createWidget("wall/wall_second_info_1")
    self:initUI(root)
end

function UIDeviceDetailFPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/wall_second_info_1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.trim_top = self.root.trim_top_export
    self.title = self.root.title_export
    self.name = self.root.title_export.name_fnt_mlan_12_export
    self.scrollView = self.root.scrollView_export
    self.ps_node = self.root.scrollView_export.ps_node_export
    self.name = self.root.scrollView_export.name_export
    self.des = self.root.scrollView_export.des_export
    self.icon = self.root.scrollView_export.icon_export
    self.space_num = self.root.scrollView_export.space_num_export
    self.itfDef_num = self.root.scrollView_export.itfDef_num_export
    self.cylDef_num = self.root.scrollView_export.cylDef_num_export
    self.acrDef_num = self.root.scrollView_export.acrDef_num_export
    self.mafDef_num = self.root.scrollView_export.mafDef_num_export
    self.food_num = self.root.scrollView_export.food_num_export
    self.wood_num = self.root.scrollView_export.wood_num_export
    self.stone_num = self.root.scrollView_export.stone_num_export
    self.time_num = self.root.scrollView_export.time_num_export

--EXPORT_NODE_END
    -- global.panelMgr:trimScrollView(self.scrollView,self.trim_top)
    self:adapt()

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIDeviceDetailFPanel:onEnter()
    self.scrollView:jumpToTop()
end

function UIDeviceDetailFPanel:adapt()

    local sHeight =(gdisplay.height - self.trim_top:getContentSize().height)
    local defY = self.scrollView:getContentSize().height
    self.scrollView:setContentSize(cc.size(gdisplay.width, sHeight))
     if sHeight < defY then 

    else
        self.scrollView:setTouchEnabled(false)
        self.scrollView:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.scrollView:getContentSize().height- self.ps_node:getPositionY()
        for _ ,v in pairs(self.scrollView:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
    end 

end 


function UIDeviceDetailFPanel:setData(data)
    
    self.des:setString(data.name)
    self.space_num:setString(data.basePara1)
    self.itfDef_num:setString(data.iftDef)
    self.cylDef_num:setString(data.cvlDef)
    self.acrDef_num:setString(data.acrDef)
    self.mafDef_num:setString(data.magDef)
    self.food_num:setString(data.foodCost)
    self.wood_num:setString(data.woodCost)
    self.stone_num:setString(data.stoneCost)
    self.time_num:setString(funcGame.formatTimeToHMS(data.perTime))

end

function UIDeviceDetailFPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanelForBtn("UIDeviceDetailFPanel")
end

--CALLBACKS_FUNCS_END

return UIDeviceDetailFPanel

--endregion
