local global = global
local luaCfg = global.luaCfg

local _M = {
    all = {},
    effect = {}
}

function _M:init(buffs)
    if not buffs then return end
    log.trace("####buffs=%s",vardump(buffs))

    local noDelItems = {}
    for i,v in ipairs(buffs) do

        local id = self:getBuffId(v.lID,v.lTarget)
        self.all[id] = self.all[id] or {}
        noDelItems[id] = true
        table.assign(self.all[id],v)
    end

    --删除多余的元素
    for k,v in pairs(self.all) do
        if not noDelItems[k] then
            self.all[k] = nil
        end
    end
    log.trace("####self.all=%s",vardump(self.all))
end

function _M:getBuffs()
    return self.all
end

function _M:getDesignBuffBy(id)
    local data = luaCfg:get_data_type_by(id)
    return data
end

function _M:updateBuffer(tagPlus)
    
    for _,v in pairs(tagPlus) do
        local id = self:getBuffId(v.lID,v.lTarget)
        self.all[id] = v
    end
end

function _M:deleteBuffer(tagPlus)
    
    for _,v in pairs(tagPlus) do
        local id = self:getBuffId(v.lID,v.lTarget)
        if self.all[id] then
            self.all[id] = nil
        end
    end
end

function _M:getServerBuffBy(id)
    return self.all[id]
end

function _M:setServerBuffsBy(datas)
    for i,v in ipairs(datas) do
        self.all[self:getBuffId(v.lID,v.lTarget)] = v
    end
    gevent:call(global.gameEvent.EV_ON_CITY_BUFF_UPDATE)
end

function _M:getBuffId(proId,targetId)
    return proId*10000+targetId
end

--获取加速道具类型buff，目前针对一个建筑只做一种buff处理
function _M:getBuffTimeBy(targetId)
    local data = {}
    for i,v in pairs(self.all) do
        if v.lTarget == targetId then
            data = v
            return data
        end
    end
    return data
end

function _M:getBuffByTarget( targetId )
    
    local data = {}
    for i,v in pairs(self.all) do
        if v.lTarget == targetId then
            table.insert(data, v)
        end
    end
    return data
end

function _M:checkFarmSpeed(targetId)
    local data = {}
    for i,v in pairs(self.all) do
        if v.lTarget == targetId then
            return true
        end
    end
    return false
end

--根据k，v得到buff字符串
function _M:getBuffStrBy(pair)
    -- local data = luaCfg:get_data_type_by(pair.lID)
    -- local str = data.paraName.."+"..pair.lValue..luaCfg:get_local_string(10076)
    -- return str

    local id = pair.lID
    local league1count = pair.lValue
    local league1Cfg = luaCfg:get_data_type_by(id)

    return string.format("%s+%s%s%s",league1Cfg.paraName,league1count,league1Cfg.str,league1Cfg.extra)
end

---------------------------------effcet------------------------------------------

function _M:initEffect(tgEffect)
    if not tgEffect then return end
    log.debug("####tgEffect=%s",vardump(tgEffect))

    for i,v in ipairs(tgEffect) do
        self.effcet[v.lEffectID] = self.effcet[v.lEffectID] or {}
        table.assign(self.effcet[v.lEffectID],v)
    end
    log.debug("####self.effcet=%s",vardump(self.effcet))
end


function _M:getBEffectBy(id)
    return self.effcet[id]
end

function _M:setBEffectBy(datas)
    for i,v in ipairs(datas) do
        self.effcet[v.lID] = self.effcet[v.lID] or {}
        table.assing(self.effcet[v.lID],v)
    end
    -- gevent:call(global.gameEvent.EV_ON_CITY_BUFF_UPDATE)
end

--获取建造buff减少时间
function _M:setBEffectBy(datas)
end

global.buffData = _M