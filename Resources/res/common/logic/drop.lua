-- 本文件用来计算游戏中的掉落,前后台统一掉落随机数种子，则掉落计算相同
local crandom   = require "crandom"
local HQCONST   = HQCONST
local table     = table
local math      = math
local pairs     = pairs
local assert    = assert

local drop = {}

local cfgmgr = nil
cfgmgr = global.luaCfg

-- 为了支持小数，概率最大扩展为10000
local DROP_PROBABILITY_MAX = 10000

-- 单个掉落包生成物品

local maxrand = DROP_PROBABILITY_MAX
local function __do_one_drop(dropcfg)
    assert(dropcfg)
    local rd = crandom.rlc_between(1, maxrand)
    local allrd = 0
    
    local dropmap = {}     
    for _, w in pairs(dropcfg.droplist) do 
        local item_id  = w[1]
        local item_num = w[2]
        local item_rnd = w[3]
--                log.debug("check drop %d %d %d, rd %d, allrd %d", item_id, item_num, item_rnd, rd, allrd)
        -- 掉落规则
        -- {{10001,1,3000},{11002,1,1000} ,{11003,1,1000}} 为例
        -- 以10000 取随机数 当 [1-3000] 掉落10001, 当[3001, 4000] 掉落11002 
                
        if rd > allrd and rd <= allrd + item_rnd then
            local item = item_id
            local num  = item_num
            dropmap[item] = dropmap[item] or { tid = item, num = 0 }
            dropmap[item].num = dropmap[item].num + num 
--                    log.debug("drop item:%d,%d, allrd:%d, rd:%d", item, num, allrd, rd)
                    
            -- 一个掉落包只能掉一个配置的物品
            break
        end
                
        allrd = allrd + item_rnd
        if allrd > maxrand then
            allrd = maxrand
        end
                
        if allrd == maxrand then
            break
        end
    end

    return table.values(dropmap)
end



local function _do_item_drop(items, drop_list)
    
    for _,v in pairs(items) do
        local dropcfg = cfgmgr:get_itemdrop_by(v)
        if dropcfg == nil then
            log.debug("item drop cfg not found:%d", v)
        else
            local allrd = 0
            local maxrand = DROP_PROBABILITY_MAX
            local rd = crandom.rlc_between(1, maxrand)
            
            for _, w in pairs(dropcfg.droplist) do 
                local item_id  = w[1]
                local item_num = w[2]
                local item_rnd = w[3]
--                log.debug("check drop %d %d %d, rd %d, allrd %d", item_id, item_num, item_rnd, rd, allrd)
                -- 掉落规则
                -- {{10001,1,3000},{11002,1,1000} ,{11003,1,1000}} 为例
                -- 以10000 取随机数 当 [1-3000] 掉落10001, 当[3001, 4000] 掉落11002 
                
                if rd > allrd and rd <= allrd + item_rnd then
                    local item = item_id
                    local num  = item_num
                    if drop_list[item] == nil then
                        drop_list[item] = { tid = item, num = 0 }
                    end
                    drop_list[item].num = drop_list[item].num + num 
--                    log.debug("drop item:%d,%d, allrd:%d, rd:%d", item, num, allrd, rd)
                    
                    -- 一个掉落包只能掉一个配置的物品
                    break
                end
                
                allrd = allrd + item_rnd
                if allrd > maxrand then
                    allrd = maxrand
                end
                
                if allrd == maxrand then
                    break
                end
            end
        end
    end    
end


-- 掉落包内的物品合并，各掉落包之间的物品不合并
-- 用数组存储返回结果
local function __do_item_drop_no_merge(items, drop_list)
    assert(items and drop_list)

    for _, v in pairs(items) do
        local dropcfg = cfgmgr:get_itemdrop_by(v)
        if dropcfg == nil then
            log.debug("item drop cfg not found:%d", v)
        else
            local curr_drop = __do_one_drop(dropcfg)
            if #curr_drop > 0 then
                table.insertTo(drop_list, curr_drop)
            end
        end
    end    
end


local function _do_prop_drop(props, drop_list)
   -- props format: {{1003,360,10},{1005,576,10}}
   for _, v in pairs(props) do 
       local prop_id = v[1]
       local prop_num = v[2]
       local prop_vibrate = v[3]
       local rand_val = crandom.rlc_between(1, prop_vibrate * 2)
       local rate = HQCONST.HUNDREND + (rand_val - prop_vibrate)
       prop_num = math.floor(prop_num * rate / HQCONST.HUNDREND)
       
       if drop_list[prop_id] == nil then
           drop_list[prop_id] = { tid = prop_id, num = 0 }
       end    
       drop_list[prop_id].num = drop_list[prop_id].num + prop_num
--       log.trace("drop prop:%d,%d,%d", prop_id, rate, prop_num)
   end
end

local function __do_prop_drop_no_merge(props, drop_list)
   -- props format: {{1003,360,10},{1005,576,10}}
   for _, v in pairs(props) do 
       local prop_id = v[1]
       local prop_num = v[2]
       local prop_vibrate = v[3]
       local rand_val = crandom.rlc_between(1, prop_vibrate * 2)
       local rate = HQCONST.HUNDREND + (rand_val - prop_vibrate)
       prop_num = math.floor(prop_num * rate / HQCONST.HUNDREND)
       
       drop_list[#drop_list + 1] = { tid = prop_id, num = prop_num }
   end
end


---
-- @param seed
-- @param items
-- @param props
-- @param item_plus
-- @param prop_plus
-- @return
function drop.do_drop(seed, items, props, item_plus, prop_plus)
    crandom.rlc_seed(seed)
    
    local drop_list = {}
    -- 常规道具掉落
    if items ~= nil then
        _do_item_drop(items, drop_list)
    end
    
    -- 常规资源掉落
    if props ~= nil then
        _do_prop_drop(props, drop_list)
    end
    
    -- 额外道具掉落
    if item_plus ~= nil then
        _do_item_drop(item_plus, drop_list)
    end
    
    -- 额外资源掉落
    if prop_plus ~= nil then
        _do_prop_drop(prop_plus, drop_list)
    end
    
    return table.values(drop_list)
end

--[Comment]
-- 计算掉落结果，掉落包之间相同的item不合并
function drop.do_drop_no_merge(seed, items, props)
    crandom.rlc_seed(seed)
    
    local drop_list = {}
    local drop_item_list = {}
    -- 常规道具掉落
    if items ~= nil and #items > 0 then
        __do_item_drop_no_merge(items, drop_list)
    end
    drop_item_list = clone(drop_list)

    -- 常规资源掉落
    if props ~= nil and #props > 0 then
        __do_prop_drop_no_merge(props, drop_list)
    end

    return drop_list, drop_item_list
end

return drop
