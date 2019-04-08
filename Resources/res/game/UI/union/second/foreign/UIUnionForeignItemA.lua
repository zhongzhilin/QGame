--region UIUnionForeignItemA.lua
--Author : wuwx
--Date   : 2017/01/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIUnionForeignItemA  = class("UIUnionForeignItemA", function() return gdisplay.newWidget() end )

function UIUnionForeignItemA:ctor()
    self:CreateUI()
end

function UIUnionForeignItemA:CreateUI()
    local root = resMgr:createWidget("union/union_foreign_apply")
    self:initUI(root)
end

function UIUnionForeignItemA:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_foreign_apply")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.union_name = self.root.Image_4.union_name_export
    self.desc = self.root.Image_4.desc_export
    self.flag = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.flag, self.root.Image_4.flag)
    self.btn_agree = self.root.btn_agree_export
    self.btn_refuse = self.root.btn_refuse_export
    self.btn_cancel = self.root.btn_cancel_export

    uiMgr:addWidgetTouchHandler(self.btn_agree, function(sender, eventType) self:agreeHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_refuse, function(sender, eventType) self:refuseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_cancel, function(sender, eventType) self:cancelHandler(sender, eventType) end)
--EXPORT_NODE_END
end

local descs = {
    [WCONST.UNION_RELATION.FRIEND] = 10320,
    [WCONST.UNION_RELATION.NEUTRAL] = 10321
}

local colors = {
    [WCONST.UNION_RELATION.FRIEND]  = cc.c3b(87 , 213, 63),
    [WCONST.UNION_RELATION.NEUTRAL] = cc.c3b(255, 208, 65)
}
function UIUnionForeignItemA:setData(data)
    self.data = data

    --设置旗帜
    self.flag:setData(self.data.lTotem)

    local szShortName = global.unionData:getUnionShortName(data.szShortName)
    self.union_name:setString(string.format("%s%s",szShortName,data.szName))

    self.btn_cancel:setVisible(self.data.isMineUnion)
    self.btn_agree:setVisible(not self.data.isMineUnion)
    self.btn_refuse:setVisible(not self.data.isMineUnion)

    self.desc:setString(global.luaCfg:get_local_string(descs[self.data.lRelation]))
    self.desc:setTextColor(colors[self.data.lRelation])
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUnionForeignItemA:agreeHandler(sender, eventType)

    local errorKeys = {
        [WCONST.UNION_RELATION.NEUTRAL] = "UnionForeign22",
        [WCONST.UNION_RELATION.FRIEND] = "UnionForeign20",
    }

    local showKeys = {
        [WCONST.UNION_RELATION.NEUTRAL] = "UnionForeign23",
        [WCONST.UNION_RELATION.FRIEND] = "UnionForeign21",
    }

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(errorKeys[self.data.lRelation], function()
        -- body
        global.unionApi:setAllyRelation(function(msg)
            global.tipsMgr:showWarning(showKeys[self.data.lRelation])
        end,2,self.data.lID,self.data.lRelation)
    end,self.union_name:getString())
end

function UIUnionForeignItemA:refuseHandler(sender, eventType)
    local errorKeys = {
        [WCONST.UNION_RELATION.NEUTRAL] = "UnionForeign25",
        [WCONST.UNION_RELATION.FRIEND] = "UnionForeign24",
    }

    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(errorKeys[self.data.lRelation], function()
        -- body
        global.unionApi:setAllyRelation(function(msg)
            global.tipsMgr:showWarning("UnionForeign26")
        end,2,self.data.lID,-1)
    end,self.union_name:getString())
end

function UIUnionForeignItemA:cancelHandler(sender, eventType)

    local errorKeys = {
        [WCONST.UNION_RELATION.NEUTRAL] = "UnionForeign17",
        [WCONST.UNION_RELATION.FRIEND] = "UnionForeign16",
    }
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData(errorKeys[self.data.lRelation], function()
        -- body
        global.unionApi:setAllyRelation(function(msg)
            global.tipsMgr:showWarning("UnionForeign27")
        end,3,self.data.lID,-1)
    end)
end
--CALLBACKS_FUNCS_END

return UIUnionForeignItemA

--endregion
