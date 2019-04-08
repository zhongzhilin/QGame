--region UIWildTownPro.lua
--Author : untory
--Date   : 2016/12/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWildTownPro  = class("UIWildTownPro", function() return gdisplay.newWidget() end )

function UIWildTownPro:ctor()
    
end

function UIWildTownPro:CreateUI()
    local root = resMgr:createWidget("wild/wild_camp_currency")
    self:initUI(root)
end

function UIWildTownPro:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/wild_camp_currency")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.star1 = self.root.Node_1.lv_mlan_5.star1_export
    self.star2 = self.root.Node_1.lv_mlan_5.star2_export
    self.star3 = self.root.Node_1.lv_mlan_5.star3_export
    self.star4 = self.root.Node_1.lv_mlan_5.star4_export
    self.star5 = self.root.Node_1.lv_mlan_5.star5_export
    self.type = self.root.Node_1.type_mlan_5.type_export
    self.loadingbar_bg = self.root.Node_1.hp_mlan_7.loadingbar_bg_export
    self.loading = self.root.Node_1.hp_mlan_7.loadingbar_bg_export.loading_export
    self.lord = self.root.Node_1.hp_mlan_7.loadingbar_bg_export.lord_export
    self.tips = self.root.Node_1.hp_mlan_7.loadingbar_bg_export.lord_export.tips_export
    self.hp = self.root.Node_1.hp_mlan_7.loadingbar_bg_export.hp_export
    self.rest_time = self.root.Node_1.recover_mlan_7.rest_time_export
    self.success = self.root.Node_1.success_mlan_5.success_mlan_24_export
    self.level = self.root.Node_1.level_mlan_7.level_export
    self.failed = self.root.Node_1.failed_mlan_5.failed_mlan_24_export
    self.type_icon = self.root.Node_1.type_bj.type_icon_export

--EXPORT_NODE_END
    self.success1 = self.success
    self.failed1 = self.failed
end

function UIWildTownPro:setData( cfgData , data , surfaceData , plusData)
    
    -- self.lv:setString(cfgData.lv)
    dump(data,"plusData...")

    cfgData.lv = cfgData.lv or 0
    for i = 1,5 do
        self["star"..i]:setVisible(i <= cfgData.lv)
    end

    cfgData.hp = cfgData.hp or 0 

    self.hp:setString(string.format("%s/%s",data.lCurHp,cfgData.hp))
    local pen = data.lCurHp / cfgData.hp * 100
    self.loading:setPercent(pen)
    self.tips:setPositionX(data.lCurHp / cfgData.hp * 392)
    -- self.recover:setString("测试")
    --print(self.recover:convertToWorldSpace(cc.p(0,0)).x,">>>>X")
    -- self.recover:setString(string.format(luaCfg:get_local_string(10844),cfgData.hpRecover))
    -- self.success:setString(string.format(luaCfg:get_local_string(10204),cfgData.damage))
    -- self.failed:setString(string.format(luaCfg:get_local_string(10204),cfgData.hp))
    -- self.type_icon:setSpriteFrame(surfaceData.worldmap)
    global.panelMgr:setTextureFor(self.type_icon,surfaceData.worldmap)
    self.type_icon:setScale(surfaceData.iconSize)
    self.level:setString(cfgData.reqLv)

    local typeStr = ""
    for i,v in ipairs(plusData) do

        local id = v.lID
        local league1count = v.lValue
        local league1Cfg = luaCfg:get_data_type_by(id)

        typeStr = typeStr .. (i == 1 and '' or '\n') .. string.format("%s+%s%s%s",league1Cfg.paraName,league1count,league1Cfg.str,league1Cfg.extra)
    end

    if not data.lflushtime then
        self.rest_time:setString(global.funcGame.formatTimeToMS(0))
    else
        self:startCheckTime()
        self.flushEndTime = data.lflushtime
        self:checkTime()
    end

    self.type:setString(typeStr)

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.type:getParent(),self.type)
    -- global.tools:adjustNodePosForFather(self.hp:getParent(),self.hp)
    global.tools:adjustNodePosForFather(self.rest_time:getParent(),self.rest_time)
    global.tools:adjustNodePosForFather(self.level:getParent(),self.level)

    global.tools:adjustNodePosForFather(self.success1:getParent(),self.success1)
    -- global.tools:adjustNodePos(self.success1,self.success)
    global.tools:adjustNodePosForFather(self.failed1:getParent(),self.failed1)
    -- global.tools:adjustNodePos(self.failed1,self.failed)
end

function UIWildTownPro:onExit()

    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end
end

function UIWildTownPro:checkTime()
    
    local contentTime = self.flushEndTime - global.dataMgr:getServerTime()
    if contentTime < 0 then contentTime = 0 end

    if contentTime == 0 then

        self.rest_time:setString("00:00")
        return
    end

    local str = global.funcGame.formatTimeToMS(contentTime) --global.troopData:timeStringFormat(contentTime)
    self.rest_time:setString(str)
end

function UIWildTownPro:startCheckTime()
    
    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end

    self.scheduleListenerId = gscheduler.scheduleGlobal(function()

        if self.checkTime then  -- protect 
            self:checkTime()
        end 
    end, 1) 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIWildTownPro

--endregion
