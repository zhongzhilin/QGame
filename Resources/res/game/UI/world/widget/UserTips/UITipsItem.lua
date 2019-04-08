--region UITipsItem.lua
--Author : untory
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITipsItem  = class("UITipsItem", function() return gdisplay.newWidget() end )

function UITipsItem:ctor()
  
 	self:CreateUI()
end

function UITipsItem:CreateUI()
    local root = resMgr:createWidget("world/info/stickers_d")
    self:initUI(root)
end

function UITipsItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/stickers_d")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.tisp_node = self.root.tisp_node_export
    self.bg = self.root.tisp_node_export.bg_export
    self.time = self.root.tisp_node_export.time_export
    self.rich_node = self.root.tisp_node_export.rich_node_export
    self.time_node = self.root.time_node_export
    self.top_time = self.root.time_node_export.top_time_export

--EXPORT_NODE_END	
end

function UITipsItem:setData(data)
	
	if data.isTitle then

		self.time_node:setVisible(true)
		self.tisp_node:setVisible(false)

		self.top_time:setString(data.tileStr)
	else

		-- int tag, const Color3B& color, GLubyte opacity, const std::string& text, const std::string& fontName, float fontSize, const Color4B &outlineColor = Color4B::WHITE , float outlineSize = 0.0f

		self.time_node:setVisible(false)
		self.tisp_node:setVisible(true)

		self.rich_node:removeAllChildren()

		local contentTime = global.funcGame.formatTimeToTime(1483528378)

	    local time = global.funcGame.formatTimeToTime(data.lTime)
	    self.time:setString(string.format("%s:%s", time.hour,time.minute))

	    self.bg:setVisible(data.isShowBar)

		if data.lFlag == 1 then
			
			local richText = ccui.RichText:create()
		    richText:setContentSize(cc.size(600, 72))
		    richText:setAnchorPoint(cc.p(0,0.5))
		    self.rich_node:addChild(richText)

		    local re1 = nil 
		    
		    if data.isOwn then

		    	re1 = ccui.RichElementText:create(1, cc.c4b(0,0,0,255), 255, data.userName,"fonts/normal.ttf", 24)
		    else

		    	re1 = ccui.RichElementText:create(1, cc.c4b(255,185,34,255), 255, data.userName,"fonts/normal.ttf", 20,cc.c4b(0, 0,0, 255),2)
		    end

		    richText:pushBackElement(re1)

		    re1 = ccui.RichElementText:create(1, cc.c4b(0,0,0,255), 255,luaCfg:get_local_string(10274),"fonts/normal.ttf", 24)
		    richText:pushBackElement(re1)

		    re1 = ccui.RichElementText:create(1, cc.c4b(255,185,34,255), 255, data.szSendName,"fonts/normal.ttf", 20,cc.c4b(0, 0,0, 255),2)
		    richText:pushBackElement(re1)

		    re1 = ccui.RichElementText:create(1, cc.c4b(0,0,0,255), 255, luaCfg:get_local_string(10275),"fonts/normal.ttf", 24)
		    richText:pushBackElement(re1)		    		 		  

		    re1 = ccui.RichElementText:create(1, cc.c4b(255,255,255,255), 255, data.szContent,"fonts/normal.ttf", 20,cc.c4b(0, 0,0, 255),2)
		    richText:pushBackElement(re1)

		    re1 = ccui.RichElementText:create(1, cc.c4b(0,0,0,255), 255, luaCfg:get_local_string(10273),"fonts/normal.ttf", 24)
		    richText:pushBackElement(re1)

		    richText:formatText()		

		    -- self.root.tisp_node_export.Button_3:setVisible(false)   		   			
		else

			local richText = ccui.RichText:create()
		    richText:setContentSize(cc.size(600, 72))
		    richText:setAnchorPoint(cc.p(0,0.5))
		    self.rich_node:addChild(richText)

		    local re1 = ccui.RichElementText:create(1, cc.c4b(255,226,165,255), 255, data.szSendName,"fonts/normal.ttf", 20,cc.c4b(0, 0,0, 255),2)
		    richText:pushBackElement(re1)

		    -- re1 = ccui.RichElementText:create(1, cc.c4b(0,0,0,255), 255, " " ..luaCfg:get_local_string(10271),"fonts/normal.ttf", 24)
		    -- richText:pushBackElement(re1)

		    -- if data.isOwn then

		    -- 	re1 = ccui.RichElementText:create(1, cc.c4b(0,0,0,255), 255, data.userName,"fonts/normal.ttf", 24)
		    -- else

		    -- 	re1 = ccui.RichElementText:create(1, cc.c4b(255,208,65,255), 255, data.userName,"fonts/normal.ttf", 20,cc.c4b(0, 0,0, 255),2)
		    -- end
		    
		    -- richText:pushBackElement(re1)

		    re1 = ccui.RichElementText:create(1, cc.c4b(0,0,0,255), 255, " " .. luaCfg:get_local_string(10272),"fonts/normal.ttf", 24)
		    richText:pushBackElement(re1)

		    re1 = ccui.RichElementText:create(1, cc.c4b(255,255,255,255), 255, data.szContent,"fonts/normal.ttf", 20,cc.c4b(0, 0,0, 255),2)
		    richText:pushBackElement(re1)

		    re1 = ccui.RichElementText:create(1, cc.c4b(0,0,0,255), 255, luaCfg:get_local_string(10273),"fonts/normal.ttf", 24)
		    richText:pushBackElement(re1)

		    richText:formatText()		   		   

		    -- if data.isOwn then

		    -- 	self.root.tisp_node_export.Button_3:setVisible(true)
		    -- else

		    -- 	self.root.tisp_node_export.Button_3:setVisible(false)
		    -- end		    
		end		
	end	

	self.data = data

    -- self.time:setString(.year)
    -- self.time:setString("global.funcGame.formatTimeToTime(data.lTime).year")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITipsItem:deleteItem(sender, eventType)

	local panel = global.panelMgr:openPanel("UIPromptPanel")
	panel:setData("StickersDeleteConfirm", function()
		
		global.worldApi:deleteTips(global.g_worldview.worldPanel.chooseCityId, self.data.lID, function(msg)
       
	       global.panelMgr:getPanel("UITipsPanel"):flushContent()
	    end)    
	end,self.data.szContent)    
end
--CALLBACKS_FUNCS_END

return UITipsItem

--endregion
