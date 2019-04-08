--region UIUnionPro.lua
--Author : wuwx
--Date   : 2016/12/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIUnionPro  = class("UIUnionPro", function() return gdisplay.newWidget() end )

function UIUnionPro:ctor()
    
end

function UIUnionPro:CreateUI()
    local root = resMgr:createWidget("union/union_data_info")
    self:initUI(root)
end

function UIUnionPro:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_data_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.Node_1.name_export
    self.boss = self.root.Node_1.boss_mlan_3.boss_export
    self.battle = self.root.Node_1.battle.battle_export
    self.num = self.root.Node_1.num.num_export
    self.reward = self.root.Node_1.reward_export
    self.language = self.root.Node_1.battle_0.language_export
    self.FileNode_1 = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)

--EXPORT_NODE_END
end

function UIUnionPro:setData(data)
    self.data = data
    --设置旗帜
    self.FileNode_1:setData(self.data.lTotem)

    data.szShortName= data.szShortName or "-"
    self.name:setString(string.format("【%s】%s",data.szShortName,data.szName))
    self.boss:setString(data.szLeader)
    self.num:setString(string.format("%s/%s",self.data.lCount,self.data.lMaxCount))
    self.battle:setString(self.data.lPower)

    self.reward:setString(global.luaCfg:get_local_string(10278,data.lMinBuild,data.lMinPower))

    if data.lLanguage then
        self.language:setString(global.unionData:getUnionLanguage(data.lLanguage))
    else
        self.language:setString(global.unionData:getUnionLanguage(1))
    end
  
    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.boss:getParent(),self.boss)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUnionPro

--endregion
