--region UIWideListNode.lua
--Author : yyt
--Date   : 2016/11/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWideListNode  = class("UIWideListNode", function() return gdisplay.newWidget() end )

function UIWideListNode:ctor()
    self:CreateUI()
end

function UIWideListNode:CreateUI()
    local root = resMgr:createWidget("resource/res_wild_list_node")
    self:initUI(root)
end

function UIWideListNode:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_wild_list_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.go_target = self.root.res_list_bg.go_target_export
    self.rest_time = self.root.res_list_bg.rest_time_export
    self.rest_num = self.root.res_list_bg.rest_num_mlan_5_export
    self.perhour_speed = self.root.res_list_bg.perhour_speed_export
    self.perhour_speedT = self.root.res_list_bg.perhour_speedT_mlan_7_export
    self.posX = self.root.res_list_bg.posX_export
    self.posY = self.root.res_list_bg.posY_export
    self.lv_num = self.root.res_list_bg.lv_num_export
    self.wild_name = self.root.res_list_bg.wild_name_export
    self.pic = self.root.res_list_bg.pic_export

    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:gpsHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.go_target:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWideListNode:setData(data)
    self.data = data

    local resData = global.luaCfg:get_wild_res_by(data.lKind)
    self.wild_name:setString(resData.name)

    local surfaceData = global.luaCfg:get_world_surface_by(resData.file)
    global.panelMgr:setTextureFor(self.pic, surfaceData.worldmap)

    self.pic:setScale(1)
    if surfaceData.id >= 3005 then
        self.pic:setScale(0.65)
    end

    self.lv_num:setString(resData.level)

    local worldConst = require("game.UI.world.utils.WorldConst")
    local pos = worldConst:converPix2Location(cc.p(data.lPosX, data.lPosY))
    self.posX:setString(pos.x)
    self.posY:setString(pos.y)

    -- 没有驻防部队显示0
    --self.perhour_speed:setString(string.format("%s%s", global.resData:getWildNumByResId(data.lResID), global.luaCfg:get_local_string(10076) ))
    -- 野地剩余时间
   -- self:checkTime()
   
    local designerData = luaCfg:get_wild_res_by(self.data.lKind)
    -- self.perhour_speed:setString(string.format("%s%s", data.lCollectSpeed or 0, global.luaCfg:get_local_string(10076) ))
    local add = data.lCollectSpeed and data.lCollectSpeed - designerData.yield or 0
    add = add == 0 and "" or ("+"..global.funcGame:_formatBigNumber(add , 1 ))
    global.uiMgr:setRichText(self, "perhour_speed", 50249, {basics = global.funcGame:_formatBigNumber(designerData.yield , 1 )
    , addnum = add})

    if not self.data.lCollectSpeed then

        self.rest_time:setString(designerData.allres - self.data.lCollectCount)  
    else
        local cutTime = global.dataMgr:getServerTime() - (self.data.lCollectStart or 0)
        local speed = self.data.lCollectSpeed / 3600
        local alreadyGet = speed * cutTime + (self.data.lPlusRes or  0)
        local hp = math.ceil(designerData.allres - alreadyGet - self.data.lCollectCount)
        self.rest_time:setString( global.funcGame:_formatBigNumber(hp , 1 ))
    end

    global.tools:adjustNodePos(self.rest_num, self.rest_time)
    global.tools:adjustNodePos(self.perhour_speedT, self.perhour_speed)

end

function UIWideListNode:checkTime()

    local designerData = luaCfg:get_wild_res_by(self.data.lKind)
    local currSvrTime = global.dataMgr:getServerTime()
    local maxHp = designerData.waste
    self.lEndTime = maxHp*designerData.consume + self.data.lFlushTime

    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 1)
    end
    self:countDownHandler()
end

function UIWideListNode:countDownHandler(dt)
    if self.lEndTime <= 0 then
        self.rest_time:setString("00:00:00")
        return
    end
    local curr = global.dataMgr:getServerTime()
    local rest = math.floor(self.lEndTime - curr)
    if rest < 0 then
        if self.m_countDownTimer then
            gscheduler.unscheduleGlobal(self.m_countDownTimer)
            self.m_countDownTimer = nil
        end
        return
    end
    self.rest_time:setString(global.funcGame.formatTimeToHMS(rest))
end

function UIWideListNode:onExit()
    if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
end

function UIWideListNode:gpsLocation(sender, eventType)
    
end

function UIWideListNode:gpsHandler(sender, eventType)
    
    local infoPanel = global.panelMgr:getPanel("UIResInfoPanel")
    if eventType == ccui.TouchEventType.began then
        infoPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if infoPanel.isPageMove then 
            return
        end
        global.funcGame:gpsWorldPos(cc.p(self.data.lPosX, self.data.lPosY))
    end
end
--CALLBACKS_FUNCS_END

return UIWideListNode

--endregion
