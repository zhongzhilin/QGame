--region UIRedBag.lua
--Author : yyt
--Date   : 2018/02/11
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRedBag  = class("UIRedBag", function() return gdisplay.newWidget() end )

function UIRedBag:ctor(isnew)
	if isnew then 
		self:CreateUI()
	end     
end

function UIRedBag:CreateUI()
    local root = resMgr:createWidget("effect/radbag_01")
    self:initUI(root)
end

function UIRedBag:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "effect/radbag_01")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.num = self.root.Button_1.icon.num_export

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:getGiftHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRedBag:setData()

	local redLog = global.chatData:getChatUnionGift()
	local curCanGetNum = 0
	for k,v in pairs(redLog) do
		if v.lAddTime > global.dataMgr:getServerTime() then
			curCanGetNum  = curCanGetNum + 1
		end
	end
	if curCanGetNum > 0 then
		self.num:setString(curCanGetNum)
		self:showHint()
	else
		self:hideHint()
	end
end

function UIRedBag:showHint()

    self.root:setVisible(true)
	self.root:stopAllActions()
	local nodeTimeLine = resMgr:createTimeline("effect/radbag_01")
    nodeTimeLine:gotoFrameAndPause(0)
    self.root:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0", true)
end

function UIRedBag:hideHint()
	self.root:setVisible(false)
end

function UIRedBag:getGiftHandler(sender, eventType)
	
	local redLog = global.chatData:getChatUnionGift()
	if table.nums(redLog) > 0 then

		table.sort(redLog, function(s1, s2) return s1.lAddTime > s2.lAddTime end) 

		local giftId = redLog[1].lID
		-- 发送方信息
		local lFaceID = redLog[1].lFaceID
		local lBackID = redLog[1].lBackID
		local lFrom = redLog[1].lUserID
		local szCustomIco = redLog[1].szCustomIco
		local szPara = global.tools:strSplit(redLog[1].szName, '|')
		local szFrom = szPara[3] or ""
		local totalNum = szPara[2] or ""
		local lType = szPara[1] or "" -- 2世界3联盟

		global.chatApi:chatRedGift(function (msg, ret)

			local data = {tagSpl={}}
			data.tagSpl.szParam = giftId .. "+" .. "0" .. "+" .. totalNum
			data.lFaceID = lFaceID
			data.lBackID = lBackID
			data.lFrom = lFrom
			data.szFrom = szFrom
			data.lType = tonumber(lType)
			data.szCustomIco = szCustomIco
	        global.panelMgr:openPanel("UIChatGiftPanel"):setData(data, msg, ret)
	        
	    end, 2, {giftId})
	end
end
--CALLBACKS_FUNCS_END

return UIRedBag

--endregion
