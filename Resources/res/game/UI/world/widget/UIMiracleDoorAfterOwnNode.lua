--region UIMiracleDoorAfterOwnNode.lua
--Author : Untory
--Date   : 2017/09/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIMiracleDoorAfterOwnNode  = class("UIMiracleDoorAfterOwnNode", function() return gdisplay.newWidget() end )

function UIMiracleDoorAfterOwnNode:ctor()
    
end

function UIMiracleDoorAfterOwnNode:CreateUI()
    local root = resMgr:createWidget("wild/temple_occupy_node")
    self:initUI(root)
end

function UIMiracleDoorAfterOwnNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/temple_occupy_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.flag = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.flag, self.root.Node_1.flag)
    self.lord = self.root.Node_1.lord_mlan_5.lord_export
    self.league = self.root.Node_1.league_mlan_5.league_export
    self.league_boss = self.root.Node_1.league_boss_mlan_3.league_boss_export
    self.reward1 = self.root.Node_1.reward_mlan_8.reward1_export
    self.occ_time = self.root.Node_1.last_time_mlan_7.occ_time_export
    self.protect_desc = self.root.Node_1.protect_desc_export
    self.time = self.root.Node_1.protect_desc_export.time_export
    self.tips = self.root.Node_1.tips_mlan_40_export

--EXPORT_NODE_END
end

function UIMiracleDoorAfterOwnNode:setData( data , city )
    
    self.lord:setString('-')
    self.league:setString('-')
    self.league_boss:setString('-')
    self.reward1:setString(str)
    self.flag:setData(0)    

    self.occ_time:setString('-')
    self.time:setString('-')

    if city:isInProtect() then

        self.isInProtect = true
        self.protect_desc:setString(luaCfg:get_local_string(10846))
    else

        self.isInProtect = false
        self.protect_desc:setString(luaCfg:get_local_string(10847))
    end

    global.tools:adjustNodePosForFather(self.protect_desc,self.time)

    global.worldApi:LegendMiracleOccupyInfo(city:getId(),function(msg)

        dump(msg,">>>msg")

        self.lord:setString(msg.szUsername)
        self.league:setString(msg.szAllyName and ('【' .. msg.szAllyName .. '】') or '-')
        self.league_boss:setString(msg.szAllyLeader or '-')
        self.flag:setData(msg.lTotem)    
        self.reward1:setString(msg.lBuffNum .. "%")

        if city:isInProtect() then
            self.reward1:setString('-')
        end

        self:startCheckTime()
        self.proTime = msg.lprotect
        self.occTime = msg.lOccTime
        self:checkTime()
    end) 

    --润稿处理 张亮
    global.tools:adjustNodePosForFather(self.lord:getParent(),self.lord)
    global.tools:adjustNodePosForFather(self.league:getParent(),self.league)
    global.tools:adjustNodePosForFather(self.league_boss:getParent(),self.league_boss)
    global.tools:adjustNodePosForFather(self.occ_time:getParent(),self.occ_time)
    global.tools:adjustNodePosForFather(self.reward1:getParent(),self.reward1)
end


function UIMiracleDoorAfterOwnNode:onExit()

    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end
end

-- function UIMiracleDoorAfterOwnNode:isInProtect()
    
--     print("self.isInProtect",self.isInProtect)
--     return self.isInProtect    
-- end

function UIMiracleDoorAfterOwnNode:checkTime()
    
    local contentTime = global.dataMgr:getServerTime()
    local proLeftTime = self.proTime - contentTime
    local occTime = contentTime - self.occTime
    
    if occTime <= 0 then

        -- self.occ_time:setString("00:00:00")
        occTime = 0
    end

    if proLeftTime <= 0 then

        -- self.time:setString("00:00:00")
        proLeftTime = 0
    end

    self.time:setString(global.troopData:timeStringFormat(proLeftTime))
    self.occ_time:setString(global.troopData:timeStringFormat(occTime))

    if self.isInProtect then
        self.occ_time:setString("-")
    end
end

function UIMiracleDoorAfterOwnNode:startCheckTime()
    
    if self.scheduleListenerId then

        gscheduler.unscheduleGlobal(self.scheduleListenerId)
    end

    self.scheduleListenerId = gscheduler.scheduleGlobal(function()
        
        if self.checkTime then 
            self:checkTime()
        end 
        
    end, 1) 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIMiracleDoorAfterOwnNode

--endregion
