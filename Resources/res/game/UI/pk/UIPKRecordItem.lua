--region UIPKRecordItem.lua
--Author : zzl
--Date   : 2018/02/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPKRecordItem  = class("UIPKRecordItem", function() return gdisplay.newWidget() end )

function UIPKRecordItem:ctor()
	
    self:CreateUI()
end

function UIPKRecordItem:CreateUI()
    local root = resMgr:createWidget("player_kill/pk_record_item")
    self:initUI(root)
end

function UIPKRecordItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/pk_record_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.union_name = self.root.Image_4.union_name_export
    self.date = self.root.Image_4.date_export
    self.win = self.root.win_export
    self.fail = self.root.fail_export

    uiMgr:addWidgetTouchHandler(self.root.newDiplomaticBtn, function(sender, eventType) self:view_click(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIPKRecordItem:onEnter()

end 

function UIPKRecordItem:onExit()

end 


function UIPKRecordItem:getRank(data)
	
	if self:getResult(data) == 0 then --赢了

		if data.lAtkRank > data.lDefRank then 

			return data.lDefRank
		else 
			return data.lAtkRank
		end 
	else 

		return data.lAtkRank
	end 	
end 

function UIPKRecordItem:getResult(data)

	 if data.lResult[1] == 2 then 

	 	return 1 
	 end 

	 return 0
end

function UIPKRecordItem:setData(data)

	self.data = data

	self.win:setVisible(false)
	self.fail:setVisible(false)

	if self.data.lAtkID == global.userData:getUserId() then 

		if self:getResult(self.data) == 0 then --赢了

	        uiMgr:setRichText(self,"union_name",50316,{key_1=data.szDefName or "Joker" , key_2 =self:getRank(data) or 123 })
			self.win:setVisible(true)

		else 

	        uiMgr:setRichText(self,"union_name",50317,{key_1=data.szDefName or "Joker"})
			self.fail:setVisible(true)

		end 

	else 

		if self:getResult(self.data) == 0 then --输了

	        if self.data.lAtkRank < self.data.lDefRank then 

		        uiMgr:setRichText(self,"union_name",50324,{key_1=data.szAtkName or "Joker"})
	        else 

		        uiMgr:setRichText(self,"union_name",50322,{key_1=data.szAtkName or "Joker" , key_2 = self.data.lAtkRank or 123 })
	        end 

			self.fail:setVisible(true)
		else 
	        uiMgr:setRichText(self,"union_name",50323,{key_1=data.szAtkName or "Joker"})
			self.win:setVisible(true)
		end 

	end 

 --    local time = global.funcGame.formatTimeToTime(data.lAddTime or  global.dataMgr:getServerTime(),true)
	self.date:setString(global.mailData:getDataTime(data.lAddTime or global.dataMgr:getServerTime()))

end


function UIPKRecordItem:view_click(sender, eventType)
		
	-- dump(self.data ,"fufkc ")

	
	global.panelMgr:openPanel("UIPKRePlayPanel"):setData({tagRecord =self.data} , true)

end
--CALLBACKS_FUNCS_END

return UIPKRecordItem

--endregion
