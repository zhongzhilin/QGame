local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UITableView = require("game.UI.common.UITableView")
local UIBagTableView = class("UIBagTableView",function() return UITableView.new() end)

local contentSort = -1

function UIBagTableView:ctor(tableView, idx)
    -- body
    self.cellTable = {}
    UITableView.ctor(self)
end

function UIBagTableView:tableCellSizeForIndex(tableView, idx)

    local tableData = self.__tableData[idx + 1]
    if tableData and tableData.sort == contentSort then

        return self.__cellSize.width, self.__cellSize.height + 200    
    end

    return self.__cellSize.width, self.__cellSize.height
end

function UIBagTableView:getChooseSort()
    -- body

    return contentSort
end

function UIBagTableView:chooseItem( sort )
    -- body

    contentSort = sort
end

-- function UIBagTableView:tableCellAtIndex(tableView, idx)   
        
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

function UIBagTableView:tableCellAtIndex(tableView, idx)
    local cell = self:dequeueCell()
    if cell == nil then 
        cell = cc.TableViewCell:create()
        table.insert(self.__cellList, cell)
    end

    local sIdx = self.__selectedIndex
    local dt = 0.015+1/30*idx
    local updateCall = function()
        -- body
        cell:setVisible(true)
        if not cell.tv_target or tolua.isnull(cell.tv_target) then
            cell.tv_target = self.__cellTemplate.new()
            cell:addChild(cell.tv_target)
        end
        cell.tv_target:setData(self.__tableData[idx + 1])
        if cell.tv_target.setFocus then
            cell.tv_target:setFocus(sIdx~=nil and sIdx == idx)
            --2017年3月1日20:08:04 z  末尾刪除item 讓光標定位到上一個
             if sIdx-idx==1 and #self.__tableData==sIdx then
                sIdx =sIdx-1
                cell.tv_target:setFocus(sIdx~=nil and sIdx== idx)
            end 
        end
    end
    if self.__isFirstIn then
        cell:setVisible(false)
        cell:runAction(cc.Sequence:create(cc.DelayTime:create(dt),cc.CallFunc:create(updateCall)))
    else
        updateCall()
    end
    return cell
end

return UIBagTableView