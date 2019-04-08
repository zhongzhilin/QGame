--region UIWorldSearchPanel.lua
--Author : Untory
--Date   : 2017/08/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UITableView = require("game.UI.common.UITableView")

local UIWorldSearchPanel  = class("UIWorldSearchPanel", function() return gdisplay.newWidget() end )
local UIWorldSearchItemCell = require("game.UI.world.widget.UIWorldSearchItemCell")
local CountSliderControl = require("game.UI.common.UICountSliderControl")
local TabControl = require("game.UI.common.UITabControl")

function UIWorldSearchPanel:ctor()
    self:CreateUI()
end

function UIWorldSearchPanel:CreateUI()
    local root = resMgr:createWidget("world/info/seek_bj")
    self:initUI(root)
end

function UIWorldSearchPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/seek_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.name_mlan_10_export
    self.tab = self.root.Node_export.tab_export
    self.node_1 = self.root.Node_export.node_1_export
    self.tableview_item = self.root.Node_export.node_1_export.tableview_item_export
    self.tableview_node = self.root.Node_export.node_1_export.tableview_node_export
    self.btn_apply = self.root.Node_export.node_1_export.btn_apply_export
    self.cost_bt_bg = self.root.Node_export.node_1_export.btn_apply_export.cost_bt_bg_export
    self.diamond_node = self.root.Node_export.node_1_export.btn_apply_export.diamond_node_export
    self.diamond_num = self.root.Node_export.node_1_export.btn_apply_export.diamond_node_export.diamond_num_export
    self.diamond_icon = self.root.Node_export.node_1_export.btn_apply_export.diamond_node_export.diamond_icon_export
    self.time = self.root.Node_export.node_1_export.btn_apply_export.time_export
    self.max_text = self.root.Node_export.node_1_export.max_text_export
    self.slider = self.root.Node_export.node_1_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.node_1_export.slider_export.cur)
    self.rightBtn = self.root.Node_export.node_1_export.rightBtn_export
    self.leftBtn = self.root.Node_export.node_1_export.leftBtn_export
    self.info = self.root.Node_export.node_1_export.info_export
    self.node_2 = self.root.Node_export.node_2_export
    self.textFieldY = self.root.Node_export.node_2_export.text_bj_0.textFieldY_export
    self.textFieldY = UIInputBox.new()
    uiMgr:configNestClass(self.textFieldY, self.root.Node_export.node_2_export.text_bj_0.textFieldY_export)
    self.textFieldX = self.root.Node_export.node_2_export.text_bj.textFieldX_export
    self.textFieldX = UIInputBox.new()
    uiMgr:configNestClass(self.textFieldX, self.root.Node_export.node_2_export.text_bj.textFieldX_export)
    self.btnAddItem2 = self.root.Node_export.node_2_export.btnAddItem2_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_apply, function(sender, eventType) self:applyHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.rightBtn, function(sender, eventType) self:rightHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.leftBtn, function(sender, eventType) self:leftHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btnAddItem2, function(sender, eventType) self:searchXY_click(sender, eventType) end)
--EXPORT_NODE_END

    self.slider.cur = self.cur
    self.tableView = UITableView.new()
        :setSize(self.tableview_node:getContentSize())
        :setCellSize(self.tableview_item:getContentSize())
        :setCellTemplate(UIWorldSearchItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        :setColumn(1)

    self.tableview_node:getParent():addChild(self.tableView)
    self.tableView:setPosition(self.tableview_node:getPosition())
    self.sliderControl = CountSliderControl.new(self.slider, handler(self,self.numChange) , true)

    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)


    self.tabControl = TabControl.new(self.tab, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))
end

function UIWorldSearchPanel:onTabButtonChanged(index)
    self.node_1:setVisible(index == 1)
    self.node_2:setVisible(index == 2)
end

function UIWorldSearchPanel:tableMove()
    
    local offsetX = self.tableView:getContentOffset().x
    local itemW = self.tableview_item:getContentSize().width
    local minX = self.tableView:minContainerOffset().x

    if offsetX > -(itemW/2) then
        self.leftBtn:setEnabled(false)
        self.rightBtn:setEnabled(true)
    elseif offsetX < -(itemW/2) and offsetX > (minX+itemW/2) then
        self.leftBtn:setEnabled(true)
        self.rightBtn:setEnabled(true)
    elseif offsetX <= (minX+itemW/2) then
        self.leftBtn:setEnabled(true)
        self.rightBtn:setEnabled(false)
    end   
end

function UIWorldSearchPanel:onEnter()

    self.maxTime =  global.userData:getSearchFree() or 0 --免费次数
    self.costnumber = global.userData:getSearchCost() or 0 --消耗魔晶次数

    -- self.time:setVisible(false)
    self.diamond_node:setVisible(false)

    if not self.choose_index then
        self:chooseIndex(1,true)
    end    

    -- self.time:setString(luaCfg:get_local_string(10809, ''))
    global.commonApi:getComCount(1,function(msg)

        if msg.tagCount[1] then 

            if msg.tagCount[1].lID == 1 then 

                self.maxTime = msg.tagCount[1].lValue
                
                global.userData:setSearchFree( self.maxTime )

            elseif  msg.tagCount[1].lID == 2 then

                self.costnumber = msg.tagCount[1].lValue

                global.userData:setSearchCost(  self.costnumber  )
            end 

        end 

        if self.changeState then 
            self:changeState()
        end 

    end)

    self:changeState()


    local x, y = global.collectData:getCurPos()
    self.textFieldX:setString(x)
    self.textFieldY:setString(y)
    
    self.tabControl:setSelectedIdx(1)
    self:onTabButtonChanged(1)
end


function UIWorldSearchPanel:numChange()
    
end

function UIWorldSearchPanel:isFree()  -- 是否免费

    return self.maxTime > 0 
end 



local color = {

    default  = cc.c3b( 255 , 185, 34 )  , 

    red = cc.c3b( 255 ,226 , 165) ,
} 


function UIWorldSearchPanel:changeState()
    

    if tolua.isnull(self.time) then return end 

    if self:isFree() then -- 显示免费

        self.cost_bt_bg:setVisible(false)
        self.time:setVisible(true)  
        self.diamond_node:setVisible(false)
        self.time:setString(luaCfg:get_local_string(10809, self.maxTime))

    else          

        local diamond = tonumber( global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))
        self.cost_bt_bg:setVisible(true)
        self.time:setVisible(false) 
        self.diamond_node:setVisible(true)

        local maxnumber =  table.nums(global.luaCfg:search_cost())

        local nextNumber=  self.costnumber + 1 
        if nextNumber > maxnumber then 
            nextNumber  = maxnumber
        end

        if not global.luaCfg:get_search_cost_by(nextNumber) then return end 
         self.sear_cost = global.luaCfg:get_search_cost_by(nextNumber).cost

        if  diamond <  self.sear_cost then 
            self.diamond_num:setTextColor(gdisplay.COLOR_RED)
        else
            self.diamond_num:setTextColor(color.default)
        end  
        self.diamond_num:setString( self.sear_cost)

    end
end 

function UIWorldSearchPanel:chooseIndex(index,isFirst)
    
    self.choose_index = index

    local preCount = tonumber(self.cur:getString())

    local preContentOffset = self.tableView:getContentOffset()

    local data = clone(luaCfg:world_seek())
    table.sortBySortList(data,{{'array','min'}})
    self.tableView:setData(data)

    if not isFirst then

        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
        self.tableView:setContentOffset(preContentOffset)
    end

    local seekData = luaCfg:get_world_seek_by(index or 1)
    self.info:setString(seekData.text)
    self.seekData = seekData

    local max = 0 

    if seekData.maxlv > 0 then
        max = seekData.maxlv
    else

        if seekData.worldtype == 2 then

            local resLevel = global.userData:getResLevel()
            local unlockData = global.luaCfg:get_map_unlock_by(resLevel)
            max = unlockData.MaxLv
        elseif seekData.worldtype == 5 then

            local buildData = global.cityData:getTopLevelBuild(1)
            max = buildData.serverData.lGrade + 1
        else
            
            local buildData = global.cityData:getTopLevelBuild(1)
            max = buildData.serverData.lGrade
        end        
    end

    if max > 30 then max = 30 end
    preCount = preCount or 0
    if preCount > max then preCount = max end

    self.sliderControl:setMaxCount(max)
    self.sliderControl:changeCount(preCount)
    self.max_text:setString(luaCfg:get_local_string(10810,max))
end

function UIWorldSearchPanel:getChooseIndex()

    return self.choose_index
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWorldSearchPanel:leftHandler(sender, eventType)

    local offset = self.tableView:getContentOffset()
    local itemW = self.tableview_item:getContentSize().width
    local maxX = self.tableView:maxContainerOffset().x
    local minX = self.tableView:minContainerOffset().x
    local moveX = offset.x + itemW
    if moveX > maxX then
        moveX = maxX
    end
    global.uiMgr:addSceneModel(0.5)
    self.tableView:setContentOffsetInDuration(cc.p(moveX,offset.y), 0.3)  
end

function UIWorldSearchPanel:rightHandler(sender, eventType)

    local offset = self.tableView:getContentOffset()
    local itemW = self.tableview_item:getContentSize().width
    local minX = self.tableView:minContainerOffset().x
    local moveX = offset.x - itemW
    if moveX < minX then
        moveX = minX
    end
    global.uiMgr:addSceneModel(0.5)
    self.tableView:setContentOffsetInDuration(cc.p(moveX,offset.y), 0.3)
end

local preSearchType = -1
local preSearchLevel = -1
local searchCount = 1

function UIWorldSearchPanel:applyHandler(sender, eventType)
    
    if not self:isFree() then --不是免费
    
        if self.sear_cost and  self.sear_cost >  tonumber( global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) then 

             global.tipsMgr:showWarning("ItemUseDiamond")

             return 
        end 
    end 

    local objType = self.seekData.worldtype
    local level = self.cur:getString()
    local kind = self.seekData.wildtype

    if level == preSearchLevel and self.seekData.id == preSearchType then
        searchCount = searchCount + 1
    else
        searchCount = 1
    end

    preSearchLevel = level
    preSearchType = self.seekData.id

    global.worldApi:searchWorldObj(objType,self.seekData.screen[tonumber(level)] or tonumber(level),searchCount,kind,function(msg)

        local data = self.seekData

        global.funcGame:gpsWorldCity(msg.lMapID, data.citytype,true,function()

            if self:isFree() then  
                self.maxTime = self.maxTime - 1
                global.userData:setSearchFree( global.userData:getSearchFree() - 1)

                if self.time and not tolua.isnull(self.time) then 
                    self.time:setString(luaCfg:get_local_string(10809, self.maxTime))
                end 
            else 
                self.costnumber =  self.costnumber + 1    
                local curCost = global.userData:getSearchCost() or 0
                global.userData:setSearchCost(curCost + 1)
            end 
            self:changeState()

            local names = {[0] = "worldcity",[1] = "wildres",[2] = "monsterObj"}

            local widgetName = names[data.citytype] .. msg.lMapID 
            global.guideMgr:setStepArg(widgetName)
            gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_AFTER_SEARCH)

            -- global.guideMgr:getHandler():autoFlushWorld({
            --     panelName = "UIWorldPanel",widgetName = widgetName1,isShowLight = true,scaleY = 1
            --     })
        end)

        global.panelMgr:closePanel("UIWorldSearchPanel")       

    end,function()
        -- global.tipsMgr:showWarning("78")
    end)
end

function UIWorldSearchPanel:exitCall(sender, eventType)

    global.panelMgr:closePanel("UIWorldSearchPanel")
end

function UIWorldSearchPanel:searchXY_click(sender, eventType)
    
    local x = tonumber(self.textFieldX:getString())
    local y = tonumber(self.textFieldY:getString())

    if x and y then

        local pos = global.g_worldview.const:converLocation2Pix(cc.p(y, x))
        
        if global.g_worldview.worldPanel.m_scrollView:checkOffsetIsCanJump({x = -pos.x,y = -pos.y},true) then
            local isExitXY = global.g_worldview.worldPanel.m_scrollView:setOffset(cc.p(-pos.x, -pos.y)) 
            if isExitXY then
                local worldPanel = global.panelMgr:getPanel("UIWorldPanel")
                if worldPanel then
                    worldPanel.locationInfo:setPosLocation(cc.p(x, y))
                end
            end
            self:exitCall()
        else
            global.tipsMgr:showWarning('invalidCoordinate')
        end

        
    else
        global.tipsMgr:showWarning("Searchempty")
    end
end
--CALLBACKS_FUNCS_END

return UIWorldSearchPanel

--endregion
