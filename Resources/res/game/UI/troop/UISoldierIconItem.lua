--region UISoldierIconItem.lua
--Author : yyt
--Date   : 2016/09/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISoldierIconItem  = class("UISoldierIconItem", function() return gdisplay.newWidget() end )

function UISoldierIconItem:ctor()
    self:CreateUI()
end

function UISoldierIconItem:CreateUI()
    local root = resMgr:createWidget("troop/details_soldier_icon_node")
    self:initUI(root)
end

function UISoldierIconItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "troop/details_soldier_icon_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_view = self.root.portrait_view_export
    self.portrait_node = self.root.portrait_view_export.Panel_1.portrait_node_export
    self.num = self.root.num_export
    self.star = self.root.star_export
    self.star1_bj = self.root.star_export.star1_bj_export
    self.star1 = self.root.star_export.star1_bj_export.star1_export
    self.star2 = self.root.star_export.star1_bj_export.star2_export
    self.star2_bj = self.root.star_export.star2_bj_export
    self.star3 = self.root.star_export.star2_bj_export.star3_export
    self.star4 = self.root.star_export.star2_bj_export.star4_export
    self.star3_bj = self.root.star_export.star3_bj_export
    self.star5 = self.root.star_export.star3_bj_export.star5_export
    self.star6 = self.root.star_export.star3_bj_export.star6_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISoldierIconItem:setData( data, flag )

    local soldier_data = luaCfg:get_soldier_train_by(data.lID)
    global.tools:setSoldierAvatar(self.portrait_node,soldier_data)

    local lid = data.lID%1000
    if lid == 61 or lid == 62 then
        self.portrait_node.pic:setScale(0.3)
    else
        self.portrait_node.pic:setScale(0.6)
    end
    self.num:setString(data.lCount)

    local showlvStar = function (lGrade)
        self.star:setVisible(lGrade ~= -1)
        for i=1,6 do
            self["star"..i]:setVisible(lGrade >= i*5)
        end
    end
    local id,dataBuild = global.cityData:getBuildingIdBySoldierId(data.lID)
    if (soldier_data.race ~=0) and dataBuild and dataBuild.serverData and (soldier_data.type ~= 7) and (soldier_data.type ~= 0) then
        showlvStar(dataBuild.serverData.lGrade or 1)
    else
        showlvStar(-1)
    end

    if flag and flag==1 and data.lLv then
        showlvStar(data.lLv)
    end


end

function UISoldierIconItem:getScale(id)
    
    local scaleData = luaCfg:picture()
    for _,v in pairs(scaleData) do
        if v.sId == id and v.order == 1 then
            return v.scale/100
        end
    end

end

--CALLBACKS_FUNCS_END

return UISoldierIconItem

--endregion
