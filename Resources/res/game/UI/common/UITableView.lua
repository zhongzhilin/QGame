--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local UITableView = class("UITableView", function() return cc.TableView:create(cc.size(0,0)) end )

function UITableView:ctor()
    self:setDelegate()
    self:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self:registerScriptHandler(handler(self, self.tableCellSizeForIndex), cc.TABLECELL_SIZE_FOR_INDEX)
    self:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
    self:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.__cellList = {}
    
  
    -- self:openRemoveUnusedTouches()
    if not self.m_eventNode then
        local node = gdisplay.newWidget()
        node.onEnter = function()
            self:onNodeEnter()
        end
        node.onExit = function()
            self:onNodeExit()
        end
        self:addChild(node)
        self.m_eventNode = node
    end
    return self
end

function UITableView:onNodeEnter()
end

function UITableView:onNodeExit()
    self:clearTouches()
end

function UITableView:numberOfCellsInTableView(tableView)
    if self.__tableData then
        return #self.__tableData
    else
        return 0
    end
end

function UITableView:tableCellSizeForIndex(tableView, idx)
    
    return self.__cellSize.width, self.__cellSize.height
end



function UITableView:tableCellAtIndex(tableView, idx)

    print("############UITableView:tableCellAtIndex(tableView, idx)=---》idx="..idx)
    local cell = self:dequeueCell()
    if cell == nil then 
        cell = cc.TableViewCell:create()
        table.insert(self.__cellList, cell)
    end

    local sIdx = self.__selectedIndex or 0
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

    if self.__isYorder then
        cell:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(function()
            -- body
            local cellY = cell:getPositionY()
            cell:setLocalZOrder(-cellY)
        end)))
    end
    return cell
end

function UITableView:tableCellTouched(tableView, cell)
    if cell.tv_target and cell.tv_target.onClick then
        cell.tv_target:onClick()
    end

    print(tolua.type(cell))
    local idx =  cell:getIdx()
    if self.cellClickHandler then
        self.cellClickHandler(self.__tableData[idx + 1], cell)
    end

    if cell.tv_target and cell.tv_target.setFocus then
        self.__selectedIndex = idx
        for k, v in ipairs(self.__cellList) do
            if v.tv_target and v.tv_target.setFocus then
                v.tv_target:setFocus(self.__selectedIndex == v:getIdx())
            end
        end        
    end
end

function UITableView:scrollViewDidScroll(tableView, cell)
    --print("------>UITableView:scrollViewDidScroll(tableView, cell)")
    if self.scrollViewDidScroll_ then self.scrollViewDidScroll_(tableView, cell) end
end

function UITableView:cleanFocus()
    self.__selectedIndex = nil
    for k, v in ipairs(self.__cellList) do
        if v.tv_target and v.tv_target.setFocus then
            v.tv_target:setFocus(false)
        else
            return self
        end
    end        
end

function UITableView:scrollToBottom()

    local minOffset = self:minContainerOffset()
    if minOffset.y >= 0 then
        return
    end
    local offset = self:getContentOffset()
    self:setContentOffset(cc.p(offset.x,0))
end

function UITableView:setFocusIndex(index)
    self.__selectedIndex = index - 1
    return self
end

function UITableView:setSize(size,topNode,buttomNode)

    if topNode ~= nil then
        
        local topY = topNode:getPositionY()
        local buttomY = 0

        if buttomNode ~= nil then

            buttomY = buttomNode:getPositionY()
        end

        size.height = topY - buttomY
        self:setPositionY(buttomY)
    end

    self:initWithViewSize(size)
    
    return self
end

function UITableView:setCellSize(size)
    self.__cellSize = size
    return self
end

function UITableView:setCellTemplate(template)
    self.__cellTemplate = template
    return self
end

function UITableView:setDidScrollCall(call)
    self.scrollViewDidScroll_ = call
end

function UITableView:setData(data,noReset,isFirstIn)
    -- dump(data,"=========>>data")
    -- dump(self.__tableData,"=========>>i_lastTableData")
    local i_lastTableData = self.__tableData
    self.__tableData = data
    self:setYorder(self:getDirection() == cc.SCROLLVIEW_DIRECTION_VERTICAL)
    if noReset then
        self.__isFirstIn = false
        self:updateNoReset(i_lastTableData)
    else
        if isFirstIn == nil then
            self.__isFirstIn = false
        else
            self.__isFirstIn = isFirstIn
        end
        self:reloadData()
    end
    self.__isFirstIn = false
end

function UITableView:updateNoReset(i_lastTableData)
    if i_lastTableData and self.__tableData and #self.__tableData == #i_lastTableData then
    -- dump(self.__cellList)
        for k, v in ipairs( self.__cellList) do
            if v.tv_target and v.tv_target.setData then
                v:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(function()
                    --延迟一帧
                    local data = self.__tableData[v:getIdx()+1]
                    if v:getIdx()>=0 and data then
                        v.tv_target:setData(data)
                    end
                end)))
            else
                return
            end
        end
    else
    print("##########################5")
        self:reloadData()
    end
end

function UITableView:update(data)
    if data then
        self.__tableData = data
    end
    for k, v in ipairs( self.__cellList) do
        if v.tv_target and v.tv_target.updateUI then
            v.tv_target:updateUI()
        else
            return
        end
    end
end

function UITableView:setCellClickHandler(handler)
    self.cellClickHandler = handler
end

------------------------API----------------------------
function UITableView:scrollToLeft()
    local offset = self:getContentOffset()
    self:setContentOffset(cc.p(0,offset.y))
end

function UITableView:scrollToRight(isNoDelay)
    self.__tableData = self.__tableData or {}
    local offset = self:getContentOffset()
    self:jumpToCellByIdx(#self.__tableData, isNoDelay)
end

function UITableView:jumpToCellByIdx(idx,isNoDelay)
    local offset = self:getContentOffset()
    local x = 0 
    if idx > 2 then
        x = 0-self.__cellSize.width*(idx-2)
    end
    log.trace("#####UITableView:jumpToCellByIdx idx=%s,beforex=%s",idx,x)

    local minOffset = self:minContainerOffset()
    local maxOffset = self:maxContainerOffset()
    x = math.max(minOffset.x, math.min(maxOffset.x, x))
    log.trace("#####UITableView:jumpToCellByIdx idx=%s,afterx=%s,maxOffset=%s,minOffset=%s",idx,x,vardump(maxOffset),vardump(minOffset))

    if x > 0 then
        x = 0
    end
    if not isNoDelay then 
        self.scheduleId = gscheduler.performWithDelayGlobal(function()
            self:setContentOffset(cc.p(x,offset.y))
        end,0)
    else
        self:setContentOffset(cc.p(x,offset.y))
    end
end

function UITableView:jumpToCellYByIdx(idx,isNoDelay)
    local offset = self:getContentOffset()
    local y = 0 
    if idx > 2 then
        y = 0-self.__cellSize.height*(idx-2)
    end
    log.trace("#####UITableView:jumpToCellByIdx idx=%s,beforex=%s",idx,y)

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

function UITableView:getData()
    return self.__tableData
end

function UITableView:getCells()
    return self.__cellList
end

function UITableView:getSelectedData()
    if self.__selectedIndex ~= nil then
        return self.__tableData[self.__selectedIndex + 1]
    else
        return nil
    end
end

function UITableView:setYorder(i_order)
    if i_order and (self.__isYorder == i_order) then return end
    self.__isYorder = i_order
end

function UITableView:clearTouches()
    self:setTouchEnabled(false)
    self:setTouchEnabled(true)
end
-------------------------------------------------------

return UITableView

--endregion
