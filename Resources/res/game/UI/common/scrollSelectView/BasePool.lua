--region BasePool.lua
--Author : Song
--Date   : 2016/6/7

local BasePool = class("BasePool")

ObjectPoolType = 
{
    HASH = 1, 
    ARRAY = 2
}

function BasePool:ctor(poolType, maxObjCount)
    self.itemList = {};
    self.poolType = poolType
    self.maxObjCount = maxObjCount
end

function BasePool:getObject(key)
    local obj
    local poolList
     
    if self.poolType == ObjectPoolType.HASH then 
        poolList = self:getClassPool(key)
    else
        poolList = self.itemList
    end

    local objCount = poolList and #poolList or 0
    if objCount > 0 then 
        obj = table.remove(poolList, objCount)
        self:onReuseObj(obj)
    end
    
    return obj
end

function BasePool:recycleObject(object, key)
    local poolList = nil
    if self.poolType == ObjectPoolType.HASH then 
        poolList = self:getClassPool(key)
    else
        poolList = self.itemList
    end

    if  #poolList > self.maxObjCount then
        if object.onRelease then
            object:onRelease()
        end
        return
    end

    poolList[#poolList+1] = object
    self:onCacheObj(object)
end

function BasePool:getClassPool(key)
    if self.itemList[key] == nil then 
        self.itemList[key] = {}
    end
    return self.itemList[key]
end

function BasePool:clearPool()
    if self.poolType == ObjectPoolType.HASH then 
        for key, pool in pairs(self.itemList) do
            for i=1, #pool, 1 do 
                self:onReleaseObj(pool[i])
            end
        end
    else
        poolList = self.itemList
        for i=1, #poolList, 1 do 
            self:onReleaseObj(poolList[i])
        end
    end

--    self.itemList = {}
    self.itemList = {}
end

--[[--
   资源从池中取出 
]]
function BasePool:onReuseObj(obj)
    if obj.onReuse then
        obj:onReuse()
    end
end

--[[--
   资源被缓存
]]
function BasePool:onCacheObj(obj)
    if obj.onCache then
        obj:onCache()
    end

end

--[[--
   资源被彻底释放
]]
function BasePool:onReleaseObj(obj)
    if obj.onRelease then
        obj:onRelease()
    end
end

return BasePool

--endregion
