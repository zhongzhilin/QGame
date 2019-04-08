--[[
#  MenuBigBtn describe
#  creation time 2016/06/02 17:47:28
#  @author East
#]]

------------------------------------------------class---------------------------------------
local MenuBaseBtn = require("game.UI.common.superMenuView.MenuBaseBtn");
local MenuBigBtn = class("MenuBigBtn", MenuBaseBtn);


------------------------------------------------local var---------------------------------------------

-----------------------------------------------public var----------------------------------------------

function MenuBigBtn:updateRenderData(d)
	MenuBigBtn.super.updateRenderData(self, d);

	self:setPosition(cc.p(0, 0));


	for i = 1, #self._childRenders do
		self._childRenders[i]:removeFromParent(true);
	end
	self._childRenders = {};

	
	if d.openFlag ~= 0 and self._TabSmallBtn then
		self:setPosition(cc.p(0, #d.childDatas*self._CELL_HEIGHT1));

		for i = 1, #d.childDatas do
			local tempRender = self._TabSmallBtn.new(self._data.cellId, i, self._CELL_HEIGHT2, self._callFun);
			-- tempRender:setPosition(cc.p(0, -i*self._CELL_HEIGHT2));
			if d.openFlag == 1 then
				tempRender:setPosition(cc.p(0, 0));--cc.p(0, -i*self._CELL_HEIGHT2 + #d.childDatas * self._CELL_HEIGHT2)
				tempRender:runAction(cc.MoveTo:create(0.2, cc.p(0, -i*self._CELL_HEIGHT2)));
			else
				tempRender:setPosition(cc.p(0, -i*self._CELL_HEIGHT2));
			end
			self:addChild(tempRender, -1);
			tempRender:updateRenderData(d.childDatas[i])
			self._childRenders[i] = tempRender;
		end
		
		d.openFlag = 2;
	end


	self:setSelectState(self.__curSelectIndex);
	self:setSelectChild(self.__parentChildIndex, self.__curChildIndex);


end

function MenuBigBtn:btnClickHdr()
	self._callFun(1, self._data.cellId, 0, self._data);
end


function MenuBigBtn:setSelectChild(parentChildIndex, childIndex)
	self.__curChildIndex = childIndex;
	self.__parentChildIndex = parentChildIndex;
	for i, v in ipairs(self._childRenders) do
		v:setSelectState(parentChildIndex, childIndex);
	end
end

function MenuBigBtn:setSelectState(selectIndex)
	self.__curSelectIndex = selectIndex;
	self:setSelectStateShow(self._data.cellId == selectIndex);
end
------------------------------------------------private var-------------------------------------------
------------------------------------------------public method-----------------------------------------

function MenuBigBtn:init()
	
end

------------------------------------------子类重写部分
function MenuBigBtn:getSmallCellHeight()
	return 70;
end

function MenuBigBtn:getTabSmallBtnClass()
	return nil;
end



function MenuBigBtn:getBigBtnRes()
	return nil;
end
--------------------------------------------------------


------------------------------------------------private method---------------------------------------------

function MenuBigBtn:ctor(CELL_HEIGHT, callFun)
	self._TabSmallBtn = self:getTabSmallBtnClass();
	self._CELL_HEIGHT2 = self:getSmallCellHeight();
	self._CELL_HEIGHT1 = CELL_HEIGHT;
	local bigBtnUIRes = self:getBigBtnRes();

	self._childRenders = {};

	MenuBigBtn.super.ctor(self, self._CELL_HEIGHT1, callFun, bigBtnUIRes);
end



return MenuBigBtn;
