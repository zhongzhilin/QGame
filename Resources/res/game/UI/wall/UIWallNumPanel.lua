--regi-on UIWallNumPanel.lua
--Author : yyt
--Date   : 2016/09/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local panelMgr = global.panelMgr
local propData = global.propData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWallNumPanel  = class("UIWallNumPanel", function() return gdisplay.newWidget() end )
local UIChatTableView = require("game.UI.chat.UIChatTableView")
local UIRcodeCell = require("game.UI.wall.UIRcodeCell")

function UIWallNumPanel:ctor()
    self:CreateUI()
end

function UIWallNumPanel:CreateUI()
    local root = resMgr:createWidget("wall/wall_num_bg")
    self:initUI(root)
end

function UIWallNumPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/wall_num_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.panel_name = self.root.title_export.panel_name_fnt_mlan_12_export
    self.wall_UnNormalState = self.root.top_content.wall_UnNormalState_export
    self.title_fireState = self.root.top_content.wall_UnNormalState_export.title_fireState_export
    self.speed = self.root.top_content.wall_UnNormalState_export.title_fireState_export.speed_mlan_10_export
    self.speed_num = self.root.top_content.wall_UnNormalState_export.title_fireState_export.speed_num_export
    self.speed_point = self.root.top_content.wall_UnNormalState_export.title_fireState_export.speed_point_mlan_2_export
    self.defFire_num = self.root.top_content.wall_UnNormalState_export.title_fireState_export.defFire_num_export
    self.title_destoryState = self.root.top_content.wall_UnNormalState_export.title_destoryState_export
    self.def1 = self.root.top_content.wall_UnNormalState_export.title_destoryState_export.def1_mlan_20_export
    self.defDestory_num = self.root.top_content.wall_UnNormalState_export.title_destoryState_export.def1_mlan_20_export.defDestory_num_export
    self.def_perDestory = self.root.top_content.wall_UnNormalState_export.title_destoryState_export.def1_mlan_20_export.def_perDestory_export
    self.wall_NormalState = self.root.top_content.wall_NormalState_export
    self.def_num = self.root.top_content.wall_NormalState_export.title_txt_bg1.def_num_export
    self.def_NormalPer = self.root.top_content.wall_NormalState_export.title_txt_bg1.def_NormalPer_export
    self.loadingbar_bg = self.root.top_content.loadingbar_bg_export
    self.LoadingBar = self.root.top_content.loadingbar_bg_export.LoadingBar_export
    self.now_num = self.root.top_content.loadingbar_bg_export.now_num_export
    self.total_num = self.root.top_content.loadingbar_bg_export.total_num_export
    self.max_speed = self.root.max_speed_export
    self.TipLayout = self.root.TipLayout_export
    self.top_node = self.root.top_node_export
    self.scrollView = self.root.scrollView_export
    self.fireUse_btn = self.root.scrollView_export.fire_bg.fireUse_btn_export
    self.buyFire_btn = self.root.scrollView_export.fire_bg.buyFire_btn_export
    self.fdiamond_num = self.root.scrollView_export.fire_bg.buyFire_btn_export.fdiamond_num_export
    self.ficon_bg = self.root.scrollView_export.fire_bg.ficon_bg_export
    self.ficon = self.root.scrollView_export.fire_bg.ficon_bg_export.ficon_export
    self.fire_number = self.root.scrollView_export.fire_bg.ficon_bg_export.item_number_bg.fire_number_export
    self.waterUse_btn = self.root.scrollView_export.water_bg.waterUse_btn_export
    self.buyWater_btn = self.root.scrollView_export.water_bg.buyWater_btn_export
    self.wdiamond_num = self.root.scrollView_export.water_bg.buyWater_btn_export.wdiamond_num_export
    self.wicon_bg = self.root.scrollView_export.water_bg.wicon_bg_export
    self.wicon = self.root.scrollView_export.water_bg.wicon_bg_export.wicon_export
    self.water_number = self.root.scrollView_export.water_bg.wicon_bg_export.item_number_bg.water_number_export
    self.trim_top = self.root.trim_top_export
    self.recode = self.root.recode_export
    self.recodeTb = self.root.recode_export.recodeTb_export
    self.recodeText = self.root.recode_export.recodeText_export
    self.recodeCell = self.root.recode_export.recodeCell_export
    self.recodeLay = self.root.recode_export.recodeLay_export
    self.topNode = self.root.recode_export.topNode_export
    self.botNode = self.root.recode_export.botNode_export

    uiMgr:addWidgetTouchHandler(self.root.title_export.intro_btn, function(sender, eventType) self:info_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.strength_btn, function(sender, eventType) self:recover_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.fireUse_btn, function(sender, eventType) self:fire_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.buyFire_btn, function(sender, eventType) self:fireBuy_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.waterUse_btn, function(sender, eventType) self:outFire_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.buyWater_btn, function(sender, eventType) self:waterBuy_click(sender, eventType) end)
--EXPORT_NODE_END
    self.defDestory_mlan = self.def1

    self.top_content = self.root.top_content
    global.panelMgr:trimScrollView(self.scrollView,self.trim_top)
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)

    self.strength_btn = self.root.strength_btn
    self.Particle_1 = self.root.Particle_1
    self.smoke1 = self.root.smoke
    self.smoke2 = self.root.smoke_0

    self.tableView = UIChatTableView.new()
        :setSize(self.recodeLay:getContentSize(), self.topNode, self.botNode)
        :setCellSize(self.recodeCell:getContentSize())
        :setCellTemplate(UIRcodeCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.recodeTb:addChild(self.tableView)

    self.water_bg = self.root.scrollView_export.water_bg
    self.fire_bg = self.root.scrollView_export.fire_bg

    self.speed_mlan = self.speed
    self.speed_point_mlan = self.speed_point
end

function UIWallNumPanel:initTextTips()

    self.TipLayout.Image_1.nofire_node:setVisible(true)
    self.TipLayout.Image_1.fire_node:setVisible(true)
     
    if self.WALL_STATE == 2 then
        self.TipLayout.Image_1.nofire_node:setVisible(false)
        self.TipLayout.Image_1.fire_node.fire_time_export:setString(global.luaCfg:get_local_string(10784, self.speedNum))
    else
        self.TipLayout.Image_1.fire_node:setVisible(false)
        if self.data then 
            self.TipLayout.Image_1.nofire_node.recover_time_export:setString(global.luaCfg:get_local_string(10783, self.data.revSpeed))
        end 
    end
    
    self.TipLayout.Image_1.nofire_node.recover_time1_mlan_8:setString(global.luaCfg:get_local_string(10782))
    self.TipLayout.Image_1.fire_node.fire_time1_mlan_8:setString(global.luaCfg:get_local_string(10785))

end

function UIWallNumPanel:longPressDeal(beganPoint)
    
    self.TipLayout:setVisible(true)
    self.TipLayout:runAction(cc.FadeIn:create(0.2))

    local layoutW = self.TipLayout.Image_1:getContentSize().width
    local rightX = gdisplay.width - layoutW
    if beganPoint.x >= rightX then
        beganPoint.x = rightX
    end

    local offsetY = self.TipLayout.Image_1:getContentSize().height/2 + 15
    local x, y = self.loadingbar_bg:getPosition()
    local position = self.top_content:convertToWorldSpace(cc.p(x, y))
    self.TipLayout:setPosition(cc.p( beganPoint.x + layoutW/2 ,position.y+offsetY))

end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIWallNumPanel:onEnter()
    
    self.flag = 0

    -- self.scrollView:setPositionY(self.ps_node:getPositionY())    

    self.scrollView:setContentSize(cc.size(gdisplay.width, self.top_node:getPositionY()-5))
    self.scrollView:setInnerContainerSize(self.scrollView:getContentSize())

    local yy =self.scrollView:getInnerContainerSize().height

    local part_x = 15 

    self.fire_bg:setPositionY(yy - self.fire_bg:getContentSize().height/2 -part_x)

    self.water_bg:setPositionY(yy - self.fire_bg:getContentSize().height - self.water_bg:getContentSize().height/2 - part_x * 2 )


    self.scrollView:jumpToTop()

    -- 注册长按事件
    global.tipsMgr:registerLongPress(self, self.loadingbar_bg, self.TipLayout ,
        handler(self, self.initTextTips),  handler(self, self.longPressDeal))

    self:addEventListener(global.gameEvent.EV_ON_CITY_BURNED, function ()
        if self.close then
            self:close()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()
        if self.initData then
            self:fireTimeLine()
            self:initData(self.cityId)
        end

        if self.referRecode then
            self:referRecode()
        end
    end) 

    self:addEventListener(global.gameEvent.EV_ON_RECONNECT_UPDATE, function ()
        if self.initData then
            self:initData(self.cityId)
        end

        if self.referRecode then
            self:referRecode()
        end
    end)

    self:fireTimeLine()

    -- 烧城记录
    self.recodeData = {}
    self.recode:setVisible(false)
    self:addEventListener(global.gameEvent.EV_ON_FIRECODE_UPDATE, function (event, msg)
        if self.setRecode then
            table.insert(self.recodeData, msg.tagFiredLog or {})
            self:setRecode(true)
        end
    end)
    
end

-- required int32      lDoID = 1;  //userid
-- required int32      lType = 2;  //1.fire,2water
-- required int32      lNum = 3;   //使用个数
-- required int32      lValue = 4; //效果值
-- required uint32     lAddTime = 5;   //使用时间
-- required string     szName = 6; //使用者名字
-- required string     szParam = 7; //附加参数‘|’分隔
function UIWallNumPanel:setRecode(isAnimation)
    -- body
    self.cellH = 0
    local data = {}

    local getCellH = function (v)
        local cdata = v
        local timeStr = global.mailData:getTime(0, cdata.lAddTime)
        if cdata.lType == 1 then
           uiMgr:setRichText(self, "recodeText", 50143, {time=timeStr, name=cdata.szName, name1=cdata.szParam or "", itemNum=cdata.lNum, burnSpeed=cdata.lValue})
        else
           uiMgr:setRichText(self, "recodeText", 50144, {time=timeStr, name=cdata.szName, name1=cdata.szParam or "", itemNum=cdata.lNum, burnSpeed=cdata.lValue})
        end
        local textH = self.recodeText:getRichTextSize().height
        return textH
    end

    if table.nums(self.recodeData) > 1 then
        table.sort(self.recodeData, function(s1, s2) return s1.lAddTime > s2.lAddTime end)
    end
    for _,v in pairs(self.recodeData) do
        local temp = {}
        temp.cdata = v 
        temp.cellH = getCellH(v) + 8
        table.insert(data, temp)
        self.cellH = temp.cellH
    end

    if table.nums(data) > 0 then
        self.recode:setVisible(true)
        self.tableView:setData(data)
        if isAnimation then self:cellAnimation() end       
    end

end
-- 记录滚动动画
function UIWallNumPanel:cellAnimation()

    local offset = self.tableView:getContentOffset()
    local minOffsetY = self.tableView:minContainerOffset().y
    self.tableView:setContentOffset(cc.p(offset.x, minOffsetY+self.cellH))
    self.tableView:setContentOffsetInDuration(cc.p(offset.x, minOffsetY), 0.2)
end

function UIWallNumPanel:fireTimeLine()

    -- 烧城特效
    self.root:stopAllActions()
    local timeLine = resMgr:createTimeline("wall/wall_num_bg")
    timeLine:play("animation0", true)
    self.root:runAction(timeLine)
end

-- 初始化数据
function UIWallNumPanel:initData(cityId, occupyUserId)
    
    self.fireUse_btn:setTouchEnabled(false)
    self.buyFire_btn:setTouchEnabled(false)
    self.waterUse_btn:setTouchEnabled(false)
    self.buyWater_btn:setTouchEnabled(false)
    self.strength_btn:setTouchEnabled(false)

    self.cityId = cityId
    global.worldApi:fireWall(true, cityId ,function(msg)    

        if self.setData then

            self.fireUse_btn:setTouchEnabled(true)
            self.buyFire_btn:setTouchEnabled(true)
            self.waterUse_btn:setTouchEnabled(true)
            self.buyWater_btn:setTouchEnabled(true)
            self.strength_btn:setTouchEnabled(true)
            self:setData(msg)
        end
    end)

    -- 烧城记录 (occupyUserId  当前城池拥有者id)
    self.occupyUserId = occupyUserId or global.userData:getUserId()
    self:referRecode()
end

-- test:
-- self.recodeData = {
--     [1] = {
--         lDoID = 1,
--         lType = 2,
--         lNum = 3,  
--         lValue = 4,
--         lAddTime = 0,
--         szName = "DDDFDFDFDFFDadi jdf idf jidfdf fdfjdf idf jidfdf fdfjdf idf jidfdf fdf",
--         szParam = 7,
--     },
-- }

function UIWallNumPanel:referRecode()
    global.worldApi:getFireRecode(self.occupyUserId, function (msg)
        if self.setRecode then
            self.recodeData = msg.tagFiredLog or {}
            self:setRecode()
        end
    end)
end

function UIWallNumPanel:setData(data)

    self.cityId = data.lCityID
    self.duraValue = 0  -- 当前城防值

    local itemW = luaCfg:get_item_by(11501)
    -- self.wicon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemW.quality))
    -- self.wicon:setSpriteFrame(itemW.itemIcon)
    global.panelMgr:setTextureFor(self.wicon,itemW.itemIcon)
    global.panelMgr:setTextureFor(self.wicon_bg,string.format("icon/item/item_bg_0%d.png",itemW.quality))

    local itemF = luaCfg:get_item_by(11401)
    -- self.ficon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemF.quality))
    -- self.ficon:setSpriteFrame(itemF.itemIcon)
    global.panelMgr:setTextureFor(self.ficon,itemF.itemIcon)
    global.panelMgr:setTextureFor(self.ficon_bg,string.format("icon/item/item_bg_0%d.png",itemF.quality))
    
    if not self.m_scheduleId then
        self.m_scheduleId = gscheduler.scheduleGlobal(function ()
            if self.initDef then
                self:initDef()
            end
        end, 15)
    end

    if not self.m_scheduleRefersh then
        self.m_scheduleRefersh = gscheduler.scheduleGlobal(function ()
            if self.refershSpeed then
                self:refershSpeed(1)
            end
        end, 1)
    end
    
    self.curBurnMax = 0

    self:initCityData(data)
    self:initDef()   

end

-- 刷新
function UIWallNumPanel:refershSpeed(flag)
    global.worldApi:fireWall(true, self.cityId ,function(msg)

        if self.initCityData then 
            self:initCityData(msg)
            if flag == 0 then
                self:initDef()
            end
        end
    end)
end

--　城墙当前状态　0（正常状态） 1（破损状态） 2（燃烧状态） 
-- self.WALL_STATE = 0

--  城堡状态 0 (未占领状态)  1（占领状态）
-- self.CITY_STATE = 0

function UIWallNumPanel:initCityData(msg)

    msg = msg or {}
    msg.lAvatar = msg.lAvatar or 1

    -- dump(msg, "---------------------> UIWallNumPanel:initCityData(msg): ")
    self.smoke1:setVisible(false)
    self.smoke2:setVisible(false)

    local m_useId = global.userData:getUserId()
    self.CITY_STATE = (msg.lOwnerID == 0) and 0 or 1

    -- 与城池领主关系
    self.m_isFriend = ((msg.lAvatar >= 1) and (msg.lAvatar <= 3))
    self.m_isMe = (msg.lAvatar == 1)

    -- 与占领者的关系
    msg.lOwnerAvatar = msg.lOwnerAvatar or -1
    self.o_isFriend = ((msg.lOwnerAvatar >= 1) and (msg.lOwnerAvatar <= 3)) 
    self.m_isCanFire = self.o_isFriend or self.m_isMe

    local wallData = luaCfg:get_buildings_wall_by(msg.lDefLevel)
    self.data = wallData
    self.wallMsg = msg
    self.data.buildId = 14

    if self.curBurnMax ~= self.data.burnMax then
        uiMgr:setRichText(self, "max_speed", 50051, {num = self.data.burnMax})
        self.curBurnMax = self.data.burnMax
    end

    if msg.lDefense > msg.lMaxDefense then
        msg.lDefense = msg.lMaxDefense
    end
    self.duraValue = msg.lDefense
    self.maxDuraValue = msg.lMaxDefense
    self.speedNum = msg.lFireSpeed
    self.speed_num:setString(msg.lFireSpeed)

    -- 超框处理
    self.speed_mlan:setPositionX(gdisplay.width/3)
    self.speed_num:setPositionX(self.speed_mlan:getPositionX()+self.speed_mlan:getContentSize().width/2*0.7)
    self.speed_point_mlan:setPositionX(self.speed_num:getPositionX()+self.speed_num:getContentSize().width*0.7)

    if msg.lDefense < msg.lFireSpeed and self.flag == 0 then
        self:initDef()
        self.flag = 1
    end

    if msg.lMaxDefense <= msg.lDefense and msg.lFireSpeed <= 0 then
        --正常
        self.WALL_STATE = 0
        self:CityNormalState()
    elseif msg.lFireSpeed > 0 then
        --燃烧
        self.WALL_STATE = 2
        self:CityFireState()
    elseif msg.lMaxDefense > msg.lDefense and msg.lDefense > 0 and msg.lFireSpeed <= 0 then
        --破损
        self.WALL_STATE = 1
        self:CityDestoryState()
    elseif msg.lDefense <= 0 and msg.lFireSpeed <= 0 then
        --摧毁
        self:cityAllDestoryed()
    end

end

function UIWallNumPanel:initDef()
    
    self:strengthBtnState()
    self.total_num:setString(self.maxDuraValue)
    self.now_num:setString(self.duraValue)
    self.LoadingBar:setPercent(self.duraValue/self.maxDuraValue*100)
    self:resetFireDef()
    self:resetDestoryDef()
end

function UIWallNumPanel:strengthBtnState()
    
    self.strength_btn:setEnabled(false)
    if self.m_isMe and (self.duraValue ~= self.maxDuraValue) then
        self.strength_btn:setEnabled(true)
    end

end

-- 界面状态重置
function UIWallNumPanel:initState()
    
    self.Particle_1:setVisible(false)
    self.wall_UnNormalState:setVisible(true)
    self.wall_NormalState:setVisible(true)
    self.title_fireState:setVisible(true)
    self.title_destoryState:setVisible(true)

    self:updateItemNum()
end

-- 更新火把、水桶使用按钮状态
function UIWallNumPanel:updateItemNum()

    self.fireUse_btn:setVisible(true)
    self.buyFire_btn:setVisible(true)
    self.waterUse_btn:setVisible(true)
    self.buyWater_btn:setVisible(true)

    local numF = global.normalItemData:getItemById(11401).count  
    self.fire_number:setString(numF)
    local numW = global.normalItemData:getItemById(11501).count   
    self.water_number:setString(numW)

    self:fireBtnState()
    self:waterBtnState()
end

function UIWallNumPanel:fireBtnState()

    --　判断是否有火把道具
    local num = global.normalItemData:getItemById(11401).count   --火把数量     
    local buyData = luaCfg:get_shop_by(11401)
    self.fdiamond_num:setString(buyData.cost)

    if num <= 0 then

        self.fireUse_btn:setVisible(false)
        self.buyFire_btn:setEnabled(false)
        if self.CITY_STATE == 1 and self.m_isCanFire then
            self.buyFire_btn:setEnabled(true)            
        end
    else
        self.buyFire_btn:setVisible(false)
        self.fireUse_btn:setEnabled(false)
        self.max_speed:setVisible(false)
        if self.CITY_STATE == 1 and self.m_isCanFire then
            self.fireUse_btn:setEnabled(true)
            self.max_speed:setVisible(true)
        end
    end
end

function UIWallNumPanel:waterBtnState()
    
    --　判断是否有灭火道具
    local num = global.normalItemData:getItemById(11501).count   --　水桶数量
    local buyData = luaCfg:get_shop_by(11501)
    self.wdiamond_num:setString(buyData.cost)   

    if num <= 0 then
        self.waterUse_btn:setVisible(false)        

        if (self.WALL_STATE == 2) and self.m_isFriend  then
            self.buyWater_btn:setEnabled(true)            
        else
            self.buyWater_btn:setEnabled(false)
        end
        
    else
        self.buyWater_btn:setVisible(false)
        if (self.WALL_STATE == 2) and self.m_isFriend then            -- 城市燃烧状态才能使用灭火 
            self.waterUse_btn:setEnabled(true)
        else
            self.waterUse_btn:setEnabled(false)
        end
    end
end

-- 正常状态
function UIWallNumPanel:CityNormalState()
    self:initState()
    self.wall_UnNormalState:setVisible(false)

    self:initDef()
    self.def_num:setString(self.data.defUp)
    self.def_NormalPer:setPositionX( self.def_num:getPositionX() + self.def_num:getContentSize().width )
end

--　燃烧状态
function UIWallNumPanel:CityFireState()
    self:initState()
    self.wall_NormalState:setVisible(false)
    self.title_destoryState:setVisible(false)
    -- self.max_speed:setString(luaCfg:get_local_string())   

    self.Particle_1:setVisible(true)
    self.smoke1:setVisible(true)
    self.smoke2:setVisible(true)
end

--　破损状态
function UIWallNumPanel:CityDestoryState()
    self:initState()
    self.wall_NormalState:setVisible(false)
    self.title_fireState:setVisible(false)
end

function UIWallNumPanel:resetDestoryDef()
    
    local defNum = self.LoadingBar:getPercent()
    self.defDestory_num:setString(" " .. string.format("%0.2f", defNum*self.data.defUp/100 ))

    -- 垂直居中
    local tW = self.defDestory_mlan:getContentSize().width + self.defDestory_num:getContentSize().width
    local posX = gdisplay.width/2 - tW/2
    local posR = self.title_destoryState:convertToNodeSpace(cc.p(posX, 0))
    self.defDestory_mlan:setPositionX(posR.x) 
    local x = posX + self.defDestory_mlan:getContentSize().width
    local posL = self.defDestory_mlan:convertToNodeSpace(cc.p(x, 0))
    self.defDestory_num:setPositionX(posL.x)
    self.def_perDestory:setPositionX( self.defDestory_num:getPositionX() + self.defDestory_num:getContentSize().width)
end

function UIWallNumPanel:resetFireDef()
    local defNum = self.LoadingBar:getPercent()
    self.defFire_num:setString( string.format("%0.2f", defNum*self.data.defUp/100 ) .. "%"  )
end

function UIWallNumPanel:fire_click(sender, eventType)

    if self.wallMsg.lFireSpeed >= self.data.burnMax then        
        global.tipsMgr:showWarning("BurnMax")       
        return 
    end

    local less = math.ceil((self.data.burnMax - self.wallMsg.lFireSpeed) / 3)

    local itemUsePanel = panelMgr:openPanel("UIItemUsePanel")
    local fireNum =  tonumber(self.fire_number:getString())
    local maxCount = self.duraValue < fireNum and self.duraValue or fireNum
    local data = {itemId = 11401, maxCount = math.min(less,maxCount)}
    itemUsePanel:setData(data, handler(self, self.fireCall),function(param)
        
        if not param[2] then return end
        local max = self.data.burnMax - self.wallMsg.lFireSpeed
        if param[2] > max then
            param[2] = max
        end            
    end)
end

function UIWallNumPanel:outFire_click(sender, eventType)
    
    if self.wallMsg.lFireSpeed == 0 then        
        global.tipsMgr:showWarning("180")       
        return 
    end

    local itemUsePanel = panelMgr:openPanel("UIItemUsePanel")
    local waterNum =  tonumber(self.water_number:getString())
    local maxCount = math.ceil(self.speedNum / 3) < waterNum and math.ceil(self.speedNum / 3) or waterNum
    local data = {itemId = 11501, maxCount = maxCount}
    itemUsePanel:setData(data, handler(self, self.outFireCall),function(param)
        
        if not param[2] then return end
        if param[2] > self.speedNum then
           param[2] = self.speedNum                      
        end
    end)
end

function UIWallNumPanel:recover_click(sender, eventType)

    local recoverP = panelMgr:openPanel("UIRecoverWallPanel")
    recoverP:setData(self.data, handler(self, self.recoverCall))
end

function UIWallNumPanel:recoverCall(msg)

    self.strength_btn:setEnabled(false)
    local time = 1 - self.LoadingBar:getPercent()/100
    self:changLoadingBar(100, self.data.durability, time )
    self:runAction(cc.Sequence:create(cc.DelayTime:create(time), cc.CallFunc:create(function ()
        
        if self.updateItemNum then 
            self:updateItemNum()
        end 
        if self.refershSpeed then 
            self:refershSpeed(0)
        end 
    end)))

end

function UIWallNumPanel:fireCall(count, exitCall)

    if self.duraValue == 0 then
         global.tipsMgr:showWarning("CityBurnInCity")
        exitCall()
    else
        local useCount = count
        -- 火把烧毁自己城池 参数 1 
        global.itemApi:itemUse(11401, count, self.cityId , self.data.buildId , function(msg)
            global.normalItemData:updateItem({id = msg.lID, count = msg.lCount})
            if self.updateItemNum then 
                self:updateItemNum() 
            end 
            if self.refershSpeed then 
                self:refershSpeed(0)
            end 
            exitCall()
        end)
    end
end

function UIWallNumPanel:outFireCall(count, exitCall)

    if self.duraValue == 0 then
        global.tipsMgr:showWarning("CityBurnInCity")
        exitCall()
    else
        local useCount = count
        global.itemApi:itemUse(11501, count, self.cityId , self.data.buildId , function(msg)

            global.normalItemData:updateItem({id = msg.lID, count = msg.lCount})
            if self.updateItemNum then 
                self:updateItemNum()  
            end 
            if self.refershSpeed then 
                self:refershSpeed(0)
            end 
            exitCall()
        end)
    end
end

function UIWallNumPanel:getItemInfo( itemId, count )
    
    local tipStr = ""
    local itemData = luaCfg:get_item_by(self.getPanel.curResId)
    local itemNum = luaCfg:get_item_by(itemId).effectPara1*count
    tipStr = itemData.itemName.." +"..itemNum
    return tipStr
end

--　城池已被烧毁
function UIWallNumPanel:cityAllDestoryed()
      
    self.WALL_STATE = 0
    self.CITY_STATE = 0          

    self.duraValue = 0
    self.LoadingBar:setPercent(0)
    self.now_num:setString(0)
    self.defFire_num:setString("0.00")
    self:close()
    global.tipsMgr:showWarning("CityBurnInCity")
end


function UIWallNumPanel:changLoadingBar(per, num, time)
    
    self:runAction(cc.Spawn:create( cc.CallFunc:create(function ()
        self.LoadingBar:runAction(cc.ProgressFromTo:create(time, self.LoadingBar:getPercent(),per))
    end), cc.CallFunc:create(function ()
        self:scroNum( tonumber(self.now_num:getString()) , num, time )    
    end) ))
end

function UIWallNumPanel:scroNum(startNum, endNum, time )

    local scoreNode = cc.Node:create()
    self.root:addChild(scoreNode)

    scoreNode:setPositionX(startNum)

    if scoreNode:getPositionX() ~= endNum then
            scoreNode:runAction(cc.Sequence:create(cc.CallFunc:create(function()
                
                scoreNode:runAction(cc.MoveTo:create(time, cc.p(endNum,0)))
                scoreNode:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(time / 30),cc.CallFunc:create(function ()
                    
                    local numStr = scoreNode:getPositionX()
                    self.now_num:setString(math.floor(numStr))
                end)), 30))          
            end)))            
    else
        self.now_num:setString(endNum)
    end
end

function UIWallNumPanel:checkDiamondEnough(num)
    if not propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        return false
    else
        return true
    end
end

function UIWallNumPanel:fireBuy_click(sender, eventType)
    
    if not self.data or not self.wallMsg then --protect
        
        return 
    end 

    if self.wallMsg and self.wallMsg.lFireSpeed >= self.data.burnMax then        
        global.tipsMgr:showWarning("BurnMax")       
        return 
    end
    
    local diamondNum = tonumber(self.fdiamond_num:getString())
    local maxCount = math.ceil((self.data.burnMax - self.wallMsg.lFireSpeed) / 3)
    local data = {diamondNum=diamondNum, itemId=11401, maxCount = maxCount}
    panelMgr:openPanel("UIItemBuyPanel"):setData(data, handler(self, self.buyAndUseItem))
end

function UIWallNumPanel:waterBuy_click(sender, eventType)

    if self.wallMsg.lFireSpeed == 0 then        
        global.tipsMgr:showWarning("180")       
        return 
    end
    
    local diamondNum = tonumber(self.wdiamond_num:getString())
    local data = {diamondNum=diamondNum, itemId=11501, maxCount =  math.ceil(self.speedNum / 3)  }
    panelMgr:openPanel("UIItemBuyPanel"):setData(data, handler(self, self.buyAndUseItem))
end

function UIWallNumPanel:buyAndUseItem( data, exitCall )


    if self.duraValue == 0 then
        global.tipsMgr:showWarning("CityBurnInCity")
        exitCall()
    else

        local itemId, num = data.id, data.count
        global.itemApi:diamondUse(function(msg)
            if self.refershSpeed then 
                self:refershSpeed(0)
            end 
            exitCall()
        end,1,num,self.data.buildId,itemId, self.cityId)
    end
end

function UIWallNumPanel:info_click(sender, eventType)

    local data = luaCfg:get_introduction_by(1)
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end

function UIWallNumPanel:onCloseHandler(sender, eventType)
    panelMgr:closePanelForBtn("UIWallNumPanel")
    --关闭订阅
    global.worldApi:fireWall(false, self.cityId ,function(msg)end)
end

function UIWallNumPanel:close()
    panelMgr:closePanel("UIWallNumPanel")
    --关闭订阅
    global.worldApi:fireWall(false, self.cityId ,function(msg)end)
end

function UIWallNumPanel:onExit()

    if self.listener then
        self:getEventDispatcher():removeEventListener(self.listener)
        self.listener = nil
    end
    if self.m_scheduleId then
        gscheduler.unscheduleGlobal(self.m_scheduleId)
        self.m_scheduleId = nil
    end
    if self.m_scheduleRefersh then
        gscheduler.unscheduleGlobal(self.m_scheduleRefersh)
        self.m_scheduleRefersh = nil
    end

    -- 移除长按事件监听
    global.tipsMgr:removeLongPress(self)
end

--CALLBACKS_FUNCS_END

return UIWallNumPanel

--endregion
