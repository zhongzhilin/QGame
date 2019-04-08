--region UISelectItem.lua
--Author : yyt
--Date   : 2016/09/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISelectItem  = class("UISelectItem", function() return gdisplay.newWidget() end )
local UIISoldierTipsControl = require("game.UI.common.UIISoldierTipsControl")

function UISelectItem:ctor()
    self:CreateUI()
end

function UISelectItem:CreateUI()
    local root = resMgr:createWidget("troop/soldier_node_1")
    self:initUI(root)
end

function UISelectItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "troop/soldier_node_1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.soldier_bg = self.root.soldier_bg_export
    self.node_icon = self.root.soldier_bg_export.soldier_panel.node_icon_export
    self.number = self.root.soldier_bg_export.soldier_number_bg.number_export
    self.star = self.root.soldier_bg_export.star_export
    self.star1_bj = self.root.soldier_bg_export.star_export.star1_bj_export
    self.star1 = self.root.soldier_bg_export.star_export.star1_bj_export.star1_export
    self.star2 = self.root.soldier_bg_export.star_export.star1_bj_export.star2_export
    self.star2_bj = self.root.soldier_bg_export.star_export.star2_bj_export
    self.star3 = self.root.soldier_bg_export.star_export.star2_bj_export.star3_export
    self.star4 = self.root.soldier_bg_export.star_export.star2_bj_export.star4_export
    self.star3_bj = self.root.soldier_bg_export.star_export.star3_bj_export
    self.star5 = self.root.soldier_bg_export.star_export.star3_bj_export.star5_export
    self.star6 = self.root.soldier_bg_export.star_export.star3_bj_export.star6_export
    self.chief = self.root.soldier_bg_export.chief_export

--EXPORT_NODE_END
    self.soldierId = 0
    self.curNumber = 0
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UISelectItem:setData(data)
    self.data= data
    local soldier_data = luaCfg:get_soldier_train_by(data.lID)
    global.tools:setSoldierBust(self.node_icon,soldier_data)
    self.node_icon.pic:setScale(0.75)
    self.soldier_data = soldier_data

	self.number:setString(data.lCount)
    self.soldierId = data.lID
    if data.lCount == 0 then
        self.soldier_bg:setScale(0)
    else
        self.soldier_bg:setScale(1)
    end
    self.curNumber = data.lCount

    self.chief:setVisible(data.isChief == 1)

    if soldier_data.race ~= 0 then
        local raceData = global.luaCfg:get_race_by(soldier_data.race)
        global.panelMgr:setTextureFor(self.soldier_bg.Image_1, raceData.soldierBg)
    else
        self.soldier_bg.Image_1:loadTexture("troops_soldier_bg1.jpg", ccui.TextureResType.plistType)
    end

    local showlvStar = function (lGrade)
        self.star:setVisible(lGrade ~= -1)
        for i=1,6 do
            self["star"..i]:setVisible(lGrade >= i*5)
        end
    end
    local id,dataBuild = global.cityData:getBuildingIdBySoldierId(data.lID)
    if soldier_data.race ~=0 and  dataBuild and dataBuild.serverData and (soldier_data.type ~= 0) then
        showlvStar(dataBuild.serverData.lGrade or 1)
    else
        showlvStar(-1)
    end
end

function UISelectItem:addtips()
    self.m_TipsControl = UIISoldierTipsControl.new()
    if self.data.tips_panel and   self.data.tips_panel.tips_node then 
        local tips_node = self.data.tips_panel.tips_node
        local soldier_train  = clone(global.luaCfg:get_soldier_train_by(self.data.lID))
        self.m_TipsControl:setdata(self.soldier_bg ,soldier_train,tips_node)
    end 
end

function UISelectItem:onExit()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
    end 
end


--CALLBACKS_FUNCS_END

return UISelectItem

--endregion
