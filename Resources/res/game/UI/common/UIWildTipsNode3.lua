--region UIWildTipsNode3.lua
--Author : Untory
--Date   : 2017/08/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWildTipsNode3  = class("UIWildTipsNode3", function() return gdisplay.newWidget() end )

function UIWildTipsNode3:ctor()

    self:CreateUI()
end

function UIWildTipsNode3:CreateUI()
    local root = resMgr:createWidget("common/wild_pro_tips_node3")
    self:initUI(root)
end

function UIWildTipsNode3:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/wild_pro_tips_node3")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.board = self.root.board_export
    self.node1 = self.root.board_export.node1_export
    self.wild_name = self.root.board_export.node1_export.wild_name_export
    self.type_name = self.root.board_export.Node_11.type_mlan_5.type_name_export
    self.dPower_num = self.root.board_export.Node_11.destructive_mlan_5.dPower_num_export
    self.dPower_num_add = self.root.board_export.Node_11.destructive_mlan_5.dPower_num_export.dPower_num_add_export
    self.scale = self.root.board_export.Node_11.scale_mlan_8.scale_export
    self.iftDef_num = self.root.board_export.def_property.def_infantry_mlan_14.iftDef_num_export
    self.acrDef_num = self.root.board_export.def_property.def_archer_mlan_14.acrDef_num_export
    self.cvlDef_num = self.root.board_export.def_property.def_cav_mlan_14.cvlDef_num_export
    self.magDef_num = self.root.board_export.def_property.def_mage_mlan_14.magDef_num_export
    self.atk_num = self.root.board_export.atk_property.atk_combat_mlan_14.atk_num_export
    self.portrait_node = self.root.portrait_node_export

--EXPORT_NODE_END
end

function UIWildTipsNode3:setData(proData)
    -- local proData = luaCfg:get_wild_property_by(data.lID)
    dump(proData)


    global.tools:setSoldierAvatar(self.portrait_node,proData)

    self.wild_name:setString(proData.name)

    local monsList = {
        [1] = 10363,
        [2] = 10364,
        [3] = 10365,
        [4] = 10366,
        [5] = 10640,
        [6] = 10367,
    }
    
    self.dPower_num:setString(luaCfg:get_local_string(monsList[proData.monsType]))
    self.scale:setString(proData.perPop)

    if proData.skill == 1 then
        self.type_name:setString(luaCfg:get_local_string(10124))
    else
        self.type_name:setString(luaCfg:get_local_string(10819))
    end

    self.atk_num:setString(proData.atk)

    self.iftDef_num:setString(proData.iftDef)
    self.cvlDef_num:setString(proData.cvlDef)
    self.acrDef_num:setString(proData.acrDef)
    self.magDef_num:setString(proData.magDef)

    self:setVisible(proData.atk ~= nil)

    
    global.tools:adjustNodePosForFather(self.atk_num:getParent(),self.atk_num)
    global.tools:adjustNodePosForFather(self.iftDef_num:getParent(),self.iftDef_num)
    global.tools:adjustNodePosForFather(self.cvlDef_num:getParent(),self.cvlDef_num)
    global.tools:adjustNodePosForFather(self.acrDef_num:getParent(),self.acrDef_num)
    global.tools:adjustNodePosForFather(self.magDef_num:getParent(),self.magDef_num)
    global.tools:adjustNodePosForFather(self.type_name:getParent(),self.type_name)
    global.tools:adjustNodePosForFather(self.scale:getParent(),self.scale)


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIWildTipsNode3

--endregion
