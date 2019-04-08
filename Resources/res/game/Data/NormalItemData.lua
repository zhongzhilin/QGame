
local global = global
local NormalItemData = class("NormalItemData")
local _instance = nil
local luaCfg = global.luaCfg
local userData = global.userData

NormalItemData._items = {}

function NormalItemData:getInstance()
    
    if _instance == nil then _instance = NormalItemData.new() end

    return _instance

end

function NormalItemData:init( msg )   

    msg = msg or {}
    local res = {}
    for _,v in ipairs(msg) do

        table.insert(res,self:serverData2ItemData(v))
    end

    table.assign(self._items,res)
end

function NormalItemData:serverData2ItemData(data)
    
    return {id = data.lID,count = data.lCount}
end

function NormalItemData:addItem( itemId , itemNum )
    
    for _,v in ipairs(self._items) do
        
        if v.id == itemId then

            v.count = v.count + itemNum

            return
        end
    end

    table.insert(self._items,{id = itemId,count = itemNum})
end

function NormalItemData:updateItem( data )

    for _,v in ipairs(self._items) do
        
        if v.id == data.id then

            v.count = data.count

            return
        end
    end

    table.insert(self._items,data)
end

function NormalItemData:updateItems( datas )

    for _,data in ipairs(datas) do
       
        self:updateItem(data)
    end
end


function NormalItemData:getItemByItemType(itemType)
    local luaCfg = global.luaCfg
    for k,v in pairs(self._items) do
        if luaCfg:get_item_by(v.id).itemType == itemType then
            return true
        end
    end
    return false
end

--模拟服务器数据

function NormalItemData:addItem_TEMP( data )
    -- body

    local LogicNtf = require "game.Rpc.LogicNotify"

    for _,v in ipairs(self._items) do
        
        if v.id == data.id then
            
            LogicNtf:itemUpdate({id = v.id,count = v.count + data.count})  
            
            return
        end
    end 

    LogicNtf:itemUpdate(data)
end

function NormalItemData:addItems( datas )
    -- body

    local LogicNtf = require "game.Rpc.LogicNotify"

    local resData = {}

    for _,data in ipairs(datas) do


        local isFound = false

        for _,v in ipairs(self._items) do
        
            if v.id == data.id then
        
                isFound = true
                table.insert(resData,{id = v.id,count = v.count + data.count})  
            end
        end

        if isFound == false then

            table.insert(resData,data)  
        end
    end 

    LogicNtf:itemsUpdate(resData)
end

function NormalItemData:useItem_TEMP( itemId , useCount )
    -- body

    self:addItem({id = itemId,count = -useCount})

    useCount = useCount or 1

    local itemData = luaCfg:get_item_by(itemId)


    if itemData.itemType == 101 or itemData.itemType == 107 or itemData.itemType  == 120 then

        local dropId = itemData.typePara1

        local dropData = luaCfg:get_drop_by(dropId)

        local dropItems = clone(dropData.dropItem)

        local resData =  {}
        
        for _,v in ipairs(dropItems) do
          
            v[2] = v[2] * useCount 
            table.insert(resData,{id = v[1],count = v[2]})            
        end

        self:addItems(resData)

        return dropItems
    end

    return nil

end

function NormalItemData:useItem( itemId , useCount )

    local itemData = luaCfg:get_item_by(itemId)

    print(".........." .. itemData.itemType)

    if itemData.itemType == 101 or itemData.itemType == 107 or itemData.itemType  == 120 then

        local dropId = itemData.typePara1

        local dropData = luaCfg:get_drop_by(dropId)

        local dropItems = clone(dropData.dropItem)
 
        for _,v in ipairs(dropItems) do
          
            v[2] = v[2] * useCount 
        end

        -- table.insert(dropItems,{[1] = itemId,[2] = -useCount})

        return dropItems
    elseif itemData.itemType == 106 then

        print("return a exp info")
        return {{[1] = WCONST.ITEM.TID.EXP,[2] = itemData.typePara1 * useCount}}
        -- userData:addExp(itemData.typePara1 * useCount)
    end

    -- local dropItems = {{[1] = itemId,[2] = -useCount}}

    return dropItems
end

--模拟服务器数据

function NormalItemData:getItems()
    
    return self._items
end

function NormalItemData:getItemById(_id)

    for _,v in ipairs(self._items) do

        if v.id == _id then

            return v
        end
    end

    return {id = _id,count = 0}
end


function NormalItemData:getItemNumByID(_id)

    for _,v in ipairs(self._items) do

        if v.id == _id then

            return v.count or 0
        end
    end

    return 0
end

global.normalItemData = NormalItemData

return _M