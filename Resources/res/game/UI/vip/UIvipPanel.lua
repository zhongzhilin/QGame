--region UIvipPanel.lua
--Author : anlitop
--Date   : 2017/03/20
--generate by [ui_code_tool.py] automatically
local luaCfg = global.luaCfg
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local funcGame = global.funcGame

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIvipEspecialItem = require("game.UI.vip.UIvipEspecialItem")
--REQUIRE_CLASS_END

local UIvipPanel  = class("UIvipPanel", function() return gdisplay.newWidget() end )
local UILeveL_item = require("game.UI.vip.UILeveL_item")
local UITableView = require("game.UI.common.UITableView")
local UIDescribeItemCell = require("game.UI.vip.UIDescribeItemCell")
function UIvipPanel:ctor()
    self:CreateUI()
end

function UIvipPanel:CreateUI()
    local root = resMgr:createWidget("vip/vip_bg")
    self:initUI(root)
end

function UIvipPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "vip/vip_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.describe_content = self.root.describe_content_export
    self.describe_item_content = self.root.describe_item_content_export
    self.shipei = self.root.shipei_export
    self.top = self.root.shipei_export.top_export
    self.loadingbar_experience = self.root.shipei_export.top_export.VIP_bg_2.loadingbar_experience_export
    self.next_VIP_level_text = self.root.shipei_export.top_export.VIP_bg_2.next_VIP_level_text_export
    self.current_viplevel_text = self.root.shipei_export.top_export.VIP_bg_2.current_viplevel_text_export
    self.current_experience_text = self.root.shipei_export.top_export.VIP_bg_2.current_experience_text_export
    self.target_experience_text = self.root.shipei_export.top_export.VIP_bg_2.target_experience_text_export
    self.togoReCharge = self.root.shipei_export.top_export.VIP_bg_2.togoReCharge_export
    self.over_time_text = self.root.shipei_export.top_export.over_time_text_export
    self.over_time_node = self.root.shipei_export.top_export.over_time_node_export
    self.bt_renew = self.root.shipei_export.top_export.bt_renew_export
    self.bt_activation_node = self.root.shipei_export.top_export.bt_activation_node_export
    self.login_get = self.root.shipei_export.top_export.login_get_export
    self.bt_activation_text = self.root.shipei_export.top_export.bt_activation_text_mlan_6_export
    self.portrait_node = self.root.shipei_export.top_export.portrait_node_export
    self.headFream = self.root.shipei_export.top_export.portrait_node_export.headFream_export
    self.user_level_banner_node = self.root.shipei_export.top_export.portrait_node_export.user_level_banner_node_export
    self.level_mark = self.root.shipei_export.top_export.portrait_node_export.user_level_banner_node_export.level_mark_export
    self.user_level_gary = self.root.shipei_export.top_export.portrait_node_export.user_level_banner_node_export.user_level_gary_export
    self.user_level_text = self.root.shipei_export.top_export.portrait_node_export.user_level_banner_node_export.user_level_text_export
    self.title_node = self.root.shipei_export.title_node_export
    self.show_level_text = self.root.shipei_export.level_text.show_level_text_export
    self.level_node = self.root.shipei_export.level_node_export
    self.level_loadingBar = self.root.shipei_export.level_node_export.loading_node.level_loadingBar_export
    self.level_arrnode_node = self.root.shipei_export.level_node_export.level_arrnode_node_export
    self.PageView_1 = self.root.shipei_export.PageView_1_export
    self.point_node = self.root.point_node_export
    self.FileNode_1 = UIvipEspecialItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.tb_top = self.root.tb_top_export
    self.tb_bottom = self.root.tb_bottom_export
    self.left = self.root.left_export
    self.right = self.root.right_export

    uiMgr:addWidgetTouchHandler(self.root.shipei_export.top_export.VIP_bg_2.bt_add_vip, function(sender, eventType) self:bt_add_vip_experience(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.togoReCharge, function(sender, eventType) self:reCharge(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.bt_renew, function(sender, eventType) self:bt_activation_vip(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.bt_activation_node, function(sender, eventType) self:bt_activation_vip(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.left, function(sender, eventType) self:click_to_left(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.right, function(sender, eventType) self:click_to_right(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title_node.esc, function(sender, eventType) self:exit_back(sender, eventType) end , true)
    -- self.tableView1 = UITableView.new()
    --     :setSize(self.describe_content:getContentSize(), self.describe_top, self.describe_buttom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
    --     :setCellSize(self.describe_item_content:getContentSize()) -- 每个小intem 的大小
    --     :setCellTemplate(UIDescribeItemCell) -- 回调函数
    --     :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
    --     :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
    --     :setColumn(1)
    -- self.describe_add_node:addChild(self.tableView1)

    -- self.tableView2 = UITableView.new()
    --     :setSize(self.describe_content:getContentSize(), self.describe_top, self.describe_buttom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
    --     :setCellSize(self.describe_item_content:getContentSize()) -- 每个小intem 的大小
    --     :setCellTemplate(UIDescribeItemCell) -- 回调函数
    --     :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
    --     :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
    --     :setColumn(1)
    -- self.describe_add_node:addChild(self.tableView2)

    self.PageView_1:addEventListener(handler(self, self.pageViewEvent))
    self.node_touch = cc.Node:create()
    self:addChild(self.node_touch)
    uiMgr:addWidgetTouchHandler(self.PageView_1, function(sender, eventType) self:touEvnenter(sender, eventType) end, true)

    self.tips_node = cc.Node:create()
    self:addChild(self.tips_node)
    global.vipPanel = self


    local level_bg =  self.show_level_text:getParent()
    self.tb_top:setPositionY(level_bg:convertToWorldSpace((cc.p(0,0))).y+15)
    local y =  self.tb_top:getPositionY() - self.tb_bottom:getPositionY()
    self.PageView_1:setContentSize(cc.size(self.PageView_1:getContentSize().width, y))

    local arrow_y = self.tb_top:getPositionY() - (self.tb_top:getPositionY() - self.tb_bottom:getPositionY()) / 2 
    self.left:setPositionY(arrow_y)
    self.right:setPositionY(arrow_y)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
 
function UIvipPanel:exit_back(sender, eventType)
    self.want_exit =true
    if eventType == 2 then
        self:exit_call()
    end
end 

function UIvipPanel:exit_call(sender, eventType)
    global.panelMgr:closePanel("UIvipPanel")
end
  
function UIvipPanel:onEnter()

    -- self.ScrollView_1:jumpToTop()

    self:setData()

    self:addEventListener(global.gameEvent.EV_ON_UI_VIPUPDATE,function()

        self:setData(true)
    end)

    local function onResume()
        self:BackRefreshTime()
    end
    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME,onResume)
    self.want_exit = false

    -- self.PageView_1:setInnerContainerSize(self.describe_content:getContentSize())
    -- self.hero_scrollview:setInnerContainerSize(cc.size(width, height))

end 

function UIvipPanel:BackRefreshTime()

    local vipdata = global.userData:getVipData()
    self.vip_data = {}

    self:getConfigVIPData()

    self.vip_data.isvalid = global.vipBuffEffectData:isVipEffective()

    self.vip_data.endtime =vipdata.lEndTime
    self.vip_data.loginday = vipdata.lDay
    self.vip_data.level =vipdata.lLV
    self.vip_data.point = vipdata.lPoint 
    self.vip_data.alltime = vipdata.lEndTime - global.dataMgr:getServerTime()
     self.currentLeveldata = self:getVipDescribeByLevel(self.vip_data.level)
    self:updateUI()
    self:updatePointState(self.PageView_1:getCurrentPageIndex())
end 

function UIvipPanel:setData(isNotify)

    self.isNotify = isNotify
    local vipdata = global.userData:getVipData()
    self.vip_data = {}
    self:getConfigVIPData()

    self.vip_data.isvalid = global.vipBuffEffectData:isVipEffective()

    print("self.vip_data.isvalid" , self.vip_data.isvalid)
    dump(vipdata,"vipdata/////////////")
    print(global.dataMgr:getServerTime(),"setServerTime")

    self.vip_data.endtime =vipdata.lEndTime
    self.vip_data.loginday = vipdata.lDay
    self.vip_data.level =vipdata.lLV
    self.vip_data.point = vipdata.lPoint 
    self.vip_data.alltime = vipdata.lEndTime - global.dataMgr:getServerTime()
    self.currentLeveldata = self:getVipDescribeByLevel(self.vip_data.level)
 
    self:updateUI()

    self.isMoveing  = true
    self.isStartMove = false
    self.isPageMove = false
    self.innited = true 
    self:showSlider()
    self:registerMove()

end

function UIvipPanel:fade()
    self.vip_data.isvalid = false
    self.vip_data.endtime = global.dataMgr:getServerTime() - 1 
    self:updateUI()
end
 
function UIvipPanel:ChooseTableView()
    if self.current_show_tableView == self.tableView1 then 
        return  self.tableView2
    else
        return self.tableView1
    end 
end

function UIvipPanel:updateLevelUI( )
    for _,v in pairs(self.level_arrnode_node:getChildren()) do 
        if  self:checknode(v) then -- 这变灰
            v.AtlasLabel_1_0:setVisible(true)
            v.AtlasLabel_1:setVisible(false)
            global.colorUtils.turnGray(v,true ) 
        else
            v.AtlasLabel_1_0:setVisible(false)
            v.AtlasLabel_1:setVisible(true)
            global.colorUtils.turnGray(v,false) 
        end  
    end 
end


function UIvipPanel:checknode(node)
    local flg =true 
    for i=1,self.vip_data.level do 
        if node:getName() == 'VIP_icon_bg_'..i then 
            flg = false 
            break 
        end 
    end 
    return flg 
end 

function UIvipPanel:getVipDescribeByLevel(level)
    local temp={} 
    for key1 , v in pairs(self.vip_data.vip_func) do 
        if v.lv == level then 
            for key2 , vv in pairs(v.buffID) do 
                if vv[2]>0 and (not global.vipBuffEffectData:checkEquiment(vv  , level)) then 
                     table.insert(temp,clone(vv))
                end
            end 
        end 
    end
    return temp 
end

function UIvipPanel:setChooseTableViewData(direction)
    local temp = self:getVipDescribeByLevel(self.current_table_number)
    if self.current_table_number >  self.vip_data.level  then 
        for _ , v in pairs(temp) do 
            local inLevel = false --两个等级是否同时拥有
            for __ , vv in pairs(self.currentLeveldata) do 
                if v[1] == vv[1] then 
                    v.up_text = v[2]-vv[2]
                    inLevel = true 
                    break
                end 
            end  
            if not inLevel then 
                v.up_text =0 
                v.isNewItem = true 
            else
                v.isNewItem = false
            end 
        end 
    else
        for _ , v in pairs(temp) do
            for __, vv in pairs(self.currentLeveldata) do 
                if v[1] == vv[1] then 
                    v.up_text = v[2]-vv[2]
                     v.isNewItem = false
                    break
                end 
            end 
        end 
    end 
    self:ChooseTableView():setData(temp)
 end


function UIvipPanel:getTableViewData(tablenumber)  --获取 tablenumber vip等级数据 
    local temp = self:getVipDescribeByLevel(tablenumber)

    if tablenumber >  self.vip_data.level  then 
        for _ , v in pairs(temp) do 
            local inLevel = false --两个等级是否同时拥有
            for __ , vv in pairs(self.currentLeveldata) do 
                if v[1] == vv[1] then 
                    v.up_text = v[2]-vv[2]
                    inLevel = true 
                    break
                end 
            end  
            if not inLevel then 
                v.up_text =0 
                v.isNewItem = true 
            else
                v.isNewItem = false
            end 
        end 
    else
        for _ , v in pairs(temp) do

            local inLevel = false --两个等级是否同时拥有
            for __, vv in pairs(self.currentLeveldata) do 
                if v[1] == vv[1] then 
                    v.up_text = v[2]-vv[2]
                    v.isNewItem = false
                    inLevel = true
                    break
                end 
            end 
            if not inLevel then 
                v.up_text = 0 
                v.isNewItem = false 
            end

        end 
    end 
    return temp
 end 


function UIvipPanel:updateUI()  -- 显示基本数据  不包括下面 vip 效果

    if  self.vip_data.isvalid  then
        self.bt_activation_text:setVisible(false)
        self.bt_activation_node:setVisible(false)
        self.over_time_text:setVisible(true)
        if not self.timer then 
            self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTimeUI), 1)
        end
        self:updateOverTimeUI()
        self.user_level_text:setString(self.vip_data.level)
        self.user_level_gary:setVisible(false)
        self.user_level_text:setVisible(true)
        global.colorUtils.turnGray(self.user_level_banner_node,false)
        global.tools:adjustNodeMiddle(self.level_mark , self.user_level_text)
        self.bt_renew:setVisible(true)
    else 
        self.bt_renew:setVisible(false)
        self.bt_activation_node:setVisible(true)
        self.bt_activation_text:setVisible(true)
        self.over_time_text:setVisible(false)
        --self.login_VIP_point_node:setVisible(false)
        self.user_level_gary:setString(self.vip_data.level)
        self.user_level_gary:setVisible(true)
        self.user_level_text:setVisible(false)
        global.colorUtils.turnGray(self.user_level_banner_node,true)
        global.tools:adjustNodeMiddle(self.level_mark , self.user_level_gary)

    end 


    local setRitchText = function () 
        local str = ""
        if self.vip_data.loginday > 30  then 

            if  self.vip_data.isvalid   then --10800

                if self.vip_data.level >= global.vipBuffEffectData:getMaxVIPLevel() then --  敬请期待

                    -- uiMgr:setRichText(self,"login_get",50046,{today =temptoday ,tomorrow = temptomorrow})
                    str = global.luaCfg:get_local_string(10800)
                else  -- 10798

                    str = global.luaCfg:get_local_string(10798)
                    -- uiMgr:setRichText(self,"login_get",50046,{today =temptoday ,tomorrow = temptomorrow})
                end 

            else --10799
                str = global.luaCfg:get_local_string(10799)
                -- uiMgr:setRichText(self,"login_get",50046,{today =temptoday ,tomorrow = temptomorrow}) -- 显示 激活 显示有加成
            end

          self.login_get:setString(str)
        end 
    end 

    setRitchText()
    -- 经验
     if self.vip_data.loginday == 0 then 
        uiMgr:setRichText(self,"login_get",50046,{today =0 ,tomorrow =luaCfg:get_vip_day_by(self.vip_data.loginday+1).exp})
        -- self.login_VIP_point:setString('0')
        -- self.tomorrow_point:setString(luaCfg:get_vip_day_by(self.vip_data.loginday+1).exp)
    elseif self.vip_data.loginday > 30  then 
        -- self.login_VIP_point_node:setVisible(false) 
    elseif self.vip_data.loginday == 30 then
        local temptoday =luaCfg:get_vip_day_by(self.vip_data.loginday).exp
        uiMgr:setRichText(self,"login_get",50129,{today =temptoday})
    else 

        if  luaCfg:get_vip_day_by(self.vip_data.loginday) then 

            local temptoday =luaCfg:get_vip_day_by(self.vip_data.loginday).exp
            local temptomorrow = 0
            -- self.login_VIP_point:setString(luaCfg:get_vip_day_by(self.vip_data.loginday).exp)
            if luaCfg:get_vip_day_by(self.vip_data.loginday+1) then 
                    -- self.tomorrow_point:setString(luaCfg:get_vip_day_by(self.vip_data.loginday+1).exp)
                temptomorrow = luaCfg:get_vip_day_by(self.vip_data.loginday+1).exp
    
            end
            uiMgr:setRichText(self,"login_get",50046,{today =temptoday ,tomorrow = temptomorrow})

        else 
             -- self.login_VIP_point_node:setVisible(false)
        end 
    end 

    self.current_viplevel_text:setString(self.vip_data.level)
    if self:getMaxVIPLevel()>= self.vip_data.level+1 then 
         self.next_VIP_level_text:setString(self.vip_data.level+1)
    else
        self.next_VIP_level_text:setString(self:getMaxVIPLevel())
    end 

    self.current_experience_text:setString(self.vip_data.point)
    for _ ,v in pairs(self.vip_data.vip_func) do 
        if v.lv == self.vip_data.level+1 then 
                self.target_experience_text:setString("/"..v.exp)
                self.loadingbar_experience:setPercent(self.vip_data.point/ v.exp * 100 )
            break
        end 
    end
    -- level 满级 经验显示 为 -- 
    if self.vip_data.level == self:getMaxVIPLevel() then 
        self.current_experience_text:setString('M')
        self.target_experience_text:setString("ax")
        self.loadingbar_experience:setPercent( 100 )
    end 
    self.level_loadingBar:setPercent((self.vip_data.level-1) / self:getMaxVIPLevel() * 100 )
    -- dump(head,"---------------------head")
    -- dump(global.headData:getCurHead())
    local head = clone(global.headData:getCurHead())
    if head then
         global.tools:setCircleAvatar(self.portrait_node, head)
    end

    -- self.headFream:setSpriteFrame(global.userheadframedata:getCrutFrame().pic) --设置头像边框
    local headData = global.userheadframedata:getCrutFrame()
    -- dump(headData)
    if headData and headData.pic then
        global.panelMgr:setTextureFor(self.headFream,headData.pic)
    end

    -- self:updateTablePointUI()
    self:updateLevelUI()
end

function UIvipPanel:getMaxVIPLevel()
    local max =0 
    for _ ,v in pairs(self.vip_data.vip_func) do 
        if max < v.lv then 
            max = v.lv 
        end 
    end 
    return max  
end 

function UIvipPanel:onExit()
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
    if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
     if self.touchEventListener  then 
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener  = nil
    end
     if self.m_countDownTimer then
        gscheduler.unscheduleGlobal(self.m_countDownTimer)
        self.m_countDownTimer = nil
    end
    self.want_exit = nil
    self.PageView_1:removeAllChildren()
end 
function UIvipPanel:updateOverTimeUI()
    if not self.vip_data then return end  
    self.vip_data.alltime  = self.vip_data.alltime -1 
    local dayTime =  self.vip_data.alltime - self.vip_data.alltime % (24*60*60) -- 余数
    local remnantTime = self.vip_data.alltime % (24*60*60)
    local day  = dayTime / (24*60*60)
    if day >= 1 then 
        -- self.over_time_day_text:setString(day)

        self.over_time_text:setString(luaCfg:get_local_string(10675,day, funcGame.formatTimeToHMS(remnantTime)))
    else 
        -- self.over_time_day_text:setString(0)
        
        self.over_time_text:setString(funcGame.formatTimeToHMS(remnantTime))
    end 

    if self.vip_data.alltime <=0 then 
        if self.timer then
            gscheduler.unscheduleGlobal(self.timer)
            self.timer = nil
        end
        self:fade()
    end 
end

function UIvipPanel:getConfigVIPData()
    self.vip_data.vip_func= luaCfg:vip_func()
    self.vip_data.vip_day = luaCfg:vip_day()
end 

function UIvipPanel:updateLevelProgressUI()
   local part =  self.level_describe_current_loadingBar:getContentSize().width / #self.vip_data.vip_func
   for i =0 , #self.vip_data.vip_func-1 do 
        local item = UILeveL_item.new()
        item:setPositionX(i*part)
        self.level_describe_current_loadingBar:addChild(item)
    end

    if  self.vip_data.isvalid then 
        self.level_describe_current_loadingBar:setPercent(self.vip_data.level /#self.vip_data.vip_func*100)  
    else  
        self.level_describe_current_loadingBar:setPercent(0)  
    end 
end 

function UIvipPanel:bt_activation_vip(sender, eventType)
    local panel = global.panelMgr:openPanel("UISpeedPanel")   --行军加速道具使用
    panel:setData(nil,nil,panel.TYP_VIPActivation, nil)
end

function UIvipPanel:bt_add_vip_experience(sender, eventType)
    if self.vip_data.level < self:getMaxVIPLevel() then 
            local panel = global.panelMgr:openPanel("UISpeedPanel")   --行军加速道具使用
             panel:setData(nil,nil,panel.TYP_VIPAddPoint, nil)
    else
            global.tipsMgr:showWarning("VIP_FULL")
    end 
end

function UIvipPanel:itemClickHanlder(sender, eventType)

end


function UIvipPanel:registerMove()
    if  not  self.touchEventListener  then 
        self.touchEventListener = cc.EventListenerTouchOneByOne:create()
        self.touchEventListener:setSwallowTouches(false)
        self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
        self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
        self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.node_touch)
    end 
end

function UIvipPanel:pageViewEvent(sender, eventType )
    if not self.sliderData then return end
    if eventType == ccui.PageViewEventType.turning then
        -- 滑动到循环页
        local currPageIndex = self.PageView_1:getCurrentPageIndex()
        self:updatePointState(currPageIndex)
    end
end



local beganPos = cc.p(0,0)
local isMoved = false
function UIvipPanel:onTouchBegan(touch, event)
    isMoved = false
    self.moveingType = 1
    self.beganPos = touch:getLocation()
    return true
end

function UIvipPanel:onTouchMoved(touch, event)
    self.movePos = touch:getLocation()
    local  x = math.abs( self.beganPos.x - self.movePos.x) 
    local  y = math.abs(self.beganPos.y - self.movePos.y)
      -- print(self.beganPos.x,self.beganPos.y)
      -- print(self.movePos.x,self.movePos.y)
            -- print(self.PageView_1:isRunning(),"self.PageView_1:isRunning()")
    if self.isMoveing  then 
        if x > 10  then 
            for _ ,v in pairs(self.pageviewchild) do 
                v:clearTouches()
            end
            --self.touch_panel:setTouchEnabled(true)
            self.isMoveing  = false
            self.moveingType = 1
        elseif y > 10  then
            -- self.PageView_1:setEnabled(false)
            self.PageView_1:setTouchEnabled(false)
            self.isMoveing  = false
            self.moveingType = 2
        end 
    end 
    isMoved = true
end

function UIvipPanel:Test()
    self.touch_panel:setTouchEnabled(false)
    gscheduler.unscheduleGlobal(self.Testtimer)
    self.Testtimer = nil
end 

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIvipPanel:onTouchEnded(touch, event)
    -- if not self.Testtimer  then 
    --     self.Testtimer = gscheduler.scheduleGlobal(handler(self,self.Test), 0.3)
    -- end
    self.isMoveing =true
    -- self.PageView_1:setEnabled(true)
    self.PageView_1:setTouchEnabled(true)    
    
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        -- return
    end

    local y = self.PageView_1:getPositionY()+self.PageView_1:getContentSize().height - 2 

    if isMoved and self.moveingType == 2 and self.want_exit == false then
        global.delayCallFunc(function()
            print(">>>>delay call")
            CCHgame:sendTouch(cc.p(100,y))
        end,nil,0)        
    end
end

function UIvipPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIvipPanel:innitData()
    self.lAdID ={1,2,3,}
end 
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
 
function UIvipPanel:getChargeSlider()
    local temp = luaCfg:vip_func()
    return temp
end 

function UIvipPanel:jumpToIndex(index)
    self.PageView_1:jumpToPercentHorizontal( index/(#self.sliderData+1) *100 )
end


function UIvipPanel:showSlider()
    local sliderData = self:getChargeSlider()
    self.sliderData = sliderData
    -- if self.inpanel then 
    --     -- self.PageView_1:removeAllPages()
    --     if self.pageviewchild then 
    --         self:jumpToIndex(self.vip_data.level) 
    --         self:updatePointState(self.vip_data.level)
    --         return 
    --     end 
    -- end
    self.PageView_1:removeAllChildren()

    local getTable = function (data, level,isDelay)
        -- body
        local tableView  = UITableView.new()
        :setSize(cc.size(self.PageView_1:getContentSize().width , self.PageView_1:getContentSize().height-10) )
        :setCellSize(self.describe_item_content:getContentSize()) 
        :setCellTemplate(UIDescribeItemCell) 
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

        local setOrderAndStrong = function (data) 
            for _ ,v in ipairs(global.luaCfg:vip_effect()) do 
                if v.data_type ==  data[1] then 
                    data.order = v.id
                    if v["vip_"..level] and v["vip_"..level] == 1 then 
                        data.strong  = true 
                    end 
                end 
            end 
        end


        for _ ,v in ipairs(data) do 
            setOrderAndStrong(v)
        end 


        local new = {}
        local notnew= {} 
        for _ , v in pairs(data) do 
            if  v.isNewItem  then
                table.insert(new , v)
            else 
                table.insert(notnew , v)
            end 
        end 

        table.sort(new , function(A ,B)  return A.order < B.order  end ) 
        table.sort(notnew , function(A ,B)  return A.order < B.order end ) 

        data = {} 

        for _ ,v in ipairs(new ) do 
            table.insert(data , v )
        end         

        for _ ,v in ipairs(notnew ) do 
            table.insert(data , v )
        end         

        local time =  math.abs( self.vip_data.level - level ) * 0.1
        if  time == 0  or  not isDelay or self.isNotify then 
            tableView:setData(data)
        else 
            gscheduler.performWithDelayGlobal(function()
                if  tableView.setData then 
                 tableView:setData(data)
                end 
            end, time)
        end  
    
        tableView.id = level

        return tableView
    end

    local createNode = function (node , time , data, index, isDelay) 
        local node = node

        local call  = function()
            if  not tolua.isnull(self) and not tolua.isnull(node) and not node.isCreate then 
                local repeatItem1 = getTable(self:getTableViewData(index), index , isDelay)
                repeatItem1.panel = self
                node:addChild(repeatItem1)
                node.isCreate =true 
            end
        end
        node.createCall = call 

        if time == 0  or self.isNotify then 
            node.createCall()
        else 
            gscheduler.performWithDelayGlobal(node.createCall, time)
        end 
    end 

    local partTime = 0.1 
    if #sliderData > 0 then
        local node = gdisplay.newWidget()
        createNode(node ,  partTime , sliderData[#sliderData], #sliderData)
        self.PageView_1:addPage(node) 
        for i,v in ipairs(sliderData) do
            local node = gdisplay.newWidget()
            v.panel = self
            self.PageView_1:addPage(node)
            local time = i* partTime
            if i == 1  then 
                time =  0 
            end
            if time > 1 then 
                time = 1 
            end 
            createNode(node , time ,  v, i, true)
        end 
        local node = gdisplay.newWidget()
        createNode(node , partTime , sliderData[1], 1)
        self.PageView_1:addPage(node) 
    end


    self:setPoint(#sliderData)
    self:jumpToIndex(self.vip_data.level) 
    self:updatePointState(self.vip_data.level)
      --  self:playAuto()
end

-- 开始自动播放
function UIvipPanel:playAuto()
    if not self.m_countDownTimer then
        self.m_countDownTimer = gscheduler.scheduleGlobal(handler(self,self.countDownHandler), 5)
    end
end

function UIvipPanel:countDownHandler(dt)

    local currPageIndex = self.PageView_1:getCurrentPageIndex()
    if currPageIndex  == (#self.sliderData + 1) then 
        
        currPageIndex = 1
        self:jumpToIndex(currPageIndex)
    elseif currPageIndex  == 0 then

        currPageIndex = #self.sliderData
        self:jumpToIndex(currPageIndex)
    else
        currPageIndex = currPageIndex + 1
        self.PageView_1:scrollToPage(currPageIndex)
    end
    self:updatePointState(currPageIndex)
end

-- slider 点
function UIvipPanel:setPoint(num)


    for i=1,10 do
        if self.point_node["p"..i] then 
            self.point_node["p"..i]:setVisible(i<=num)
        end 
    end
    if num > 0 then
        local posX = self.point_node["p_"..num]:getPositionX()
        self.point_node:setPositionX(gdisplay.width/2-posX/2)
    end
end
-- 当前页点亮
function UIvipPanel:updatePointState(index)
    if index>10 then index =1 end 
    if index<1 then index =10 end 
    self.show_level_text:setString( index)

    local temp =self.show_level_text:getParent():getChildren()
    local node1 = temp[1]
    local node2 = temp[2]
    local node3 = temp[3]

    global.tools:adjustNodeMiddle(node1 ,node2, node3 )

    if index == (#self.sliderData+1)  then
        index = 1
    elseif index == 0 then
        index = #self.sliderData
    end

    for i=1,#self.sliderData do
        if self.point_node["p_"..i] then 
            global.colorUtils.turnGray(self.point_node["p_"..i], i~=(index))
        end
        if self.level_arrnode_node["VIP_icon_bg_"..i].circle then 
            global.colorUtils.turnGray(self.level_arrnode_node["VIP_icon_bg_"..i].circle,i~=(index))
            self.level_arrnode_node["VIP_icon_bg_"..i].circle:setVisible(i==(index))
        end 
    end

    if self.FileNode_1 then 
        self.FileNode_1:setData(index)
    end 

end

function UIvipPanel:showTips(icon,itemId)
    if not icon.m_TipsControl then
        icon.m_TipsControl = UILongTipsControl.new(icon,WCONST.LONG_TIPS_PANEL.ITEM_DESC)
    end
    icon.m_TipsControl:setData({information=global.luaCfg:get_local_item_by(itemId)})

    return m_TipsControl
end

function UIvipPanel:touEvnenter(sender, eventType)
    if not self.sliderData then return end
    local currPageIndex = self.PageView_1:getCurrentPageIndex()
    if eventType == 1 then
    elseif eventType == 2 or eventType == 3 then
        if currPageIndex == (#self.sliderData+1) then
            self:jumpToIndex(1)
        elseif currPageIndex == 0 then
            self:jumpToIndex(#self.sliderData)
        end
    end
end
 

function UIvipPanel:click_to_left(sender, eventType)

end

function UIvipPanel:click_to_right(sender, eventType)

end

function UIvipPanel:reCharge(sender, eventType)
    global.panelMgr:closePanel("UIvipPanel")
    global.tipsMgr:showWarning("ItemUseDiamond")
end
--CALLBACKS_FUNCS_END

return UIvipPanel

--endregion
