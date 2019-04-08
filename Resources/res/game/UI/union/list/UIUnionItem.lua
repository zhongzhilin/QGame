--region UIUnionItem.lua
--Author : wuwx
--Date   : 2016/12/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIUnionItem  = class("UIUnionItem", function() return gdisplay.newWidget() end )

function UIUnionItem:ctor()
    self:CreateUI()
end

function UIUnionItem:CreateUI()
    local root = resMgr:createWidget("union/union_list_info")
    self:initUI(root)
end

function UIUnionItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_list_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.FileNode_1 = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.info_bg.FileNode_1)
    self.name = self.root.info_bg.name_export
    self.language = self.root.info_bg.language.language_export
    self.num = self.root.info_bg.union_num.num_export
    self.battle = self.root.info_bg.union_battle.battle_export

--EXPORT_NODE_END
    self.root.info_bg:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
end

function UIUnionItem:setData(data)
    
    self.data = data
    --设置旗帜
    self.FileNode_1:setData(self.data.lTotem)

    local szShortName = global.unionData:getUnionShortName(data.szShortName)
    self.name:setString(string.format("%s%s",szShortName,data.szName))
    -- self.leader_name:setString(data.lLeader)

    if data.lLanguage then
        self.language:setString(global.unionData:getUnionLanguage(data.lLanguage))
    else
        self.language:setString(global.unionData:getUnionLanguage(1))
    end
    self.num:setString(string.format("%s/%s",data.lCount,data.lMaxCount))
    if data.lPower then
        self.battle:setString(data.lPower)
    end

    self.root.info_bg:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUnionItem

--endregion
