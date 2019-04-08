--region UIPassDoorPanel.lua
--Author : untory
--Date   : 2017/01/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPassDoorPanel  = class("UIPassDoorPanel", function() return gdisplay.newWidget() end )

function UIPassDoorPanel:ctor()
    self:CreateUI()
end

function UIPassDoorPanel:CreateUI()
    local root = resMgr:createWidget("world/mainland/fly_door")
    self:initUI(root)
end

function UIPassDoorPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mainland/fly_door")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.name_export
    self.info = self.root.Node_export.info_mlan_56_export
    self.num = self.root.Node_export.scale_mlan_6.num_export
    self.collection = self.root.Node_export.collection_export
    self.reward = self.root.Node_export.reward_export
    local FileNode_1_TimeLine = resMgr:createTimeline("effect/Transfer_door")
    FileNode_1_TimeLine:play("animation0", true)
    self.root.Node_export.FileNode_1:runAction(FileNode_1_TimeLine)

    uiMgr:addWidgetTouchHandler(self.root.Panel, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.collection, function(sender, eventType) self:collect_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.reward, function(sender, eventType) self:rewardHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIPassDoorPanel:setData()
    

end

function UIPassDoorPanel:onEnter()
   
    -- local str = luaCfg:get_local_string(10300,luaCfg:get_map_region_by(global.g_worldview.areaDataMgr.areaId).name) 
    -- self.name:setString(str)

    local FileNode_1_TimeLine = resMgr:createTimeline("effect/Transfer_door")
    FileNode_1_TimeLine:play("animation0", true)
    self.root.Node_export.FileNode_1:runAction(FileNode_1_TimeLine)
end

function UIPassDoorPanel:setCity( city )
    
    self.city = city
    self.name:setString(city:getName())

    self.curSoldierScale = 0
    self.maxSoldierScale = 0

    -- 驻防规模上限
    self:setGarrisonLimit()

    -- 获取所有驻防部队信息
    self:setGarrisonTroop()
end

function UIPassDoorPanel:setGarrisonTroop()

    local troop = global.troopData:getOwnTroopsByCityId(self.city:getId())
    local curSoldierScale = 0
    for _,v in ipairs(troop) do
        if v.lUserID == global.userData:getUserId() then
            local scale = global.troopData:getTroopsScaleByData(v.tgWarrior)
            curSoldierScale = curSoldierScale + scale
        end
    end
    self.curSoldierScale = curSoldierScale
    
end

function UIPassDoorPanel:setGarrisonLimit()

    global.gmApi:effectBuffer({{lType = luaCfg:get_buildings_pos_by(4).funcType, lBind = 4}},function(msg)
        
        if not self.num then return end
        local maxSoldierScale = 0
        msg.tgEffect[1] = msg.tgEffect[1] or {}
        local buffs = msg.tgEffect[1].tgEffect or {}
        for i,v in ipairs(buffs) do
            if v.lEffectID == 48 then
                maxSoldierScale = maxSoldierScale + v.lVal
            end
        end

        self.maxSoldierScale = maxSoldierScale
        self.num:setString(self.curSoldierScale .. "/" .. self.maxSoldierScale)

        global.tools:adjustNodePosForFather(self.num:getParent(),self.num)

    end)  
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPassDoorPanel:collect_click(sender, eventType)

    global.troopData:setTargetData(4)
    global.panelMgr:openPanel("UITroopPanel")   
end         

function UIPassDoorPanel:rewardHandler(sender, eventType)

    global.panelMgr:openPanel("UIChooseLand")
end

function UIPassDoorPanel:exit_call(sender, eventType)

    global.panelMgr:closePanel("UIPassDoorPanel")
end
--CALLBACKS_FUNCS_END

return UIPassDoorPanel

--endregion
