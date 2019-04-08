local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UITableView = require("game.UI.common.UITableView")
local UILoadTableView = class("UILoadTableView",function() return UITableView.new() end)

local contentSort = -1

function UILoadTableView:ctor(tableView, idx)
    -- body
    self.cellTable = {}
    UITableView.ctor(self)
end

-- function UILoadTableView:tableCellSizeForIndex(tableView, idx)

--     local tableData = self.__tableData[idx + 1]
--     if tableData and tableData.sort == contentSort then

--         return self.__cellSize.width, self.__cellSize.height + 200    
--     end

--     return self.__cellSize.width, self.__cellSize.height
-- end

function UILoadTableView:getChooseSort()
    -- body

    return contentSort
end

function UILoadTableView:chooseItem( sort )
    -- body

    contentSort = sort
end

return UILoadTableView