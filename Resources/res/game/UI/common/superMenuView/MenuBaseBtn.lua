--[[
#  MenuBaseBtn describe
#  creation time 2016/06/02 17:54:55
#  @author East
#]]

------------------------------------------------class---------------------------------------
local MenuBaseBtn = class("MenuBaseBtn", function()	return gdisplay.newNode() end);

------------------------------------------------local var---------------------------------------------
local resMgr = global.resMgr
local uiMgr = global.uiMgr
-----------------------------------------------public var----------------------------------------------


------------------------------------------------private var-------------------------------------------
MenuBaseBtn._tabBtn = nil;
MenuBaseBtn._callFun = nil;
------------------------------------------------public method-----------------------------------------
function MenuBaseBtn:init()

end

function MenuBaseBtn:updateRenderData(d)
	self._data = d;
	if d == nil then
		self:setVisible(false);
		return;
	else
		self:setVisible(true);
	end

end

function MenuBaseBtn:btnClickHdr()
	print("you are wrong")
end

function MenuBaseBtn:getTabBtn()
	return self._root.btn_type;
end

function MenuBaseBtn:setSelectState(selectIndex)
	
end

function MenuBaseBtn:setSelectStateShow(isSelect)
	
end
------------------------------------------------private method---------------------------------------------

function MenuBaseBtn:ctor(CELL_HEIGHT, callFun, selfResStr)
	self._CELL_HEIGHT = CELL_HEIGHT;
	self._callFun = callFun;
	local tempResStr = selfResStr;
	local root = resMgr:createWidget(tempResStr);
	self:addChild(root)
	self._root = root;

	self._root:setPosition(cc.p(0, CELL_HEIGHT));

	uiMgr:configUITree(self._root)
    uiMgr:configUILanguage(self._root, tempResStr)

    self._tabBtn = self:getTabBtn();

	local tempSize1 = self._tabBtn:getContentSize();
    self:setContentSize(cc.size(tempSize1.width, tempSize1.height))
    -- ccui.Helper:doLayout(self._root)
    
    self._tabBtn:setSwallowTouches(false);

    uiMgr:addWidgetTouchHandler(self._tabBtn, function(sender, eventType)
    	if eventType == ccui.TouchEventType.began then 
    		self._beginPos = self:convertToWorldSpace(cc.p(0, 0));

    	elseif eventType == ccui.TouchEventType.ended then 
    		local tempEndPos = self:convertToWorldSpace(cc.p(0, 0));
    		if math.abs(tempEndPos.y - self._beginPos.y) <= 6 then
    			self:btnClickHdr();
    		end
    	end
     end, true)
    

    self:init();

end



return MenuBaseBtn;
