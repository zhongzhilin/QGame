--region UITechMaxLvPanel.lua
--Author : yyt
--Date   : 2017/03/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITechMaxLvPanel  = class("UITechMaxLvPanel", function() return gdisplay.newWidget() end )

function UITechMaxLvPanel:ctor()
    self:CreateUI()
end

function UITechMaxLvPanel:CreateUI()
    local root = resMgr:createWidget("science/tech_max_lv_bg")
    self:initUI(root)
end

function UITechMaxLvPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/tech_max_lv_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.science_name = self.root.Node_export.Image_14.science_name_export
    self.icon = self.root.Node_export.Image_14.icon_export
    self.res_icon = self.root.Node_export.Image_14.res_icon_export
    self.lv = self.root.Node_export.Image_14.lv_export
    self.des = self.root.Node_export.Image_14.des_export
    self.now_num = self.root.Node_export.Image_14.nowlv_mlan_6.now_num_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UITechMaxLvPanel:setData(data)
    
    self.data = data
    self.science_name:setString(data.name)
    self.lv:setString(luaCfg:get_local_string(10410, self.data.lGrade, self.data.maxLv))
    self.des:setString(data.des)
    -- self.res_icon:setSpriteFrame(data.icon)
    global.panelMgr:setTextureFor(self.res_icon,data.icon)

    local lvData = luaCfg:science_lvup()
    for _,v in pairs(lvData) do
        if v.id == self.data.id then
            local buffData = luaCfg:get_data_type_by(v.buff)
            if v.lv == self.data.lGrade then
                self.now_num:setString("+"..v.buffNum..buffData.extra)
            end
        end
    end
    --修改科技满级页面重叠 阿成
    global.tools:adjustNodePosForFather(self.now_num:getParent(),self.now_num)
end

function UITechMaxLvPanel:exitCall(sender, eventType)
    global.panelMgr:closePanel("UITechMaxLvPanel")
end
--CALLBACKS_FUNCS_END

return UITechMaxLvPanel

--endregion
