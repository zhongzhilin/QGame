--region UIResItem.lua
--Author : yyt
--Date   : 2016/11/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local resData = global.resData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIResItem  = class("UIResItem", function() return gdisplay.newWidget() end )

function UIResItem:ctor()
    self:CreateUI()
end

function UIResItem:CreateUI()
    local root = resMgr:createWidget("resource/res_pandect_node")
    self:initUI(root)
end

function UIResItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_pandect_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.res_name = self.root.res_name_export
    self.icon = self.root.res_icon_bg.icon_export
    self.Node_1 = self.root.Node_1_export
    self.Panel_3 = self.root.Node_1_export.Panel_3_export
    self.LoadingBar = self.root.Node_1_export.Panel_3_export.LoadingBar_export
    self.line = self.root.Node_1_export.Panel_3_export.line_export
    self.loadingEffect = self.root.Node_1_export.Panel_3_export.loadingEffect_export
    self.max_num = self.root.Node_1_export.max_num_export
    self.now_num = self.root.Node_1_export.now_num_export
    self.num = self.root.Node_1_export.num_export
    self.get_res_btn = self.root.Node_1_export.get_res_btn_export
    self.get_info_btn = self.root.Node_1_export.get_info_btn_export
    self.storeNode = self.root.Node_1_export.storeNode_export
    self.store_num = self.root.Node_1_export.storeNode_export.store_num_export

    uiMgr:addWidgetTouchHandler(self.get_res_btn, function(sender, eventType) self:getRes_click(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.get_info_btn, function(sender, eventType) self:getInfo_click(sender, eventType) end)
--EXPORT_NODE_END
    
    global.funcGame:initBigNumber(self.now_num , 1 )
    global.funcGame:initBigNumber(self.max_num , 1)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIResItem:onEnter()
    
    self:addEventListener(global.gameEvent.EV_ON_UI_CITY_FEATURE, function()
        self:checkResSpeed(resData:getResSpeedHour(self.data.resId))
    end)

    self:addEventListener(global.gameEvent.EV_ON_RESWAREHOUSE, function(event, addVal)
        self:checkStorePosition(addVal)
    end)
end

function UIResItem:setData(msg)

    local data = msg.cdata or msg
    self.get_res_btn:setVisible(msg.cdata == nil)
    self.get_info_btn:setVisible(msg.cdata == nil)
    local posX = msg.cdata ~= nil and (gdisplay.width/2) or 0
    local posY = msg.cdata ~= nil and 110 or 0
    self.root:setPosition(cc.p(posX, posY))
    local posX1 = msg.cdata ~= nil and 90 or 0
    self.Node_1:setPositionX(posX1)

    self.data = data
    local resTypeData = resData:getResTypeById(data.resId)
    self.icon:setSpriteFrame(resTypeData.resIcon)
    local itemData = luaCfg:get_item_by(data.resId)
    self.res_name:setString(itemData.itemName)
    self.now_num:setString(data.curRes)
    self.max_num:setString(data.maxRes)
    self.LoadingBar:setPercent(data.curRes/data.maxRes*100)
    self:checkResSpeed(resData:getResSpeedHour(data.resId))
    self:checkStorePosition(msg.wareHouseAdd or 0)
end

function UIResItem:checkStorePosition(addVal)

    self.LoadingBar:loadTexture("res_store_loadingbar_"..self.data.resId..".png", ccui.TextureResType.plistType)
    self.loadingEffect:setSpriteFrame("res_store_tips_"..self.data.resId..".png") 
    self.line:setSpriteFrame("res_store_line_"..self.data.resId..".png")

    local lW = self.LoadingBar:getContentSize().width
    local per = self.LoadingBar:getPercent()
    local curLw = lW*per/100
    self.loadingEffect:setPositionX(curLw)

    -- 仓库基础保护百分比
    local curLv = global.cityData:getBuildingById(18).serverData.lGrade
    local infoId = global.cityData:getBuildingsInfoId(18, curLv)
    local infos = luaCfg:get_buildings_info_by(infoId) or { para2Num = 0} --protect
    addVal = addVal or tonumber(infos.para2Num)

    local x = self.Panel_3:getPositionX()
    self.storeNode:setPositionX(x + lW*addVal/100)
    local lineLw = lW*addVal/100
    self.line:setPositionX(lineLw)
    addVal = math.floor(addVal)
    self.store_num:setString(luaCfg:get_local_string(10792, addVal .. "%"))

    if curLw < lineLw then
        self.line:setSpriteFrame("res_store_line_5.png")
    end

    self.baseProtect = addVal
end

function UIResItem:checkResSpeed(numSpeed)
   
    local hourStr = luaCfg:get_local_string(10076)
    local str = numSpeed..hourStr
    self.num:setColor(cc.c3b(255, 226, 165))
 
    if numSpeed > 0 then
        str = "+"..numSpeed..hourStr
    elseif numSpeed < 0 then
        self.num:setColor(gdisplay.COLOR_RED)
    end
    self.num:setString(str)
end

function UIResItem:getRes_click(sender, eventType)
    
    local getPanel = global.panelMgr:openPanel("UIResGetPanel")
    getPanel:setData(global.resData:getResById(self.data.resId))
end

function UIResItem:getInfo_click(sender, eventType)
    local infoPanel = global.panelMgr:openPanel("UIResInfoPanel")
    infoPanel:setData(global.resData:getResById(self.data.resId))
    infoPanel:checkSoldierConsump(self.baseProtect)
end
--CALLBACKS_FUNCS_END

return UIResItem

--endregion
