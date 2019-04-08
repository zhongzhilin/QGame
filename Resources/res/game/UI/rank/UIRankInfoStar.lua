--region UIRankInfoStar.lua
--Author : yyt
--Date   : 2018/11/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRankInfoStar  = class("UIRankInfoStar", function() return gdisplay.newWidget() end )

function UIRankInfoStar:ctor()
    self:CreateUI()
end

function UIRankInfoStar:CreateUI()
    local root = resMgr:createWidget("rank/rank_star")
    self:initUI(root)
end

function UIRankInfoStar:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rank/rank_star")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.star = self.root.star_export
    self.NodeStar1 = self.root.star_export.NodeStar1_export
    self.star1_bj = self.root.star_export.NodeStar1_export.star1_bj_export
    self.starTotal1 = self.root.star_export.NodeStar1_export.star1_bj_export.starTotal1_export
    self.star1 = self.root.star_export.NodeStar1_export.star1_bj_export.starTotal1_export.star1_export
    self.star2 = self.root.star_export.NodeStar1_export.star1_bj_export.starTotal1_export.star2_export
    self.star2_bj = self.root.star_export.NodeStar1_export.star2_bj_export
    self.starTotal2 = self.root.star_export.NodeStar1_export.star2_bj_export.starTotal2_export
    self.star3 = self.root.star_export.NodeStar1_export.star2_bj_export.starTotal2_export.star3_export
    self.star4 = self.root.star_export.NodeStar1_export.star2_bj_export.starTotal2_export.star4_export
    self.star3_bj = self.root.star_export.NodeStar1_export.star3_bj_export
    self.starTotal3 = self.root.star_export.NodeStar1_export.star3_bj_export.starTotal3_export
    self.star5 = self.root.star_export.NodeStar1_export.star3_bj_export.starTotal3_export.star5_export
    self.star6 = self.root.star_export.NodeStar1_export.star3_bj_export.starTotal3_export.star6_export
    self.star4_bj = self.root.star_export.NodeStar1_export.star4_bj_export
    self.starTotal4 = self.root.star_export.NodeStar1_export.star4_bj_export.starTotal4_export
    self.star7 = self.root.star_export.NodeStar1_export.star4_bj_export.starTotal4_export.star7_export
    self.star8 = self.root.star_export.NodeStar1_export.star4_bj_export.starTotal4_export.star8_export
    self.star5_bj = self.root.star_export.NodeStar1_export.star5_bj_export
    self.starTotal5 = self.root.star_export.NodeStar1_export.star5_bj_export.starTotal5_export
    self.star9 = self.root.star_export.NodeStar1_export.star5_bj_export.starTotal5_export.star9_export
    self.star10 = self.root.star_export.NodeStar1_export.star5_bj_export.starTotal5_export.star10_export
    self.starLvNum1 = self.root.star_export.NodeStar1_export.starLvNum1_export
    self.NodeStar2 = self.root.star_export.NodeStar2_export
    self.star6_bj = self.root.star_export.NodeStar2_export.star6_bj_export
    self.starTotal6 = self.root.star_export.NodeStar2_export.star6_bj_export.starTotal6_export
    self.star11 = self.root.star_export.NodeStar2_export.star6_bj_export.starTotal6_export.star11_export
    self.star12 = self.root.star_export.NodeStar2_export.star6_bj_export.starTotal6_export.star12_export
    self.star7_bj = self.root.star_export.NodeStar2_export.star7_bj_export
    self.starTotal7 = self.root.star_export.NodeStar2_export.star7_bj_export.starTotal7_export
    self.star13 = self.root.star_export.NodeStar2_export.star7_bj_export.starTotal7_export.star13_export
    self.star14 = self.root.star_export.NodeStar2_export.star7_bj_export.starTotal7_export.star14_export
    self.star8_bj = self.root.star_export.NodeStar2_export.star8_bj_export
    self.starTotal8 = self.root.star_export.NodeStar2_export.star8_bj_export.starTotal8_export
    self.star15 = self.root.star_export.NodeStar2_export.star8_bj_export.starTotal8_export.star15_export
    self.star16 = self.root.star_export.NodeStar2_export.star8_bj_export.starTotal8_export.star16_export
    self.star9_bj = self.root.star_export.NodeStar2_export.star9_bj_export
    self.starTotal9 = self.root.star_export.NodeStar2_export.star9_bj_export.starTotal9_export
    self.star17 = self.root.star_export.NodeStar2_export.star9_bj_export.starTotal9_export.star17_export
    self.star18 = self.root.star_export.NodeStar2_export.star9_bj_export.starTotal9_export.star18_export
    self.star10_bj = self.root.star_export.NodeStar2_export.star10_bj_export
    self.starTotal10 = self.root.star_export.NodeStar2_export.star10_bj_export.starTotal10_export
    self.star19 = self.root.star_export.NodeStar2_export.star10_bj_export.starTotal10_export.star19_export
    self.star20 = self.root.star_export.NodeStar2_export.star10_bj_export.starTotal10_export.star20_export
    self.starLvNum2 = self.root.star_export.NodeStar2_export.starLvNum2_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRankInfoStar:setData(mData)
    -- body
    self.NodeStar2:setVisible(false)
    self.starLvNum1:setVisible(true)
    self.NodeStar1:setPositionY(-15)
    if mData.lValue == 0 then mData.lValue = 1 end
    local lv = mData.lValue
    local petConfig = global.luaCfg:get_pet_type_by(tonumber(mData.szParams[1] or 0))
    if lv > petConfig.maxLv/2 then
        self.NodeStar2:setVisible(true)
        self.NodeStar1:setPositionY(0)
        self.starLvNum1:setVisible(false)
    end

    local curClass = math.ceil(lv/10) 
    for i=1,10 do
        self["star"..i.."_bj"]:setVisible(false)
        if i<=curClass then
            self["star"..i.."_bj"]:setVisible(true)
        end
    end

    local per = 10
    local curLvClass = math.ceil(lv/per)
    if curLvClass == 1 then
        self.starLvNum1:setString("+"..lv)
    else
        self.starLvNum1:setString("+"..(lv-per*(curLvClass-1)))
        self.starLvNum2:setString("+"..(lv-per*(curLvClass-1)))
    end

end

--CALLBACKS_FUNCS_END

return UIRankInfoStar

--endregion
