--region UIWallTipsNode.lua
--Author : anlitop
--Date   : 2017/07/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWallTipsNode  = class("UIWallTipsNode", function() return gdisplay.newWidget() end )

function UIWallTipsNode:ctor()
    self: CreateUI()
end

function UIWallTipsNode:CreateUI()
    local root = resMgr:createWidget("common/wall_tips_node")
    self:initUI(root)
end

function UIWallTipsNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/wall_tips_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.board = self.root.board_export
    self.node1 = self.root.board_export.node1_export
    self.soldier_name = self.root.board_export.node1_export.soldier_name_export
    self.type_name = self.root.board_export.Node_11.type_mlan_5.type_name_export
    self.Durability_num = self.root.board_export.Node_11.destructive_mlan_7.Durability_num_export
    self.dPower_num_add = self.root.board_export.Node_11.destructive_mlan_7.Durability_num_export.dPower_num_add_export
    self.percentage_num = self.root.board_export.base_property.manpower_mlan_14.percentage_num_export
    self.portrait_node = self.root.portrait_node_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END


function UIWallTipsNode:setData(data)

    dump(data ,"//")

    local max = data.old_count 

    local now = data.lcount 

    self.Durability_num:setString(now.."/"..max)

    -- local getGread = function(num) 
    --     for _ ,v in  pairs( global.luaCfg:buildings_wall()) do 
    --         if v.durability == num then 
    --             return v.lv
    --         end 
    --     end 
    -- end 
    -- local lv = getGread(max)

    local effect = global.luaCfg:get_buildings_wall_by(data.soldierLV or 10 ).defUp

    self.percentage_num:setString(math.floor( effect * (now / max))  .. "%")

    -- self.data = data

    -- dump(self.data,"UIWildTipsNode///////////")
    -- local property =global.luaCfg:get_wild_property_by(self.data.id)
    -- if not property then
    --     return 
    -- end 
    -- local att_string =10124
    -- local def_string =10127
    -- print(property.skill,"skill  ")
    -- if property.skill == 1 then 
    --     self.type_name:setstring(global.luaCfg:get_local_string(att_string))
    -- else
    --     self.type_name:setstring(global.luaCfg:get_local_string(def_string))
    -- end 
    -- global.tools:setSoldierAvatar(self.portrait_node,self.data)
    -- for i,v in ipairs(WDEFINE.SOLDIER_PROPERTY) do
    --     if self[v.."_num"] then
    --         self[v.."_num"]:setString(property[v])
    --     end
    -- end
    -- self.Durability_num:getParent():setString("///////////////////////")
    
    local data = global.luaCfg:get_soldier_property_by(3)

    self.soldier_name:setString(data.name)
    self.type_name:setString(data.name)

    global.tools:adjustNodePosForFather(self.Durability_num:getParent(),self.Durability_num)
    global.tools:adjustNodePosForFather(self.percentage_num:getParent(),self.percentage_num)
end



function UIWallTipsNode:getContentSize() --qaq
    return  self.board:getContentSize()
end 

return UIWallTipsNode

--endregion
