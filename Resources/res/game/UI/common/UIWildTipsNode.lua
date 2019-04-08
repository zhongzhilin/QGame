--region UIWildTipsNode.lua
--Author : anlitop
--Date   : 2017/07/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWildTipsNode  = class("UIWildTipsNode", function() return gdisplay.newWidget() end )

function UIWildTipsNode:ctor()
    self:CreateUI()
end

function UIWildTipsNode:CreateUI()
    local root = resMgr:createWidget("common/wild_tips_node")
    self:initUI(root)
end

function UIWildTipsNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/wild_tips_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.board = self.root.board_export
    self.node1 = self.root.board_export.node1_export
    self.wild_name = self.root.board_export.node1_export.wild_name_export
    self.type_name = self.root.board_export.Node_11.type_mlan_7.type_name_export
    self.dPower_num = self.root.board_export.Node_11.destructive_mlan_7.dPower_num_export
    self.dPower_num_add = self.root.board_export.Node_11.destructive_mlan_7.dPower_num_export.dPower_num_add_export
    self.atk_num = self.root.board_export.Node_11.atk_combat_mlan_8.atk_num_export
    self.atk_num_add = self.root.board_export.Node_11.atk_combat_mlan_8.atk_num_export.atk_num_add_export
    self.iftDef_num = self.root.board_export.def_property.def_infantry_mlan_14.iftDef_num_export
    self.iftDef_num_add = self.root.board_export.def_property.def_infantry_mlan_14.iftDef_num_export.iftDef_num_add_export
    self.acrDef_num = self.root.board_export.def_property.def_archer_mlan_14.acrDef_num_export
    self.acrDef_num_add = self.root.board_export.def_property.def_archer_mlan_14.acrDef_num_export.acrDef_num_add_export
    self.cvlDef_num = self.root.board_export.def_property.def_cav_mlan_14.cvlDef_num_export
    self.cvlDef_num_add = self.root.board_export.def_property.def_cav_mlan_14.cvlDef_num_export.cvlDef_num_add_export
    self.magDef_num = self.root.board_export.def_property.def_mage_mlan_14.magDef_num_export
    self.magDef_num_add = self.root.board_export.def_property.def_mage_mlan_14.magDef_num_export.magDef_num_add_export
    self.portrait_node = self.root.portrait_node_export

--EXPORT_NODE_END

    
    global.tools:adjustNodePosForFather(self.iftDef_num:getParent(),self.iftDef_num)
    global.tools:adjustNodePosForFather(self.acrDef_num:getParent(),self.acrDef_num)
    global.tools:adjustNodePosForFather(self.cvlDef_num:getParent(),self.cvlDef_num)
    global.tools:adjustNodePosForFather(self.magDef_num:getParent(),self.magDef_num)
    global.tools:adjustNodePosForFather(self.atk_num:getParent(),self.atk_num)
    global.tools:adjustNodePosForFather(self.type_name:getParent(),self.type_name)
    global.tools:adjustNodePosForFather(self.dPower_num:getParent(),self.dPower_num)


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END


function UIWildTipsNode:setData(data)

    self.data = data

    local property =global.luaCfg:get_wild_property_by(self.data.id)

    if not property then
        return 
    end 
 
    local att_string =10124
    local def_string =10127

    print(property.skill,"skill  ")

    if property.skill == 1 then 
        
        self.type_name:setString(global.luaCfg:get_local_string(att_string))
    else
        self.type_name:setString(global.luaCfg:get_local_string(def_string))
    end 

    global.tools:setSoldierAvatar(self.portrait_node,self.data)
    
    for i,v in ipairs(WDEFINE.SOLDIER_PROPERTY) do
        if self[v.."_num"] then
            self[v.."_num"]:setString(property[v])
        end
    end

    self.wild_name:setString(property.name)
end


function UIWildTipsNode:getContentSize() --qaq
    return  self.board:getContentSize()
end 

return UIWildTipsNode

--endregion
