--region UIMiracleStarUpPro.lua
--Author : Untory
--Date   : 2018/02/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMiracleStarUpPro  = class("UIMiracleStarUpPro", function() return gdisplay.newWidget() end )

function UIMiracleStarUpPro:ctor()
    
end

function UIMiracleStarUpPro:CreateUI()
    local root = resMgr:createWidget("hero/miracle_star_up_pro")
    self:initUI(root)
end

function UIMiracleStarUpPro:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero/miracle_star_up_pro")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.pro = self.root.pro_export
    self.pro_num = self.root.pro_num_export
    self.pro_next = self.root.pro_next_export

--EXPORT_NODE_END
end

function UIMiracleStarUpPro:setData( buffData , plus , nowPlus )
    self:setVisible(true)

    local id = buffData[1]
    local league1count = buffData[2]
    local league1Cfg = luaCfg:get_data_type_by(id)

    self.pro:setString(league1Cfg.paraName)
    self.pro_num:setString(string.format('+%s%s%s',math.ceil(league1count * (nowPlus / 100)),league1Cfg.str,league1Cfg.extra))
    self.pro_next:setString(string.format('+%s%s%s',math.ceil(league1count * (plus / 100)),league1Cfg.str,league1Cfg.extra))
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIMiracleStarUpPro

--endregion
