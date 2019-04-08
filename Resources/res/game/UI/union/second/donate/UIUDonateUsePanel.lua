--region UIUDonateUsePanel.lua
--Author : wuwx
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIUDonateUsePanel  = class("UIUDonateUsePanel", function() return gdisplay.newWidget() end )

function UIUDonateUsePanel:ctor()
    self:CreateUI()
end

function UIUDonateUsePanel:CreateUI()
    local root = resMgr:createWidget("union/union_donate_item1")
    self:initUI(root)
end

function UIUDonateUsePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_donate_item1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.bg.title.name_mlan_12_export
    self.slider = self.root.Node_export.bg.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.Node_export.bg.slider_export.cur)
    self.icon_bg = self.root.Node_export.bg.icon_bg_export
    self.icon = self.root.Node_export.bg.icon_export
    self.type3 = self.root.Node_export.type3_mlan_3_export
    self.text3 = self.root.Node_export.type3_mlan_3_export.text3_export
    self.type2 = self.root.Node_export.type2_mlan_5_export
    self.text2 = self.root.Node_export.type2_mlan_5_export.text2_export
    self.type1 = self.root.Node_export.type1_mlan_5_export
    self.text1 = self.root.Node_export.type1_mlan_5_export.text1_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.bg.donate, function(sender, eventType) self:onDonate(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.bg.buy, function(sender, eventType) self:onBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.bg.select_all, function(sender, eventType) self:select_all_click(sender, eventType) end)
--EXPORT_NODE_END
    self.slider.cur = self.cur
    
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)

    local CountSliderControl = require("game.UI.common.UICountSliderControl")
    self.sliderControl = CountSliderControl.new(self.slider,function(count)
        -- body
        local itemData = global.luaCfg:get_item_by(self.data.itemID)
        self.text1:setString("+"..math.floor(count*self.data.num))
        self.text2:setString("+"..math.floor(count*self.data.boom))
        self.text3:setString(count..""..itemData.itemName)
    end , true)

    self.sliderControl.formatCall = function (num) 
        return  global.funcGame:_formatBigNumber(num,  2)
    end
    global.funcGame:initBigNumber(self.slider.max, 2)
    global.funcGame:initBigNumber(self.text3, 2)

end


function UIUDonateUsePanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function() 
        if self.data then
            self:setData(self.data)
        end
    end)

end 

function UIUDonateUsePanel:setData(data)
    self.data = data
    local itemData = global.luaCfg:get_item_by(data.itemID)

    local quality = itemData.quality
    if quality == 0 then quality = 1 end
    -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",quality))
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",quality))

    local maxCount = 0
    if data.type == 1 or data.type == 3 then
        maxCount = global.propData:getProp(data.itemID)
    else
        maxCount = global.normalItemData:getItemById(data.itemID).count
    end
    if maxCount <= 0 then
        self.sliderControl:setMaxCount(maxCount)
        self.sliderControl:reSetMaxCount(maxCount)
        self.Node.bg.donate:setEnabled(false)
    else
        self.sliderControl:setMaxCount(maxCount)
        if data.display > maxCount then
            self.sliderControl:changeCount(maxCount)
        else
            self.sliderControl:changeCount(data.display)
        end
        self.Node.bg.donate:setEnabled(true)
    end

    if data.icon == "" then
        local itemIcon = itemData.itemIcon
        -- self.icon:setSpriteFrame(itemIcon)
        global.panelMgr:setTextureFor(self.icon,itemIcon)
    else
        -- self.icon:setSpriteFrame(data.icon)
        global.panelMgr:setTextureFor(self.icon,data.icon)
    end
    local itemData = global.luaCfg:get_item_by(data.itemID)
    local count = self.sliderControl:getContentCount()
    self.text1:setString("+"..math.floor(count*self.data.num))
    self.text2:setString("+"..math.floor(count*self.data.boom))
    self.text3:setString(count.." "..itemData.itemName)



    if not self.btnUsePoint then 
        self.btnUsePoint ={} 
        self.btnUsePoint.x ,self.btnUsePoint.y = self.root.Node_export.bg.donate:getPosition()
    end 

    self.root.Node_export.bg.select_all:setVisible(false)
    self.root.Node_export.bg.buy:setVisible(false)

    self.root.Node_export.bg.donate:setPosition(cc.p(self.btnUsePoint.x,self.btnUsePoint.y))


    local adjustps = function()  
            local cx=  self.Node.bg:getContentSize().width/2
            self.root.Node_export.bg.donate:setPosition(cc.p(cx,self.root.Node_export.bg.donate:getPositionY()))
    end 

    if self.data.type == 2   then

        if global.ShopData:checkInShop(self.data.itemID)  then     

             self.root.Node_export.bg.buy:setVisible(true)

        else --不在商品列表中

            if global.ShopData:checkCanUseAll(self.data.itemID) and self.data.itemID ~=6 then  --能使用全选

                self.root.Node_export.bg.select_all:setVisible(true)

                self.root.Node_export.bg.select_all:setEnabled(global.ShopData:getItemNumber(self.data.itemID) > 0 )
                
            else
                adjustps()
            end 
           
        end

    else 

        if self.data.itemID  == 6 then 
            adjustps()
        else 

            self.root.Node_export.bg.buy:setVisible(true)

        end 
    end 

    
    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.text1:getParent(),self.text1)
    global.tools:adjustNodePosForFather(self.text2:getParent(),self.text2)
    global.tools:adjustNodePosForFather(self.text3:getParent(),self.text3)


end




--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIUDonateUsePanel:exit(sender, eventType)
    global.panelMgr:closePanel("UIUDonateUsePanel")
end

function UIUDonateUsePanel:onDonate(sender, eventType)
    local itemData = global.luaCfg:get_item_by(self.data.itemID)
    local count = self.sliderControl:getContentCount()
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("UnionDonate01", function()
        global.unionApi:donateAllyEndow(function(msg)
            global.panelMgr:closePanel("UIUDonateUsePanel")
            global.tipsMgr:showWarning("UnionDonate02",math.floor(count*self.data.num),math.floor(count*self.data.boom))
        end,self.data.itemID,count)
    end,count,itemData.itemName)
end
 

function UIUDonateUsePanel:addItem_click()
     global.ShopData:buyShop(self.data.itemID, function() self:reFresh() end)

end


function UIUDonateUsePanel:reFresh()
    self:setData(self.data)
end 

function UIUDonateUsePanel:onBuy(sender, eventType)
    if self.data.type == 1 then -- 材料捐献
        local getPanel = global.panelMgr:openPanel("UIResGetPanel")
        getPanel:setData(global.resData:getResById(self.data.itemID))
    elseif self.data.type == 2 then --道具捐献
        self:addItem_click()
    elseif self.data.type == 3 then -- 魔镜捐献
        global.panelMgr:openPanel("UIRechargePanel")
    end
end

function UIUDonateUsePanel:select_all_click(sender, eventType)
     self.sliderControl:chooseAll()
end
--CALLBACKS_FUNCS_END

return UIUDonateUsePanel

--endregion
