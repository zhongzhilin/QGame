--region UISevenDaysItem.lua
--Author : anlitop
--Date   : 2017/08/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISevenDaysItem  = class("UISevenDaysItem", function() return gdisplay.newWidget() end )

local UISevenDaysRewardItemCell = require("game.UI.activity.cell.UISevenDaysRewardItemCell")
local UITableView =  require("game.UI.common.UITableView")

function UISevenDaysItem:ctor()

    self:CreateUI()

end

function UISevenDaysItem:CreateUI()
    local root = resMgr:createWidget("activity/sevendays/sevenday_target_node")
    self:initUI(root)
end

function UISevenDaysItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/sevendays/sevenday_target_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.name = self.root.name_export
    self.now = self.root.now_mlan_6_export
    self.current = self.root.current_export
    self.target = self.root.target_export
    self.reward_btn = self.root.reward_btn_export
    self.go_btn = self.root.go_btn_export
    self.node_killed = self.root.node_killed_export
    self.table_contont = self.root.table_contont_export
    self.table_item = self.root.table_item_export
    self.table_add = self.root.table_add_export

    uiMgr:addWidgetTouchHandler(self.reward_btn, function(sender, eventType) self:onClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.go_btn, function(sender, eventType) self:onTarget(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.table_contont:getContentSize())-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.table_item:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UISevenDaysRewardItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
        :setColumn(1)
    self.table_add:addChild(self.tableView)


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


local  color ={

        red = cc.c3b( 180,29 ,  11) , 
        dd = cc.c3b( 208,167 , 114),
    } 

    local fontColor = {

        normal =cc.c3b(255, 226 ,165) ,
        strong =cc.c3b(232, 67 ,237)
    }


function UISevenDaysItem:setData(data) 


    self.node_killed:setVisible(false)
    self.reward_btn:setVisible(false)
    self.go_btn:setVisible(false)


    self.data = data 

    -- dump(self.data ,"self.data ///")

    local target_condition = global.luaCfg:get_target_condition_by(self.data.id)

    self.name:setString(target_condition.description)

    self.bg:setSpriteFrame(self.data.bg)

    if self.data.bg == "train_list_bg.jpg" then 
        self.name:setTextColor(fontColor.normal)
    else 
        self.name:setTextColor(fontColor.strong)
    end  

    local temp = {} 

    for index ,v in pairs(global.luaCfg:get_drop_by(self.data.reward).dropItem) do 

            local data = {} 
            
            data.tips_panel =  self.data.tips_panel

            data.data = global.luaCfg:get_local_item_by(v[1])

            data.isshownumber =  true

            data.number = v[2]

            table.insert(temp   , clone(data) )
    end

    table.sort(temp  , function(A ,B) return A.data.quality >  B.data.quality end)

    for _ ,v in pairs(temp) do 
        -- v.scale = 1.4
    end 

    self.tableView:setData(temp)

    -- self.node_killed:setVisible(data.killed)

    self.data.max = target_condition.condition

    if self.data.now  >= self.data.max then 

        -- self.data.state = 1 
    end 

    if self.data.state  ==  0 then -- 0 未完成

        if  self.data.type  ~= 0 then 

            self.go_btn:setVisible(true)
        end 

    elseif self.data.state  == 1  then -- 1--已完成 未领取
        
        self.reward_btn:setVisible(true)

    elseif self.data.state  == 2 then --2-- 已领取

        self.node_killed:setVisible(true)
    end 

    if   self.data.now >= self.data.max  then 

        self.current:setString(self.data.max)

        self.current:setTextColor(color.dd)

    else

        self.current:setString(self.data.now)        

        self.current:setTextColor(color.red)

    end

    self.target:setString("/"..self.data.max)

self.current:setPositionX(self.target:getPositionX()-self.target:getContentSize().width)
    self.now:setPositionX(self.current:getPositionX()-self.current:getContentSize().width)    


    if global.UISevenDaysCell  then 

        global.UISevenDaysCell[self.data.index] = self
    end


    -- if self.data.type == 0 and  self.data.state  ~=2  then --没有前往的 页显示领取 
    --     self.reward_btn:setVisible(true)
    -- end 


    global.colorUtils.turnGray(self.reward_btn , self.data.day  > self.data.now_day or self.data.state  ==  0 )

end


-- function UISevenDaysItem:ChcekState()

--     if not global.severDataRequestComplete then 

--         self.node_killed:setVisible(false)
--         self.reward_btn:setVisible(false)
--         self.go_btn:setVisible(false)

--     end 
-- end 


function UISevenDaysItem:onExit()

    if global.UISevenDaysCell then 
        global.UISevenDaysCell[self.data.index]= nil
    end 
end 


function UISevenDaysItem:setTBTouchEable(state)

    if state then 
        if not  self.tableView:isTouchEnabled()  then 

            self.tableView:setTouchEnabled(true)
        end
    else 
        
        self.tableView:setTouchEnabled(false)
    end 
end 


function UISevenDaysItem:onClick(sender, eventType) --领取物品 
    
    -- dump(self.data , "条状似是士大夫")


    if  self.data.now < self.data.max  then

        global.tipsMgr:showWarning("notFinishTarget")
        return 
    end 


    if self.data.day  > self.data.now_day then 

        global.tipsMgr:showWarning("cannotGetReward")
        return 
    end
 

    global.panelMgr:openPanel("UIItemRewardPanel"):setData(global.luaCfg:get_drop_by(self.data.reward).dropItem or {})

    local taskID = self.data.id
    global.ActivityAPI:SevenActivityRecevieReq(self.data.id, function(msg)

         -- global.tipsMgr:showWarning("MONTH_CARD_RECEIVE")
            self.data.state = 2
            self:setData(self.data)
            local orgin = global.ActivityData:getSevenDayNotifyRedCount()
            if orgin then 
                if orgin < 0 then orgin = 0 end 
                global.ActivityData:setSevenDayNotifyRedCount(orgin - 1 )
            end 
            global.ActivityData:finishSevenDay(taskID)
    end)

end

-- 0-无跳转
-- 1-跳转建筑
-- 2-跳转界面
-- 3-跳转附近野怪
-- 4-跳转附近野地
-- 5-跳转到大地图


local setDataArr = {

    "UIUnionPanel" , 
    "UIWallSpacePanel",
}


local panelBuild = {

    UIHeroPanel = 15 , 
    UIHeroPanel2 = 15 , 
    UIWallSpacePanel = 1 ,  
    UISoldierSourcePanel  = 4 , 
    UIHpPanel = 13 , 
    UISciencePanel = 17 , 
    UIEquipStrongPanel = 20 ,
}


local skipPanel = {
    
    UIUnionPanel = true  , 
    UIHadUnionPanel = true  , 
    UIWallSpacePanel = true , 

} 



function UISevenDaysItem:checkBuild(curBuildId)

    curBuildId =tonumber(curBuildId)

    if curBuildId ~= 0 and (not global.cityData:checkBuildLv(curBuildId, 1)) then 

        return true 
    end

    return false 
end 

        
function UISevenDaysItem:onTarget(sender, eventType) -- 前往目标


        if self.data.type ==  1  then  

            local  curBuildId =tonumber(self.data.target)

            if  self:checkBuild(curBuildId) then 

                if not   global.luaCfg:get_buildings_ui_by(curBuildId) then return end 

                local str =string.format(global.luaCfg:get_local_string(10549), global.luaCfg:get_buildings_ui_by(curBuildId).typeName)

                global.tipsMgr:showWarning(str)

                return
            end

            global.panelMgr:closePanel("UISevenDays")

            global.guideMgr:setStepArg(curBuildId)
            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_UPDATE)

        elseif self.data.type ==  2   then

            local  curBuildId =panelBuild[self.data.target]

            if  self:checkBuild(curBuildId) and  not skipPanel[self.data.target] then 

                if not   global.luaCfg:get_buildings_ui_by(curBuildId) then return end 

                local str =string.format(global.luaCfg:get_local_string(10549), global.luaCfg:get_buildings_ui_by(curBuildId).typeName)

                global.tipsMgr:showWarning(str)

                return
            end

            if self.data.target == "UIHadUnionPanel" then  -- 跳转联盟界面 判断是否加入过联盟
                if global.userData:checkJoinUnion() then --已有联盟信息界面
                    -- global.panelMgr:closePanel("UISevenDays")
                    global.panelMgr:openPanel("UIHadUnionPanel")
                    -- global.panelMgr:openPanel("UIUBuildPanel")
                else --选择加入联盟列表
                    -- global.panelMgr:openPanel("UIUnionPanel"):setData()
                    global.tipsMgr:showWarning("UnionMap01")
                end
                return 

            elseif self.data.target == "UIHeroPanel" then 

                 global.panelMgr:openPanel("UIHeroPanel"):setMode1()
    
                return 


            elseif self.data.target == "UIHeroPanel2" then 

                 global.panelMgr:openPanel("UIHeroPanel"):setMode2()
    
                return 

            elseif  self.data.target == "UIWallSpacePanel" then 

                local data =  clone(global.cityData:getBuildingById(14))

                global.otherTrainId  = 4 

                data.trainCall = true

                local panel = global.panelMgr:openPanel("UIWallSpacePanel")

                panel:setData(data)  

                return 

            elseif self.data.target == "UISoldierSourcePanel" then 

                local buildingData = global.cityData:getBuildingById(4)


                global.panelMgr:openPanel("UISoldierSourcePanel"):setData(buildingData)  

                return 
            elseif self.data.target =="UIHpPanel" then 

                local buildingData = global.cityData:getBuildingById(13)

                global.panelMgr:openPanel("UIHpPanel"):setData(buildingData)  

                return 
            end    

            -- local panel = global.panelMgr:getPanel("UISevenDays") --退出时清理模拟点击
            -- if panel  and panel.cleanSchedule then panel:cleanSchedule() end
            -- global.panelMgr:closePanel("UISevenDays")

            local panel = global.panelMgr:openPanel( tostring(self.data.target ))

            if  global.EasyDev:CheckContrains(setDataArr , self.data.target) and (not tolua.isnull(panel)) then 

                panel:setData()
            end     

        elseif self.data.type ==  3   then

           global.funcGame:gpsLeastObj(5)

        elseif self.data.type ==  4    then

           global.funcGame:gpsLeastObj(2)

        elseif self.data.type ==  5    then

             global.scMgr:gotoWorldSceneWithAnimation()

        end 
end



function UISevenDaysItem:goTarget(curBuildId ,panelName, isWorldOpen)

    -- 检测是否有当前建筑
    if curBuildId ~= 0 and (not global.cityData:checkBuildLv(curBuildId, 1)) then 
        local builds = luaCfg:get_buildings_pos_by(tonumber(curBuildId))
        global.tipsMgr:showWarning("pandectBuild", builds.buildsName)
        return
    end

    local data = clone(self.data)
    local infoData = clone(self.infoData)

    local lType = self.infoData.data_type
    isWorldOpen = isWorldOpen or (lType == 60 or lType == 63 or data.lFrom == 9)
    if global.scMgr:isWorldScene() and (not isWorldOpen) then
        global.g_worldview.mapPanel:cleanSchedule()
        global.scMgr:setMainSceneCall(function()    
            global.userData:setOpenFirst(false)         
            global.funcGame:pandectFunCall(data, infoData, panelName)
            global.userData:setOpenFirst(true)
        end)
        global.scMgr:gotoMainSceneWithAnimation()
    else
        global.funcGame:pandectFunCall(data, infoData, panelName)
    end
end


--CALLBACKS_FUNCS_END

return UISevenDaysItem

--endregion
