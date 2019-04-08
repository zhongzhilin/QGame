--[[
#  MenuSmallBtn describe
#  creation time 2016/06/02 17:47:39
#  @author East
#]]

------------------------------------------------class---------------------------------------
local MenuBaseBtn = require("game.UI.common.superMenuView.MenuBaseBtn");
local MenuSmallBtn = class("MenuSmallBtn", MenuBaseBtn);

------------------------------------------------local var---------------------------------------------

-----------------------------------------------public var----------------------------------------------
function MenuSmallBtn:updateRenderData(d)
	MenuSmallBtn.super.updateRenderData(self, d);
	-- self:setPosition(cc.p(10, 0));
end

-- function MenuSmallBtn:getTabBtn()
-- 	return self._root.btn_one;
-- end
------------------------------------------------private var-------------------------------------------
------------------------------------------------public method-----------------------------------------

function MenuSmallBtn:init()
	
end

function MenuSmallBtn:btnClickHdr()
	self._callFun(2, self._cellId, self._index, self._data);
end


function MenuSmallBtn:setSelectState(parentIndex, selectIndex)
	self:setSelectStateShow(parentIndex == self._cellId and self._index == selectIndex);
end


------------------------------------------子类重写部分


function MenuSmallBtn:getSmallBtnRes()
	return nil;
end
--------------------------------------------------------


------------------------------------------------private method---------------------------------------------

function MenuSmallBtn:ctor(cellId, index, CELL_HEIGHT, callFun)
	self._cellId = cellId;
	self._index = index;
	local btnUIRes = self:getSmallBtnRes();
	MenuSmallBtn.super.ctor(self, CELL_HEIGHT, callFun, btnUIRes);
end



return MenuSmallBtn;
