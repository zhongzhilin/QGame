--region UIUEditPowerItem.lua
--Author : wuwx
--Date   : 2017/02/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUEditPowerItem  = class("UIUEditPowerItem", function() return gdisplay.newWidget() end )

function UIUEditPowerItem:ctor()
    self:CreateUI()
end

function UIUEditPowerItem:CreateUI()
    local root = resMgr:createWidget("union/union_power_list")
    self:initUI(root)
end

function UIUEditPowerItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_power_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.title = self.root.title_export
    self.name = self.root.name_export
    self.img_5 = self.root.img_5_export
    self.img_4 = self.root.img_4_export
    self.img_3 = self.root.img_3_export
    self.img_2 = self.root.img_2_export
    self.img_1 = self.root.img_1_export
    self.shadow_5 = self.root.shadow_5_export
    self.shadow_4 = self.root.shadow_4_export
    self.shadow_3 = self.root.shadow_3_export
    self.shadow_2 = self.root.shadow_2_export
    self.shadow_1 = self.root.shadow_1_export
    self.Paneledge = self.root.Paneledge_export

--EXPORT_NODE_END
    -- uiMgr:addWidgetTouchHandler(self.bg, function(sender, eventType) self:onBgClick(sender, eventType) end)
    
    for i=1,5 do
        local icon = self["img_"..i]
        icon:setTag(i)
        icon.noEdit = true
        uiMgr:addWidgetTouchHandler(icon, function(sender, eventType) self:onClick(sender, eventType) end)
        icon:setSwallowTouches(false)
    end
end
--<0:不可能编辑-1：有权限，-2：没有权限，1：有权限，2：没有权限
function UIUEditPowerItem:setData(data)
    self.data = data

    for i=1,5 do
        local p = self.data["powerR"..i]
        print("###########i="..i..",p="..p)
        if p < 0 then
            --不可以修改就没有服务器数据
            local isSelected = (p==-1)
            self["img_"..i].noEdit = true
            self:selectTarget(i,isSelected)
            self["shadow_"..i]:setVisible(self:isEditModel())
        else
            local isSelected = self:isSdataInclude(i)
            self["img_"..i].noEdit = false
            self:selectTarget(i,isSelected)
            self["shadow_"..i]:setVisible(false)
        end
    end
    self.name:setString(self.data.name)

    self.title:setVisible(self.data.array%2==1)
end

--判断是否设置了权限
function UIUEditPowerItem:isSdataInclude(id)
    if not self.data.sData.lItem then
        return false
    end
    for i,v in ipairs(self.data.sData.lItem) do
        if v == id then
            return true
        end
    end
    return false
end

function UIUEditPowerItem:addSdataInclude(id,value)
    if not self.data.sData.lItem then
        self.data.sData.lItem = {}
    end
    for i,v in ipairs(self.data.sData.lItem) do
        if v == id then
            if value == 0 then
                table.remove(self.data.sData.lItem,i)
            end
            return true
        end
    end
    if value == 1 then
        table.insert(self.data.sData.lItem,id)
    end
    return true
end

function UIUEditPowerItem:isEditModel()
    return global.panelMgr:getPanel("UIUEditPower"):isEditModel()
end

local selectedFrameName = {
    [0] = "ui_surface_icon/power_yes.png", --未选中
    [1] = "ui_surface_icon/check_box_checked.png",
}
function UIUEditPowerItem:selectTarget(id,isSelected)
    local icon = self["img_"..id]
    if not icon then return end
    icon:setOpacity(255)
    if isSelected then
        icon:loadTexture(selectedFrameName[1], ccui.TextureResType.plistType)
        icon.selectedState = 1
    else
        if self:isEditModel() then
            if isSelected == nil then
                --不传，认为编辑模式,from cell onclick,故反向
                icon.selectedState = (icon.selectedState == 0) and 1 or 0
                icon:loadTexture(selectedFrameName[icon.selectedState], ccui.TextureResType.plistType)
            else
                icon.selectedState = isSelected and 1 or 0
                icon:loadTexture(selectedFrameName[icon.selectedState], ccui.TextureResType.plistType)
            end
            self:addSdataInclude(id,icon.selectedState)
            icon:setOpacity((icon.selectedState == 1) and 255 or 0)
        else
            icon.selectedState = 0
            icon:setOpacity(0)
        end
    end
    self.Paneledge:setVisible(self:isEditModel())
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIUEditPowerItem:onClick(sender, eventType)
    if sender.noEdit or not self:isEditModel() then return end
    self:getParent():setSelectedId(nil)
    self:getParent():setSelectedId(sender:getTag())
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(function()
        self:getParent():setSelectedId(nil)
    end)))
end

function UIUEditPowerItem:onBgClick(sender, eventType)
    -- print("############onBgClick()")
    -- if self.m_isClick then
    --     self:getParent():setSelectedId(nil)
    -- end
    -- self.m_isClick = false
end
--CALLBACKS_FUNCS_END

return UIUEditPowerItem

--endregion
