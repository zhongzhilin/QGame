local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionWarCell  = class("UIUnionWarCell", function() return cc.TableViewCell:create() end )
local UIUnionWarItem = require("game.UI.union.list.UIUnionWarItem")

function UIUnionWarCell:ctor()
    self:CreateUI()
end

function UIUnionWarCell:CreateUI()

    self.item = UIUnionWarItem.new() 
    self:addChild(self.item)
end

-- [1] = { id=1,  functionid=1,  name="联盟战争",  array=1,  btn="ui_surface_icon/union_min_btn01.png",  name_en="League War",  },
-- [2] = { id=2,  functionid=7,  name="联盟任务",  array=2,  btn="ui_surface_icon/union_min_btn08.png",  name_en="League Mission",  },
-- [3] = { id=3,  functionid=2,  name="联盟建设",  array=3,  btn="ui_surface_icon/union_min_btn03.png",  name_en="League Construction",  },
-- [4] = { id=4,  functionid=3,  name="联盟动态",  array=4,  btn="ui_surface_icon/union_min_btn04.png",  name_en="League News",  },
-- [5] = { id=5,  functionid=4,  name="联盟外交",  array=5,  btn="ui_surface_icon/union_min_btn05.png",  name_en="League Diplomacy",  },
-- [6] = { id=6,  functionid=5,  name="联盟商店",  array=6,  btn="ui_surface_icon/union_min_btn06.png",  name_en="League Store",  },
-- [7] = { id=7,  functionid=6,  name="联盟奇迹",  array=7,  btn="ui_surface_icon/union_min_btn07.png",  name_en="League Miracle",  },
local operate = {
	[1] = "war",
	[2] = "build",
	[3] = "dynamic",
	[4] = "foreign",
	[5] = "shop",
	[6] = "miracle",
	[7] = "task",
	[8] = "village",
	[9] = "donate",
	[10] = "help",
	[11] = "exp",
}



function UIUnionWarCell:onClick()
	gevent:call(gsound.EV_ON_PLAYSOUND,"ui_Paging")
	if self[operate[self.data.functionid]] then
		self[operate[self.data.functionid]](self)
	else
		global.tipsMgr:showWarning("FuncNotFinish")
	end
end

function UIUnionWarCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionWarCell:updateUI()
    self.item:setData(self.data)

	self:setRed()
end

function UIUnionWarCell:setRed()
	local funcIdToRedId = {[7] = 8,[2] = 7,[3] = 6,[4] = 3 ,[10]=12 ,[11] = 13}
	local needId = funcIdToRedId[self.data.functionid]
    local num = nil
    if self.data.functionid == 1 then
    	--联盟战争不更新到外部红点
    	num = global.unionData:getInUnionRed(self.data.functionid)
    else
		if not needId then return end
    	local innerNum = global.unionData:getInUnionRed(self.data.functionid)
    	if innerNum then
    		-- 联盟动态或者联盟不需要更新
   			global.userData:updatelAllyRedCount({lID=needId,lValue=innerNum})
    	end
    	num = global.userData:getlAllyRedCountBy(needId)
    end
    if num then
	    if self.data.functionid == 4 then
	    	-- 联盟外交权限
	    	if global.unionData:isHadPower(23) then
    			self.item:setRed(num)
	    	end
	    elseif self.data.functionid == 2 then
	    	-- 联盟建设权限
	    	if global.unionData:isHadPower(9) then
    			self.item:setRed(num)
	    	end
	    else
    		self.item:setRed(num)
	    end
    end
end

---------------------------------按钮功能回调----------------------------------------

function UIUnionWarCell:exp()
	--联盟战争
	if global.funcGame:checkBuildAndBuildLV(32) then 
		global.panelMgr:openPanel("UIHeroExpListPanel")
	end 
end

function UIUnionWarCell:war()
	--联盟战争
	global.panelMgr:openPanel("UIUWarListPanel")
end

function UIUnionWarCell:build()
	--联盟建设
	global.panelMgr:openPanel("UIUBuildPanel")
end

function UIUnionWarCell:dynamic()
	--联盟动态
	global.panelMgr:openPanel("UIUnionDynamicPanel"):setData()
end

function UIUnionWarCell:foreign()
	--联盟外交
	global.panelMgr:openPanel("UIUnionForeignPanel")
end

function UIUnionWarCell:shop()
	--联盟商店
	global.panelMgr:openPanel("UIUShopPanel")
end

function UIUnionWarCell:miracle()
	--联盟奇迹
	global.panelMgr:openPanel("UIUnionMiraclePanel")
end

function UIUnionWarCell:task()
	--联盟任务
	global.panelMgr:openPanel("UIUTaskPanel")
end

function UIUnionWarCell:village()
	--联盟任务
	global.panelMgr:openPanel("UIUnionVillagePanel")
end

function UIUnionWarCell:donate()
	--联盟捐献
	global.panelMgr:openPanel("UIUDonatePanel")
end

function UIUnionWarCell:help()
	--联盟捐献
	global.panelMgr:openPanel("UIUnionHelpPanel")
end



return UIUnionWarCell