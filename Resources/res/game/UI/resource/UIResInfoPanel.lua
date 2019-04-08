--region UIResInfoPanel.lua
--Author : yyt
--Date   : 2016/11/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local resData = global.resData
local luaCfg = global.luaCfg
local TabControl = require("game.UI.common.UITabControl")
local UILoadBarItem = require("game.UI.resource.UILoadBarItem")
local UICityListNode = require("game.UI.resource.UICityListNode")
local UIBuildListNode = require("game.UI.resource.UIBuildListNode")
local UIWideListNode = require("game.UI.resource.UIWideListNode")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIResInfoPanel  = class("UIResInfoPanel", function() return gdisplay.newWidget() end )

function UIResInfoPanel:ctor()
    self:CreateUI()
end

function UIResInfoPanel:CreateUI()
    local root = resMgr:createWidget("resource/res_info")
    self:initUI(root)
end

function UIResInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top = self.root.top_export
    self.res_icon = self.root.res_info_top_bg.res_icon_export
    self.num_change = self.root.res_info_top_bg.num_change_export
    self.base_node = self.root.res_info_top_bg.base_node_export
    self.buff_num = self.root.res_info_top_bg.base_node_export.Node_1.buff_num_export
    self.base_num1 = self.root.res_info_top_bg.base_node_export.Node_2.base_num1_mlan_10_export
    self.base_num = self.root.res_info_top_bg.base_node_export.Node_2.base_num_export
    self.food_cost_node = self.root.res_info_top_bg.food_cost_node_export
    self.Node_1 = self.root.res_info_top_bg.food_cost_node_export.Node_1_export
    self.res_cost = self.root.res_info_top_bg.food_cost_node_export.Node_1_export.res_cost_export
    self.Node_2 = self.root.res_info_top_bg.food_cost_node_export.Node_2_export
    self.soldier_cost = self.root.res_info_top_bg.food_cost_node_export.Node_2_export.soldier_cost_mlan_25_export
    self.resBotBg = self.root.resBotBg_export
    self.res_buff = self.root.res_buff_mlan_16_export
    self.loadBarLayout = self.root.loadBarLayout_export
    self.middleLayout = self.root.middleLayout_export
    self.res_wild_node = self.root.res_wild_node_export
    self.wild_num = self.root.res_wild_node_export.wild_num_mlan_12_export
    self.now_num = self.root.res_wild_node_export.now_num_export
    self.max_num = self.root.res_wild_node_export.max_num_export
    self.bottom_tb = self.root.bottom_tb_export
    self.itemLayout = self.root.itemLayout_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.topLayout = self.root.topLayout_export
    self.textLayout = self.root.textLayout_export

--EXPORT_NODE_END
    self.txt_wild_num = self.wild_num
    uiMgr:addWidgetTouchHandler(self.top.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.tabControl = TabControl.new(self.bottom_tb, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.resBuffPosY = self.res_buff:getPositionY()

    self.posY = self.Node_2:getPositionY()

    self.resBotBg:setPositionY(self.resBotBg:getPositionY()+gdisplay.height-1280)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIResInfoPanel:registerMove()

    local touchNode = cc.Node:create()
    self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end

function UIResInfoPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

local beganPos = cc.p(0,0)
local isMoved = false
function UIResInfoPanel:onTouchBegan(touch, event)
    isMoved = false
    beganPos = touch:getLocation()
    return true
end
function UIResInfoPanel:onTouchMoved(touch, event)
    isMoved = true
end

-- 手势误差处理
local ALLOW_MOVE_ERROR = 7.0/160.0
function UIResInfoPanel:onTouchEnded(touch, event)
    if isMoved and self:convertDistanceFromPointToInch(cc.pGetDistance(beganPos, touch:getLocation())) > ALLOW_MOVE_ERROR then
        self.isPageMove = true
        return
    end
end

function UIResInfoPanel:convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local  factor = (glview:getScaleX() + glview:getScaleY()) / 2
    return pointDis * factor / cc.Device:getDPI()
end

function UIResInfoPanel:onEnter()

    self.isPageMove = false
    self:registerMove()

    self:addEventListener(global.gameEvent.EV_ON_UI_CITY_FEATURE, function()
     
        local hourStr = global.luaCfg:get_local_string(10076)
        self.buff_num:setString(resData:getTotalResAdd(self.curResId)..hourStr)
        self:checkResSpeed(resData:getResSpeedHour(self.curResId))
        self:initNode1()
        self:checkConsump()

    end)

    self:addEventListener(global.gameEvent.EV_ON_RES_WIDELIST, function()
        self:setData(resData:getResById(self.curResId))
    end)


    self:addEventListener(global.gameEvent.EV_ON_RESWAREHOUSE, function(event, addVal)
        self:checkSoldierConsump(addVal)
    end)


     self:addEventListener(global.gameEvent.EV_ON_LORDE_EQUIP_BUFF_UPDATE,function()
        self:checkConsump()
    end)

end

function UIResInfoPanel:setData(data)

    self.data = data
    self.allAdd = {}
    self.curResId = data.resId
    self:checkResSpeed(resData:getResSpeedHour(data.resId))
    local resTypeData = resData:getResTypeById(data.resId)
    self.res_icon:setSpriteFrame(resTypeData.resIcon)

    local hourStr = global.luaCfg:get_local_string(10076)
    self:checkConsump()
    self.base_num:setString(global.funcGame:_formatBigNumber(data.baseRes , 1 )..hourStr)

    self:initResAdd()
    self.tabControl:setSelectedIdx(1)
    self:onTabButtonChanged(1)

    
    self.buff_num:setString(global.funcGame:_formatBigNumber(data.totalAdd , 1 )..hourStr)

    -- 获取资源建筑buff
    self:initResBuff()

    --英文版本自适应 张亮
    -- global.tools:adjustNodePos(self.base_num1,self.base_num,20)
end

function UIResInfoPanel:initResBuff()

    local build = {}
    local resTemp = {}
    local buildTypeId = resData:getResTypeById(self.data.resId).buildResType
    local data =  resData:getBuildResByType(buildTypeId)
    for _,v in pairs(data) do
        local temp = {}
        temp.lType = luaCfg:get_buildings_pos_by(v.id).funcType
        temp.lBind = v.id
        table.insert(resTemp, temp)  
        table.insert(build, v) 
    end

    local dealCall = function (msg, buildData)
        
        if not buildData then return 0 end
        local infoId = global.cityData:getBuildingsInfoId(buildData.buildingType,buildData.serverData.lGrade)
        local infos = luaCfg:get_buildings_info_by(infoId)
        local proData = infos.data
        local paraNum = infos.para1Num

        local proId = proData[1]
        local pro = luaCfg:get_data_type_by(proId)
        local buffData = msg.tgEffect or {}
        local allAdd = 0

        for _,v in pairs(buffData) do

            if v.lTarget == msg.lBind or v.lTarget == 0  then 
                local buff_conf = luaCfg:get_data_type_by(v.lEffectID)           
                if buff_conf then
                    if buff_conf.typeId == pro.typeId then
                        if pro.extra == "%" and buff_conf.extra == "%" then                        
                            allAdd = math.floor(allAdd + v.lVal / buff_conf.magnification)                       
                        elseif pro.extra == "" and buff_conf.extra == "%" then                        
                            allAdd = math.floor(allAdd + paraNum * v.lVal / 100 / buff_conf.magnification)
                        elseif pro.extra == "" and buff_conf.extra == "" then
                            allAdd = math.floor(allAdd + v.lVal / buff_conf.magnification)
                        end
                    end            
                end
            end
        end
        allAdd = math.floor(allAdd)
        return allAdd
    end

    local getBuildData = function (id)
        for _,v in pairs(build) do
            if v.id == id then
                return v
            end
        end
        return nil
    end

    local allEff = {}
    global.gmApi:effectBuffer(resTemp, function(msg)

        msg.tgEffect = msg.tgEffect or {}
        for _,v in pairs(msg.tgEffect) do           
            local buildData = getBuildData(v.lBind)
            local allAdd = dealCall(v, buildData)
            local effAll = {}
            effAll.lBind = v.lBind
            effAll.add = allAdd
            table.insert(allEff, effAll)
        end
        self.allEff = allEff
        gevent:call(global.gameEvent.EV_ON_RES_BUILDLISTNODE, allEff)
    end)
end

function UIResInfoPanel:getInitResBuff(id)

    if not self.allEff then return nil end
    for _,v in pairs(self.allEff) do
        if v.lBind == id then
            return v.add
        end
    end
    return  nil
end

function UIResInfoPanel:checkConsump()

    local hourStr = global.luaCfg:get_local_string(10076)
    self.food_cost_node:setVisible(false)
    if self.data.resId == 1 then
        self.food_cost_node:setVisible(true)
        
        local soldierCost =math.floor(resData:getFoodConsumpWithBuff())
        if soldierCost == 0 then
            self.res_cost:setString("0"..hourStr)
        else
            self.res_cost:setString("-" .. global.funcGame:_formatBigNumber(soldierCost , 1 )..hourStr)
        end
        -- 士兵可维持时间
        -- self:soldierConsump()
    end
end

function UIResInfoPanel:checkSoldierConsump(protect) -- 如果粮食低于 保护比 则显示不耗粮

    print(protect , "protect")
    local res  = global.resData:getRes()[1]
    print(res.curRes/res.maxRes,"res.curRes/res.maxRes")
    print( protect/100," protect/100")

    if  self.data.resId == 1 then 

        if   protect/100 < (res.curRes/res.maxRes) then 

              self.soldier_cost:setVisible(false)

        else 
            self.soldier_cost:setVisible(true)

        end 
    else
        self.soldier_cost:setVisible(false)
    end 
end 


function UIResInfoPanel:soldierConsump()
    
    local soldierCost = resData:getFoodConsumpWithBuff()
    if soldierCost == 0 then 

        self.Node_1:setPositionY(self.posY+35)
        self.Node_2:setVisible(false)
    else 
        self.Node_1:setPositionY(self.posY)
        self.Node_2:setVisible(true)
        local resAll = self.data.curRes
        local rest = math.floor(resAll/soldierCost)
        if rest <= 5 then
            self.soldierTime:setTextColor(cc.c3b(92, 12, 7))
        else
            self.soldierTime:setTextColor(cc.c3b(87, 213, 63))
        end

        if rest < 1 then
            str = luaCfg:get_local_string(10664)            
        else
            local dayNum = math.floor(rest/24)
            local hourN  = math.floor(rest-dayNum*24)
            str = luaCfg:get_local_string(10663, dayNum,  hourN)           
        end
        self.soldierTime:setString(str)
    end
end

-- 废弃掉了，之前是显示总资源加成的
function UIResInfoPanel:checkResSpeed(numSpeed)
    
    local hourStr = global.luaCfg:get_local_string(10076)
    local str = numSpeed..hourStr
    self.num_change:setColor(gdisplay.COLOR_BLACK) 
 
    if numSpeed > 0 then
        str = "+"..global.funcGame:_formatBigNumber(numSpeed , 1 )..hourStr
    elseif numSpeed < 0 then
        self.num_change:setColor(gdisplay.COLOR_RED)
    end
    self.num_change:setString(str)

end

function UIResInfoPanel:initResAdd()
    
    local data = resData:getResAdd() 
    self.middleLayout:removeAllChildren()
    local sW = self.loadBarLayout:getContentSize().width
    local sH = self.loadBarLayout:getContentSize().height

    self.res_buff:setPositionY(self.resBuffPosY+10)
    local x, y = self.res_buff:getPosition()
    local p = self.middleLayout:convertToNodeSpace(cc.p(x, y))
    local px = p.x - sW/2 - 5
    local py = p.y - sH - 3
    
    for i=1,#data do
        local item = UILoadBarItem.new()
        item:setPosition(cc.p(px + (sW+5)*((i-1)%2), py - (sH+2)*(math.floor((i-1)/2))))
        item:setAnchorPoint(cc.p(0, 0))
        item:setData(data[i], self.data.resId, self.data.baseRes)
        self.middleLayout:addChild(item)
    end
end

function UIResInfoPanel:initScroll(data, flag)
    
    self.ScrollView_1:removeAllChildren()
    
    local contentSize = 0
    if flag == 0 then
        contentSize = gdisplay.height -  self.topLayout:getContentSize().height 
        self.res_wild_node:setVisible(false)
    else
        contentSize = gdisplay.height -  self.topLayout:getContentSize().height - self.textLayout:getContentSize().height
        self.res_wild_node:setVisible(true)
    end
      
    local sH = self.itemLayout:getContentSize().height 
    local sW = self.itemLayout:getContentSize().width 
    local containerSize = sH*(#data)
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, contentSize))
    self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, containerSize))
    local pY = containerSize - sH/2

    return pY, sH
end

function UIResInfoPanel:initNode1()
    
    local buildTypeId = resData:getResTypeById(self.data.resId).buildResType
    local data =  resData:getBuildResByType(buildTypeId)
    local pY, sH = self:initScroll(data, 0)
    local i = 0
    for _,v in pairs(data) do
        local item = UIBuildListNode.new()
        item:setPosition(cc.p(gdisplay.width/2, pY - sH*i))
        item:setData(v)
        self.ScrollView_1:addChild(item)
        i = i + 1
    end
    self.ScrollView_1:jumpToTop()
end

-- 获取资源建筑buff
function UIResInfoPanel:setBuildResBuff(addValue, id, isSet)
    self.allAdd[id] = addValue
    self.allAdd.isSet = isSet
end
function UIResInfoPanel:getBuildResBuff(id)

    return self.allAdd[id] or 0, self.allAdd.isSet 
end

function UIResInfoPanel:initNode2()

    self.txt_wild_num:setString(global.luaCfg:get_local_string(10331))
    local nowNum, maxNum = 0, 0
    local occupyData = resData:getOccupyMaxInfo() 

    if occupyData and occupyData.tagResource then
        maxNum = occupyData.tagResource.lMaxOccupy
    end
    local worldWild = global.resData:getWorldWild()
    nowNum = table.nums(worldWild) 
    local vip_Resource = global.vipBuffEffectData:getCurrentVipLevelEffect(3078).quantity or 0 
    
    self.now_num:setString(nowNum)
    self.max_num:setString(maxNum+vip_Resource)
    -- local data = resData:getWildResByType(self.data.resId)
    -- self.now_num:setString(#data)
    -- local maxNum = global.luaCfg:get_wild_max_by(global.userData:getLevel()).max 
    -- self.max_num:setString(maxNum)

    local data = resData:getWildResByType(self.data.resId)
    local pY, sH = self:initScroll(data, 1)

    local i = 0
    for _,v in pairs(data) do
        local item = UIWideListNode.new()
        item:setPosition(cc.p(gdisplay.width/2, pY - sH*i))
        item:setData(v)
        self.ScrollView_1:addChild(item)
        i = i + 1
    end
    self.ScrollView_1:jumpToTop()
end

function UIResInfoPanel:initNode3()

    self.txt_wild_num:setString(global.luaCfg:get_local_string(10332))
    local vip_tagCity = global.vipBuffEffectData:getCurrentVipLevelEffect(3076).quantity  or  0 

    local maxNum = 0
    local occupyData = resData:getOccupyMaxInfo() 
    if occupyData and occupyData.tagCity then
        maxNum = occupyData.tagCity.lMaxOccupy
    end
    self.max_num:setString(maxNum+vip_tagCity)
   
    local data = resData:getCityResData()
    self.now_num:setString(table.nums(data))

    local pY, sH = self:initScroll(data, 1)
    local i = 0
    for _,v in pairs(data) do
        local item = UICityListNode.new()   
        item:setPosition(cc.p(gdisplay.width/2, pY - sH*i))
        item:setData(v)
        self.ScrollView_1:addChild(item)
        i = i + 1
    end
    self.ScrollView_1:jumpToTop()
end

function UIResInfoPanel:onTabButtonChanged(index)
   
   if index == 1 then
        self:initNode1()
   elseif index == 2 then
        self:initNode2()
   elseif index == 3 then
        self:initNode3()
   end
end

function UIResInfoPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIResInfoPanel")
end

--CALLBACKS_FUNCS_END

return UIResInfoPanel

--endregion
