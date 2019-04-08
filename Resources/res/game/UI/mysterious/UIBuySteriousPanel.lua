--region UIBuySteriousPanel.lua
--Author : anlitop
--Date   : 2017/03/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIBuySteriousPanel  = class("UIBuySteriousPanel", function() return gdisplay.newWidget() end )

function UIBuySteriousPanel:ctor()
    self:CreateUI()
end

function UIBuySteriousPanel:CreateUI()
    local root = resMgr:createWidget("random_shop/random_buy_shop")
    self:initUI(root)
end

function UIBuySteriousPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "random_shop/random_buy_shop")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.bg.title.name_export
    self.descText = self.root.Node_export.bg.descText_export
    self.icon_bg = self.root.Node_export.bg.icon_bg_export
    self.icon = self.root.Node_export.bg.icon_bg_export.icon_export
    self.btn_gold_normal = self.root.Node_export.btn_gold_normal_export
    self.node_gray1 = self.root.Node_export.btn_gold_normal_export.node_gray1_export
    self.gold_normal_text = self.root.Node_export.btn_gold_normal_export.gold_normal_text_export
    self.btn_magic_normal = self.root.Node_export.btn_magic_normal_export
    self.node_gray1 = self.root.Node_export.btn_magic_normal_export.node_gray1_export
    self.magic_normal_text = self.root.Node_export.btn_magic_normal_export.magic_normal_text_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    uiMgr:addWidgetTouchHandler(self.btn_gold_normal, function(sender, eventType) self:ongold_normal_buy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_magic_normal, function(sender, eventType) self:onmagic_normal_buy(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBuySteriousPanel:setData(data)
    self.data =data
    self:updateUI()
end 

function UIBuySteriousPanel:updateUI()
    
    self.name:setString(self.data.name)
    -- self.icon:setSpriteFrame(self.data.information.itemIcon)
    -- self.icon_bg:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",self.data.information.quality))
    global.panelMgr:setTextureFor(self.icon,self.data.information.itemIcon or self.data.information.icon)
    global.panelMgr:setTextureFor(self.icon_bg,string.format("icon/item/item_bg_0%d.png",self.data.information.quality))

    if self.data.type ==1  then  -- 消耗金币
        self.btn_gold_normal:setVisible(true)
        self.btn_magic_normal:setVisible(false)
        self.gold_normal_text:setString(self.data.cost)
    elseif self.data.type ==2  then --还是魔晶
        self.btn_magic_normal:setVisible(true)
        self.btn_gold_normal:setVisible(false)
        self.magic_normal_text:setString(self.data.cost)
    end
    self.descText:setString(self.data.information.itemDes or self.data.information.des)
end 

-- required    int32       lType   = 1; // 0拉取列表 1购买商品 2刷新随机商品
-- optional    int32       localId = 2; //购买商品id   
function UIBuySteriousPanel:BuyRequest()
    local itemId = self.data.ID
    local typeId = 1
    local count = 1 
    global.SecretShopAPI:mysteriousReq(typeId,itemId,function(ret,msg)
         if ret.retcode == 0 then
            if not self.data then return end
            global.panelMgr:closePanel("UIBuySteriousPanel")
            global.tipsMgr:showWarning("shop03",count ,self.data.name)
            global.panelMgr:getPanel("UIMysteriousPanel"):RequestData(0)
            self.data.parentRef.refreshItemPosition =self.data.position
        end 
    end)
end 

function UIBuySteriousPanel:exit_call(sender, eventType)
      global.panelMgr:closePanel("UIBuySteriousPanel")
end

function UIBuySteriousPanel:ongold_normal_buy(sender, eventType)
    self:BuyRequest()
end

function UIBuySteriousPanel:onmagic_normal_buy(sender, eventType)
    self:BuyRequest()
end
--CALLBACKS_FUNCS_END

return UIBuySteriousPanel

--endregion
