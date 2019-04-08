--region BuildPanel.lua
--Author : wuwx
--Date   : 2016/08/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local cityData = global.cityData
local gameEvent = global.gameEvent
local propData = global.propData
local cityView = global.g_cityView
local cityData = global.cityData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local BuildPanel  = class("BuildPanel", function() return gdisplay.newWidget() end )
local BuildingProItem = require("game.UI.city.widget.BuildingProItem")

function BuildPanel:ctor()
    self:CreateUI()
end

function BuildPanel:CreateUI()
    local root = resMgr:createWidget("city/build_bld")
    self:initUI(root)
end

function BuildPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_bld")

    -- local nodeTimeLine = resMgr:createTimeline("city/build_bld")
    -- nodeTimeLine:play("animation0", false)
    -- self.root:runAction(nodeTimeLine)

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.suface_title = self.root.node_top.suface_title_export
    self.Text_build_name = self.root.node_top.Sprite_build_name.Text_build_name_export
    self.node_res = self.root.node_top.Image_29.node_res_export
    self.infoflag = self.root.infoflag_export
    self.lv_info = self.root.infoflag_export.lv_info_export
    self.build_num = self.root.infoflag_export.build_num_export
    self.build_num_max = self.root.infoflag_export.build_num_max_export
    self.bg_node = self.root.node.bg_node_export
    self.btn_upgrade = self.root.node.btn_upgrade_export
    self.grayBg2 = self.root.node.btn_upgrade_export.grayBg2_export
    self.time = self.root.node.btn_upgrade_export.time_export
    self.btn_quickbuild = self.root.node.btn_quickbuild_export
    self.grayBg1 = self.root.node.btn_quickbuild_export.grayBg1_export
    self.num = self.root.node.btn_quickbuild_export.num_export
    self.ScrollView_1 = self.root.node.ScrollView_1_export
    self.NodeUI = self.root.node.ScrollView_1_export.NodeUI_export

    uiMgr:addWidgetTouchHandler(self.btn_upgrade, function(sender, eventType) self:onNormalBuildHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_quickbuild, function(sender, eventType) self:onNoCdBuildHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.suface_title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)

    local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
    self.ResSetControl = ResSetControl.new(self.node_res)

    self.btn_upgrade:setSwallowTouches(true)

    -- 屏幕适配
    local y =  self.root.node.title:convertToWorldSpace((cc.p(0,0))).y 
    local part_y = 100 
    local yy = 0 
    if  y  >  gdisplay.height /2 - part_y then 
        yy =  y -(gdisplay.height /2 - part_y)
        self.root.node.title:setPositionY(self.root.node.title:getPositionY() -yy)
    end

    if yy > 0 then 
        local contentSize= self.bg_node:getContentSize()
        self.bg_node:setContentSize(cc.size(contentSize.width , contentSize.height -yy  ))

        contentSize= self.ScrollView_1:getContentSize()
        self.ScrollView_1:setContentSize(cc.size(contentSize.width , contentSize.height -yy  ))
    end 

    -- local part_y_two= 33 
    -- if self.ScrollView_1:getContentSize().height +  self.ScrollView_1:getPositionY() >  self.root.node.title:getPositionY() - part_y_two  then 
    --      self.ScrollView_1:setContentSize(cc.size(self.ScrollView_1:getContentSize().width , self.ScrollView_1:getContentSize().height - self.root.node.title:getPositionY() - part_y_two))
    -- end 

end 

function BuildPanel:initTouchListener()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(true)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.root.touch)
end

function BuildPanel:onTouchBegan(touch, event)
    return true
end

function BuildPanel:onTouchEnded(touch, event)
    self:onCloseHandler()
end

function BuildPanel:onEnter(touch, event)
    self.costDiamond = 0
    global.delayCallFunc(function()
        global.luaCfg:build_lvup_ui()
    end,nil,0)    

    self.ResSetControl:setData()
    self.ResSetControl:playAnimation(self.node_res)
    
    global.g_cityView:setUIVisible(false)
    self:initTouchListener()

    self:addEventListener(global.gameEvent.EV_ON_UI_BUILD_FLUSH, function (event, isRefershBtn)
        if isRefershBtn then
            if self.refershBtn then 
               self:refershBtn()
            end 
        else
            self:setUIText()
        end
    end)
   
    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function()        
        self:setUIText()
    end) 

    self:addEventListener(global.gameEvent.EV_ON_UNION_CLEANCD,function(event , cleantype , time) --联盟帮助 清除 CD
        if self.data then 
            self:setData(self.data)
        end 
    end)

    self.m_ownCloseCall = nil
end


function BuildPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

function BuildPanel:setData(data)

    self.data = data

    local cityView = global.g_cityView
    local cityTouchMgr = cityView:getTouchMgr()
    for i,i_building in ipairs(cityTouchMgr.registerBuildings) do
        if i_building.data and i_building.data.id == self.data.id and i_building.checkName then 
            i_building:checkName(true)
        end 
    end

    self.Text_build_name:setString(data.buildsName.." "..luaCfg:get_local_string(10019,data.level))
    self.lv_info:setString(data.description)

    local timeData = global.funcGame.formatTimeToHMS(data.time)
    self.time:setString(timeData)
    -- self.num:setString(global.funcGame.getDiamondCount(data.time))
    -- global.propData:checkEnoughWithColor(WCONST.ITEM.TID.DIAMOND, self.costDiamond, self.num)

    local buildedNum = 0
    local registerBuild = cityData:getRegistedBuild()
    for _,v in ipairs(registerBuild) do
        if v.buildingType == data.buildingType then
            buildedNum = buildedNum + 1
        end
    end

    self.build_num:setString(buildedNum)

    local buildNumMax = 0
    local  buildingPosData = luaCfg:buildings_pos()


    for k,v in pairs(buildingPosData) do
        if data.buildingType ==  v.buildingType then
            buildNumMax = buildNumMax + 1
        end
    end

    if self.data.buildingType == 16 then  -- 家族建筑特殊处理  
        buildNumMax = 1 
    end 

    self.build_num_max:setString(buildNumMax)

    self:setUIText()

    self.m_ownCloseCall = function()
        -- body
        if tolua.isnull(global.g_cityView) then return end
        local newbuildingData = cityData:getBuildingById(self.data.id)
        if newbuildingData.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BLANK then
            global.g_cityView.touchMgr:removeBuildingNodeBy(self.data.id)
        end
    end
end

function BuildPanel:checkDiamond()
    local timeDiamond = global.funcGame.getDiamondCount(self.data.time)
    local resDiamond = 0
    if self.noEnoughRes < 0 then
        local perDiamond = global.luaCfg:get_config_by(1).resPrice
        resDiamond = math.ceil(-self.noEnoughRes/perDiamond)
    end
    if self.data.time <= global.cityData:getFreeBuildTime() then
        self.num:setString(luaCfg:get_local_string(10390))
        timeDiamond = 0
    else 
        self.num:setString(timeDiamond+resDiamond)
    end
    self.costDiamond = timeDiamond+resDiamond
    local isEnough = global.propData:checkEnoughWithColor(WCONST.ITEM.TID.DIAMOND, self.costDiamond, self.num)
    return isEnough,timeDiamond,resDiamond
end

function BuildPanel:setUIText()

    local canBuild = false
    local index = 1

    self.isEnoughLv = true
    self.noEnoughRes = 0
    --当前队列条件
    local isFree = true
    local builder = global.g_cityView:getFreeBuilder()
    if not builder then
        isFree = false
        index = 2
        if tolua.isnull(self.FileNode_ui_text1) then
            self.FileNode_ui_text1 = BuildingProItem.new()
            self.FileNode_ui_text1:setPositionX(-0.72)
            self.ScrollView_1.NodeUI_export:addChild(self.FileNode_ui_text1)
        end
        self.FileNode_ui_text1:setData({}, true)
    end

    --建筑多条件建造
    local isEnoughLv = true
    for _,v in pairs(self.data.triggerId) do

        local triggerData = luaCfg:get_triggers_id_by(v) or {}
        local triggerStr = triggerData.triggerDescription
        local isEnough = cityData:checkTrigger(v)
        local triggerItemData = {icon = nil,content = triggerStr, isEnough = isEnough, triggerData = triggerData, isNoFirstNode = false}
        if tolua.isnull(self["FileNode_ui_text"..index]) then
            self["FileNode_ui_text"..index] = BuildingProItem.new()
            self["FileNode_ui_text"..index]:setPositionX(-0.72)
            self.ScrollView_1.NodeUI_export:addChild(self["FileNode_ui_text"..index])
        end
        self["FileNode_ui_text"..index]:setData(triggerItemData)
        index = index + 1
        isEnoughLv = isEnough and isEnoughLv
        self.isEnoughLv = isEnoughLv
    end

    -- 资源条件
    local proIdx = index 
    for i=proIdx,9 do
        if not tolua.isnull(self["FileNode_ui_text"..i]) then
            self["FileNode_ui_text"..i]:setVisible(false)
        end
    end
    local isEnough2 = true
    local t_dnum = 0
    for i=1,#self.data.resource do
        if tolua.isnull(self["FileNode_ui_text"..proIdx]) then
            self["FileNode_ui_text"..proIdx] = BuildingProItem.new()
            self["FileNode_ui_text"..proIdx]:setPositionX(-0.72)
            self.ScrollView_1.NodeUI_export:addChild(self["FileNode_ui_text"..proIdx])
        end
        self["FileNode_ui_text"..proIdx]:setVisible(true)

        local resource = self.data.resource[i]
        local triggerData = luaCfg:get_item_by(resource[1])
        local num = resource[2]
        local triggerStr = triggerData.itemName.." "..num
        local isEnough_temp,dnum = cityData:checkResource(resource)
    	if dnum < 0 then
    	   t_dnum = t_dnum+dnum
    	end
        isEnough2 = isEnough_temp and isEnough2
        local triggerItemData = {icon = triggerData.iconName,content = triggerStr, isEnough = isEnough_temp, triggerData = triggerData, isNoFirstNode = true}
        self["FileNode_ui_text"..proIdx]:setData(triggerItemData)
        proIdx = proIdx+1
    end

    local containSizeH = proIdx*60
    local contentSizeH = self.ScrollView_1:getContentSize().height
    if containSizeH < contentSizeH then
        containSizeH = contentSizeH
    end
    for i=1,9 do
        if not tolua.isnull(self["FileNode_ui_text"..i]) then
            self["FileNode_ui_text"..i]:setPositionY(containSizeH-60*i)
        end
    end

    self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, containSizeH))
    self.ScrollView_1:jumpToTop()

    canBuild = isEnoughLv and isEnough2
    self.noEnoughRes = t_dnum

    -- 临界时间点处理
    local builder = global.g_cityView:getFreeBuilder()
    if builder then
        isFree = true
    end
    
    self.isCanBuild = canBuild and isFree
    global.colorUtils.turnGray(self.grayBg2, self.isCanBuild == false)
    if self.noEnoughRes >= 0 then
        global.colorUtils.turnGray(self.grayBg1, self.isCanBuild == false)
    else
        global.colorUtils.turnGray(self.grayBg1, false)
    end
    
    self:checkDiamond()
end

function BuildPanel:refershBtn()
    

    local canBuild = false
    local index = 1
    self.isEnoughLv = true
    self.noEnoughRes = 0
    --当前队列条件
    local isFree = true
    local builder = global.g_cityView:getFreeBuilder()
    if not builder then
        isFree = false
        index = 2
    end

    --建筑多条件建造
    local isEnoughLv = true
    for _,v in pairs(self.data.triggerId) do

        local isEnough = cityData:checkTrigger(v)
        index = index + 1
        isEnoughLv = isEnough and isEnoughLv
    end
    self.isEnoughLv = isEnoughLv

    -- 资源条件
    local proIdx = index 
    local isEnough2 = true
    local t_dnum = 0
    for i=1,#self.data.resource do
     
        local resource = self.data.resource[i]
        local isEnough_temp,dnum = cityData:checkResource(resource)
    	if dnum < 0 then
    		t_dnum = t_dnum+dnum
    	end
        isEnough2 = isEnough_temp and isEnough2
        proIdx = proIdx+1
    end
    self.noEnoughRes = t_dnum
    canBuild = isEnoughLv and isEnough2

    -- 临界时间点处理
    local builder = global.g_cityView:getFreeBuilder()
    if builder then
        isFree = true
    end
    
    self.isCanBuild = canBuild and isFree
    global.colorUtils.turnGray(self.grayBg2, self.isCanBuild == false)
    if self.noEnoughRes >= 0 then
        global.colorUtils.turnGray(self.grayBg1, self.isCanBuild == false)
    else
        global.colorUtils.turnGray(self.grayBg1, false)
    end

end

function BuildPanel:setCloseCall(call)
    self.closeCall = call
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function BuildPanel:onNormalBuildHandler(sender, eventType)

    if not self.isCanBuild then
        if global.g_cityView:checkThirdBuildLocked() then
            global.tipsMgr:showWarning("contribute_conditon")
        else
            -- global.tipsMgr:showWarning(luaCfg:get_local_string(10091))
            -- global.panelMgr:openPanel("UIMonthCardPanel"):setData()

            global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10979, target=5})
        end
        return 
    end

    local function workOverCall()
    end
    local cityView = global.g_cityView
    local builder = cityView:getFreeBuilder()
    if builder then
        if builder:isCharged() and not global.cityData:canBuildInOpened(self.data.time) then
            -- global.tipsMgr:showWarning(luaCfg:get_local_string(10091))
            --打开道具使用界面
            -- local panel = global.panelMgr:openPanel("UISpeedPanel")   -- 解锁道具使用
            -- panel:setData(handler(builder,  builder.unLockQueueCall), builder:getQueueId(), panel.TYPE_QUEUE_UNLOCK)
            -- global.panelMgr:openPanel("UIMonthCardPanel"):setData()

            global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10980, target=5})
            return
        end

        local cloneData = clone(self.data)
        local noModal = nil
        if self.data.id == 15 then
            noModal = false
        end
        global.cityApi:buildUpgrade(self.data.id,function(msg)
            --扣除资源

            -- for i=1,#self.data.resource do
            --     local resource = self.data.resource[i]
            --     propData:addProp(resource[1],-resource[2])
            -- end
            cityData:setServerDataById(cloneData.id,msg.tgBuild,true)
            cityData:setBuilderBy(msg.tgQueue.lID,msg.tgQueue)

            local cityView = global.g_cityView
            cityView:getFreeBuilder(msg.tgQueue.lID):work(workOverCall)
            global.taskData:buildTest(cloneData)

            cityView:getUIBtnBuild():setVisible(not global.cityData:isBuildAllOver())
        end,nil,noModal)
        self.m_ownCloseCall=nil
        self:onCloseHandler()
        local cityNode = cityView.touchMgr:getBuildingNodeBy(self.data.id)
        --特效播放监听
        gevent:call(gameEvent.EV_ON_UI_EFFECT_PLAY, cityNode ,self.data, true)
    else
        global.tipsMgr:showWarning("NoBuildQueue")
    end
end

function BuildPanel:onCloseHandler(sender, eventType)
    global.g_cityView:setUIVisible(true)
    global.panelMgr:closePanelForBtn("BuildPanel")
    if self.closeCall then self.closeCall() end
    if self.m_ownCloseCall then self.m_ownCloseCall() end
end


function BuildPanel:onNoCdBuildHandler(sender, eventType)
    -- self.num

    if not self.isCanBuild then
        if global.g_cityView:checkThirdBuildLocked() then
            if not self.isEnoughLv then
                local proItem = self["FileNode_ui_text1"]
                local index = 1
                for _,v in pairs(self.data.triggerId) do
                    local data = self["FileNode_ui_text"..index]:getData() or {} 
                    if not data.isEnough then
                        proItem = self["FileNode_ui_text"..index]
                    end
                    index = index+1
                end
                local data = proItem:getData()
                if data then
                    local buildingData = global.cityData:getBuildingById(data.triggerData.buildsId)
                    local titlestr = global.luaCfg:get_translate_string(10990,buildingData.buildsName,data.triggerData.triggerCondition)
                    global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=titlestr, isnottitleId = true, target=6, callback = function()
                        -- body
                        proItem:onOperateHandler()
                    end})
                end
                return  
            else
                if self.noEnoughRes < 0 then
                else
                    return global.tipsMgr:showWarning("upgrade_conditon")
                end
            end
        else
            -- global.tipsMgr:showWarning(luaCfg:get_local_string(10091))
            -- global.panelMgr:openPanel("UIMonthCardPanel"):setData()

            return global.panelMgr:openPanel("UIGetChannelPanel"):setData({titleId=10979, target=5})
        end
        
    end
    local callfunction = function()
        -- body
        local cityView = global.g_cityView
        local builder = global.g_cityView:getFreeBuilder()
        if builder then
            if not global.propData:checkEnoughWithTips(WCONST.ITEM.TID.DIAMOND,self.costDiamond) then return end

            local cloneData = clone(self.data)
            local noModal = nil
            if self.data.id == 15 then
                noModal = false
            end
            local updateCall = function()
                global.cityApi:buildUpgrade(self.data.id,function(msg)
                    --扣除资源

                    -- for i=1,#self.data.resource do
                    --     local resource = self.data.resource[i]
                    --     propData:addProp(resource[1],-resource[2])
                    -- end
                    cityData:setServerDataById(cloneData.id,msg.tgBuild,true)
                    cityData:setBuilderBy(msg.tgQueue.lID,msg.tgQueue)

                    local cityView = global.g_cityView
                    cityView:getFreeBuilder(msg.tgQueue.lID):work(workOverCall)
                    global.taskData:buildTest(cloneData)

                    cityView:getUIBtnBuild():setVisible(not global.cityData:isBuildAllOver())
                end,1,noModal)
                self.m_ownCloseCall=nil
                self:onCloseHandler()
                local cityNode = cityView.touchMgr:getBuildingNodeBy(self.data.id)
                --　特效播放监听
                gevent:call(gameEvent.EV_ON_UI_EFFECT_PLAY, cityNode ,self.data, true)
            end
            updateCall()       
        else
            global.tipsMgr:showWarning("NoBuildQueue")
        end
    end

    local isEnoughDiamond,timeCost,resCost = self:checkDiamond()
    if not isEnoughDiamond then
        global.tipsMgr:showWarning("ItemUseDiamond")
        return 
    end

    if self.noEnoughRes < 0 then
        local panel = global.panelMgr:openPanel("UIPromptUpgradePanel")
        local param = {}
        param.res = {}
        param.totalcost = self.costDiamond

        for i=1,#self.data.resource do
         
            local resource = clone(self.data.resource[i])
            local num = resource[2]
            resource[2] = num
            local isEnough_temp,dnum = cityData:checkResource(resource)
            if dnum < 0 then
                param.res[resource[1]] = -dnum
            end
        end
        panel:setData(param,function()
            callfunction()
        end)
    else
        callfunction()
    end
end
--CALLBACKS_FUNCS_END

return BuildPanel

--endregion
