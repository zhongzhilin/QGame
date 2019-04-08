--region UISoldierNode.lua
--Author : yyt
--Date   : 2017/08/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISoldierNode  = class("UISoldierNode", function() return gdisplay.newWidget() end )

function UISoldierNode:ctor()
    self:CreateUI()
end

function UISoldierNode:CreateUI()
    local root = resMgr:createWidget("common/pandect_soldier_node")
    self:initUI(root)
end

function UISoldierNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/pandect_soldier_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_view = self.root.soldier_list_bg.portrait_view_export
    self.portrait_node = self.root.soldier_list_bg.portrait_view_export.Panel_4.portrait_node_export
    self.type_icon = self.root.soldier_list_bg.portrait_view_export.type_icon_export
    self.name = self.root.soldier_list_bg.portrait_view_export.name_export
    self.number = self.root.soldier_list_bg.portrait_view_export.num_mlan_6.number_export
    self.star = self.root.soldier_list_bg.portrait_view_export.star_export
    self.star1_bj = self.root.soldier_list_bg.portrait_view_export.star_export.star1_bj_export
    self.star1 = self.root.soldier_list_bg.portrait_view_export.star_export.star1_bj_export.star1_export
    self.star2 = self.root.soldier_list_bg.portrait_view_export.star_export.star1_bj_export.star2_export
    self.star2_bj = self.root.soldier_list_bg.portrait_view_export.star_export.star2_bj_export
    self.star3 = self.root.soldier_list_bg.portrait_view_export.star_export.star2_bj_export.star3_export
    self.star4 = self.root.soldier_list_bg.portrait_view_export.star_export.star2_bj_export.star4_export
    self.star3_bj = self.root.soldier_list_bg.portrait_view_export.star_export.star3_bj_export
    self.star5 = self.root.soldier_list_bg.portrait_view_export.star_export.star3_bj_export.star5_export
    self.star6 = self.root.soldier_list_bg.portrait_view_export.star_export.star3_bj_export.star6_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UISoldierNode:setData(cellData)

    local data = cellData.cdata
    self.data = data
    local soldierData = luaCfg:get_soldier_train_by(data.lID)
    if not soldierData then return end
    global.tools:setSoldierAvatar(self.portrait_node,soldierData)
    self.type_icon:setSpriteFrame(soldierData.skillIcon)
    self.number:setString(data.lCount)
    self.name:setString(soldierData.name)

    local showlvStar = function (lGrade)
        self.star:setVisible(lGrade ~= -1)
        for i=1,6 do
            self["star"..i]:setVisible(lGrade >= i*5)
        end
    end
    local id,dataBuild = global.cityData:getBuildingIdBySoldierId(data.lID)
    if dataBuild and dataBuild.serverData and (soldierData.type ~= 0) then
        showlvStar(dataBuild.serverData.lGrade or 1)
    else
        showlvStar(-1)
    end
    global.tools:adjustNodePosForFather(self.number:getParent(),self.number)
    
end


--CALLBACKS_FUNCS_END

return UISoldierNode

--endregion
