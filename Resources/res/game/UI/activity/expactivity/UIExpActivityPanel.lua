--region UIExpActivityPanel.lua
--Author : anlitop
--Date   : 2017/09/12
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIExpActivityPanel  = class("UIExpActivityPanel", function() return gdisplay.newWidget() end )

local UITableView =  require("game.UI.common.UITableView")
local UIRewardItemCell = require("game.UI.activity.cell.UIRewardItemCell")
local UIItemTipsControl = require("game.UI.common.UIItemTipsControl")
local luaCfg = global.luaCfg

function UIExpActivityPanel:ctor()
    self:CreateUI()
end

function UIExpActivityPanel:CreateUI()
    local root = resMgr:createWidget("activity/exp_activity/act_normal_panel")
    self:initUI(root)
end

function UIExpActivityPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/exp_activity/act_normal_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.bt_bg = self.root.Node_export.bg.bt_bg_export
    self.btn_node = self.root.Node_export.bg.bt_bg_export.btn_node_export
    self.banner = self.root.Node_export.bg.banner_export
    self.act_name = self.root.Node_export.bg.act_name_export
    self.close = self.root.Node_export.close_export
    self.close = CloseBtn.new()
    uiMgr:configNestClass(self.close, self.root.Node_export.close_export)
    self.tb_top = self.root.Node_export.tb_top_export
    self.tb_bottom = self.root.Node_export.tb_bottom_export
    self.tb_add = self.root.Node_export.tb_add_export
    self.table_contont = self.root.Node_export.table_contont_export
    self.table_item = self.root.Node_export.table_item_export
    self.ScrollView_1 = self.root.Node_export.ScrollView_1_export
    self.desc_text = self.root.Node_export.ScrollView_1_export.desc_text_export

    uiMgr:addWidgetTouchHandler(self.root.touch, function(sender, eventType) self:close_panel(sender, eventType) end)
--EXPORT_NODE_END

    self.close:setData(function()
        self:close_panel(0)
    end)

    self.tableView = UITableView.new()
        :setSize(self.table_contont:getContentSize())-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.table_item:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIRewardItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
        :setColumn(1)
    self.tb_add:addChild(self.tableView)

    self.tips_node = cc.Node:create()
    self.root:addChild(self.tips_node)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIExpActivityPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE , function () 
        if self.data then 
            self:setData(self.data)
        end 
    end)
    
end 

function UIExpActivityPanel:setData(data)

    self.data = data 

    self.banner:loadTexture(self.data.banner, ccui.TextureResType.plistType)

    uiMgr:setRichText(self, "desc_text", self.data.desc)

    local size = self.desc_text:getRichTextSize()

    self.ScrollView_1:setInnerContainerSize(cc.size(size.width,size.height))

    if size.height <  self.ScrollView_1:getContentSize().height then 
        self.desc_text:setPositionY(self.ScrollView_1:getContentSize().height - 15 )
    else 
        self.desc_text:setPositionY(size.height)
    end 

    self.ScrollView_1:jumpToTop()

    self.act_name:setString(self.data.name)

    self.bt_bg:setVisible(#self.data.btn > 0 )


   local drop =  global.ActivityData:getDropItemByDropID(self.data.reward)

    for _ ,v in pairs(drop) do 

        v.tips_panel  = self
        v.scale = 1.4
    end 

    if global.ActivityData:isShowNumberActiviy(self.data.activity_id) then  --是否显示数字 
        for _ ,v in  pairs(drop) do  
            v.isshownumber = true 
         end
    end 

    self.tableView:setData(drop)

    if #self.data.btn > 0 then 
        self:initBtn()
    end 

end 



function UIExpActivityPanel:initBtn()

    local btnCount = #self.data.btn

    print(btnCount,"btnCount")

    local btnNode = resMgr:createWidget("activity/activity_btns/btn_" .. btnCount)
    self.btn_node:removeAllChildren()
    self.btn_node:addChild(btnNode)

    uiMgr:configUITree(btnNode)

    -- dump(self.data.btn)
    -- dump(btnNode)
    for index, panel_index in pairs(self.data.btn) do

        print(panel_index ,  "panel_index ////////")

        local btn = btnNode["btn_" .. index]

        local btn_item =luaCfg:get_btn_by(self.data.btn[index])

        btn.text:setString(btn_item.name)

        btn:loadTextures(btn_item.pic,btn_item.pic,nil,ccui.TextureResType.plistType)

        uiMgr:addWidgetTouchHandler(btn, function(sender, eventType) 

            local call = global.ActivityData:getCallBack("UIExpActivityPanel" , panel_index , self.data )
            if call then 
                call()
            end 
        end)
    end
end


function UIExpActivityPanel:close_panel(sender, eventType)

    global.panelMgr:closePanel("UIExpActivityPanel")

end


function UIExpActivityPanel:onExit()

    gsound.stopEffect("city_click")

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
end 

--CALLBACKS_FUNCS_END

return UIExpActivityPanel

--endregion
