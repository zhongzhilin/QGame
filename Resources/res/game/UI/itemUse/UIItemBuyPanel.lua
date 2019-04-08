--region UIItemBuyPanel.lua
--Author : yyt
--Date   : 2016/11/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local propData = global.propData
local luaCfg = global.luaCfg
local CountSliderControl = require("game.UI.common.UICountSliderControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIItemBuyPanel  = class("UIItemBuyPanel", function() return gdisplay.newWidget() end )

function UIItemBuyPanel:ctor()
    self:CreateUI()
end

function UIItemBuyPanel:CreateUI()
    local root = resMgr:createWidget("common/item_buy_use")
    self:initUI(root)
end

function UIItemBuyPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/item_buy_use")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.diamond_num = self.root.Node_export.buy_use_btn.diamond_num_export
    self.name = self.root.Node_export.title.name_export
    self.desc = self.root.Node_export.desc_export
    self.effect = self.root.Node_export.effect_export
    self.slider = self.root.Node_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.slider_export.cur)
    self.icon_bg = self.root.Node_export.icon_bg_export
    self.icon = self.root.Node_export.icon_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.buy_use_btn, function(sender, eventType) self:use_call(sender, eventType) end)
--EXPORT_NODE_END
    self.slider.cur = self.cur
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.sliderControl = CountSliderControl.new(self.slider,handler(self,self.sliderUpdate))
    self.effectDes = 0
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

---- data = {diamondNum=10, itemId=10041, maxCount=100, curResId=1}
---- diamondNum: 单个道具消耗的魔晶数
---- itemId: 道具id
function UIItemBuyPanel:setData(data, callback)
    
    self.data = data
    self.m_callback = callback
    local itemData = luaCfg:get_item_by(data.itemId)
    self.itemData = itemData
    -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    -- self.icon:setSpriteFrame(itemData.itemIcon)
    global.panelMgr:setTextureFor(self.icon,itemData.itemIcon)
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",itemData.quality))
    self.name:setString(itemData.itemName)

    --　效果参数
    self.param = {}
    for i=1,2 do
        if itemData["effectPara"..i] ~= 0 then
            table.insert(self.param, itemData["effectPara"..i])
        end
    end
    self.effect:setString(string.format(luaCfg:get_local_string(itemData.effectDes),unpack(self.param)))
    self.effectDes = itemData.effectDes

    self:checkDiamondEnough(data.diamondNum)
    self.diamond_num:setString(data.diamondNum)
    --　当前所拥有的魔晶数量
    self.sliderControl:setMaxCount(data.maxCount)
    self.desc:setString(string.format(luaCfg:get_local_string(10067),  itemData.itemName))
end

function UIItemBuyPanel:sliderUpdate()

    if self.param ~= nil then  
        local param = {}
        local num =  self.sliderControl:getContentCount()
        for _,v in pairs(self.param) do
            -- table.insert(param, v*num)
            if  self.itemData.itemType == 101 then 
                table.insert(param, global.funcGame:_formatBigNumber(v*num , 2))
            else 
                table.insert(param, v*num)
            end 
        end
        self.effect:setString(string.format(luaCfg:get_local_string(self.effectDes),  unpack(param)))
    end

    local num =  self.sliderControl:getContentCount()
    self.diamond_num:setString(self.data.diamondNum*num)
    self:checkDiamondEnough(self.data.diamondNum*num)
end

function UIItemBuyPanel:checkDiamond()
    
    local num =  self.sliderControl:getContentCount()
    self.diamond_num:setString(self.data.diamondNum*num)
    self:checkDiamondEnough(self.data.diamondNum*num)
end

function UIItemBuyPanel:checkDiamondEnough(num)
    if not propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.diamond_num:setColor(gdisplay.COLOR_RED)
        return false
    else
        self.diamond_num:setColor(gdisplay.COLOR_WHITE)
        return true
    end
end

function UIItemBuyPanel:onEnter()
    
    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function()        
        self:checkDiamond()
    end) 
end

function UIItemBuyPanel:exit(sender, eventType)
    
    global.panelMgr:closePanel("UIItemBuyPanel")
end

function UIItemBuyPanel:use_call(sender, eventType)

    -- 魔晶是否足够
    local num = tonumber(self.diamond_num:getString())
    if not self:checkDiamondEnough(num) then
        global.panelMgr:openPanel("UIRechargePanel")
        return
    end
    
    local selectNum =  self.sliderControl:getContentCount()
    local getCount = selectNum*self.itemData.effectPara1
    local userCall = function ()
        if not self.data then return end
        local data = {id=self.data.itemId, count=selectNum, getCount=getCount}
        self.m_callback( data, handler(self, self.exitCall))
    end

    local buy = function ()
   
        local mainCityId = global.userData:getWorldCityID()
        -- 如果被占领，则提示资源占领分成信息
        if (self.itemData.itemType == 101 or self.itemData.itemType == 120) and mainCityId~=0 then
            
            global.worldApi:getCityData(mainCityId,function(msg)

                local occupierData = msg.lCitys.tagCityOwner
                if not occupierData then
                    userCall()
                else
                    local panel = global.panelMgr:openPanel("UIPromptPanel")
                    panel:setData("OccupyResUse", function()
                        userCall()
                    end)
                end
            end)
        else
            userCall()
        end
    end

    if self.data.curResId then
        -- 判断是否满仓
        local itemD = luaCfg:get_item_by(self.data.curResId)
        local name = itemD.itemName
        local per,resData,maxNum = global.resData:getPropPer(self.data.curResId)
        local leftCount = selectNum*self.itemData.effectPara1 + global.propData:getProp(self.data.curResId) - maxNum
        local str = luaCfg:get_local_string(10693, name, leftCount, name)
        if leftCount > 0 then
            getCount = selectNum*self.itemData.effectPara1 - leftCount
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData(str, function()
                buy()
            end)
            return
        else
            buy()
        end
    else
        buy()
    end
    
end


function UIItemBuyPanel:exitCall()
    if self.exit then 
        self:exit()
    end 
end

--CALLBACKS_FUNCS_END

return UIItemBuyPanel

--endregion
