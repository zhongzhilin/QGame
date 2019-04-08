local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UITableView = require("game.UI.common.UITableView")
local UICollectTableView = class("UICollectTableView",function() return UITableView.new() end)

local contentSort = -1

function UICollectTableView:ctor(tableView, idx)
    -- body
    self.cellTable = {}
    UITableView.ctor(self)
end

function UICollectTableView:tableCellSizeForIndex(tableView, idx)

    local tableData = self.__tableData[idx + 1]
    if tableData and tableData.lID == contentSort then

        return self.__cellSize.width, self.__cellSize.height + 138    
    end

    return self.__cellSize.width, self.__cellSize.height
end

function UICollectTableView:getChooseSort()
    -- body

    return contentSort
end

function UICollectTableView:chooseItem( sort )
    -- body

    contentSort = sort
end

function UICollectTableView:tableCellAtIndex(tableView, idx)   
    
    local cell = self:dequeueCell()
    if cell == nil then 
        cell = cc.TableViewCell:create()
        table.insert(self.__cellList, cell)
    end

    local dt = 0.015+1/30*idx
    local sIdx = self.__selectedIndex
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

return UICollectTableView