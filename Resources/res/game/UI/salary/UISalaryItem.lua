--region UISalaryItem.lua
--Author : yyt
--Date   : 2017/02/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local refershData = global.refershData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISalaryItem  = class("UISalaryItem", function() return gdisplay.newWidget() end )

function UISalaryItem:ctor()
   
end

function UISalaryItem:CreateUI()
    local root = resMgr:createWidget("salary/salary_res_node")
    self:initUI(root)
end

function UISalaryItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "salary/salary_res_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.effectNode = self.root.effectNode_export
    self.res_icon = self.root.res_icon_export
    self.appear_node = self.root.appear_node_export
    self.res_num = self.root.appear_node_export.res_num_export
    self.free_get = self.root.appear_node_export.free_get_export
    self.diamond_get = self.root.appear_node_export.diamond_get_export
    self.diamondNum = self.root.appear_node_export.diamond_get_export.diamondNum_export
    self.lock_node = self.root.lock_node_export
    self.trigger = self.root.lock_node_export.trigger_export

--EXPORT_NODE_END

end

local resIcon = {
    [1] = "ui_surface_icon/city_res_food.png",
    [2] = "ui_surface_icon/city_res_coin.png",
    [3] = "ui_surface_icon/city_res_wood.png",
    [4] = "ui_surface_icon/city_res_stone.png",
}

local resLockIcon = {
    [1] = "ui_surface_icon/city_res_lock_food.png",
    [2] = "ui_surface_icon/city_res_lock_coin.png",
    [3] = "ui_surface_icon/city_res_lock_wood.png",
    [4] = "ui_surface_icon/city_res_lock_stone.png",
}

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UISalaryItem:onEnter()

    local nodeTimeLine = resMgr:createTimeline("salary/salary_res_node")
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)
end

function UISalaryItem:setData(i)

    self.res_icon:setSpriteFrame(resIcon[i])

    self.effectNode:setVisible(false)
    self.lock_node:setVisible(false)
    self.appear_node:setVisible(false)


    local cunt_vip_freenumber = global.vipBuffEffectData:getVipLevelEffect(3086).quantity or 0 
    local vipfreenumber = global.vipBuffEffectData:getVipDiverseFreeNumber("lVipDiamondCount")
    local lFreeTimes, lDiamondTimes = refershData:getSalaryFreeCount()
    vipfreenumber = cunt_vip_freenumber-vipfreenumber
     if not global.vipBuffEffectData:isVipEffective() then 
        vipfreenumber = 0
    end

    self.build = refershData:getCurSalaryBuild()
    local condit = self:isOpen(i)
    if not condit then

        self.appear_node:setVisible(true)
        self.free_get:setVisible(false)
        self.diamond_get:setVisible(false)

        if lFreeTimes+vipfreenumber > 0 then
            self.useState = 1
            self.free_get:setVisible(true)
            self.effectNode:setVisible(true)
        else    
            self.useState = 2
            self.diamond_get:setVisible(true)
            local diamondNum = self:getDiamondCost(lDiamondTimes)
            self:checkDiamondEnough(diamondNum)
        end

        local currentLv = self.build.level
        local costData = luaCfg:get_cost_rise_by(currentLv) 
        self.res_num:setString(costData.basicNum)

    else
        self.useState = 0
        self.lock_node:setVisible(true)
        self.trigger:setString(condit.description)
        self.res_icon:setSpriteFrame(resLockIcon[i])
    end

end

-- 0 锁住 1 免费  2 魔晶
function UISalaryItem:getState()

    return self.useState
end

function UISalaryItem:getDiamondCost(lDiamondTimes)

    lDiamondTimes = lDiamondTimes + 1
    local costData = luaCfg:get_cost_rise_by(self.build.level)
    return costData["costNum"..lDiamondTimes] or costData["costNum"..costData.maxNum]
end

function UISalaryItem:checkDiamondEnough(num)
    self.diamondNum:setString(num)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.diamondNum:setTextColor(cc.c3b(237, 26, 0))
    else
        self.diamondNum:setTextColor(cc.c3b(255, 184, 34))
    end
end

-- 解锁开启
function UISalaryItem:isOpen(id)
    
    local data = luaCfg:get_day_salary_by(id)
    local condit = luaCfg:get_target_condition_by(data.conditionId)

    local registerBuild = global.cityData:getRegistedBuild()
    for _,v in ipairs(registerBuild) do
        if v.buildingType == condit.objectId  then
            if v.serverData.lGrade >= condit.condition then
                return nil
            end
        end
    end
    return condit
end

--CALLBACKS_FUNCS_END

return UISalaryItem

--endregion
