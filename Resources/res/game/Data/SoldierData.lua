local global = global
local luaCfg = global.luaCfg
local userData = global.userData

local _M = {
    traps = {},
    soldiers = {},
    designSoldiers = {}
}

function _M:init(msg)    
    msg = msg or {}

    if self.soldiers and #self.soldiers > 0 then
        table.assign(self.soldiers,msg)
    else
        self.soldiers = msg
        self.soldierList = self:getSoldierList(userData:getRace())
    end
    self.woundedSoldiers = {}
end

function _M:initTrap(tgTraps)
    tgTraps = tgTraps or {}

    if self.tgTraps and #self.tgTraps > 0 then
        table.assign(self.tgTraps,tgTraps)
    else
        self.traps = tgTraps
    end
end

function _M:getSoldiers()    
    return self.soldiers
end

function _M:getSoldiersBy(i_id)
    for _idx,v in pairs(self.soldiers) do
        if v.lID == i_id then
            return v
        end
    end
end

--根据种族和士兵类型获取兵营可训练的兵种列表
function _M:getSoldierTypeById(i_id)
    local soldiers = luaCfg:soldier_train()
    if soldiers[i_id] then
        return soldiers[i_id].type
    else
        return nil
    end
end

-- i_soldier = 
-- {
--     required int32      lID         = 1;//士兵ID
--     required int32      lCount      = 2;//士兵正常数量
--     required int32      lWounded    = 3;//伤兵数量
-- }
--收获专用
function _M:addSoldierBy(i_soldier)
    for _idx,v in pairs(self.soldiers) do
        if i_soldier.lID and v.lID == i_soldier.lID then
            v.lCount = v.lCount + i_soldier.lCount
            return
        end
    end
    table.insert(self.soldiers,i_soldier)
end

-- --更新伤兵或者治愈兵种信息
function _M:addSoldierWithCover(i_soldier)
    for _idx,v in pairs(self.soldiers) do
        if i_soldier.lID and v.lID == i_soldier.lID then
            table.assign(self.soldiers[_idx],i_soldier)
            return
        end
    end
    table.insert(self.soldiers,i_soldier)
end

--i_soldiers = {
-- {
--     required int32      lID         = 1;//士兵ID
--     required int32      lCount      = 2;//士兵正常数量
--     required int32      lWounded    = 3;//伤兵数量
-- }
-- }
function _M:addSoldiersBy(i_soldiers,noCover)
    for _idx,v in ipairs(i_soldiers or {} ) do
        if noCover then
            self:addSoldierBy(v)
        else
            self:addSoldierWithCover(v)
        end
    end
end

--根据种族和士兵类型获取兵营可训练的兵种列表
function _M:getSoldierList(i_race)
    local list = {}
    local soldiers = luaCfg:soldier_train()
    for _idx,v in pairs(soldiers) do
        list[v.type] = list[v.type] or {}
        if v.race == i_race then
            list[v.type][v.id] = clone(v)
        end
    end
    return list
end

-- 修改士兵的数量
function _M:updateSoldiersNum( i_id, restNum )
    for _idx,v in pairs(self.soldiers) do
        if v.lID == i_id then
            v.lCount = restNum
        end
    end
end

function _M:getSoldierListByType(i_type)
    if not self.soldierList then return end
    return self.soldierList[i_type]
end

function _M:getSoldierClassBy(building_lv)
    local lvupData = global.luaCfg:soldier_lvup()
    for i,v in ipairs(lvupData) do
        if i >= #lvupData then
            return true,v.lv,v.lv
        else
            local nextData = lvupData[i+1]
            if building_lv>=v.buildLv and building_lv < nextData.buildLv then
                return false,v.lv,v.lv+1
            end
        end
    end
end
--------------------------------城防建筑-----------------------------------------
function _M:getTraps()
    local trainData= self:getSoldierListByType(7)
    if self.traps and trainData and #self.traps < table.nums(trainData) then
        for id,v in pairs(trainData) do
            if self:getTrapsBy(v.id) then
            else
                table.insert(self.traps,{lID = v.id, lCount = 0})
            end
        end
    end
    return self.traps
end

function _M:getTrapsBy(i_id)
    for _idx,v in pairs(self.traps) do
        if v.lID == i_id then
            return v
        end
    end
    return nil
end

function _M:getTrapsTotalPower()
    local power = 0
    for _idx,v in pairs(self.traps) do

        local soldierPro = luaCfg:get_def_device_by(self:getDefDeviceId(v.lID)) or {}
        soldierPro.combat = soldierPro.combat or 0
        power = power + soldierPro.combat*v.lCount
    end
    return power
end

function _M:getDefDeviceId(lID)
    -- body
    -- local raceId = global.userData:getRace()
    local id = lID
    if id > 1000 then
        local rtemp = math.floor(id/1000)
        id = id%(rtemp*1000)
    end
    return id
end

function _M:addTrapBy(i_trap)
    for _idx,v in pairs(self.traps) do
        if i_trap.lID and v.lID == i_trap.lID then
            v.lCount = v.lCount + i_trap.lCount
            return
        end
    end
    table.insert(self.traps,i_trap)
end

function _M:addTrapWithCover(i_trap)
    for _idx,v in pairs(self.soldiers) do
        if i_trap.lID and v.lID == i_trap.lID then
            table.assign(self.traps[_idx],i_trap)
            return
        end
    end
    table.insert(self.traps,i_trap)
end

function _M:addTrapsBy(i_traps,noCover)
    for _idx,v in ipairs(i_traps) do
        if isCover then
            self:addTrapBy(v)
        else
            self:addTrapWithCover(v)
        end
    end
end
------------------------------伤兵数据------------------------------------
function _M:getAllWoundedSoldierArr()
    local arr = {}
    for i,v in pairs(self.soldiers) do
        if v.lWounded and v.lWounded > 0 then
            local temp = clone(v)
            temp.num = v.lWounded
            temp.isWounded = true
            table.insert(arr,temp)
        end
    end
    return arr
end

function _M:getAllHealedSoldierArr()
    local arr = {}
    for i,v in pairs(self.soldiers) do
        if v.lHealed and v.lHealed > 0 then
            local temp = clone(v)
            temp.num = v.lHealed
            table.insert(arr,temp)
        end
    end
    return arr
end

global.soldierData = _M