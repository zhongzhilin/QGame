--region UIUnionModifyName.lua
--Author : wuwx
--Date   : 2017/01/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIUnionModifyName  = class("UIUnionModifyName", function() return gdisplay.newWidget() end )

function UIUnionModifyName:ctor()
    self:CreateUI()
end

function UIUnionModifyName:CreateUI()
    local root = resMgr:createWidget("union/union_abbreviation")
    self:initUI(root)
end

function UIUnionModifyName:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_abbreviation")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.Node_5.name_export
    self.free_btn = self.root.Node_export.Node_5.free_btn_export
    self.charge_btn = self.root.Node_export.Node_5.charge_btn_export
    self.dia_icon = self.root.Node_export.Node_5.charge_btn_export.dia_icon_export
    self.dia_num = self.root.Node_export.Node_5.charge_btn_export.dia_num_export
    self.tips = self.root.Node_export.Node_1.tips_export
    self.info2 = self.root.Node_export.Node_1.info2_export
    self.input = self.root.Node_export.Node_1.input_export
    self.input = UIInputBox.new()
    uiMgr:configNestClass(self.input, self.root.Node_export.Node_1.input_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.free_btn, function(sender, eventType) self:freeSaveHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.charge_btn, function(sender, eventType) self:chargeSaveHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIUnionModifyName:onEnter()
end

-- i_type = 1:修改简称，2：修改名称
function UIUnionModifyName:setData(i_type)
    self.data = global.unionData:getInUnion()
    self.m_type = i_type or self.m_type
    self.m_costRmb = 0

    if self.m_type == 1 then
        --简称
        self.info2:setString(global.luaCfg:get_local_string(10334))
        self.name:setString(global.luaCfg:get_local_string(10295))
        self.tips:setString(global.luaCfg:get_local_string(10297))
        self.input:setMaxLength(3)
        self.input:setString(self.data.szShortName)
        if not self.data.lFlagChg or self.data.lFlagChg <= 0 then
            self.data.lFlagChg = 0
            self.m_costRmb = 0
        else
            self.m_costRmb = global.luaCfg:get_config_by(1).unionNet
        end
    else
        self.info2:setString(global.luaCfg:get_local_string(10335))
        self.name:setString(global.luaCfg:get_local_string(10296))
        self.tips:setString(global.luaCfg:get_local_string(10298))
        self.input:setMaxLength(20)
        self.input:setString(self.data.szName)

        if not self.data.lNameChg or self.data.lNameChg <= 0 then
            self.data.lNameChg = 0
            self.m_costRmb = 0
        else
            self.m_costRmb = global.luaCfg:get_config_by(1).unionName
        end
    end

    self.free_btn:setVisible(self.m_costRmb<=0)
    self.charge_btn:setVisible(self.m_costRmb>0)
    self.dia_num:setString(self.m_costRmb)
    global.tools:adjustNodePos(self.dia_icon,self.dia_num)
end

function UIUnionModifyName:save()
    if not global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND, self.m_costRmb, self.dia_num) then
        return 
    end
    local param ={}
    if self.m_type == 1 then
        param ={
            szShortName = self.input:getString(),
            lUpdateID={2}
        }
        if param.szShortName == self.data.szShortName then
            return global.tipsMgr:showWarning("NameCantChange")
        end
        if #param.szShortName ~= 3 then
            return global.tipsMgr:showWarning("unionSimple")
        end
    else
        param ={
            szName = self.input:getString(),
            lUpdateID={1}
        }
        if param.szName == self.data.szName then
            return global.tipsMgr:showWarning("NameCantChange")
        end

        if #param.szName < 3 then
            return global.tipsMgr:showWarning("12")
        end
    end
    global.unionApi:setAllyUpdate(param, function()
        if self.m_type == 1 then
            self.data.szShortName = param.szShortName
            self.data.lFlagChg = self.data.lFlagChg + 1
        else
            self.data.szName = param.szName
            self.data.lNameChg = self.data.lNameChg + 1
        end
        global.unionData:setInUnion(self.data)
        global.tipsMgr:showWarning("RenameSuccess")
        global.panelMgr:closePanel("UIUnionModifyName")
        gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL,true)
    end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionModifyName:onCloseHanler(sender, eventType)

    global.panelMgr:closePanel("UIUnionModifyName")
end

function UIUnionModifyName:freeSaveHandler(sender, eventType)

    self:save()
end

function UIUnionModifyName:chargeSaveHandler(sender, eventType)

    self:save()
end
--CALLBACKS_FUNCS_END

return UIUnionModifyName

--endregion
