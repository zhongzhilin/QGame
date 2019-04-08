local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local luaCfg = global.luaCfg

local UIRankInfoCell  = class("UIRankInfoCell", function() return cc.TableViewCell:create() end )
local UIRankInfoItem = require("game.UI.rank.UIRankInfoItem")

function UIRankInfoCell:ctor()
    self:CreateUI()
end

function UIRankInfoCell:CreateUI()

    self.item = UIRankInfoItem.new() 
    self:addChild(self.item)
end

function UIRankInfoCell:onClick()
	dump(self.data, " onClick >>> ")
	
	 gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Open")

	local infoPanel = panelMgr:getPanel("UIRankInfoPanel")
	if infoPanel:getInfoData().type == 1 then 
		
		-- 获取联盟信息
		global.unionApi:getUnionInfo(function (msg)
			
			global.panelMgr:getPanel("UIUnionPanel"):setInputMode(0)

			msg.tgAlly = msg.tgAlly or {}
			panelMgr:openPanel("UIJoinUnionPanel"):setData(msg.tgAlly)
		end, self.data.lFindID)

	else

		local openUserInfoCall =function () 
			-- 获取用户详细信息
	        global.chatApi:getUserInfo(function(msg)
		            msg.tgInfo = msg.tgInfo or {}
		            panelMgr:openPanel("UIChatUserInfoPanel"):setData(msg.tgInfo[1])
		    end, {self.data.lFindID})
		end 


		local infoPanel = global.panelMgr:getPanel("UIRankInfoPanel")
    	local typeId = infoPanel:getInfoData().id

    	if  infoPanel.isActivity then 

    		openUserInfoCall()

    	elseif typeId == 8 then -- 英雄信息

			-- 获取用户详细信息
	        global.chatApi:getHeroInfo(function(msg)
	           
	            msg.tgHero = msg.tgHero or {}
	            msg.tgEquip = msg.tgEquip or {}
	            if not msg.tgHero.lID then return end	            	
	            local heroData  = {}
			    local equipData = {}
			    for index,v in ipairs(msg.tgEquip) do        
			    	local equipLua = luaCfg:equipment()  
			    	for _,vv in pairs(equipLua) do
			    		if vv.id == v.lGID then
			    			v.lType = vv.type
			    			break
			    		end
			    	end
			        equipData[v.lType] = {id = v.lGID, lv = v.lStronglv, lType = v.lType, lCombat=v.lCombat, tgAttr=v.tgAttr}
			    end
			    heroData.equipData = equipData
			    heroData.serverData = msg.tgHero
	            panelMgr:openPanel("UIShareHero"):setData(heroData)
	        end, tonumber(self.data.szParams[1]), self.data.lFindID)
	    elseif typeId == 11 then -- 神兽信息
	    	panelMgr:openPanel("UIPetDetailPanel"):setData(self.data)

		elseif typeId == 13 then -- PK
			global.commonApi:getPKRankInfo(self.data.lFindID ,function(msg)
	            panelMgr:openPanel("UIChatUserInfoPanel"):setHeroData(msg)
			end)
	    else
	    	openUserInfoCall()
	    end

	end

end

function UIRankInfoCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIRankInfoCell:updateUI()
    self.item:setData(self.data)
end

return UIRankInfoCell