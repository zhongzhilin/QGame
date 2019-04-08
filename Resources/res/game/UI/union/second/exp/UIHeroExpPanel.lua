--region UIHeroExpPanel.lua
--Author : zzl
--Date   : 2017/12/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIHeroExpChoose = require("game.UI.union.second.exp.UIHeroExpChoose")
local UIHeroExpHeroItem = require("game.UI.union.second.exp.UIHeroExpHeroItem")
local UIHeroExpTimeItem = require("game.UI.union.second.exp.UIHeroExpTimeItem")
--REQUIRE_CLASS_END
local UIHeroExpPanel  = class("UIHeroExpPanel", function() return gdisplay.newWidget() end )
local UIHeroExpItem = require("game.UI.union.second.exp.UIHeroExpItem")
local UIHeroExpItemCell = require("game.UI.union.second.exp.UIHeroExpItemCell")
local UITableView = require("game.UI.common.UITableView")

function UIHeroExpPanel:ctor()
    self:CreateUI()
end

function UIHeroExpPanel:CreateUI()
    local root = resMgr:createWidget("hero_exp/hero_exp_bg")
    self:initUI(root)
end

function UIHeroExpPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "hero_exp/hero_exp_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_mlan_12_export
    self.ScrollView = self.root.ScrollView_export
    self.ps_node = self.root.ScrollView_export.ps_node_export
    self.bot_bg = self.root.ScrollView_export.bot_bg_export
    self.bot_frame = self.root.ScrollView_export.bot_frame_export
    self.my_exp_node = self.root.ScrollView_export.my_exp_node_mlan_10_export
    self.my_exp = self.root.ScrollView_export.my_exp_node_mlan_10_export.my_exp_export
    self.get_my = self.root.ScrollView_export.my_exp_node_mlan_10_export.get_my_export
    self.end_bt = self.root.ScrollView_export.my_exp_node_mlan_10_export.end_bt_export
    self.my_choose = self.root.ScrollView_export.my_choose_export
    self.my_choose = UIHeroExpChoose.new()
    uiMgr:configNestClass(self.my_choose, self.root.ScrollView_export.my_choose_export)
    self.my_hero = self.root.ScrollView_export.my_hero_export
    self.my_hero = UIHeroExpHeroItem.new()
    uiMgr:configNestClass(self.my_hero, self.root.ScrollView_export.my_hero_export)
    self.my_tips = self.root.ScrollView_export.my_tips_mlan_32_export
    self.my_start = self.root.ScrollView_export.my_start_export
    self.my_time = self.root.ScrollView_export.my_time_export
    self.my_time = UIHeroExpTimeItem.new()
    uiMgr:configNestClass(self.my_time, self.root.ScrollView_export.my_time_export)
    self.other_exp_node = self.root.ScrollView_export.other_exp_node_mlan_12_export
    self.other_exp = self.root.ScrollView_export.other_exp_node_mlan_12_export.other_exp_export
    self.other_btn = self.root.ScrollView_export.other_btn_export
    self.other_tips = self.root.ScrollView_export.other_tips_mlan_24_export
    self.other_time = self.root.ScrollView_export.other_time_export
    self.other_time = UIHeroExpTimeItem.new()
    uiMgr:configNestClass(self.other_time, self.root.ScrollView_export.other_time_export)
    self.my_other_exp_node = self.root.ScrollView_export.my_other_exp_node_mlan_10_export
    self.my_other_exp = self.root.ScrollView_export.my_other_exp_node_mlan_10_export.my_other_exp_export
    self.get_my_other = self.root.ScrollView_export.my_other_exp_node_mlan_10_export.get_my_other_export
    self.my_other_tips = self.root.ScrollView_export.my_other_tips_mlan_32_export
    self.my_other_hlpe_name = self.root.ScrollView_export.my_other_hlpe_name_export
    self.my_other_start = self.root.ScrollView_export.my_other_start_export
    self.my_other_time = self.root.ScrollView_export.my_other_time_export
    self.my_other_time = UIHeroExpTimeItem.new()
    uiMgr:configNestClass(self.my_other_time, self.root.ScrollView_export.my_other_time_export)
    self.my_add_exp = self.root.ScrollView_export.my_add_exp_export
    self.my_ather_add_exp = self.root.ScrollView_export.my_ather_add_exp_export
    self.ather_add_exp = self.root.ScrollView_export.ather_add_exp_export
    self.my_other_choose = self.root.ScrollView_export.my_other_choose_export
    self.my_other_choose = UIHeroExpChoose.new()
    uiMgr:configNestClass(self.my_other_choose, self.root.ScrollView_export.my_other_choose_export)
    self.my_other_hero = self.root.ScrollView_export.my_other_hero_export
    self.my_other_hero = UIHeroExpHeroItem.new()
    uiMgr:configNestClass(self.my_other_hero, self.root.ScrollView_export.my_other_hero_export)
    self.other_choose = self.root.ScrollView_export.other_choose_export
    self.other_choose = UIHeroExpChoose.new()
    uiMgr:configNestClass(self.other_choose, self.root.ScrollView_export.other_choose_export)
    self.other_hero = self.root.ScrollView_export.other_hero_export
    self.other_hero = UIHeroExpHeroItem.new()
    uiMgr:configNestClass(self.other_hero, self.root.ScrollView_export.other_hero_export)
    self.tb_one = self.root.ScrollView_export.tb_one_export
    self.tb_two = self.root.ScrollView_export.tb_two_export
    self.tb_three = self.root.ScrollView_export.tb_three_export
    self.tb_content_one = self.root.tb_content_one_export
    self.tb_content_two = self.root.tb_content_two_export
    self.tb_cell_size = self.root.tb_cell_size_export

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro_btn, function(sender, eventType) self:info_btn(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.get_my, function(sender, eventType) self:get_my_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.end_bt, function(sender, eventType) self:endClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.my_start, function(sender, eventType) self:my_star_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.get_my_other, function(sender, eventType) self:get_my_other_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.my_other_start, function(sender, eventType) self:my_other_star_click(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) 
        global.panelMgr:closePanel("UIHeroExpPanel")
    end)

    self.my_choose:setData(function(data) 

        if not data then return end 

        self.my_choose:setVisible(false)
        self.my_hero:setVisible(true)
        self.my_hero:setData(data.heroId)

        self.my_tips:setVisible(false)

        self.my_start:setVisible(true)

        local heroData= global.heroData:getHeroDataById(data.heroId)

        self.my_hero:setSpringHero({szName= global.userData:getUserName() , lLevel= heroData.serverData.lGrade})
        self.my_hero.start:setData(heroData.heroId , heroData.serverData.lStar)

        self.my_hero:setExitCall(function () 

            self.my_hero:setVisible(false)
            self.my_start:setVisible(false)

            self.my_choose:setVisible(true)
            self.my_tips:setVisible(true)

            self.chooseFlag = false 

        end)

        self.chooseFlag = true 

    end , self:getChooseHero())

    self.other_choose.addIcon1:setVisible(false)
    self.other_choose.help_btn:setTouchEnabled(false)

    uiMgr:addWidgetTouchHandler(self.my_other_choose.addIcon1, function(sender, eventType) 
        if global.chatData:isJoinUnion() then 
            global.panelMgr:openPanel("UIHeroExpListPanel")
        else 
            global.tipsMgr:showWarning("noUnionExp")
        end  
    end)

    self.tableView = UITableView.new()
        :setSize(self.tb_content_one:getContentSize())
        :setCellSize(self.tb_cell_size:getContentSize())
        :setCellTemplate(UIHeroExpItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_one:addChild(self.tableView)

    self.tableView2 = UITableView.new()
        :setSize(self.tb_content_two:getContentSize())
        :setCellSize(self.tb_cell_size:getContentSize())
        :setCellTemplate(UIHeroExpItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_two:addChild(self.tableView2)


    self.tableView3 = UITableView.new()
        :setSize(self.tb_content_one:getContentSize())
        :setCellSize(self.tb_cell_size:getContentSize())
        :setCellTemplate(UIHeroExpItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_three:addChild(self.tableView3)


    self.ScrollView_1  =self.ScrollView
    self:adapt()
end



--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIHeroExpPanel:adapt()

    local sHeight =(gdisplay.height - 75)
    local defY = self.ScrollView_1:getContentSize().height
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, sHeight))
    if sHeight < defY then 

    else
        self.ScrollView_1:setTouchEnabled(false)
        self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.ScrollView_1:getContentSize().height- self.ps_node:getPositionY()
        for _ ,v in pairs(self.ScrollView_1:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 

        local oldcontent = self.bot_bg:getContentSize()
        if self.bot_bg:getPositionY() > oldcontent.height then 
            self.bot_bg:setContentSize(cc.size(oldcontent.width , self.bot_bg:getPositionY()))
        end 
        local oldcontent2 = self.bot_frame:getContentSize()
        self.bot_frame:setContentSize(cc.size(oldcontent2.width , self.bot_frame:getPositionY()-5))
    end 

end 


function UIHeroExpPanel:onEnter()


    gdisplay.loadSpriteFrames("hero.plist")


    global.unionApi:updateHeroSpring() 

    self:addEventListener(global.gameEvent.EV_ON_UNION_HEREXPUPDATE ,function (e, station)
        if station and station ==  1 then 
        else 
            self:setData(global.unionData:getMySpingData())
        end 
    end) 
    
    self:setData(global.unionData:getMySpingData())


    self.ScrollView:setContentSize(cc.size(720 , gdisplay.height - 80))


    local nodeTimeLine =resMgr:createTimeline("hero_exp/hero_exp_bg")
    self.root:runAction(nodeTimeLine)
    nodeTimeLine:play("animation0",true)
    
    self.chooseFlag  = false 
end

local space = 10
local recordNumber= 15



function UIHeroExpPanel:isSHowMyHero()

    return self.chooseFlag or global.unionData:getMyMainExpHero() ~= nil
end 

function UIHeroExpPanel:setData(msg)

    dump(msg ,"msg ///")

    self.tableView:setData({})
    self.tableView2:setData({})
    self.tableView3:setData({})

    local lessExpHero = global.unionData:getMylessExpHero()
    local mainHero = global.unionData:getMyMainExpHero()
    local myspring = global.unionData:getMySpingData()
    local my_other_hero_spring  =global.unionData:getMyInOtherSpringData()

    if not mainHero then lessExpHero =nil end --主英雄池没有东西时  副英雄也不显示

    self.chooseFlag =self.chooseFlag and (not mainHero)

    -- choose 
    self.my_choose:setVisible(not self:isSHowMyHero())
    self.other_choose:setVisible(not mainHero)

    --tips 
    self.my_tips:setVisible(not self:isSHowMyHero())
    self.other_tips:setVisible(lessExpHero == nil )

    -- time
    self.my_time:setVisible(mainHero ~=nil)
    self.other_time:setVisible(lessExpHero ~= nil )

    -- hero
    self.my_hero:setVisible(self:isSHowMyHero())
    self.other_hero:setVisible(lessExpHero ~= nil)
    self.my_hero:setEnabled(true)
    self.other_hero:setEnabled(true)
    self.my_other_hero:setEnabled(true)

    -- start 
    self.my_start:setVisible(self.chooseFlag)
    self.my_other_start:setVisible(false)

    -- exp 
    self.my_exp_node:setVisible(mainHero ~=nil)
    self.other_exp_node:setVisible(lessExpHero ~=nil)

    --exp item 
    self.my_add_exp:removeAllChildren()
    self.my_ather_add_exp:removeAllChildren()
    self.ather_add_exp:removeAllChildren()


     -- get btn 
     self.get_my:setVisible(false)
     self.get_my_other:setVisible(false)



    if myspring ~=nil then 

        self.my_hero:setEnabled(false)

        if lessExpHero then 
            self.other_hero:setEnabled(false)
            self.other_hero.exit_bt:setVisible(false)
            self.other_hero:setData(lessExpHero.lHeroID)
            self.other_hero:setSpringHero(lessExpHero)
            self.other_hero.start:setData(lessExpHero.lHeroID ,tonumber(lessExpHero.szParams))
        end

        if mainHero then 
            self.my_hero:setData(mainHero.lHeroID)
            self.my_hero:setExitCall(function () 
                local panel = global.panelMgr:openPanel("UIPromptPanel")
                panel:setData("endExp", function()
                    self:get_my_click()
                end)
            end)
            self.my_hero:setSpringHero(mainHero)
            self.my_hero.start:setData(mainHero.lHeroID ,tonumber(mainHero.szParams))
        end 

        self.other_choose:setVisible(not self.other_hero:isVisible())
        self.my_time:setData(msg.lEndTime)
        self.other_time:setData(msg.lEndTime)
    end

    --have hero on other 
    local my_other_hero_data = global.unionData:getMyInOtherHeroData()
    self.my_other_exp_node:setVisible(my_other_hero_data ~= nil )
    self.my_other_hero:setVisible(my_other_hero_data ~= nil )
    self.my_other_time:setVisible(my_other_hero_data ~= nil )
     self.my_other_hlpe_name:setVisible(my_other_hero_spring ~=nil )

    self.my_other_choose:setVisible(not my_other_hero_data)
    self.my_other_tips:setVisible(not my_other_hero_data)

    if my_other_hero_data then 

        dump(my_other_hero_spring ,"my_other_hero_spring->>>>>>")

        self.my_other_hero:setEnabled(false)
        self.my_other_hero:setData(my_other_hero_data.lHeroID)
        self.my_other_hero:setSpringHero(my_other_hero_data)
        self.my_other_hero.start:setData(my_other_hero_data.lHeroID ,tonumber(my_other_hero_data.szParams))
        if my_other_hero_spring then 
            self.my_other_hlpe_name:setString(global.luaCfg:get_local_string(10999 , my_other_hero_spring.szName))
            self.my_other_time:setData(my_other_hero_spring.lEndTime)
        end 
      
        self.my_other_hero:setExitCall(function () 
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("endExp", function()
                self:get_my_other_click()
            end)
        end)
    end 

    global.netRpc:delHeartCall(self)
    self:cleanTimer()

    local updataTime =function ()

        self.my_add_exp:removeAllChildren()
        self.my_ather_add_exp:removeAllChildren()
        self.ather_add_exp:removeAllChildren()

        if my_other_hero_data then 
            local my_other_hero_spring  =global.unionData:getMyInOtherSpringData()
            if my_other_hero_spring then 
                self.get_my_other:setVisible( my_other_hero_spring.lEndTime < global.dataMgr:getServerTime())
                self.my_other_time:setVisible(my_other_hero_spring.lEndTime > global.dataMgr:getServerTime())
            end 
        end 

        if myspring then

            if mainHero then 
                self.get_my:setVisible(msg.lEndTime < global.dataMgr:getServerTime())
                self.my_time:setVisible(msg.lEndTime > global.dataMgr:getServerTime())               

                self.end_bt:setVisible(not self.get_my:isVisible())
            end 


            if lessExpHero then 
                self.other_time:setVisible(msg.lEndTime > global.dataMgr:getServerTime())            
            end 
        end  


        if self.costCall then       
            self.costCall()
        end     
    end

    updataTime()
    global.netRpc:addHeartCall(function() updataTime() end ,self)

    local call1 = function (animation) 
        if myspring then
            if mainHero then 
                self:setExpItemBySping( msg ,mainHero.lHeroID ,8 , self.tableView , animation ,0)
                self:setExp2(msg  , mainHero  ,self.tableView ,self.my_exp)
            end 
        end 
    end 

    local call2 = function (animation) 
        if myspring then
            if lessExpHero then 
                self:setExpItemBySping( msg ,lessExpHero.lHeroID , 5, self.tableView2 , animation , 1)
                self:setExp2(msg  , lessExpHero  ,self.tableView2,self.other_exp)
            end 
        end 
    end 

    local call3 = function (animation) 
        if my_other_hero_data then 
            self:setExpItemBySping( my_other_hero_spring ,my_other_hero_data.lHeroID , 8 , self.tableView3 , animation , 1)
            self:setExp2(my_other_hero_spring  , my_other_hero_data  ,self.tableView3  , self.my_other_exp)
        end 
    end

    call1(-1)
    call2(-1)
    call3(-1)

    self:startCall(myspring , mainHero , call1  , 1)
    self:startCall(myspring , lessExpHero , call2  , 2)
    self:startCall(my_other_hero_spring , my_other_hero_data , call3  , 3)
end


function UIHeroExpPanel:startCall(spring , heroData  , call  , id)

    if not spring or not heroData then return end 

    self["delay"..id] = global.delayCallFunc(function()
        -- if table.hasval(self.tiemrTable  , id ) then return end 
        self["timer"..id] = gscheduler.scheduleGlobal(call ,space)  -- 每  5 秒钟 检测一下tips 
        -- table.insert(self.tiemrTable , id)
        call()
    end, 0 ,self:getNextTime(spring , heroData))
end 


function UIHeroExpPanel:getNextTime(spring , heroData)

    local nextTime = 0 

    if global.dataMgr:getServerTime() < spring.lEndTime  then 

        nextTime =  global.dataMgr:getServerTime() - heroData.lAddTime
    else

        nextTime =  spring.lEndTime - heroData.lAddTime
    end

    return space - nextTime % space + 1 
end 

function UIHeroExpPanel:cleanTimer()

   if self.timer1 then
        gscheduler.unscheduleGlobal(self.timer1)
        self.timer1 = nil
    end

   if self.timer2 then
        gscheduler.unscheduleGlobal(self.timer2)
        self.timer2 = nil
    end

   if self.timer3 then
        gscheduler.unscheduleGlobal(self.timer3)
        self.timer3 = nil
    end

    self.tiemrTable ={}

    for i =1 , 3 do 
        if self["delay"..i] then 
            global.stopDelayCallFunc(self["delay"..i])
            self["delay"..i]= nil
        end 
    end 
end 


function UIHeroExpPanel:setExp(spring ,heroId ,node , sit)

    local past_time =  0 

    if not spring or not heroId then return end 

    local heroData = nil 
    for _ ,v in ipairs(spring.tagHelps) do 
        if v.lHeroID   == heroId  and  v.lSit==sit then 
            heroData = v 
        end 
    end

    if global.dataMgr:getServerTime() < spring.lEndTime  then 

        past_time =  global.dataMgr:getServerTime() - heroData.lAddTime
    else

        past_time =  spring.lEndTime - heroData.lAddTime
    end 

    local speed = (heroData.lSpeed / 60  / 60)
    
    node:setString(math.floor( speed *  past_time))
end 

function UIHeroExpPanel:setExp2(spring ,heroData ,node , text)

    local tb = node:getData() or {} 
    local speed = (heroData.lSpeed / 60  / 60)
    local time  = 0 
    
    global.tools:adjustNodePosForFather(text:getParent() , text)

    if global.dataMgr:getServerTime() < spring.lEndTime then 

        -- if  (#tb < recordNumber) then 
        if true  then 
            local count = 0 
            for _ ,v in ipairs(tb) do 
                count = count + v.speed
            end 
            text:setString(count)

            return 
        else 
            time = global.dataMgr:getServerTime() - heroData.lAddTime

            local count = math.floor(time * speed)
            if count < 0 then 
                count = 0
            end  
            text:setString(count)
        end 
    else

        time= spring.lEndTime - heroData.lAddTime
        local count = math.floor(time * speed)
        if count < 0 then 
            count = 0
        end  
        text:setString( count)
    end 
end 


function UIHeroExpPanel:setExpItemBySping(spring ,heroId , count , node , effect ,sit)

    local Herospeed = 1 
    local past_time =  0 
    local tt =  0
    local start_time = 0 
    local one = false 

    if not spring or not heroId then return end 

    local heroData = nil 

    for _ ,v in ipairs(spring.tagHelps) do 
        if v.lHeroID   == heroId and  v.lSit==sit then 
            heroData = v 
        end 
    end

    if not heroData then return end 

    Herospeed = heroData.lSpeed

    if global.dataMgr:getServerTime() < spring.lEndTime  then 

        past_time =  global.dataMgr:getServerTime() - heroData.lAddTime
        start_time =  heroData.lAddTime
    else
        past_time = spring.lEndTime  - heroData.lAddTime
        start_time =  heroData.lAddTime
        one = true 
    end

    local t = math.floor(past_time / (space))

    local baseSpeed = math.floor( (heroData.lSpeed / 60  / 60) * space)

    local timeData = {} 

    --     --一开始添加一个
    -- table.insert(timeData,{time=start_time , speed = baseSpeed })

    for i =1 , t do
        local data = {time=start_time + space * i, speed = baseSpeed}
        table.insert(timeData , data)
    end 
    
    table.sort(timeData ,function(A ,B) return A.time > B.time end )

    -- local i = 1 
    -- for key ,v in ipairs(timeData) do 
    --     if i > recordNumber then 
    --         timeData[key] = nil 
    --     end 
    --     i = i + 1 
    -- end 
    table.sort(timeData ,function(A ,B) return A.time < B.time end )

    local tb = node:getData() or {} 

    local offset = node:getContentOffset()

    if one  then --过期的只设置一次
        node:setData(timeData)
        node:setContentOffset(cc.p(offset.x, 0))
    else

        node:setData(timeData)
        if effect ~=-1 then 
            self:cellAnimation(node)
        else
            node:setContentOffset(cc.p(offset.x, 0))
        end 
    end 
    -- node:setTouchEnabled(#timeData>count)
    node:setTouchEnabled(false)
end 


function UIHeroExpPanel:updateText(id , count)

    if not id or not count then  return end 

    print(tonumber(self.my_exp:getString()))
    print(tonumber(self.other_exp:getString()))
    print(tonumber(self.my_other_exp:getString()))

    if id == 1 then 
        self.my_exp:setString(tonumber(self.my_exp:getString()) + count)
    elseif id ==2 then 
        self.other_exp:setString( tonumber(self.other_exp:getString()) + count)
    elseif id ==3 then 
        self.my_other_exp:setString( tonumber(self.my_other_exp:getString()) + count)
    end 
end 

function UIHeroExpPanel:getHeroSspeed(heroData)

    print((heroData.lSpeed / 60  / 60) ,"(heroData.lSpeed / 60  / 60)")

    return (heroData.lSpeed / 60  / 60)
end 


function UIHeroExpPanel:getRecordData(spring ,heroData) --{time= , speed= ''}

    local key = "exp"..global.userData:getUserId()..spring.lAddTime..heroData.lUserID

    local str = cc.UserDefault:getInstance():getStringForKey(key)
    local available = {}

    if str and str~= "" then --已经解锁的 id
        local id_arr = global.tools:strSplit(str, '||')
        for key ,v in ipairs(id_arr or {} ) do 
            local st = global.tools:strSplit(v, '|')
            table.insert(available , {time =st[1] , speed = st[2] })
        end 
    end

    return  available
end

function UIHeroExpPanel:excute(spring , heroData , timeData)

    -- 复制时间 
    local data = self:getRecordData(spring,heroData)


    -- dump(data ,"fu pan data")

    for key ,v in ipairs(timeData) do 
        for _ ,vv in ipairs(data) do 
            if tonumber(v.time) == tonumber(vv.time) then 
                v.speed = tonumber(vv.speed)
            end 
        end 
    end

    -- dump(timeData ,"fu pan data")

    self:cleanLocalData(spring ,timeData ,heroData)

    local  getLastSpeed = function (key) 
        for _ ,v in ipairs(timeData) do 
            if  (v.key+1) == key then 
                return v
            end 
        end 
    end 

    local two = math.ceil(self:getHeroSspeed(heroData) * space *  2 )
    print(two ,"two///")

    for _ ,v in ipairs(timeData) do 

        if v.speed == -1 then

            if v.ood == true then  -- 偶数位 
               local last = getLastSpeed(v.key)
               if last then 
                    v.speed = two - last.speed
                else
                    v.speed = two
                end 
            else
                local r = (math.random(1,80)) / 100
                v.speed = math.ceil(two * r)
            end
            assert( v.speed <= two,"模拟数据异常")
            self:setRecordData(spring , v ,heroData)
        end         
    end 
end 


function UIHeroExpPanel:cleanLocalData(spring , timeData ,heroData)

    local key = "exp"..global.userData:getUserId()..spring.lAddTime..heroData.lUserID

    local data = self:getRecordData(spring , heroData)

    local i = 1 
    for key ,v in ipairs(data) do
        local flg = false
        for _ ,vv in ipairs(timeData) do 
            if tonumber(vv.time) == tonumber(v.time) then 
                flg = true 
            end 
        end 
        if  not flg then 
            data[key] = nil 
        end 
    end 

    local str  = ""

    -- dump(data ,"清理 Ａ//")

    for _ , v in ipairs(data) do 
        local ts  = "" 
        ts = v.time.."|"..v.speed
        if str == "" then
            str = ts 
        else
            str = ts..'||'..str 
        end 
    end 

    cc.UserDefault:getInstance():setStringForKey(key , str)
end

function UIHeroExpPanel:setRecordData(spring ,timeData ,heroData)

    -- dump(timeData ,"timeData-->>")

    local key = "exp"..global.userData:getUserId()..spring.lAddTime..heroData.lUserID

    local data = self:getRecordData(spring,heroData)

    -- dump(data ,"data ->>>>")

    local temp  = {time =timeData.time ,speed = timeData.speed}
    
    table.insert(data, temp) 

    table.sort(data, function (A ,B) return tonumber(A.time) < tonumber(B.time) end )

    -- local i = 1 
    -- for k ,v in ipairs(data) do
    --     if i > recordNumber then 
    --         data[k] = nil 
    --     end 
    --     i = i + 1 
    -- end 

    local str  = ""
    for _ , v in ipairs(data) do 
        local ts  = "" 
        ts = v.time.."|"..v.speed
        if str == "" then
            str = ts 
        else
            str = ts..'||'..str 
        end 
    end 

    cc.UserDefault:getInstance():setStringForKey(key , str)
end

-- 记录滚动动画
function UIHeroExpPanel:cellAnimation(node)
    local offset = node:getContentOffset()
    node:setContentOffset(cc.p(offset.x,-node.__cellSize.height))
    node:setContentOffsetInDuration(cc.p(offset.x, 0), 0.2)
end

function UIHeroExpPanel:getChooseHero()

    return self.current_choose_hero or global.heroData:getGotHeroData()[1]
end 


function UIHeroExpPanel:setChooseHero(hero)
    self.current_choose_hero = hero
end 

function UIHeroExpPanel:onExit()
    self:cleanTimer()
    global.netRpc:delHeartCall(self)
end 

function UIHeroExpPanel:info_btn(sender, eventType)
    local data =global.luaCfg:get_introduction_by(33)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIHeroExpPanel:getRewardHandler(sender, eventType)

end

function UIHeroExpPanel:my_star_click(sender, eventType)
        
    local chooseHero = self.my_hero:getChooseHero()
    self:star(chooseHero)
end

function UIHeroExpPanel:my_other_star_click(sender, eventType)

    self:star(self.my_other_hero:getChooseHero())
end

function UIHeroExpPanel:getExp(spring  , heroData)

    if not heroData or not spring then return 0 end 

    local speed = (heroData.lSpeed / 60  / 60)
    local time  = 0 
    local count = 0 

    if global.dataMgr:getServerTime() < spring.lEndTime then 
        time = global.dataMgr:getServerTime() - heroData.lAddTime
        count = math.floor(time * speed)
        if count < 0 then 
            count = 0
        end  
    else
        time= spring.lEndTime - heroData.lAddTime
        count = math.floor(time * speed)
        if count < 0 then 
            count = 0
        end  
    end 

    return count
end  


function UIHeroExpPanel:get_my_other_click(sender, eventType)

    local spring = clone(global.unionData:getMyInOtherSpringData())

    if not spring then return end 

    local my_other_hero_data = clone(global.unionData:getMyInOtherHeroData())

    global.unionApi:heroSpring(function ()

        if spring then 

            local exp  = self:getExp(spring  , my_other_hero_data)

            self.my_other_exp:setString(exp)

            global.tipsMgr:showWarning("getExpSuccess" ,exp)

        end
    end ,3 , self.my_other_hero:getChooseHero().heroId , spring.lID  , nil , nil  , 1 )

end


function UIHeroExpPanel:get_my_click(sender, eventType , get_type)
    
    local spring =clone( global.unionData:getMySpingData())
    local mainHero =clone( global.unionData:getMyMainExpHero())


    global.unionApi:heroSpring(function () 

        if get_type and get_type == 5 then 

            local speed = (mainHero.lSpeed / 60  / 60)

            local exp = math.floor((spring.lEndTime - spring.lAddTime ) * speed)

            global.tipsMgr:showWarning("getExpSuccess" , exp)

        else 
            if spring then 

                local exp  = self:getExp(spring  , mainHero)

                self.my_exp:setString(exp)

                global.tipsMgr:showWarning("getExpSuccess" , exp)

            end
        end 
        
    end ,get_type or 3 , self.my_hero:getChooseHero().heroId , spring.lID  , nil , nil  , 1 )

end

function UIHeroExpPanel:star(data)

    if not data then return end 
    local panel = global.panelMgr:openPanel("UISpeedPanel")   --行军加速道具使用
    panel:setData(nil,nil,panel.TYPE_HERO_EXP_BATCH, data.heroId)

end 


function UIHeroExpPanel:endClick(sender, eventType)

    local panel = global.panelMgr:openPanel("UIPromptPanel")

    call= function (time) 

       local tips =string.format( gls(11090 ) ,global.funcGame.getDiamondCount(time) )

        panel:setData(tips, function()
                
                self:get_my_click( nil , nil , 5)
        end)

    end 
    
    self.costCall =function () 
        local myspring = global.unionData:getMySpingData()
        if myspring and global.dataMgr:getServerTime() < myspring.lEndTime then 
            call(myspring.lEndTime-global.dataMgr:getServerTime())
        else 
            global.panelMgr:closePanel("UIPromptPanel")
            self.costCall = nil 
        end  
    end

    self.costCall()

    panel:setPanelonExitCallFun(function () 
        self.costCall = nil 
    end)
end
--CALLBACKS_FUNCS_END

return UIHeroExpPanel

--endregion
