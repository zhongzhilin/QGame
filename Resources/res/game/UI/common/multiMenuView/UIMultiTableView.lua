local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UITableView = require("game.UI.common.UITableView")
local UIMultiTableView = class("UIMultiTableView",function() return UITableView.new() end)

local contentSort = -1

function UIMultiTableView:ctor(tableView, idx)
    -- body
    self.cellTable = {}
    UITableView.ctor(self)
end

------------------------------overwrite----------------------------------------->>>>
function UIMultiTableView:tableCellSizeForIndex(tableView, idx)

    local tableData = self.__tableData[idx + 1]
    if tableData then
        return self.__cellSize.width, tableData.uiData.h
    end

    return self.__cellSize.width, self.__cellSize.height
end


-- function UIMultiTableView:tableCellAtIndex(tableView, idx)
--     local cell = self:dequeueCell()
--     if cell == nil then 
--         cell = self.__cellTemplate.new()
--         table.insert(self.__cellList, cell)
--     end

--     cell:setData(self.__tableData[idx + 1])

--     if cell.setCellScale then
--         cell:setCellScale(self.__cellScale or 1)
--     end

--     if cell.setFocus then
--         cell:setFocus(self.__selectedIndex~=nil and self.__selectedIndex == idx)
--     end
--     return cell
-- end
------------------------------overwrite-----------------------------------------<<<<
return UIMultiTableView