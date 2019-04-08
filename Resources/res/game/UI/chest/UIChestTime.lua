--region UIChestTime.lua
--Author : anlitop
--Date   : 2017/11/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIChestTime  = class("UIChestTime", function() return gdisplay.newWidget() end )
local funcGame = global.funcGame
local dailyTaskData = global.dailyTaskData
local luaCfg = global.luaCfg

function UIChestTime:ctor()
   self:CreateUI()
end

function UIChestTime:CreateUI()
    local root = resMgr:createWidget("chest/chest_time_node")
    self:initUI(root)
end

function UIChestTime:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chest/chest_time_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.time = self.root.time.time_export

--EXPORT_NODE_END

    self.freeData = luaCfg:get_free_chest_by(1)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function  UIChestTime:onEnter()
	self:setData()
end 

function UIChestTime:setData()

    self.now_freeNum = dailyTaskData:getFreeBagNum() --免费次数
    -- self.now_wildNum = dailyTaskData:getWildTimes() --现在的次数
    if self.now_freeNum < 0 then self.now_freeNum = 0 end
    -- if self.now_wildNum < 0 then self.now_wildNum = 0 end

    if  self.now_freeNum < self.freeData.max  then 

    	
		self.m_restTime = math.floor(dailyTaskData:getRestTime() + global.dataMgr:getServerTime()) 

    	self.root:setVisible(true)

    	self:countDownHandler()

    else 
    	self.root:setVisible(false)

	    self.m_restTime =  0
    end 

end 


function UIChestTime:countDownHandler()

    local restTime =  math.floor(self.m_restTime - global.dataMgr:getServerTime())


    if restTime <= 0 then -- 变零秒 之后，重置
	    self.m_restTime = math.floor(dailyTaskData:getRestTime() + global.dataMgr:getServerTime())
    end 

    self.time:setString(funcGame.formatTimeToHMS(restTime))
end

--CALLBACKS_FUNCS_END

return UIChestTime

--endregion
