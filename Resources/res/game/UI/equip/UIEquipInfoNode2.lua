--region UIEquipInfoNode2.lua
--Author : Administrator
--Date   : 2017/02/23
--generate by [ui_code_tool.py] automatically

local equipData = global.equipData
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIEquipInfoNode2  = class("UIEquipInfoNode2", function() return gdisplay.newWidget() end )

function UIEquipInfoNode2:ctor()
    
end

function UIEquipInfoNode2:CreateUI()
    local root = resMgr:createWidget("equip/equipInfoNode2")
    self:initUI(root)
end

function UIEquipInfoNode2:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equipInfoNode2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.suit_name_1 = self.root.suit_name_1_export
    self.suit_num = self.root.suit_num_export
    self.get_suits = self.root.get_suits_export
    self.no_suits = self.root.no_suits_export
    self.get_pro = self.root.get_pro_export
    self.no_pro = self.root.no_pro_export

--EXPORT_NODE_END
end

function UIEquipInfoNode2:setData(data,heroId,isLongTips)	


	local equipment = luaCfg:get_equipment_by(data.lGID)

	if not equipment then 
		equipment = luaCfg:get_lord_equip_by(data.lGID)
	end 

	local kind = equipment.kind or 0 

	
	if kind == 0 then

		self.height = 0
		self:setVisible(false)
	else

		local suitData = luaCfg:get_equipment_suit_by(kind)
		local allSuit = suitData.equipment

		self:setVisible(true)
		self.suit_name_1:setString(suitData.suitName)		

		local getStr = ""
		local noStr = ""
		local gotCount = 0
		for index,v in ipairs(allSuit) do

			local name = luaCfg:get_equipment_by(v).name

			if (data.isOther and data.otherSuitList[index]) or (not data.isOther and equipData:isEquipOnHero(v,heroId)) or self:isShareHeroOn(v) then

				getStr = getStr .. name .. "\n" 
				noStr = noStr .. "\n"
				gotCount = gotCount + 1
			else

				getStr = getStr .. "\n" 
				noStr = noStr .. name .. "\n"
			end
		end

		local gotProStr = ""
		local noProStr = ""
		for i = 1,6 do

			local suitPros = suitData["pro"..i]

			if type(suitPros) == "table" then

				local str = luaCfg:get_local_string(10387,i,"")
				if gotCount >= i or isLongTips then

					gotProStr = gotProStr .. str .. "\n" 
					noProStr = noProStr .. "\n"
				else

					gotProStr = gotProStr .. "\n" 
					noProStr = noProStr .. str .. "\n"
				end

				for _,suitPro in ipairs(suitPros) do
					
					local leagueCfg = luaCfg:get_data_type_by(suitPro[1])
					local leaguecount = suitPro[2]
					local str = string.format("    · %s+%s%s%s",leagueCfg.paraName,leaguecount,leagueCfg.str,leagueCfg.extra)					
					if gotCount >= i or isLongTips then

						gotProStr = gotProStr .. str .. "\n" 
						noProStr = noProStr .. "\n"
					else

						gotProStr = gotProStr .. "\n" 
						noProStr = noProStr .. str .. "\n"
					end
				end				
			end			
		end

		self.suit_num:setString(string.format("(%s/%s)",gotCount,#allSuit))

		self.get_suits:setString(getStr)
		self.no_suits:setString(noStr)
		self.get_pro:setString(gotProStr)
		self.no_pro:setString(noProStr)

		local proY = self.get_pro:getContentSize().height * 0.4
		self.no_pro:setPositionY(proY)
		self.get_pro:setPositionY(proY)

		if isLongTips then
			self.get_suits:setString('')
			self.no_suits:setString('')
		end		

		local suitY = self.get_suits:getContentSize().height  * 0.4
		self.get_suits:setPositionY(proY + suitY)
		self.no_suits:setPositionY(proY + suitY)

		self.suit_name_1:setPositionY(proY + suitY + 30)
		self.suit_num:setPositionY(proY + suitY + 30)

		self.height = proY + suitY + 30 + 30


	end	

	--润稿翻译处理 张亮
    global.tools:adjustNodePos(self.suit_name_1,self.suit_num)
end


function UIEquipInfoNode2:isShareHeroOn(equimentID) -- 查看分享英雄
	
	if global.shareHeroData then 

		for _ ,v in pairs(global.shareHeroData.equipData or {} ) do 

			if equimentID and v.id == equimentID then 

				return true 
			end  
		end 
	end 

	return false 
end 	


function UIEquipInfoNode2:getHeight()

	return self.height
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIEquipInfoNode2

--endregion
