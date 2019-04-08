
local global = global

local _M = {
    items = {},
    inited = false,
}

global.EQUIP_ATTR_NAME_MAP = 
{
    [WCONST.ITEM.EQUIP.ATTR_IDX.DPS] = "dps",
    [WCONST.ITEM.EQUIP.ATTR_IDX.ANTIARMOR] = "antiarmor",
    [WCONST.ITEM.EQUIP.ATTR_IDX.HP] = "life",
    [WCONST.ITEM.EQUIP.ATTR_IDX.ARMOR] = "armor",
    [WCONST.ITEM.EQUIP.ATTR_IDX.SPY] = "spy",
}

--message SGoodsInfo
--{
--    required    uint32      num         = 1;    //道具数量
--}
--message SEquipInfo
--{
--    required    uint32      source          = 1;    //生成来源: WCONST.ITEM.SOURCE
--    repeated    uint32      fix_attrs       = 2;    //固定属性: WCONST.ITEM.ATTR_IDX
--    repeated    uint32      extra_attrs     = 3;    //附加属性
--    repeated    uint32      enhance_attrs   = 4;    //强化属性
--}
--// 物品(普通道具/装备)
--message SItemObj
--{
--    required    uint64      id      = 1; 
--    required    uint32      tid     = 2; 
--    optional    SGoodsInfo  goods   = 3;
--    optional    SEquipInfo  equip   = 4;
--}

function _M:init(m)    
    self.items  = m.items or {}
end

function _M:getItems()
    return self.items
end

function _M:getItemByID(id)
    for k,v in pairs(self.items) do
        if v.id == id then            
            return v
        end
    end
end

function _M:getItemByTID(tid)
    for k,v in pairs(self.items) do
        if v.tid == tid then 
            return v
        end
    end
end

function _M:getItemByItemType2(itemType2)
    local luaCfg = global.luaCfg
    local itemList = {}
    for k,v in pairs(self.items) do
        if luaCfg:get_itemtable_by(v.tid).item_type2 == itemType2 then
            table.insert(itemList, v)
        end
    end
    return itemList
end

function _M:addItem(data)
    table.insert(self.items, data)
end

function _M:delItemByID(id)
    local group = self.items
    for i = #group, 1, -1 do
        if group[i].id == id then
            table.remove(group, i)
        end
    end
end

function _M:delItemByTID(tid)
    local group = self.items
    for i = #group, 1, -1 do
        if group[i].tid == tid then
            table.remove(group, i)
        end
    end
end

function _M:updateItem(data)
    local id = data.id
    local item = self:GetItemByID(id) or {}
    
    if item.goods then
        item.goods.num = data.currnum
    elseif item.equip then
        item.equip.num = data.currnum
    end   
end

function _M:getItemNumByID(id)
    local item = self:GetItemByID(id)
    if item.goods then
        return item.goods.num
    elseif item.equip then
        return 1
    end
    return 0
end

function _M:setItemNumByTID(tid,dNum)
    local item = self:GetItemByTID(tid)
    if item then
        if item.goods then
            item.goods.num = item.goods.num - dNum
        elseif item.equip then
        end
    end
end

function _M:getItemNumByTID(tid)
    local item = self:GetItemByTID(tid)
    if item then
        if item.goods then
            return item.goods.num
        elseif item.equip then
            return 1
        end
    end
    return 0
end

function _M:getEquipReinforceInfo(id,lv,reinforce_type)
    local reinforce = global.luaCfg:reinforce()
    local temp = {}
    for _,v in ipairs(reinforce) do
        if v.equipment_id == id and v.reinforce_level == lv and v.reinforce_type == reinforce_type then
            return v 
        end
    end
end

--{
--    {tid, num},{}
--}
function _M:hasEnoughItem(list)
    for _,v in ipairs(list) do
        if self:GetItemNumByTID(v[1]) < v[2] then
            return false
        end
    end
    return true
end

--{
--    {itemId = 10001, count=522}
--}
function _M:checkEnoughItem(list)
    for _,v in ipairs(list) do
        local currNum = self:GetItemNumByTID(v.itemId)
        if currNum < v.count then
            return false,currNum
        end
    end
    return true
end

global.itemData = _M
return _M