--region UIItemUsePanel.lua
--Author : yyt
--Date   : 2016/11/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local CountSliderControl = require("game.UI.common.UICountSliderControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIItemUsePanel  = class("UIItemUsePanel", function() return gdisplay.newWidget() end )

function UIItemUsePanel:ctor()
    self:CreateUI()
end

function UIItemUsePanel:CreateUI()
    local root = resMgr:createWidget("common/item_use")
    self:initUI(root)
end

function UIItemUsePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/item_use")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.title.name_export
    self.desc = self.root.Node_export.desc_export
    self.slider = self.root.Node_export.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.slider_export.cur)
    self.icon_bg = self.root.Node_export.icon_bg_export
    self.icon = self.root.Node_export.icon_export
    self.effect = self.root.Node_export.effect_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_4_0, function(sender, eventType) self:use_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_4, function(sender, eventType) self:chooseAll(sender, eventType) end)
--EXPORT_NODE_END
    self.slider.cur = self.cur
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.sliderControl = CountSliderControl.new(self.slider,handler(self,self.sliderUpdate) , true)
    self.effectDes = 0
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

---- itemId = 10041  道具id
---- maxCount = 100  使用最大值
---- data  {itemId = 10041, maxCount = 100, curResId = 1,isBag=true}
function UIItemUsePanel:setData(data, callback,checkParaFunc)
    -- body
    self.data = data
    self.m_callback = callback
    self.sliderControl:setMaxCount(data.maxCount)   
    self.checkParaFunc = checkParaFunc

    local maxNum = data.maxCount
    if maxNum <= 0 then
        -- self.sliderControl:setMaxCount(maxNum)
        self.sliderControl:reSetMaxCount(maxNum)
    else
        self.sliderControl:setMaxCount(maxNum)
    end

    local itemData = luaCfg:get_item_by(data.itemId)
    self.itemData = itemData

    --　效果参数
    self.param = {}
    for i=1,2 do
        if itemData["effectPara"..i] ~= 0 then
            table.insert(self.param, itemData["effectPara"..i])
        end
    end

    if self.checkParaFunc then self.checkParaFunc(self.param) end

    self.effect:setVisible(itemData.effectDes ~= 0)
    self.effect:setString(string.format(luaCfg:get_local_string(itemData.effectDes),unpack(self.param)))
    self.effectDes = itemData.effectDes

    -- self.icon:setSpriteFrame(itemData.itemIcon)
    -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",itemData.quality))
    global.panelMgr:setTextureFor(self.icon,itemData.itemIcon)
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",itemData.quality))
    self.name:setString(itemData.itemName)
    
    self.desc:setString(string.format(luaCfg:get_local_string(10060),  itemData.itemName))

    self:sliderUpdate()
end

function UIItemUsePanel:sliderUpdate()

    if self.param == nil then return end
    local param = {}
    local num =  self.sliderControl:getContentCount()
    for _,v in pairs(self.param) do
       if  self.itemData.itemType == 101 then 
            if type(v) == "number" and type(num) == "number" then  
                local value=  v * num
                table.insert(param, global.funcGame:_formatBigNumber(value , 2))
            end 
        else 
            table.insert(param, v*num)
        end 
    end
    if self.checkParaFunc then self.checkParaFunc(param) end
    self.effect:setString(string.format(luaCfg:get_local_string(self.effectDes),  unpack(param)))
end

function UIItemUsePanel:exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIItemUsePanel")
end

function UIItemUsePanel:use_call(sender, eventType)

    local selectNum =  self.sliderControl:getContentCount()
    local getCount = selectNum*self.itemData.effectPara1
    local userCall = function ()      
        if self.m_callback then 
            self.m_callback(selectNum, handler(self, self.exitCall), getCount)
        end
    end

    local buy = function ()

        local mainCityId = global.userData:getWorldCityID()

        if not self.itemData then 
            -- protect 
            return 
        end 

        -- 如果被占领，则提示资源占领分成信息
        if (self.itemData.itemType == 101 or self.itemData.itemType == 120) and mainCityId~=0 then
            
            global.worldApi:getCityData(mainCityId,function(msg)

                msg = msg or {}
                msg.lCitys = msg.lCitys or {}
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

    -- 判断是否满仓
    if self.data.curResId or self.data.isBag then

        if self.data.isBag then           
            local dropD = luaCfg:get_drop_by(self.itemData.typePara1)
            self.data.curResId = dropD.dropItem[1][1]
        end
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

function UIItemUsePanel:exitCall()

    if self.exit then 
        self:exit()
    end 
end

function UIItemUsePanel:chooseAll(sender, eventType)
    self.sliderControl:chooseAll()
end
--CALLBACKS_FUNCS_END

return UIItemUsePanel

--endregion
