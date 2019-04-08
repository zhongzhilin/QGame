--region UIUnionMemOne.lua
--Author : wuwx
--Date   : 2016/12/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionMemOne  = class("UIUnionMemOne", function() return gdisplay.newWidget() end )

function UIUnionMemOne:ctor()
    self:CreateUI()
end

function UIUnionMemOne:CreateUI()
    local root = resMgr:createWidget("union/union_member_tab")
    self:initUI(root)
end

function UIUnionMemOne:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_member_tab")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.go = self.root.btn_export.go_export
    self.name = self.root.btn_export.name_export
    self.exp_icon_bg = self.root.btn_export.exp_icon_bg_export
    self.icon = self.root.btn_export.exp_icon_bg_export.icon_export
    self.num = self.root.btn_export.ui_surface_icon_union_num_16.num_export
    self.height = self.root.height_export
    self.spReadState = self.root.spReadState_export
    self.Text = self.root.spReadState_export.Text_export

--EXPORT_NODE_END
    self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)
end

function UIUnionMemOne:setData(data)
    self.data = data
    self.name:setString(data.text)
    -- self.icon:setSpriteFrame(data.icon)
    global.panelMgr:setTextureFor(self.icon,data.icon)
    if self.data.id == 1 then
        --盟主
        self.num:setString(string.format("%s/1",self.data.onlineCount))
    else
        self.num:setString(string.format("%s/%s",self.data.onlineCount,self.data.count))
    end

    if self.data.id == 6 then
        self.spReadState:setVisible(self.data.count > 0 and (global.unionData:isHadPower(22)))
        self.Text:setString(self.data.count)
    else
        self.spReadState:setVisible(false)
    end

    self:setFocus(self.data.uiData.showChildren )
end

function UIUnionMemOne:setFocus(isFocus)
    self.go:setRotation(isFocus and 90 or 0)

    -- local selectData = global.panelMgr:getPanel("UIUnionMemberPanel"):getTableView():getSelectedData()
    -- if selectData then
    --     local selectId = selectData.id>=1000 and selectData.bindId or selectData.id
    --     if selectId == self.data.id then
    --         self.go:setRotation(90)
    --     else
    --         self.go:setRotation(0)
    --     end
    -- else
    --     self.go:setRotation(0)
    -- end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUnionMemOne

--endregion
