local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UITableView = require("game.UI.common.UITableView")
local UIDownSelectItemView = class("UIDownSelectItemView",function() return UITableView.new() end)

local UIDownSelectCell = require("game.UI.common.selectItemView.UIDownSelectCell")

local contentSort = -1

function UIDownSelectItemView:ctor(tableView, idx)
    -- body
    self.cellTable = {}
    UITableView.ctor(self)
end

------------------------------overwrite----------------------------------------->>>>
-- function UIDownSelectItemView:tableCellSizeForIndex(tableView, idx)

--     local tableData = self.__tableData[idx + 1]
--     if tableData then
--         return self.__cellSize.width, tableData.uiData.h
--     end

--     return self.__cellSize.width, self.__cellSize.height
-- end


function UIDownSelectItemView:tableCellAtIndex(tableView, idx)
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
            cell.tv_target = UIDownSelectCell.new(self.__cellCsbTemplate,self.__delegate)
            cell:addChild(cell.tv_target)
        end
        cell.tv_target:setData(self.__tableData[idx + 1],self.__itemUpdateCall)
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
------------------------------overwrite-----------------------------------------<<<<

function UIDownSelectItemView:setCellCsbTemplate(template,itemUpdateCall,delegate)
    self.__cellCsbTemplate = template
    self.__itemUpdateCall = itemUpdateCall
    self.__delegate = delegate
    return self
end

return UIDownSelectItemView