local resMgr = global.resMgr
local uiMgr = global.uiMgr

local UITableView = require("game.UI.common.UITableView")
local UIEquipTableView = class("UIEquipTableView",function() return UITableView.new() end)
local UIEquipInfo = require("game.UI.equip.UIEquipInfo")

function UIEquipTableView:ctor()    
    
    UITableView.ctor(self)
end

function UIEquipTableView:tableCellSizeForIndex(tableView, idx)

	if idx == self.__selectedIndex then

        print(self.infoNode:getContentHeigth())
		return self.__cellSize.width, self.__cellSize.height + self.infoNode:getContentHeigth()
	end

    return self.__cellSize.width, self.__cellSize.height
end

function UIEquipTableView:setFocus(idx)	

    if not self.__tableData[idx + 1] then

        print("warning multiply touch")

        return
    end

	if self.__selectedIndex == idx then

		self.__selectedIndex = nil		        
	else

		self.__selectedIndex = idx

        if not self.infoNode then

            self.infoNode = UIEquipInfo.new(true)
            self.infoNode.tb = self
            self.infoNode:retain()
        end

        self.infoNode:setPositionX((idx % 4) * -self.__cellSize.width)
        self.infoNode:setData(self.__tableData[idx + 1],self.contentHeroId)        
        self.infoNode:setButton(self.equipInfoData.isShowButton,self.equipInfoData.buttonStr,self.equipInfoData.isSinglePanel,self.equipInfoData.callback)
        -- self.infoNode.root:setOpacity(0)
        -- self.infoNode.root:runAction(cc.FadeIn:create(0.4))
	end    	

    self:flush(true,idx % 4)
end

function UIEquipTableView:setEquipInfoData(data)
    
    self.equipInfoData = data
end

--TODO
function UIEquipTableView:out()

    print(">>>equip table view out")

    self:cleanFocus()
    if self.infoNode then

        print(">>>equip table view out release info node")

        if self.infoNode:getParent() then
            self.infoNode:removeFromParent()
        end

        self.infoNode:release()
        self.infoNode = nil
    end
end

function UITableView:cleanFocus()
    self.__selectedIndex = nil
    for k, v in ipairs(self.__cellList) do
        if v.setFocus then
            v:setFocus(false)
        else
            return self
        end
    end        
end

function UIEquipTableView:flush(isHavaAction,index)
    
    
    if self.infoNode then

        if self.infoNode:getParent() then

            self.infoNode:removeFromParent()            
        end
    end    
    
    local preOff = self:getContentOffset()
    local minOff = self:minContainerOffset()

    self:reloadData()             

    self:checkIsOutOffset(preOff,minOff)

    if isHavaAction and self.infoNode then
        
        self.infoNode:showUse()
        self.infoNode:setDirIndex(index)
        
        self.infoNode:checkOutScreen()
    end
end

function UIEquipTableView:tableCellTouched(tableView, cell)

    if self.infoNode and self.infoNode:getIsInTouch() then

        print("table cell touch is in touch")
        return
    end

    print("table cell touch not touch")

    if cell.tv_target and cell.tv_target.onClick then
        cell.tv_target:onClick()
    end

    local idx =  cell:getIdx()
    if self.cellClickHandler then
        self.cellClickHandler(self.__tableData[idx + 1], cell)
    end

    if cell.tv_target and cell.tv_target.setFocus then
        
        self:setFocus(idx)    	
    end
end

function UIEquipTableView:checkIsOutOffset(contentOffset,preMinOff)
	
	local minOffset = self:minContainerOffset()

    contentOffset.y = contentOffset.y - (preMinOff.y - minOffset.y)

    if contentOffset.y > 0 then contentOffset.y = 0 end
    if contentOffset.y < minOffset.y then contentOffset.y = minOffset.y end

    self:setContentOffset(contentOffset, false)
end

function UIEquipTableView:tableCellAtIndex(tableView, idx)
    
    local cell = self:dequeueCell()
    if cell == nil then 
        cell = cc.TableViewCell:create()
        table.insert(self.__cellList, cell)
    end

    local dt = 0.015+1/30*idx
    local sIdx = self.__selectedIndex
    local sNode = self.infoNode
    local updateCall = function()
        -- body
        cell:setVisible(true)
        if not cell.tv_target or tolua.isnull(cell.tv_target) then
            cell.tv_target = self.__cellTemplate.new()
            cell:addChild(cell.tv_target)
        end
        cell.tv_target:setData(self.__tableData[idx + 1])
        if cell.tv_target.setFocus then
            cell.tv_target:setFocus(sIdx~=nil and sIdx == idx,sNode)
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

return UIEquipTableView