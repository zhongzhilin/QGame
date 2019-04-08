--region UIGIftPanel.lua
--Author : anlitop
--Date   : 2017/03/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIGIftPanel  = class("UIGIftPanel", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UICifItemCell =  require("game.UI.gift.UICifItemCell")
function UIGIftPanel:ctor()
    self:CreateUI()
end

function UIGIftPanel:CreateUI()
    local root = resMgr:createWidget("gift/gift_main_ui")
    self:initUI(root)
end

function UIGIftPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "gift/gift_main_ui")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.gift_bg = self.root.gift_bg_export
    self.diaCurNum = self.root.diaCurNum_export
    self.diamond_icon_sprite = self.root.diamond_icon_sprite_export
    self.btn_magic_discount = self.root.btn_magic_discount_export
    self.oldPrice = self.root.btn_magic_discount_export.oldPrice_export
    self.linePic = self.root.btn_magic_discount_export.oldPrice_export.linePic_export
    self.gift_discount_newprice_text = self.root.btn_magic_discount_export.gift_discount_newprice_text_export
    self.timer_node = self.root.timer_node_export
    self.time_text = self.root.timer_node_export.time_text_mlan_3_export
    self.gitf_overtime_text = self.root.timer_node_export.gitf_overtime_text_export
    self.gift_top_node = self.root.gift_top_node_export
    self.gift_bottom_node = self.root.gift_bottom_node_export
    self.gift_content_node = self.root.gift_content_node_export
    self.gift_add_node = self.root.gift_add_node_export
    self.gift_item_content_node = self.root.gift_item_content_node_export
    self.close_noe = self.root.close_noe_export
    self.close_noe = CloseBtn.new()
    uiMgr:configNestClass(self.close_noe, self.root.close_noe_export)
    self.union_gift_text = self.root.union_gift_text_mlan_18_export
    self.gift_name = self.root.gift_name_bg.gift_name_export

    uiMgr:addWidgetTouchHandler(self.btn_magic_discount, function(sender, eventType) self:bt_gift_discount_buy(sender, eventType) end)
--EXPORT_NODE_END

    self.union_gift_text_mlan_export =  self.union_gift_text
    self.tableView = UITableView.new()
        :setSize(self.gift_content_node:getContentSize(), self.gift_top_node, self.gift_bottom_node)
        :setCellSize(self.gift_item_content_node:getContentSize()) 
        :setCellTemplate(UICifItemCell) 
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.gift_add_node:addChild(self.tableView)

    self.close_noe:setData(function ()
        self.dropData = nil 
    global.panelMgr:closePanel("UIGiftPanel")
    end)

end

--banner

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGIftPanel:setData(data, call)

    self.data = data
    self.m_call = call
    if self.data.resource =="0" or not  self.data.resource then 
    else 
        self.diamond_icon_sprite:setSpriteFrame(self.data.resource)
    end 
    self.diaCurNum:setString(self.data.resource_num)

    if not self.data.lEndTime then
         self.data.lEndTime = global.dailyTaskData:getCurZeroTime()
    end 

    self.data.time = self.data.lEndTime - global.dataMgr:getServerTime()

    self:upateUI()

    if  self.data.time >= 0 then 
        if not self.timer then 
            self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTimeUI), 1)
        end
        self:updateOverTimeUI()
    end 


    --print(data.type,"111111111111111111111")

    if data.type  ==global.EasyDev.AD_UNION_TYPE then 
         self.union_gift_text_mlan_export:setVisible(true )
    else 
         self.union_gift_text_mlan_export:setVisible(false )
    end 

    --润稿翻译处理 张亮
    global.tools:adjustNodePos(self.time_text,self.gitf_overtime_text,-10)

end 

function UIGIftPanel:upateUI()

    local dropData = global.luaCfg:get_drop_by(self.data.dropid).dropItem  
    self.dropData = dropData
    self.tableView:setData(dropData)
    if self.data.banner ~= ""  and  self.data.banner then 
        -- self.gift_bg:setSpriteFrame(self.data.banner)  
        global.panelMgr:setTextureFor(self.gift_bg,self.data.banner)
    end 
    self.oldPrice:setString(self.data.unit..self.data.price)
    self.linePic:setContentSize(cc.size(self.oldPrice:getContentSize().width, self.linePic:getContentSize().height))
    self.gift_discount_newprice_text:setString(self.data.unit..self.data.cost)
    self.gift_name:setString(self.data.name)
end 


function UIGIftPanel:updateOverTimeUI()
    self.data.time =self.data.lEndTime - global.dataMgr:getServerTime()
    -- local curr = global.dataMgr:getServerTime()
    -- local rest = math.floor(self.lEndTime - curr)
    if  self.data.time  < 0 then 
        if self.timer then
            gscheduler.unscheduleGlobal(self.timer)
            self.timer = nil
        end
        -- return
         self.data.time  = 0 
    end 
    self.gitf_overtime_text:setString(global.funcGame.formatTimeToHMS( self.data.time ))

end         


function UIGIftPanel:bt_gift_discount_buy(sender, eventType)

    -- 暂时屏蔽充值功能
    -- if _CPP_RELEASE == 1 then
    --     global.tipsMgr:showWarning("testPrompt")
    -- else

        -- 暂时使用魔晶模拟充值
        -- global.itemApi:diamondUse(function (msg)
        --     self.m_call(self.data)
        -- end, 100, self.data.id)

        global.sdkBridge:app_sdk_pay(self.data.id,function()
            -- body
            self.m_call(self.data)
        end)
    -- end

end

function UIGIftPanel:onExit( )
    if self.timer then
        gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end
end

--CALLBACKS_FUNCS_END

return UIGIftPanel

--endregion
