local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UITableView = require("game.UI.common.UITableView")
local UIDynamicTableView = class("UIDynamicTableView",function() return UITableView.new() end)

function UIDynamicTableView:ctor(selectHeight)    
    
    self.selectHeight = selectHeight    
    UITableView.ctor(self)
end

function UIDynamicTableView:tableCellSizeForIndex(tableView, idx)

	if idx == self.__selectedIndex then
		return self.__cellSize.width, self.__cellSize.height + self.selectHeight
	end

    return self.__cellSize.width, self.__cellSize.height
end

function UIDynamicTableView:setFocus(idx)
	
	local preOff = self:getContentOffset()

	if self.__selectedIndex == idx then

		self.__selectedIndex = nil		
	else

		self.__selectedIndex = idx
	end    	

    self:reloadData()     

    self:setContentOffset(preOff,false)       

    self:checkIsOutOffset(preOff)
end

function UIDynamicTableView:tableCellTouched(tableView, cell)
    if cell.onClick then
        cell:onClick()
    end

    local idx =  cell:getIdx()
    if self.cellClickHandler then
        self.cellClickHandler(self.__tableData[idx + 1], cell)
    end

    if cell.setFocus then
        
        self:setFocus(idx)    	
    end
end

function UIDynamicTableView:checkIsOutOffset(contentOffset)
	
	local minOffset = self:minContainerOffset()  
    if contentOffset.y > 0 then contentOffset.y = 0 end
    if contentOffset.y < minOffset.y then contentOffset.y = minOffset.y end

    self:setContentOffset(contentOffset, false)
end

function UIDynamicTableView:tableCellAtIndex(tableView, idx)
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

return UIDynamicTableView