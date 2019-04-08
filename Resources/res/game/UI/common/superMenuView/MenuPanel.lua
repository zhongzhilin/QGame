--[[
#  MenuPanel describe
#  creation time 2016/06/02 17:39:50
#  @author East
#]]

------------------------------------------------class---------------------------------------
local MenuPanel = class("MenuPanel", function() 
		return gdisplay.newNode()
	end);

------------------------------------------------local var---------------------------------------------

local CELL_HEIGHT = 72;
-----------------------------------------------public var----------------------------------------------


------------------------------------------------private var-------------------------------------------
MenuPanel._ui = nil;
------------------------------------------------public method-----------------------------------------

function MenuPanel:setTableViewData(d)

		self._listData = {};
		for i = 1, #d do
			self._listData[i] = { btnType = 1, cellId = i, openFlag = 0, data = d[i].data, childDatas = d[i].childDatas };
			if self._listData[i].childDatas == nil then
				self._listData[i].childDatas = {}
			end
		end

		self.tableView:reloadData();

end


function MenuPanel:selectHdr(parentIndex, childIndex)
	self:tabClickCallHdr(1, parentIndex, 0, self._listData[parentIndex]);
	if childIndex > 0 and self._listData[parentIndex].childDatas[childIndex] then
		self:tabClickCallHdr(2, parentIndex, childIndex, self._listData[parentIndex].childDatas[childIndex]);
	end
end	

------------------------------------------------private method---------------------------------------------

function MenuPanel:ctor(ui, cellHeight, bigBtnClass, clickHdr)
	self._ui = ui;
	self._ui:addChild(self);

	self._listData = {};
	CELL_HEIGHT = cellHeight;
	self._TabBigBtn = bigBtnClass;
	self._clickHdr = clickHdr;
	self:_createTableViewHdr();
end


function MenuPanel:_createTableViewHdr()
	local tempSize1 = self._ui:getContentSize();
	self._scrollSize = tempSize1;

	local function cellSizeForTable(table,idx) 
		local addHeight = 0;
		if self._listData[idx+1] then
			if self._listData[idx+1].openFlag ~= 0 then
				addHeight = CELL_HEIGHT*#self._listData[idx+1].childDatas;
			end
		end
	    return tempSize1.width,CELL_HEIGHT+addHeight;
	end

	
	self.renderAry = {};
	local function tableCellAtIndex(table, idx)
	    local cell = table:dequeueCell()
	    local label = nil
	    if nil == cell then
	        cell = cc.TableViewCell:new()
	        local tempCell = self._TabBigBtn.new(CELL_HEIGHT, function(btnType, cellId, index, data) 
	        		self:tabClickCallHdr(btnType, cellId, index, data);
	        	end);
	        self.renderAry[#self.renderAry+1] = tempCell;
	        tempCell:setTag(12388);
	        cell:addChild(tempCell);
	    end
	    cell:getChildByTag(12388):updateRenderData(self._listData[idx+1]);

	    return cell
	end

	local function numberOfCellsInTableView(table)
	   return #self._listData;
	end

	self.tableView = UILoadTableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

	self.tableView = cc.TableView:create(cc.size(tempSize1.width, tempSize1.height))
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setPosition(cc.p(0, 0))
    self.tableView:setDelegate()
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self._ui:addChild(self.tableView)

    self.tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tableView:reloadData()
end	

function UITableView:setSize(size,topNode,buttomNode)
    if topNode ~= nil then
        
        local topY = topNode:getPositionY()
        local buttomY = 0

        if buttomNode ~= nil then

            buttomY = buttomNode:getPositionY()
        end

        size.height = topY - buttomY
        self.tableView:setPositionY(buttomY)
    end

    self.tableView:initWithViewSize(size)
    
    return self.tableView
end

function MenuPanel:tabClickCallHdr(btnType, cellId, index, data)
	if btnType == 2 then
		if self._curParentChildIndex == cellId and self._curChildIndex == index then
			return;
		end
		self._curChildIndex = index;
		self._curParentChildIndex = cellId;
		self._clickHdr(cellId, index, data);
	elseif btnType == 1 then
		local tempOpenData = nil;
		local tempOpenIndex = 0;
		if self._curParentIndex == cellId then
			self._curParentIndex = -1;
		else
			self._curParentIndex = cellId;
		end


		if #data.childDatas <= 0 then
			self._clickHdr(cellId, index, data.data);
			self._curChildIndex = 0
		end

		

		for i, v in ipairs(self._listData) do
			if v.cellId == cellId then
				if v.openFlag ~= 0 then
					v.openFlag = 0;
				else
					v.openFlag = 1;
				end
				tempOpenData = v;
				tempOpenIndex = i;
			else
				v.openFlag = 0;
			end			
		end
	
		local tempPreOffVec2 = self.tableView:getContentOffset();
		local tempPreTableviewSize = self.tableView:getContentSize();
		local tempTopOverH = tempPreTableviewSize.height + tempPreOffVec2.y - self._scrollSize.height;

		self.tableView:reloadData();
		local tempDiff = 0;
		-- if tempOpenData then
		-- 	tempDiff = CELL_HEIGHT*tempOpenIndex
		-- end

		local tempNowTableViewSize = self.tableView:getContentSize();
		local scrollHeight = tempNowTableViewSize.height;
		local isAnimation = false;
		if self._curParentIndex ~= -1 then
			-- local tempStartY = self._scrollSize.height - scrollHeight;
			-- tempDiff = tempStartY + (tempOpenIndex-1)*CELL_HEIGHT;
			tempDiff = tempTopOverH + self._scrollSize.height - tempNowTableViewSize.height;
		else
			tempDiff = tempTopOverH + self._scrollSize.height - tempNowTableViewSize.height;
			isAnimation = false;
		end
		if self._scrollSize.height < tempNowTableViewSize.height and tempDiff > 0 then
			tempDiff = 0;
		elseif self._scrollSize.height > tempNowTableViewSize.height then
			tempDiff = self._scrollSize.height - tempNowTableViewSize.height
		end

		self.tableView:setContentOffset(cc.p(0, tempDiff), isAnimation);
	end
	self:_updateMenuBtnState();


end

function MenuPanel:_updateMenuBtnState()
	for i, v in ipairs(self.renderAry) do
		v:setSelectState(self._curParentIndex);
		v:setSelectChild(self._curParentChildIndex, self._curChildIndex);
	end
end

return MenuPanel;
