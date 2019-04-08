local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UITableView = require("game.UI.common.UITableView")
local UIChatTableView = class("UIChatTableView",function() return UITableView.new() end)

local contentSort = -1

function UIChatTableView:ctor(tableView, idx)
    -- body
    self.cellTable = {}
    UITableView.ctor(self)
end

------------------------------overwrite----------------------------------------->>>>
function UIChatTableView:tableCellSizeForIndex(tableView, idx)

    local tableData = self.__tableData[idx + 1]
    if tableData then
    
        -- if tableData.id == 9 then
        --     print("UIChatTableView height:"..tableData.id.."  :"..tableData.uiData.h)
        --     --tableData.uiData.h = 1080
        -- end
        return self.__cellSize.width,  tableData.cellH      
    end
    return self.__cellSize.width, self.__cellSize.height
end

function UIChatTableView:scrollToBottom()

    local minOffset = self:minContainerOffset()
    if minOffset.y >= 0 then
        return
    end
    local offset = self:getContentOffset()
    self:setContentOffset(cc.p(offset.x,0))
end

-- function UIChatTableView:tableCellAtIndex(tableView, idx)
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

function UIChatTableView:getCellHeight(idx)

    local cellHeight = 0
    local tableData = self.__tableData[idx]
    if tableData then
        cellHeight = tableData.cellH 
    else
        cellHeight = self.__cellSize.height
    end
    return cellHeight
end


function UIChatTableView:getPreTotalCellHeight(idx)

    local y = 0
    for index,v in ipairs(self.__tableData) do
        if idx > index then  
            y = y + self:getCellHeight(index)
        end
    end
    return y
end

function UIChatTableView:jumpToCellYByIdx(idx,isNoDelay, moveOffsetY)

    local offset = self:getContentOffset()
    local y = 0 
    if idx > 2 then
        y = 0-self:getPreTotalCellHeight(idx)
        if moveOffsetY then
            y = y + moveOffsetY
        end
    end

    local minOffset = self:minContainerOffset()
    local maxOffset = self:maxContainerOffset()
    y = math.max(minOffset.y, math.min(maxOffset.y, y))
    log.trace("#####UITableView:jumpToCellByIdx idx=%s,afterx=%s,maxOffset=%s,minOffset=%s",idx,y,vardump(maxOffset),vardump(minOffset))

    if not isNoDelay then 
        self.scheduleId = gscheduler.performWithDelayGlobal(function()
            self:setContentOffset(cc.p(offset.x,y))
        end,0)
    else
        self:setContentOffset(cc.p(offset.x,y))
    end
end

------------------------------overwrite-----------------------------------------<<<<

function UIChatTableView:getChooseSort()
    -- body

    return contentSort
end

function UIChatTableView:chooseItem( sort )
    -- body

    contentSort = sort
end

return UIChatTableView