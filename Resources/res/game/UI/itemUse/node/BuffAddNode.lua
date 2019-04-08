local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local speedData = global.speedData
local funcGame = global.funcGame
local normalItemData = global.normalItemData

local BuffAddNode  = class("BuffAddNode", function() return gdisplay.newWidget() end )

function BuffAddNode:ctor( callFunc )
    self.panel = global.speedPanel 
    self:initUI(callFunc)
end

function BuffAddNode:initUI(callFunc)

	dump(self.panel.buffdata)
	self.panel.queueUnlock_node:setVisible(true)
    self.panel.restTime_node:setVisible(false)
    self.panel.timeline_node:setVisible(false)
    self.panel.queueUnlock_node.txt_leftTime_mlan_34:setString(self.panel.buffdata.des)
    self.panel.txt_Title:setString(self.panel.buffdata.name)
    
end

function BuffAddNode:setItemData(data)
	self.data = data
    local spaceStr = self.panel.spaceNum:getString()
    local itemCount = normalItemData:getItemById(data.itemId).count
    if itemCount <= 0 then
        self:troopSpeedUI(spaceStr, data.itemName)
        self.panel.need:setTextColor(gdisplay.COLOR_RED)
        self.panel.btnUse:setEnabled(false)
    else
        self.panel.btnUse:setEnabled(true)
        self.panel.slider:setVisible(false)
        self.panel.speedTime_node:setVisible(false)
        self.panel.mojing_node:setVisible(true)
        self.panel.btnUse:setEnabled(true)

        self.panel.need:setString(1)
        self.panel.need:setTextColor(cc.c3b(255, 226, 165))
        self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10135), data.itemName) .. "?")
        global.tools:adjustNodePos(self.panel.textHead, self.panel.need)
    end
    self.panel:setLineBreak(self.panel.textEnd, self.panel.textEnd:getString())
   
end

function BuffAddNode:troopSpeedUI(spaceStr, itemName)
    self.panel.slider:setVisible(false)
    self.panel.speedTime_node:setVisible(false)
    
    self.panel.mojing_node:setVisible(true)
    self.panel.btnUse:setEnabled(true)

    self.panel.need:setString(1)
    self.panel.need:setTextColor(cc.c3b(255, 226, 165))
    self.panel.textEnd:setString(self.panel:getSpaceStr()..string.format(luaCfg:get_local_string(10135), itemName) .. "?")
end

function BuffAddNode:warningCall()
self.panel.topModel:setVisible(false)
end 




function BuffAddNode:checkUsed(msg)
	  	if  msg.tgPlus  then 
			dump( msg.tgPlus)
			local data ={count=00,id=self.data.itemId,sort =00}
			-- local panel = global.panelMgr:openPanel("UIPromptPanel")
   --  		panel:setData(self.data.itemId, handler(self, self.warningCall))
   			-- 如果有增益效果
   			local panel = global.panelMgr:openPanel("UIPromptPanel")
    		panel:setData("gain01",
    			function()
						local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
						local itemId = item.data.itemId
						local useCount = 1
						print("---------------------buildingId----------0--------------------------------" ,self.panel.buildingId,itemId)
						global.itemApi:itemUse(itemId, useCount, 0, 0, function(msg)

							-- if global.panelMgr:isPanelOpened('UICityBufferPanel') then
								local data = global.luaCfg:get_item_by(msg.lID)
					      	 	global.tipsMgr:showWarning(data.useDes)
					      	 	-- global.panelMgr:getPanel("UICityBufferPanel"):setData(true)
							-- end					    		
					  	end)
					  	gevent:call(gsound.EV_ON_PLAYSOUND,"ui_item")
					  	-- self.panel.topModel:setVisible(false)
					  	self.panel:exit()
	  	 		 end 
	  	 		 )


    			panel:setPanelExitCallFun( function ()
					     	self.panel.topModel:setVisible(false)
	  	 		 end )
			-- global.panelMgr:openPanel("UIBagUseSingle"):setData(data,function()
			-- 		self.panel:exit()
			-- 	end 
			-- 	, function()
			-- 		self.panel.topModel:setVisible(false)
			-- 	end 
			-- )	
	  	else
		    local item = self.panel.scrollviewPanel:getChildByTag(self.panel.curItemTag+1005)
		    local itemId = item.data.itemId
		    local useCount = 1
			 global.itemApi:itemUse(itemId, useCount, 0, self.panel.buildingId, function(msg)
	    		local data = global.luaCfg:get_item_by(msg.lID)
	      	  	global.tipsMgr:showWarning(data.useDes)
	      	  	-- if  global.panelMgr:isPanelOpened('UICityBufferPanel') then
	      			-- global.panelMgr:getPanel("UICityBufferPanel"):setData(true)
	      		-- end 
	  	  end)
	  		--退出当前界面
   			self.panel:exit()
	  	end 
end 

function BuffAddNode:troopAccelerate()
   dump(self.data)	
 	if self.data then   
	   global.CityBufferAPi:getcityBUfferById({self.data.typePara3},function(msg)
	   		if self.checkUsed then
	        	self:checkUsed(msg)
	        end
	    end)
	end 
end
return BuffAddNode
