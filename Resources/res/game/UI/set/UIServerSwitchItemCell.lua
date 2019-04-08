--
-- Author: Your Name
-- Date: 2017-04-08 00:57:22
--
--
-- Author: Your Name
-- Date: 2017-03-31 17:11:09
--


local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIServerSwitchItemCell  = class("UIServerSwitchItemCell", function() return cc.TableViewCell:create() end )
local UIServerSwitchItem = require("game.UI.set.UIServerSwitchItem")

function UIServerSwitchItemCell:ctor()
    self:CreateUI()
end

function UIServerSwitchItemCell:CreateUI()
    self.item = UIServerSwitchItem.new() 
    self:addChild(self.item)
end

function UIServerSwitchItemCell:onClick()
	self:chooseServer()
end

function UIServerSwitchItemCell:chooseServer()

	if global.loginData:getCurServerId() == tonumber(self.data.serverid)  then
		global.tipsMgr:showWarning("NowServer")
		return
	end

	local showStrId = 10494
	local msgInfo = global.sdkBridge:getServerListInfo(self.data.serverid)
    if msgInfo then
        showStrId = 10517
    end

	local panel = global.panelMgr:openPanel("UIPromptPanel")
	local str = global.luaCfg:get_local_string(showStrId, self.data.servername)
	panel:setData(str,function ()
		
	    if not global.netRpc:checkClientNetAvailable() then
	        global.tipsMgr:showWarning(global.luaCfg:get_local_string(10493))
	        return
	    end
		global.netRpc:checkNetRpc(self.data.serverid, function(isNormal)  
			if isNormal then

				global.sdkBridge:setLoginBind(showStrId == 10517, self.data.serverid)
				cc.UserDefault:getInstance():setStringForKey("selectSever", self.data.serverid) 
	    		cc.UserDefault:getInstance():flush()	 
				global.funcGame.RestartGame()				
			else
				global.tipsMgr:showWarning(luaCfg:get_local_string(10544))
			end
		end)

	end)
end 

function UIServerSwitchItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UIServerSwitchItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIServerSwitchItemCell