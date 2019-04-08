--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local EquipCfg = {}
local fixPropList = {"dps", "antiarmor", "life", "armor", "spy"}
local extraPorpList = {"dps_extra", "antiarmor_extra", "life_extra", "armor_extra", "spy_extra"}


function EquipCfg:getEquipmentTid(itemId)
    local itemtable = global.luaCfg:get_itemtable_by(itemId)
    assert(itemtable, string.format("错误， 未找到item<%d>对应的equipment", itemId))
    return itemtable.type_id
end

function EquipCfg:getEquipmentByItemTid(itemId)
    local typeId = self:getEquipmentTid(itemId)
    return global.luaCfg:get_hero_equipment_by(typeId)
end

function EquipCfg:getItemTid(equipId)
    local equipment = global.luaCfg:get_hero_equipment_by(equipId)
    assert(equipment, string.format("错误， 未定义的equipment<%d>", equipId))
    return equipment.item_id
end

--get the type of equipment
function EquipCfg:getTypeNameOfItem(job,equipId)
    local equip_partCfgData = global.luaCfg:equip_part()

    for _id, value in pairs(equip_partCfgData) do
        if value.job_id == job and equipId == value.part_id then
            return value.part_name
        end
    end
    assert(false, string.format("错误， 没有找对应的类型job<%d>，equipment<%d>", job,equipId))
    return ""
end

function EquipCfg:getEquipByJobAndLevel(job, level)
    local equipcfgs = {}
    local equipmentCfgData = global.luaCfg:equipment()
    for id, value in pairs(equipmentCfgData) do 
        --通用装备job为0
        if (job == value.job or value.job == 0) and level == value.level then
            table.insert(equipcfgs, clone(value))
        end
    end
    return equipcfgs
end

function EquipCfg:getEquipAddProperty(equipCfg, product_id, fix)
    local propList = fix and fixPropList or extraPorpList

    local proptyDatas = {}

    local productCfg = global.luaCfg:get_product_by(product_id)
    for i, propName in ipairs(propList) do 
        if productCfg[propName] and #productCfg[propName] > 0 then
            local proptyData =  {name=propName, min=productCfg[propName][1][1], max=productCfg[propName][1][2]}
            table.insert(proptyDatas, proptyData)
        end
    end
    return proptyDatas
end

function EquipCfg:getEquipProductMaterial(equipCfg, intensive)
    if intensive then
        if #equipCfg.superstuff_cost > 0 then
            return {itemId = equipCfg.superstuff_cost[1][1], count = equipCfg.superstuff_cost[1][2]}
        else
            return {itemId = 0, count = 0}
        end
    else
        local materials = {}
        for i, obj in ipairs(equipCfg.stuff_cost or {}) do 
            local mat = {itemId = obj[1], count = obj[2]}
            table.insert(materials, mat)
        end
        return  materials
    end
end

function EquipCfg:getEquipReinforceCfgByItemTid(itemId, level, _type)
   local equipId = self:getEquipmentTid(itemId) 
   return self:getEquipReinforceCfg(equipId, level, _type)
end

function EquipCfg:getEquipReinforceCfg(equipId, level, _type)
    local reinforceData = global.luaCfg:reinforce()

    for i, data in ipairs(reinforceData) do
        if data.reinforce_level == level and equipId == data.equipment_id and _type == data.reinforce_type then
            return data
        end
    end
end

function EquipCfg:getEquipReforceAttrByItemId(itemId, level, _type)
    local equipId = self:getEquipmentTid(itemId) 
    return self:getEquipReforceAttr(equipId, level, _type)
end

function EquipCfg:getEquipReforceAttr(equipId, level, _type)
    local propList = {}
    local foolvalue = nil

    if level == 0 then 
        level = 1
        foolvalue = 0
    end

    local refroceData = self:getEquipReinforceCfg(equipId, level, _type)
    for i, attr_name in ipairs(fixPropList) do
        if refroceData and refroceData[attr_name] and refroceData[attr_name] > 0 then
            table.insert(propList, {name = attr_name, value = foolvalue or refroceData[attr_name]})
        end
    end

    return propList
end

function EquipCfg:setHeightenState(equipId, isHeighten)
    self.heightenProduceState = self.heightenProduceState or {}
    self.heightenProduceState[equipId] = isHeighten
end

function EquipCfg:getHeightenState(equipId)
    self.heightenProduceState = self.heightenProduceState or {}
    return self.heightenProduceState[equipId]
end
return EquipCfg

--endregion
