
-------------------------------------------------------------------------------
-- Table Manipulation
-- This extension library provides generic functions for table manipulation.

table = table or {}

if table.unpack == nil then
    table.unpack = unpack
end

function table.nums(t)
    local count = 0
    for k, v in pairs(t or {}) do
        count = count + 1
    end
    return count
end

function table.keys(t)
    local keys = {}
    for k, v in pairs(t) do
        keys[#keys + 1] = k
    end
    return keys
end

function table.values(t)
    local values = {}
    for k, v in pairs(t) do
        values[#values + 1] = v
    end
    return values
end

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

--add by wuwx
--be equal to "="
function table.assign(dest, src)
  table.deepMerge(dest, src)
  table.clearNoUse(dest, src)
end

--add by wuwx
--merge with no change addr
function table.deepMerge(dest, src)
    for k, v in pairs(src or {} ) do
        if type(v) == "table" then
            dest[k] = dest[k] or {}
            table.deepMerge(dest[k], src[k])
        else
            dest[k] = v
        end
    end
end

function table.copyMode2(dest, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = dest[k] or {}
            table.copyMode2(dest[k], src[k])
        else
            dest[k] = dest[k] or v
        end
    end
end

--add by wuwx
--after deep merge then use it
function table.clearNoUse(dest, src)
    for k, v in pairs(dest) do
        if dest[k] then
            if not src[k] then
                dest[k] = nil
            else
                if type(v) == "table" then
                    table.clearNoUse(dest[k], src[k])
                end
            end
        end
    end
end

-------------------------------------------------------------------------------
--insert list.
--@param table dest
--@param table src
--@param table begin insert position for dest
function table.insertTo(dest, src, begin)
  begin = tonumber(begin)
  if begin == nil then
    begin = #dest + 1
  end

  local len = #src
  for i = 0, len - 1 do
    dest[i + begin] = src[i + 1]
  end
end

-------------------------------------------------------------------------------
--search target index at list.
--@param table list
--@param * target
--@param int from idx, default 1
--@param bool useNaxN, the len use table.maxn(true) or #(false) default:false
--@param return index of target at list, if not return -1

function table.indexOf(list, target, from, useMaxN)
  local len = (useMaxN and table.maxn(list)) or #list
  if from == nil then
    from = 1
  end
  for i = from, len do
    if list[i] == target then
      return i
    end
  end
  return -1
end

function table.indexOfKey(list, key, value, from, useMaxN)
  local len = (useMaxN and table.maxn(list)) or #list
  if from == nil then
    from = 1
  end
  local item = nil
  for i = from, len do
    item = list[i]
    if item ~= nil and item[key] == value then
      return i
    end
  end
  return -1
end

function table.removeItem(t, item, removeAll)
    for i = #t, 1, -1 do
        if t[i] == item then
            table.remove(t, i)
            if not removeAll then break end
        end
    end
end

function table.map(t, fun)
    for k,v in pairs(t) do
        t[k] = fun(v, k)
    end
end

function table.walk(t, fun)
    for k,v in pairs(t) do
        fun(v, k)
    end
end

function table.filter(t, fun)
    for k,v in pairs(t) do
        if not fun(v, k) then
            t[k] = nil
        end
    end
end

function table.find(t, item)
    return table.keyOfItem(t, item) ~= nil
end

function table.unique(t)
    local r = {}
    local n = {}
    for i = #t, 1, -1 do
        local v = t[i]
        if not r[v] then
            r[v] = true
            n[#n + 1] = v
        end
    end
    return n
end

function table.keyOfItem(t, item)
    for k,v in pairs(t) do
        if v == item then return k end
    end
    return nil
end

--
function table.haskey(t, key)
    for k, v in pairs(t) do
        if k == key then
            return true
        end
    end
    
    return false
end

-- 
function table.hasval(t, val)
    for k, v in pairs(t) do
      	if v == val then
            return true
      	end
    end
    
    return false
end

function table.is_empty(t)
    return _G.next(t) == nil
end

-- 数组元素洗牌，t必须为数组
function table.shuffle(t)
    assert(type(t) == "table" and #t > 0)
    local num = #t
    local math = math
    for i in ipairs(t) do
        local swap_idx = math.random(i, num)
        -- 直接交换
        t[i], t[swap_idx] = t[swap_idx], t[i]
    end
end

function table.sortBySortList(t,sortList)

    --[[
        local tb = {

            {
                count = 1,
                data = {child = 2,tag = false},
            },
            {
                count = 1,
                data = {child = 2,tag = false},
            },
            {
                count = 1,
                data = {child = 2,tag = true},
            },
        }
    
        table.sortBySortList(tb,{{"count","min"},{"data.child","min"},{"data.tag","true"}})
        
        注意：table数据量比较大的时候不建议使用此方法，比常规排序效率低
    ]]--

    local sortFun = function(a,b)
        
        local sortCount = #sortList
        for sortIndex,v in ipairs(sortList) do

            if #v == 2 then                

                local keys = string.split(v[1],".")
                local sort_type = v[2]
                local av = a
                local bv = b

                for _,key in ipairs(keys) do

                    av = av[key]
                    bv = bv[key]
                end

                if sort_type == 'true' or sort_type == 'false' then
                    av = not not av     -- 将 number 型 转化为 boolean 型
                    bv = not not bv
                end

                if av ~= bv then
                    
                    if sort_type == "min" then

                        return av < bv
                    elseif sort_type == "max" then

                        return av > bv
                    elseif sort_type == "true" then

                        return av
                    elseif sort_type == "false" then
                        
                        return not av
                    end
                elseif sortIndex == sortCount then

                    return false
                end             
            else

                log.error("sort type must be 2")
            end            
        end
    end

    table.sort(t,sortFun)
end

function table.sortByValue(tb, key, value)
    tb = tb or {}
    if table.nums(tb) <= 1 then return end
    for k,v in pairs(tb) do
        v.sortIndex = v[key] == value and 1 or 0
    end
    table.sort(tb, function(t1, t2) return t1.sortIndex > t2.sortIndex end)
end

function table.get2DimensionTable()

    local tb = {}
    setmetatable(tb, {

        __index = function(table,key)

            table[key] = {}

            setmetatable(table[key], {

                __index = function(tableChild,keyChild)

                    tableChild[keyChild] = {}
                    return tableChild[keyChild]     
                end
            })  

            return table[key]       
        end
    })

    return tb
end


function table.traverse(t1 ,t2 , call)
  for _ ,v in pairs(t1 or {} ) do 
    for _ ,vv in pairs(t2 or {} ) do 
      if call then 
        call(v ,vv)
      end 
    end 
  end 
end 

function table.reverse(tab)
    local tmp = {}
    for i = 1, #tab do
        local key = #tab
        tmp[i] = table.remove(tab)
    end

    return tmp
end

function table.remove2(t, call)
    for i = #t, 1, -1 do
        if call(t[i] , i) then
            table.remove(t, i)
        end
    end
end

function table.cycle(t, call)
    for i ,v in pairs(t) do 
        call(v)
    end 
end

function table.getIndex(t , value )
    for index ,v in pairs(t) do 
        if v == value then 
            return index
        end 
    end 
end