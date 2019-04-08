--region UIUnionForeignChoicePanel.lua
--Author : wuwx
--Date   : 2017/01/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionForeignChoicePanel  = class("UIUnionForeignChoicePanel", function() return gdisplay.newWidget() end )

function UIUnionForeignChoicePanel:ctor()
    self:CreateUI()
end

function UIUnionForeignChoicePanel:CreateUI()
    local root = resMgr:createWidget("union/union_foreign_add")
    self:initUI(root)
end

function UIUnionForeignChoicePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_foreign_add")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.Node_5.name_mlan_15_export
    self.foreign_1 = self.root.Node_export.foreign_1_export
    self.foreign_2 = self.root.Node_export.foreign_2_export
    self.foreign_3 = self.root.Node_export.foreign_3_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.foreign_1_export.btn, function(sender, eventType) self:friendHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.foreign_2_export.btn, function(sender, eventType) self:enemyHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.foreign_3_export.btn, function(sender, eventType) self:midHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIUnionForeignChoicePanel:setData(data)
    self.data = data
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionForeignChoicePanel:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIUnionForeignChoicePanel")
end

function UIUnionForeignChoicePanel:friendHandler(sender, eventType)
    --友好
    if self.data.lRelation == WCONST.UNION_RELATION.FRIEND then
        return global.tipsMgr:showWarning("309")
    end
    local errorKeys = {
        [WCONST.UNION_RELATION.NEUTRAL] = "UnionForeign4",
        [WCONST.UNION_RELATION.HOSTILE] = "UnionForeign8",
    }

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(errorKeys[self.data.lRelation], function()
        -- body
        global.unionApi:setAllyRelation(function(msg)
            global.tipsMgr:showWarning("UnionForeign12")
            global.panelMgr:closePanel("UIUnionForeignChoicePanel")
        end,1,self.data.lID,WCONST.UNION_RELATION.FRIEND)
    end)
end

function UIUnionForeignChoicePanel:enemyHandler(sender, eventType)
    --敌对
    if self.data.lRelation == WCONST.UNION_RELATION.HOSTILE then
        return global.tipsMgr:showWarning("310")
    end
    local errorKeys = {
        [WCONST.UNION_RELATION.NEUTRAL] = "UnionForeign5",
        [WCONST.UNION_RELATION.FRIEND] = "UnionForeign6",
    }

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(errorKeys[self.data.lRelation], function()
        -- body
        global.unionApi:setAllyRelation(function(msg)
            global.tipsMgr:showWarning("UnionForeign14")
            self.data.lRelation = WCONST.UNION_RELATION.HOSTILE
            global.panelMgr:closePanel("UIUnionForeignChoicePanel")
        end,1,self.data.lID,WCONST.UNION_RELATION.HOSTILE)
    end)
end

function UIUnionForeignChoicePanel:midHandler(sender, eventType)
    --中立
    if self.data.lRelation == WCONST.UNION_RELATION.NEUTRAL then
        return global.tipsMgr:showWarning("308")
    end
    local errorKeys = {
        [WCONST.UNION_RELATION.HOSTILE] = "UnionForeign9",
        [WCONST.UNION_RELATION.FRIEND] = "UnionForeign7",
    }

    local showKeys = {
        [WCONST.UNION_RELATION.HOSTILE] = "UnionForeign13",
        [WCONST.UNION_RELATION.FRIEND] = "UnionForeign15",
    }
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(errorKeys[self.data.lRelation], function()
        -- body
        global.unionApi:setAllyRelation(function(msg)
            if self.data.lRelation == WCONST.UNION_RELATION.FRIEND then
                self.data.lRelation = WCONST.UNION_RELATION.NEUTRAL
            end
            global.tipsMgr:showWarning(showKeys[self.data.lRelation])
            global.panelMgr:closePanel("UIUnionForeignChoicePanel")
        end,1,self.data.lID,WCONST.UNION_RELATION.NEUTRAL)
    end)
end
--CALLBACKS_FUNCS_END

return UIUnionForeignChoicePanel

--endregion
