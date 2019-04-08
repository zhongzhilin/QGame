--region UIUnionForeignItemE.lua
--Author : wuwx
--Date   : 2017/01/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIUnionForeignItemE  = class("UIUnionForeignItemE", function() return gdisplay.newWidget() end )

function UIUnionForeignItemE:ctor()
    self:CreateUI()
end

function UIUnionForeignItemE:CreateUI()
    local root = resMgr:createWidget("union/union_foreign_list")
    self:initUI(root)
end

function UIUnionForeignItemE:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_foreign_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.union_name = self.root.bg.union_name_export
    self.boss_name = self.root.bg.boss_name_export
    self.lv = self.root.bg.lv_export
    self.num = self.root.bg.num_export
    self.relation = self.root.bg.relation_export
    self.modify = self.root.bg.modify_export
    self.flag = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.flag, self.root.bg.flag)

    uiMgr:addWidgetTouchHandler(self.modify, function(sender, eventType) self:editRelationHandler(sender, eventType) end)
--EXPORT_NODE_END
end

local relations = {
    [WCONST.UNION_RELATION.FRIEND]  = {localId=10322,color=cc.c3b(87 , 213, 63)},
    [WCONST.UNION_RELATION.NEUTRAL] = {localId=10323,color=cc.c3b(255, 208, 65)},
    [WCONST.UNION_RELATION.HOSTILE] = {localId=10324,color=cc.c3b(180, 29 , 11)},
}
function UIUnionForeignItemE:setData(data)
    self.data = data

    --设置旗帜
    self.flag:setData(self.data.lTotem)

    local szShortName = global.unionData:getUnionShortName(data.szShortName)
    self.union_name:setString(string.format("%s%s",szShortName,data.szName))
    self.boss_name:setString(data.szLeader)

    self.num:setString(data.lCount)
    self.lv:setString(data.lLevel)

    self.relation:setString(global.luaCfg:get_local_string(relations[self.data.lRelation].localId))
    self.relation:setTextColor(relations[self.data.lRelation].color)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionForeignItemE:editRelationHandler(sender, eventType)
    if not global.unionData:isHadPower(23) then
        return global.tipsMgr:showWarning("unionPowerNot")
    end
    global.panelMgr:openPanel("UIUnionForeignChoicePanel"):setData(self.data)
end

function UIUnionForeignItemE:clickHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIUnionForeignItemE

--endregion
