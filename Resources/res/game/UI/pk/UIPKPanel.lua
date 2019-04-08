--region UIPKPanel.lua
--Author : zzl
--Date   : 2018/02/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPKHeroItem = require("game.UI.pk.UIPKHeroItem")
--REQUIRE_CLASS_END

local UIPKPanel  = class("UIPKPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local TabControl = require("game.UI.common.UITabControl")
local UIPKUserItemCell = require("game.UI.pk.UIPKUserItemCell")

function UIPKPanel:ctor()
    self:CreateUI()
end

function UIPKPanel:CreateUI()
    local root = resMgr:createWidget("player_kill/pk_main")
    self:initUI(root)
end

function UIPKPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/pk_main")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.item_content = self.root.item_content_export
    self.tb_cotent = self.root.tb_cotent_export
    self.title = self.root.title_export
    self.top_node = self.root.top_node_export
    self.save_bt = self.root.top_node_export.save_bt_export
    self.modify_bt = self.root.top_node_export.modify_bt_export
    self.defense_1 = self.root.top_node_export.defense_1_export
    self.defense_1 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.defense_1, self.root.top_node_export.defense_1_export)
    self.defense_2 = self.root.top_node_export.defense_2_export
    self.defense_2 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.defense_2, self.root.top_node_export.defense_2_export)
    self.defense_3 = self.root.top_node_export.defense_3_export
    self.defense_3 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.defense_3, self.root.top_node_export.defense_3_export)
    self.defenPowerIcon = self.root.top_node_export.defenPowerIcon_export
    self.defenPower = self.root.top_node_export.defenPowerIcon_export.defenPower_export
    self.black_top_1 = self.root.black_top_1_export
    self.black_top_0 = self.root.black_top_0_export
    self.black_bot_0 = self.root.black_bot_0_export
    self.black_bot_1 = self.root.black_bot_1_export
    self.tb_add = self.root.tb_add_export
    self.tb_top = self.root.tb_top_export
    self.tb_bot = self.root.tb_bot_export
    self.top_tab = self.root.top_tab_export
    self.bot_node = self.root.bot_node_export
    self.rank_bt = self.root.bot_node_export.rank_bt_export
    self.num = self.root.bot_node_export.rank_mlan_5.num_export
    self.line = self.root.bot_node_export.rank_mlan_5.line_export
    self.remaining_times = self.root.bot_node_export.day_times_mlan_8.remaining_times_export
    self.max_times = self.root.bot_node_export.day_times_mlan_8.max_times_export
    self.over_time = self.root.bot_node_export.over_time_export
    self.canvs = self.root.bot_node_export.over_time_export.canvs_mlan_4_export
    self.expBuy = self.root.bot_node_export.over_time_export.expBuy_export
    self.rank_reword_bt = self.root.bot_node_export.rank_reword_bt_export

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.save_bt, function(sender, eventType) self:saveCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.modify_bt, function(sender, eventType) self:modify_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rank_bt, function(sender, eventType) self:rank_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.bot_node_export.record_bt_xport, function(sender, eventType) self:record_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.bot_node_export.record_bt, function(sender, eventType) self:refresh_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.expBuy, function(sender, eventType) self:cleanCdClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rank_reword_bt, function(sender, eventType) self:rank_rewrord_click(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType)  
        global.panelMgr:closePanel("UIPKPanel")
    end)

    self.tableView = UITableView.new()
        :setSize(self.tb_cotent:getContentSize(), self.tb_top , self.tb_bot)
        :setCellSize(self.item_content:getContentSize())
        :setCellTemplate(UIPKUserItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_add:addChild(self.tableView)

    self.tabControl = TabControl.new(self.top_tab, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    local height = self.tb_top:getPositionY() - self.tb_bot:getPositionY() / 2 
    for _ ,v in pairs({self.black_top_1 , self.black_top_0}) do 
        local old = v:getContentSize()
        v:setContentSize(cc.size(old.width, height))
    end 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


local defence_key =  tostring(global.userData:getUserId()).."defenseHero"


function UIPKPanel:onEnter()


    local loading_TimeLine = resMgr:createTimeline("player_kill/pk_main")  
    loading_TimeLine:play("animation0", true)
    self.root:runAction(loading_TimeLine)

    gdisplay.loadSpriteFrames("hero.plist")

    -- self.bot_node:setVisible(false)

    self:onTabButtonChanged(1)

    self.tabControl:setSelectedIdx(1)

    self:setDefenseHero()

    self.save_bt:setVisible(false)
    self.modify_bt:setVisible(true)

    self.max_times:setVisible(false)


    self.line:setVisible(false)


    self:registerMove()

    self:addEventListener(global.gameEvent.EV_ON_DAILY_REGISTER,function()
        if self.mydata then 
            self.mydata.lCount =global.luaCfg:get_hero_arena_by(1).para
            self:updateSelfInfo(self.mydata)
        end 
    end)

    self.tableView:setData({})

    self.m_eventListenerCustomList = {}
end 

function UIPKPanel:setData()

end 

function UIPKPanel:onExit()

    gdisplay.removeSpriteFrames("hero.plist", string.gsub("hero.plist",".plist",".png"))

    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end

    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")


    global.netRpc:delHeartCall(self)

end 

function UIPKPanel:onTabButtonChanged(index ,call , nocAnimation , noupdateTable)

    global.commonApi:getPKList(index, function(msg)

        -- dump(msg ,"msg-->>")

        if tolua.isnull(self) then return end 

        if call and type(call)=="function" then 
            call()
        end 

        table.sort(msg.tagInfo or {} , function (A ,B) return A.lRank < B.lRank end )

        if not noupdateTable then 
            self.tableView:setData(msg.tagInfo or {} )
        end 

        self:updateSelfInfo(msg.tagArenaInfo  or {} )

        if not  nocAnimation then 
            self:cellAnimation()
        end 

        -- 下载用户头像
        if msg.tagInfo then
            local data = {}
            for i,v in pairs(msg.tagInfo) do
                if v.szCustomIco ~= "" then
                    table.insert(data,v.szCustomIco)
                end
            end
            local storagePath = global.headData:downloadPngzips(data)
            local tempData = msg.tagInfo
            table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
                -- body
                if self and not tolua.isnull(self.tableView) then
                    self.tableView:setData(self.tableView:getData(),true)
                end
            end))
        end
    end)
end 

-- message ArenaInfo
-- {
--     required uint32 lLastTime = 1;  //最近一次挑战时间
--     required int32  lCount = 2;     //剩余挑战次数
--     required int32  lRank = 3;      //当前排名
--     optional PKGroup    tagPKGroup = 4;
-- }
  -- tagPKGroup = {
  --           lHeroID = {
  --               [1] = 5,
  --               [2] = 18,
  --               [3] = 31,
  --           },
  --           lPower = 3732,
  --       }

local CDTime = global.luaCfg:get_hero_arena_by(2).para
local cost = global.luaCfg:get_hero_arena_by(3).para


function UIPKPanel:updateOverTime()

    if self.over_time and not tolua.isnull(self.over_time) and self.lLastTime and self.mydata and  self.mydata.lCount > 0  then 

        local iscd , time = self:isCd()
        self.over_time:setVisible(iscd )
        self.over_time:setString(global.funcGame.formatTimeToHMS(time or 0))

    else
        self.over_time:setVisible(false)
    end  

    if self.costCall then       
        self.costCall()
    end   

end 


function UIPKPanel:getVIPCount(leavel , effectid)

    local vipData  = global.luaCfg:get_vip_func_by(leavel)
    effectid = effectid or 0

    if vipData then 
        for _ ,v in ipairs(vipData.buffID) do 
            if v[1] and v[1]  == effectid then 
                return v[2]
            end 
        end 
    else 
        global.tipsMgr:showWarning("erroce 248 ")
    end 

    return   0 
end 

function UIPKPanel:updateSelfInfo(data)

    if not data then return end 
    data.lCount = data.lCount or 0

    self.mydata = data 


    self.num:setString(data.lRank)

    -- vip 处理
    local count = 0 
    if global.vipBuffEffectData:isVipEffective() then 
        count = self:getVIPCount(global.vipBuffEffectData:getVipLevel(), 3208)
        data.lCount = data.lCount + count
    end 

    if data.lCount < 0 then 
        data.lCount = 0 
    end 

    self.remaining_times:setString(data.lCount)

    global.pkdata = data 

    global.userData:setPkCount(data.lCount or 0 )

    data.tagPKGroup =data.tagPKGroup or {} 

    self.defenPower:setString(data.tagPKGroup.lPower)

    self.lLastTime = data.lLastTime

    global.netRpc:delHeartCall(self)

    self.over_time:setVisible(false)

    local call = function () 
        if self.updateOverTime then 
            self:updateOverTime()   
        end 
    end 

    call()

    global.tools:adjustNodePosForFather(self.num:getParent() , self.num)
    global.tools:adjustNodePosForFather(self.line:getParent() , self.line)
    global.tools:adjustNodePosForFather(self.remaining_times:getParent() , self.remaining_times)

    global.tools:adjustNodePosForFather(self.over_time , self.canvs)
    global.tools:adjustNodePos(self.canvs, self.expBuy)

    global.netRpc:addHeartCall(call,  self)

    local arr ={} 
    for _ ,v in pairs( data.tagPKGroup.tagHero or {} ) do 
        table.insert(arr , v.lID)
    end 

    self:savedef(arr ,defence_key)

    if  not  self.save_bt:isVisible() then --编辑中 

        self:setDefenseHero()

    end 

    self.line:setVisible(not (data.tagPKGroup and data.tagPKGroup.tagHero))
    self.num:setVisible(not self.line:isVisible())

end 

function UIPKPanel:isCd()

    if not self.lLastTime or self.lLastTime==0 or self.lLastTime+ CDTime - global.dataMgr:getServerTime() <=0  then 

        return false 
    end 

    return true , self.lLastTime+ CDTime - global.dataMgr:getServerTime()
end 

function UIPKPanel:rank_click(sender, eventType)
        
    global.panelMgr:openPanel("UIRankInfoPanel"):setData(global.luaCfg:get_rank_by(13))

end

function UIPKPanel:record_click(sender, eventType)

    global.panelMgr:openPanel("UIPKRecordPanel")
end

function UIPKPanel:refresh_click(sender, eventType)

    self:onTabButtonChanged(self.tabControl:getSelectedIdx() or 1 ,function () 

        -- global.tipsMgr:showWarning("pkshuaxin")
    end )
    
end

function UIPKPanel:infoCall(sender, eventType)
    
    local data = global.luaCfg:get_introduction_by(43)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)

end


----------------  滑动监听 --------------------------

function UIPKPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
local beganPos = cc.p(0,0)
local isMoved = false
function UIPKPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    -- if CCHgame.setNoTouchMove then
    --     CCHgame:setNoTouchMove(self.ScrollHero, true)
    -- end
    return true
end
function UIPKPanel:onTouchMoved(touch, event)

    isMoved = true
    if self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        -- CCHgame:setNoTouchMove(self.ScrollHero, false)
    else
        -- CCHgame:setNoTouchMove(self.ScrollHero, true)
    end
end

function UIPKPanel:onTouchEnded(touch, event)

    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isMove = true 
    else
        self.isMove = false
    end
end

function UIPKPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

----------------  滑动监听 --------------------------




function UIPKPanel:setDefenseHero()

    local key = defence_key

    local st =  cc.UserDefault:getInstance():getStringForKey(key)
    local data = {} 

    if st and  st ~="" then

        for _ ,v in pairs(global.tools:strSplit(st ,"|") or {}) do 

            table.insert(data , global.heroData:getHeroDataById(tonumber(v)))
        end 
    else

        table.insert(data ,{})
        table.insert(data ,{})
        table.insert(data ,{})
    end 

    for i= 1, 3 do 
        local item = self["defense_"..i]

        item:setData(data[i])

        if not data[i].heroId then 

            item.default:setVisible(true)
        else

            item.default:setVisible(false)

            item.bt_bg:setTouchEnabled(false)
        end 
    end 
end 

function UIPKPanel:savedef(arr , key)

    local str = ""
    for _ ,v in ipairs(arr) do 
        if str =="" then 
            str = tostring(v)
        else 
            str= str.."|"..tostring(v)
        end 
    end 
    cc.UserDefault:getInstance():setStringForKey( key, str)
end 

function UIPKPanel:saveCall(sender, eventType)
    
    local index = 0
    for i=1,3 do
        local item = self["defense_"..i]
        if item.data and (item.data.heroId) then
            index = index + 1
        end
    end
    if index < 3 then
        return global.tipsMgr:showWarning("pk01")
    end


    local id_arr = {}
    for i= 1, 3 do 
        local item = self["defense_"..i]
        item.canchange:setVisible(false)
        if item.data.heroId then 
            table.insert(id_arr , item.data.heroId)
        end 
    end

    self.save_bt:setVisible(false)
    self.modify_bt:setVisible(true)

    self:savedef(id_arr , defence_key)

    global.commonApi:buildPKGroup(1 , id_arr , function () 

        self:onTabButtonChanged(self.tabControl:getSelectedIdx() or 1  , function () 
                global.tipsMgr:showWarning("pk02")
        end , true , true)
    end)

    self:setDefenseHero()
end


-- cell 出现动画
function UIPKPanel:cellAnimation()

    global.uiMgr:addSceneModel(0.1)
 
    local allCell = self.tableView:getCells()
    table.sort( allCell, function(a,b)
        -- bod
        return a:getPositionY()>b:getPositionY()
    end )
    local speed = 5000
    for i = 1, #allCell do
        local target = allCell[i]
        if target:getIdx() >= 0 then

            local overCall = function ()
                gsound.stopEffect("city_click")
                gevent:call(gsound.EV_ON_PLAYSOUND,"ui_list")
            end

            local opacity = 0
            local dt = 0.1*i
            local dy = -dt*speed
            if dy >= -gdisplay.height then
                dy = -gdisplay.height
            end
            local dp = cc.p(0,dy)
            local speedType = nil
            if i >= #allCell then
                global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
            else
                global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
            end
        end
    end
end


--     "lCount"     = 6
-- [LUA-print] -         "lLastTime"  = 1517921657
-- [LUA-print] -         "lRank"      = 5
-- [LUA-print] -         "tagPKGroup" = {
-- [LUA-print] -             "lPower"  = 12701
-- [LUA-print] -             "tagHero" = {

function UIPKPanel:reFreshData(msg) -- 如果成功则 刷新列表， 如果失败 则 更新一下 cd  和次数 

    if msg.tagRecord and msg.tagRecord.lResult[1] == 1  and self.mydata then  --赢了

        -- self.mydata.lCount = self.mydata.lCount - 1 

        -- if self.mydata.lCount < 0 then self.mydata.lCount =0  end 

        -- self.mydata.lLastTime = global.dataMgr:getServerTime()

        -- self:updateSelfInfo(self.mydata)

        self:onTabButtonChanged(self.tabControl:getSelectedIdx() or 1  , true , true )

    else 
        self:onTabButtonChanged(self.tabControl:getSelectedIdx() or 1  , true , true , true)
    end 
end 

function UIPKPanel:modify_click(sender, eventType)

    self.modify_bt:setVisible(false)
    self.save_bt:setVisible(true)

    local getDefArr = function () 
        local data = global.heroData:getGotHeroData()
        return data
    end 

    for i= 1, 3 do 

        local item = self["defense_"..i]
        -- table.insert(data , item.data)
        item:setData(item.data or {})
        item.bt_bg:setTag(i)
        item.default:setVisible(false)
        item.canchange:setVisible(true)

        local call = function(sender, eventType)

            local curItem = item
            local panel = global.panelMgr:openPanel("UISelectHeroPanel")

            local curSelectHero = nil
            if curItem.data and curItem.data.heroId then curSelectHero = curItem.data.heroId end
            panel:setData(nil, curSelectHero ,nil ,getDefArr())
            panel:setTarget(curItem)
            panel:setExitCall(function()
                if curItem.data.heroId then 
                    self:checkDefenseHero(curItem.data.heroId, curItem.bt_bg:getTag())
                end 
            end)
        end

        item.choose_hero:setData(nil ,nil ,call)
        uiMgr:addWidgetTouchHandler(item.bt_bg, call)
    end 
end

function UIPKPanel:checkDefenseHero(curHeroId, id)
    for i=1,3 do 
        local item = self["defense_"..i]
        if item.data and item.data.heroId and item.data.heroId == curHeroId and item.bt_bg:getTag() ~= id then 
            item:setData({})
        end 
    end 
end

function UIPKPanel:cleanCdClick(sender, eventType)

    local iscd , time = self:isCd()

    if not global.propData:checkDiamondEnough(cost) then 
        global.panelMgr:openPanel("UIRechargePanel")
        return 
    end 

    local panel = global.panelMgr:openPanel("UIPromptPanel")

    call= function (cost) 
        panel:setData("pk03", function()

            global.itemApi:diamondUse(function(msg)

                self.lLastTime = 0 
                self.costCall = nil

                if self.updateOverTime then 
                    self:updateOverTime() 
                end 

            end , 15)

        end ,cost)
    end 
    
    self.costCall =function () 

        local iscd , time = self:isCd()

        if iscd then 
            call(cost)
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

function UIPKPanel:rank_rewrord_click(sender, eventType)
    
    global.panelMgr:openPanel("UIPKRewordPanel")

end
--CALLBACKS_FUNCS_END

return UIPKPanel

--endregion
