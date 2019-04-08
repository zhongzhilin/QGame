--region UIPetStar1.lua
--Author : yyt
--Date   : 2018/02/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetStar1  = class("UIPetStar1", function() return gdisplay.newWidget() end )

function UIPetStar1:ctor()
end

function UIPetStar1:CreateUI()
    local root = resMgr:createWidget("pet/pet_star1")
    self:initUI(root)
end

function UIPetStar1:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_star1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.starLv = self.root.starLv_export
    self.NodeStar = self.root.NodeStar_export
    self.star10_bj = self.root.NodeStar_export.star10_bj_export
    self.starTotal9 = self.root.NodeStar_export.star10_bj_export.starTotal9_export
    self.star17 = self.root.NodeStar_export.star10_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeStar_export.star10_bj_export.starTotal9_export.star18_export
    self.star9_bj = self.root.NodeStar_export.star9_bj_export
    self.starTotal9 = self.root.NodeStar_export.star9_bj_export.starTotal9_export
    self.star17 = self.root.NodeStar_export.star9_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeStar_export.star9_bj_export.starTotal9_export.star18_export
    self.star8_bj = self.root.NodeStar_export.star8_bj_export
    self.starTotal9 = self.root.NodeStar_export.star8_bj_export.starTotal9_export
    self.star17 = self.root.NodeStar_export.star8_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeStar_export.star8_bj_export.starTotal9_export.star18_export
    self.star7_bj = self.root.NodeStar_export.star7_bj_export
    self.starTotal9 = self.root.NodeStar_export.star7_bj_export.starTotal9_export
    self.star17 = self.root.NodeStar_export.star7_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeStar_export.star7_bj_export.starTotal9_export.star18_export
    self.star6_bj = self.root.NodeStar_export.star6_bj_export
    self.starTotal9 = self.root.NodeStar_export.star6_bj_export.starTotal9_export
    self.star17 = self.root.NodeStar_export.star6_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeStar_export.star6_bj_export.starTotal9_export.star18_export
    self.star5_bj = self.root.NodeStar_export.star5_bj_export
    self.starTotal9 = self.root.NodeStar_export.star5_bj_export.starTotal9_export
    self.star17 = self.root.NodeStar_export.star5_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeStar_export.star5_bj_export.starTotal9_export.star18_export
    self.star4_bj = self.root.NodeStar_export.star4_bj_export
    self.starTotal9 = self.root.NodeStar_export.star4_bj_export.starTotal9_export
    self.star17 = self.root.NodeStar_export.star4_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeStar_export.star4_bj_export.starTotal9_export.star18_export
    self.star3_bj = self.root.NodeStar_export.star3_bj_export
    self.starTotal9 = self.root.NodeStar_export.star3_bj_export.starTotal9_export
    self.star17 = self.root.NodeStar_export.star3_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeStar_export.star3_bj_export.starTotal9_export.star18_export
    self.star2_bj = self.root.NodeStar_export.star2_bj_export
    self.starTotal9 = self.root.NodeStar_export.star2_bj_export.starTotal9_export
    self.star17 = self.root.NodeStar_export.star2_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeStar_export.star2_bj_export.starTotal9_export.star18_export
    self.star1_bj = self.root.NodeStar_export.star1_bj_export
    self.starTotal9 = self.root.NodeStar_export.star1_bj_export.starTotal9_export
    self.star17 = self.root.NodeStar_export.star1_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.NodeStar_export.star1_bj_export.starTotal9_export.star18_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPetStar1:setData(lv)
    -- body
    local per = 10
    local curClass = math.ceil(lv/per) 
    for i=1,10 do
        self["star"..i.."_bj"]:setVisible(false)
        if i<=curClass then
            self["star"..i.."_bj"]:setVisible(true)
        end
    end
    self.starLv:setString("+"..(lv-per*(curClass-1)))
    local perStarWidth = 45*0.6
    local width = perStarWidth*curClass
    self.starLv:setPosition(cc.p(self.NodeStar:getPositionX()+width, self.NodeStar:getPositionY()))
end

--CALLBACKS_FUNCS_END

return UIPetStar1

--endregion
