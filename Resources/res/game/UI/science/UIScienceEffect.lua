--region UIScienceEffect.lua
--Author : yyt
--Date   : 2017/03/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIScienceStudy = require("game.UI.science.UIScienceStudy")
--REQUIRE_CLASS_END

local UIScienceEffect  = class("UIScienceEffect", function() return gdisplay.newWidget() end )

function UIScienceEffect:ctor()
end

function UIScienceEffect:CreateUI()
    local root = resMgr:createWidget("science/studyEffectNode")
    self:initUI(root)
end

function UIScienceEffect:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "science/studyEffectNode")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node1 = self.root.Node1_export
    self.studyNode1 = self.root.Node1_export.studyNode1_export
    self.studyNode1 = UIScienceStudy.new()
    uiMgr:configNestClass(self.studyNode1, self.root.Node1_export.studyNode1_export)
    self.Node2 = self.root.Node2_export
    self.studyNode2 = self.root.Node2_export.studyNode2_export
    self.studyNode2 = UIScienceStudy.new()
    uiMgr:configNestClass(self.studyNode2, self.root.Node2_export.studyNode2_export)

--EXPORT_NODE_END

    -- 设置父子节点透明度向下传递
    self.Node1:setCascadeOpacityEnabled(true)
    self.Node2:setCascadeOpacityEnabled(true)
    self.studyNode1:setCascadeOpacityEnabled(true)
    self.studyNode2:setCascadeOpacityEnabled(true)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIScienceEffect:onEnter()

    self.nodeTimeLine1 = resMgr:createTimeline("science/studyEffectNode")
    self:runAction(self.nodeTimeLine1)
end

function UIScienceEffect:playEffect()
    self.nodeTimeLine1:play("animation0", false)
end

function UIScienceEffect:setData(data)



    for i=1,2 do
        if data[i] then
            self["studyNode"..i]:setVisible(true)
            self["studyNode"..i]:setData(data[i], handler(self, self.techOver), i)
        else
            self["studyNode"..i]:setVisible(false)
        end
    end

end

-- 研究完成
function UIScienceEffect:techOver(techId, i)
    self["studyNode"..i]:setVisible(false)
end

--CALLBACKS_FUNCS_END

return UIScienceEffect

--endregion
