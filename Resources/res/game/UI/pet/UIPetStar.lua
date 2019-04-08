--region UIPetStar.lua
--Author : yyt
--Date   : 2017/12/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetStar  = class("UIPetStar", function() return gdisplay.newWidget() end )

function UIPetStar:ctor()
end

function UIPetStar:CreateUI()
    local root = resMgr:createWidget("pet/pet_star")
    self:initUI(root)
end

function UIPetStar:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "pet/pet_star")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.star = self.root.star_export
    self.star1_bj = self.root.star_export.star1_bj_export
    self.starTotal1 = self.root.star_export.star1_bj_export.starTotal1_export
    self.star1 = self.root.star_export.star1_bj_export.starTotal1_export.star1_export
    self.star2 = self.root.star_export.star1_bj_export.starTotal1_export.star2_export
    self.starLv1 = self.root.star_export.star1_bj_export.starLv1_export
    self.star2_bj = self.root.star_export.star2_bj_export
    self.starTotal2 = self.root.star_export.star2_bj_export.starTotal2_export
    self.star3 = self.root.star_export.star2_bj_export.starTotal2_export.star3_export
    self.star4 = self.root.star_export.star2_bj_export.starTotal2_export.star4_export
    self.starLv2 = self.root.star_export.star2_bj_export.starLv2_export
    self.star3_bj = self.root.star_export.star3_bj_export
    self.starTotal3 = self.root.star_export.star3_bj_export.starTotal3_export
    self.star5 = self.root.star_export.star3_bj_export.starTotal3_export.star5_export
    self.star6 = self.root.star_export.star3_bj_export.starTotal3_export.star6_export
    self.starLv3 = self.root.star_export.star3_bj_export.starLv3_export
    self.star4_bj = self.root.star_export.star4_bj_export
    self.starTotal4 = self.root.star_export.star4_bj_export.starTotal4_export
    self.star7 = self.root.star_export.star4_bj_export.starTotal4_export.star7_export
    self.star8 = self.root.star_export.star4_bj_export.starTotal4_export.star8_export
    self.starLv4 = self.root.star_export.star4_bj_export.starLv4_export
    self.star5_bj = self.root.star_export.star5_bj_export
    self.starTotal5 = self.root.star_export.star5_bj_export.starTotal5_export
    self.star9 = self.root.star_export.star5_bj_export.starTotal5_export.star9_export
    self.star10 = self.root.star_export.star5_bj_export.starTotal5_export.star10_export
    self.starLv5 = self.root.star_export.star5_bj_export.starLv5_export
    self.star6_bj = self.root.star_export.star6_bj_export
    self.starTotal6 = self.root.star_export.star6_bj_export.starTotal6_export
    self.star11 = self.root.star_export.star6_bj_export.starTotal6_export.star11_export
    self.star12 = self.root.star_export.star6_bj_export.starTotal6_export.star12_export
    self.starLv6 = self.root.star_export.star6_bj_export.starLv6_export
    self.star7_bj = self.root.star_export.star7_bj_export
    self.starTotal7 = self.root.star_export.star7_bj_export.starTotal7_export
    self.star13 = self.root.star_export.star7_bj_export.starTotal7_export.star13_export
    self.star14 = self.root.star_export.star7_bj_export.starTotal7_export.star14_export
    self.starLv7 = self.root.star_export.star7_bj_export.starLv7_export
    self.star8_bj = self.root.star_export.star8_bj_export
    self.starTotal8 = self.root.star_export.star8_bj_export.starTotal8_export
    self.star15 = self.root.star_export.star8_bj_export.starTotal8_export.star15_export
    self.star16 = self.root.star_export.star8_bj_export.starTotal8_export.star16_export
    self.starLv8 = self.root.star_export.star8_bj_export.starLv8_export
    self.star9_bj = self.root.star_export.star9_bj_export
    self.starTotal9 = self.root.star_export.star9_bj_export.starTotal9_export
    self.star17 = self.root.star_export.star9_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.star_export.star9_bj_export.starTotal9_export.star18_export
    self.starLv9 = self.root.star_export.star9_bj_export.starLv9_export
    self.star10_bj = self.root.star_export.star10_bj_export
    self.starTotal10 = self.root.star_export.star10_bj_export.starTotal10_export
    self.star19 = self.root.star_export.star10_bj_export.starTotal10_export.star19_export
    self.star20 = self.root.star_export.star10_bj_export.starTotal10_export.star20_export
    self.starLv10 = self.root.star_export.star10_bj_export.starLv10_export

--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_sBEGIN

function UIPetStar:setData(lv, scale)
    -- body
    local curClass = math.ceil(lv/10) 
    for i=1,10 do
        self["starTotal"..i]:setVisible(false)
        if i<=curClass then
            self["starTotal"..i]:setVisible(true)
        end
    end

    local per = 10
    local curLvClass = math.ceil(lv/per)
    for i=1,10 do
        self["starLv"..i]:setVisible(false) 
        if curLvClass == 1 then
            self.starLv1:setVisible(true)
            self.starLv1:setString("+"..lv)
        elseif i<=curLvClass and curLvClass ~= 1 then
            --self["starLv"..i]:setVisible(true)
            --self["starLv"..i]:setString("+"..per)
            if i==curLvClass then
                self["starLv"..i]:setVisible(true)
                self["starLv"..i]:setString("+"..(lv-per*(i-1)))
            end
        end
    end

end

--CALLBACKS_FUNCS_END

return UIPetStar

--endregion
