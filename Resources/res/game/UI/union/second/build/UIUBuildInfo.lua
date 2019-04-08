--region UIUBuildInfo.lua
--Author : yyt
--Date   : 2017/08/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUBuildInfo  = class("UIUBuildInfo", function() return gdisplay.newWidget() end )

function UIUBuildInfo:ctor()
    self:CreateUI()
end

function UIUBuildInfo:CreateUI()
    local root = resMgr:createWidget("union/union_build_info")
    self:initUI(root)
end

function UIUBuildInfo:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_build_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.science_name = self.root.Node_export.science_name_export
    self.icon = self.root.Node_export.icon_export
    self.res_icon = self.root.Node_export.icon_export.res_icon_export
    self.now = self.root.Node_export.now_mlan_5_export
    self.now_text = self.root.Node_export.now_mlan_5_export.now_text_export
    self.next_text = self.root.Node_export.next_mlan_5.next_text_export
    self.upif = self.root.Node_export.upif_mlan_5.upif_export
    self.boom_num = self.root.Node_export.boom_num_export
    self.btn_speed = self.root.Node_export.btn_speed_export
    self.time = self.root.Node_export.btn_speed_export.time_export
    self.ing = self.root.Node_export.ing_mlan_6_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_speed, function(sender, eventType) self:onBuildHandler(sender, eventType) end)
--EXPORT_NODE_END
    
    self.shop = self.root.Node_export.shop_icon
    self.boom = self.root.Node_export.boom_mlan_5

    global.tools:adjustNodePos(self.boom,self.shop)
    global.tools:adjustNodePos(self.shop,self.boom_num)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUBuildInfo:isMaxLv()
    if not self.sData then return end
    return self.sData.lLevel >= self.data.sData.Lvmax
end

function UIUBuildInfo:setData(data,isCanUpgrade)

    self.data = data
    self.sData = global.unionData:getInUnionBuildsBy(self.data.id)
    if not self.sData then return end
    global.panelMgr:setTextureFor(self.res_icon,self.data.sData.icon)
    self.science_name:setString(self.data.sData.name)

    local strs = {}
    local nextLvId = self.data.id*1000+(self.sData.lLevel+1)
    local currLvId = self.data.id*1000+self.sData.lLevel
    -- self.task_btn:setVisible(self.sData.lState == 0)
    -- self.ing:setVisible(self.sData.lState == 1)
    if self:isMaxLv() then
        --等级已满
        strs[1] = "-"
        strs[3] = global.luaCfg:get_local_string(10384)
        strs[4] = "-"
        self.ing:setString(global.luaCfg:get_local_string(10336))
        self.ing:setVisible(true)
        self.btn_speed:setVisible(false)
        -- self.task_btn:setVisible(false)
        -- self.text4:setTextColor(cc.c3b(255,226,165))
        -- self.text1:setTextColor(cc.c3b(255,226,165))
    else
        local nextLvData = global.luaCfg:get_union_build_levle_by(nextLvId)
        self.nextLvData = nextLvData
        local nextEffectData = global.luaCfg:get_union_build_effect_by(nextLvId)
        self.nextEffectData = nextEffectData
        strs[1] = nextLvData.Boom
        strs[3] = nextEffectData.text
        strs[4] = global.luaCfg:get_local_string(10371,nextLvData.hallLv)
        self.time:setString(global.funcGame.formatTimeToHMS(self.nextLvData.time))
        self.ing:setVisible(self.sData.lState == 1)
        self.ing:setString(global.luaCfg:get_local_string(10821))
        self.btn_speed:setVisible(self.sData.lState ~= 1)

        -- if not global.unionData:isEnoughInUnionBuildsHallLv(nextLvData.hallLv) then
        --     self.text4:setTextColor(cc.c3b(180,29,11))
        -- else
        --     self.text4:setTextColor(cc.c3b(255,226,165))
        -- end

        -- if not global.unionData:isEnoughInUnionStrong(nextLvData.Boom) then
        --     self.text1:setTextColor(cc.c3b(180,29,11))
        -- else
        --     self.text1:setTextColor(cc.c3b(255,226,165))
        -- end
    end

    if self.sData.lLevel <= 0 then
        strs[2] = global.luaCfg:get_local_string(10370)
    else
        self.currLvData = global.luaCfg:get_union_build_levle_by(currLvId)
        self.currEffectData = global.luaCfg:get_union_build_effect_by(currLvId)
        strs[2] = global.luaCfg:get_local_string(self.currEffectData.text)
    end

    --繁荣度
    self.boom_num:setString(strs[1])
    --当前效果
    self.now_text:setString(strs[2])
    --升级效果
    self.next_text:setString(strs[3])
    --建设升级条件
    self.upif:setString(strs[4])

    global.tools:adjustNodePosForFather(self.now_text:getParent(),self.now_text)
    global.tools:adjustNodePosForFather(self.next_text:getParent(),self.next_text)
    global.tools:adjustNodePosForFather(self.upif:getParent(),self.upif)


    global.colorUtils.turnGray(self.btn_speed,not isCanUpgrade)
end

function UIUBuildInfo:exitCall(sender, eventType)
    global.panelMgr:closePanel("UIUBuildInfo")
end

function UIUBuildInfo:onBuildHandler(sender, eventType)
    
    -- required int32      lID = 1;//建设id
    -- required int32      lPay = 2;//消耗繁荣度
    -- required int64      lAllyStrong = 3;//当前联盟繁荣度
    -- required uint32     lStartTime = 4;
    -- required uint32     lEndTime = 5;
    if not global.unionData:isHadPower(9) then
        return global.tipsMgr:showWarning("unionPowerNot")
    end
    if global.unionData:getInUnionBuildDoing() then
        return global.tipsMgr:showWarning("UnionBuild05")
    end
    if not self.nextLvData then return end
    if not self:isMaxLv() and not global.unionData:isEnoughInUnionBuildsHallLv(self.nextLvData.hallLv) then
        return global.tipsMgr:showWarning("UnionBuild03",self.nextLvData.hallLv)
    end
    if not self:isMaxLv() and not global.unionData:isEnoughInUnionStrong(self.nextLvData.Boom) then
        return global.tipsMgr:showWarning("UnionBuild04")
    end

    if self.sData then 
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("UnionBuild06", function()
            global.unionApi:startAllyBuild(function(msg)
                -- body
                global.panelMgr:closePanel("UIUBuildInfo")
                global.tipsMgr:showWarning("UnionBuild01")
                gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_PANEL)
            end,self.data.id,lType)
        end,global.funcGame.formatTimeToHMS(self.nextLvData.time),self.sData.lLevel+1,self.data.sData.name)
    end 

end

--CALLBACKS_FUNCS_END

return UIUBuildInfo

--endregion
