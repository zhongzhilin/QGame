--region UIGarrisonSelectHero.lua
--Author : yyt
--Date   : 2017/08/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIGarrisonSelectEffect = require("game.UI.castleGarrison.UIGarrisonSelectEffect")
--REQUIRE_CLASS_END

local UIGarrisonSelectHero  = class("UIGarrisonSelectHero", function() return gdisplay.newWidget() end )

function UIGarrisonSelectHero:ctor()
    
end

function UIGarrisonSelectHero:CreateUI()
    local root = resMgr:createWidget("castle_garrison/hero_head_node")
    self:initUI(root)
end

function UIGarrisonSelectHero:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "castle_garrison/hero_head_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.heroNode = self.root.heroNode_export
    self.head = self.root.heroNode_export.head_export
    self.interiorNum = self.root.heroNode_export.interiorNum_export
    self.addInterior = self.root.heroNode_export.interiorNum_export.addInterior_export
    self.hero_quality = self.root.heroNode_export.hero_quality_export
    self.noSelectHero = self.root.noSelectHero_export
    self.effectNode = self.root.effectNode_export
    self.FileNode_1 = self.root.effectNode_export.FileNode_1_export
    self.FileNode_1 = UIGarrisonSelectEffect.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.effectNode_export.FileNode_1_export)
    self.FileNode_2 = self.root.effectNode_export.FileNode_2_export
    self.FileNode_2 = UIGarrisonSelectEffect.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.effectNode_export.FileNode_2_export)
    self.FileNode_3 = self.root.effectNode_export.FileNode_3_export
    self.FileNode_3 = UIGarrisonSelectEffect.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.effectNode_export.FileNode_3_export)
    self.FileNode_4 = self.root.effectNode_export.FileNode_4_export
    self.FileNode_4 = UIGarrisonSelectEffect.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.effectNode_export.FileNode_4_export)
    self.FileNode_5 = self.root.effectNode_export.FileNode_5_export
    self.FileNode_5 = UIGarrisonSelectEffect.new()
    uiMgr:configNestClass(self.FileNode_5, self.root.effectNode_export.FileNode_5_export)

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGarrisonSelectHero:setData(data, firstData)
    -- body
    self.data = data
    self.heroNode:setVisible(false)
    self.noSelectHero:setVisible(false)
    self.effectNode:setVisible(true)
    if data then

        self.heroNode:setVisible(true)
        local heroData = luaCfg:get_hero_property_by(data.lid)
        global.panelMgr:setTextureFor(self.head, heroData.nameIcon)
        self.hero_quality:setVisible(heroData.Strength == 3)
        self.addInterior:setVisible(false)
        self.interiorNum:setString(global.luaCfg:get_translate_string(10827, data.toaInterior or 0))
        if firstData and (firstData.addInterior ~= 0) then
            
            self.addInterior:setVisible(true)
            if firstData.addInterior > 0 then
                self.addInterior:setTextColor(cc.c3b(87, 213, 63))
                self.addInterior:setString("+" .. firstData.addInterior)
            else
                self.addInterior:setTextColor(gdisplay.COLOR_RED)
                self.addInterior:setString(firstData.addInterior)
            end
        end

        global.tools:adjustNodePosForFather(self.addInterior:getParent(),self.addInterior)
        
        local getCommonBuffs = function (desbuffs)
            -- body
            for _,v in pairs(firstData.nodeData.tagBuffDetail) do
                if v.lBuffid == desbuffs.lBuffid then
                    return v
                end
            end
            return nil
        end

        for i=1,5 do
            self["FileNode_"..i]:setVisible(false)
            local buffs = data.tagBuffDetail or {}
            if buffs[i] then
                self["FileNode_"..i]:setVisible(true)
                if firstData and firstData.nodeData then
                    self["FileNode_"..i]:setData(buffs[i], getCommonBuffs(buffs[i]))
                else
                    self["FileNode_"..i]:setData(buffs[i])
                end
            end
        end

    else
        self.effectNode:setVisible(false)
        self.noSelectHero:setVisible(true)
    end

end

--CALLBACKS_FUNCS_END

return UIGarrisonSelectHero

--endregion
