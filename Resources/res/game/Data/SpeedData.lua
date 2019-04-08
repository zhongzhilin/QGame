
local _M = {}

local luaCfg = global.luaCfg

function _M:init(msg)
    
    -- 所有道具
    local  itemData = luaCfg:item()
    self._itemData = {}
    local IsRelease = _CPP_RELEASE == 1
    for _,v in pairs(itemData) do
        if not IsRelease or v.gmItem == 0 then
            self._itemData[v.itemId] = v
        end        
    end    
end

function _M:getItemByType(_itemType,_buildingType,isId)

	local tempData = {}
    if isId then
        table.insert(tempData, clone(self._itemData[_itemType]))
    else
        for _,v in pairs(self._itemData) do
            if v.itemType == _itemType then

                if _itemType == 6 then
                    table.insert(tempData, v)
                else
                    if _buildingType and _buildingType ~= 0 then
                        if _buildingType == v.typePara3 then
                            table.insert(tempData, v)
                        end
                    else
                        table.insert(tempData, v)
                    end
                end
            end
        end
    end
    return tempData
end

function _M:getAccelerateItemById( _itemType, _buildId  )
    
    local tempData = {}
    for _,v in pairs(self._itemData) do
        if v.itemType == _itemType  and v.typePara3 == _buildId then
            table.insert(tempData, v)
        end
    end
    return tempData
end

function _M:insertData(_tb1, _tb2)
	
	for k,v in pairs(_tb2) do
        table.insert(_tb1,v)
    end
end

global.speedData = _M

--endregion
