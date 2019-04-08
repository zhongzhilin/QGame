--region UIScrollText.lua
--Author : untory
--Date   : 2017/05/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local labelSplitWidth = 50
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIScrollText  = class("UIScrollText", function() return gdisplay.newWidget() end )

function UIScrollText:ctor()
   
   self:CreateUI() 
end

function UIScrollText:CreateUI()
    local root = resMgr:createWidget("common/common_scroll_text")
    self:initUI(root)
end

function UIScrollText:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_scroll_text")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.clip = self.root.clip_export

--EXPORT_NODE_END
end

function UIScrollText:setData(text)
	
	local size = text:getContentSize()
	local pos = cc.p(text:getPosition())
	local aPos = cc.p(text:getAnchorPoint())

	text:getParent():addChild(self)

	self.clip:setContentSize(size)
	self.clip:setPosition(pos)
	self.clip:setAnchorPoint(aPos)

	text:retain()
	text:removeFromParent()
	self.clip:addChild(text)
	text:release()

	text:setPosition(cc.p(0,0))	
	text:setAnchorPoint(cc.p(0,0))

	self.text = text

	self.tailText = text:clone()
	self.tailText:setVisible(false)
	self.clip:addChild(self.tailText)	

	local preFunc = text.setString
	text.setString = function(text,str)
		
		print("start check scroll")

		preFunc(text,str)
		self.tailText:setString(str)	
		self:checkScroll()
	end

	text.getScrollText = function(text)
	
		return self
	end
end

function UIScrollText:checkScroll()

	local contentSize = self.text:getContentSize()
	local clipSize = self.clip:getContentSize()
	self.text:stopAllActions()	
	self.tailText:stopAllActions()	

	print(contentSize.width,clipSize.width)
	if contentSize.width > clipSize.width then

		local cutSize = contentSize.width - clipSize.width + 4
		self.text:setPositionX(0)
		self.tailText:setPositionX(contentSize.width + labelSplitWidth)
		self.tailText:setVisible(true)
		
		local time = (contentSize.width + labelSplitWidth) / 30

		self.text:runAction(cc.RepeatForever:create(
			cc.Sequence:create(cc.MoveBy:create(time,cc.p(-contentSize.width - labelSplitWidth,0)),
				cc.MoveBy:create(0,cc.p(contentSize.width + labelSplitWidth,0)))))

		self.tailText:runAction(cc.RepeatForever:create(
			cc.Sequence:create(cc.MoveBy:create(time,cc.p(-contentSize.width - labelSplitWidth,0)),
				cc.MoveBy:create(0,cc.p(contentSize.width + labelSplitWidth,0)))))
	else

		local x = cc.p(self.clip:getAnchorPoint()).x * 0.95
		local cutSize = clipSize.width - contentSize.width
		self.tailText:setVisible(false)
		self.text:setPositionX(x * cutSize)	
	end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIScrollText

--endregion
