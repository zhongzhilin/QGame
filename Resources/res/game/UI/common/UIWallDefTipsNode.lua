--region UIWallDefTipsNode.lua
--Author : anlitop
--Date   : 2017/07/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWallDefTipsNode  = class("UIWallDefTipsNode", function() return gdisplay.newWidget() end )

function UIWallDefTipsNode:ctor()
    self:CreateUI()
end

function UIWallDefTipsNode:CreateUI()
    local root = resMgr:createWidget("common/walldef_tips_node")
    self:initUI(root)
end

function UIWallDefTipsNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/walldef_tips_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.board = self.root.board_export
    self.node1 = self.root.board_export.node1_export
    self.soldier_name = self.root.board_export.node1_export.soldier_name_export
    self.type_name = self.root.board_export.Node_11.type_mlan_6.type_name_export
    self.najiu_num = self.root.board_export.Node_11.destructive_mlan_6.najiu_num_export
    self.dPower_num_add = self.root.board_export.Node_11.destructive_mlan_6.najiu_num_export.dPower_num_add_export
    self.space_num = self.root.board_export.base_property.manpower_mlan_10.space_num_export
    self.kill_num = self.root.board_export.def_property.def_infantry_mlan_112.kill_num_export
    self.iftDef_num_add = self.root.board_export.def_property.def_infantry_mlan_112.kill_num_export.iftDef_num_add_export
    self.effect_percent = self.root.board_export.def_property.def_cav_mlan_14.effect_percent_export
    self.cvlDef_num_add = self.root.board_export.def_property.def_cav_mlan_14.effect_percent_export.cvlDef_num_add_export
    self.food_num = self.root.board_export.train_need.food_num_export
    self.wood_num = self.root.board_export.train_need.wood_num_export
    self.gold_num = self.root.board_export.train_need.gold_num_export
    self.stone_num = self.root.board_export.train_need.stone_num_export
    self.gift_overtime_text = self.root.board_export.need_time_node.timer_Node.gift_overtime_text_export
    self.portrait_node = self.root.portrait_node_export

--EXPORT_NODE_END

    global.tools:adjustNodePosForFather(self.space_num:getParent(),self.space_num)

    global.tools:adjustNodePosForFather(self.kill_num:getParent(),self.kill_num)

    global.tools:adjustNodePosForFather(self.effect_percent:getParent(),self.effect_percent)

    global.tools:adjustNodePosForFather(self.najiu_num:getParent(),self.najiu_num)

    global.tools:adjustNodePosForFather(self.type_name:getParent(),self.type_name)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

function  UIWallDefTipsNode:setData(data)

    self.data = data 

    if  self.data.soldierId ==71 then  --j箭塔

     global.tools:setSoldierAvatar(self.portrait_node,{id=8071})

    elseif self.data.soldierId ==72 then  --陷阱

     global.tools:setSoldierAvatar(self.portrait_node,{id=8072})

    end 

    local proData = global.luaCfg:get_def_device_by(data.soldierId)
    -- self.icon:setSpriteFrame(data.pic)
    -- global.panelMgr:setTextureFor(self.icon,data.pic)

    self.soldier_name:setString(proData.name)
    -- self.des:setString(proData.info)
    self.space_num:setString(proData.space)
    self.kill_num:setString(proData.manpowerDamage)
    self.effect_percent:setString(proData.robEffect)
    self.najiu_num:setString(proData.hp)
    self.food_num:setString(proData.foodCost)
    self.wood_num:setString(proData.woodCost)
    self.stone_num:setString(proData.stoneCost)
    self.gift_overtime_text:setString(global.funcGame.formatTimeToHMS(proData.perTime))

    -- self.data = data
    -- dump(self.data)
    -- local property =global.luaCfg:get_wild_property_by(self.data.id)

    -- if not property then
    --     return 
    -- end 
 
    -- global.tools:setSoldierAvatar(self.portrait_node,self.data)
    
    -- for i,v in ipairs(WDEFINE.SOLDIER_PROPERTY) do
    --     if self[v.."_num"] then
    --         self[v.."_num"]:setString(property[v])
    --     end
    -- end

    self.type_name:setString(global.luaCfg:get_local_string(10090))
end




function UIWallDefTipsNode:getContentSize() --qaq

    return  self.board:getContentSize()
end 

return UIWallDefTipsNode

--endregion
