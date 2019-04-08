--region UIFundItem.lua
--Author : anlitop
--Date   : 2017/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIFundItem  = class("UIFundItem", function() return gdisplay.newWidget() end )
local UIBagItem = require("game.UI.bag.UIBagItem")
local UITableView =  require("game.UI.common.UITableView")
local UIRewardItemCell = require("game.UI.activity.cell.UIRewardItemCell")

function UIFundItem:ctor()
    self:CreateUI()
end

function UIFundItem:CreateUI()
    local root = resMgr:createWidget("fund/fund_list")
    self:initUI(root)
end

function UIFundItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "fund/fund_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title_text = self.root.title_bg.title_text_export
    self.icon = self.root.icon_export
    self.compete = self.root.compete_export
    self.get = self.root.get_export
    self.number = self.root.number_export
    self.item_node = self.root.item_node_export
    self.item_name = self.root.item_node_export.item_name_export
    self.progress_node = self.root.progress_node_export
    self.now_text = self.root.progress_node_export.now_text_export
    self.target_text = self.root.progress_node_export.target_text_export
    self.scrollView = self.root.reward_bg.scrollView_export
    self.table_add = self.root.table_add_export
    self.table_item = self.root.table_item_export
    self.table_contont = self.root.table_contont_export

    uiMgr:addWidgetTouchHandler(self.get, function(sender, eventType) self:getRewardHandler(sender, eventType) end)
--EXPORT_NODE_END
    

    self.tableView = UITableView.new()
        :setSize(self.table_contont:getContentSize())-- 璁剧疆澶у皬锛 scrollview婊戝姩鍖哄煙锛堝畾浣嶇疆锛 浣庝綅缃級
        :setCellSize(self.table_item:getContentSize()) -- 姣忎釜灏廼ntem 鐨勫ぇ灏
        :setCellTemplate(UIRewardItemCell) -- 鍥炶皟鍑芥暟
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
        :setColumn(1)
    self.table_add:addChild(self.tableView)


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- 魔晶库和开服基金
-- required int32      lKind = 1;  //1存款 2基金
-- required int32      lType = 2;  //操作档位
-- required int32      lOperate = 3;   //操作类型0查看1储蓄2取出/领取
-- optional int32      lParam = 4;  //操作数量  
-- optional int64      lTarget = 5;    //操作目标

function UIFundItem:getRewardHandler(sender, eventType)
    

   if  self.state == 0  then 
        if self.data.type ==1 then 
            global.tipsMgr:showWarning("fund03" , self.data.citylv)
        else 
            global.tipsMgr:showWarning("fund04" , self.data.citylv)

        end 
        return     
   end 
    
    local call = nil 

    if  self.data.type == 1 then 

        call = function () 

            local item = global.luaCfg:get_drop_by(self.data.drop).dropItem
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(item)

            local x, y = self.get:convertToWorldSpace(cc.p(0,0))
            global.EasyDev:playHarvestEffect(x, y, tonumber(self.data.mojing) ,function () 
            end)
        end 
     
    elseif  self.data.type == 2  then 

        call = function () 

            local item = global.luaCfg:get_drop_by(self.data.mojing).dropItem
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(item)

        end 
    end 


    global.itemApi:bankAction(function (msg)
        if call then 
            call()
        end 
    end , 2 , self.data.type , 2 , self.data.ID)

end

local corlor = {
    
    red  = gdisplay.COLOR_RED , 

    unred= cc.c3b( 255 ,226 ,165)
} 


function UIFundItem:setData(data)

    if self.item and not tolua.isnull(self.item) then 
        self.item:removeFromParent()
    end 

    self.data = data 

    self.number:setString(self.data.mojing)

    self.number:setVisible(self.data.type== 1 )

    self.icon:setVisible(self.data.type== 1 )

    self.compete:setVisible(false)
    self.get:setVisible(false)
    global.colorUtils.turnGray(self.get,  false)

    self.item_node:setVisible(self.data.type == 2 )
    self.progress_node:setVisible(self.data.type == 2 )

    self.now_text:setTextColor(corlor.red)

    local id = 0 

    self.state =global.propData:getFundState(self.data.ID)

    if self.data.type == 2 then 

        self.item = UIBagItem.new()
        self.item:setScale(0.73)
        self.item_node:addChild(self.item)

        local data = {} 
        data.count = global.luaCfg:get_drop_by(self.data.mojing).dropItem[1][2]
        data.id = global.luaCfg:get_drop_by(self.data.mojing).dropItem[1][1]

        self.item:setData(data)

        self.item_name:setString(global.luaCfg:get_item_by(data.id).itemName)

        id = 10899

        self.now_text:setString(global.propData:getFundInfo().lCurCount)
        self.target_text:setString("/"..self.data.citylv)

        global.tools:adjustNodePos( self.now_text, self.target_text)

    elseif self.data.type == 1 then  

        id = 10898

        global.panelMgr:setTextureFor(self.icon,self.data.icon)

        -- local level = global.cityData:getMainCityLevel()

        self.drop_data = {} 

        for _ ,v in pairs(clone(global.luaCfg:get_drop_by(self.data.drop).dropItem)) do 
            local temp_data   = {}
            temp_data.data = global.luaCfg:get_local_item_by(v[1])
            temp_data.number= v[2]
            table.insert(self.drop_data , temp_data)
        end 

        for _ ,v in pairs(self.drop_data) do 
            v.tips_panel =global.panelMgr:getPanel("UIFundPanel")
        end
        for _ ,v in pairs(self.drop_data) do 
            v.scale = 1.285
            v.isshownumber = false 
        end 

        self.tableView:setData(self.drop_data)
    end  

   if  self.state == 0  then 

        self.get:setVisible(true)

        global.colorUtils.turnGray(self.get,  true)

    elseif  self.state  == 1 then 

        self.get:setVisible(true)
        self.now_text:setTextColor(corlor.unred)

    elseif self.state  == 2 then 

        self.compete:setVisible(true)

        self.progress_node:setVisible(false )

    end 

    self.title_text:setString( string.format( global.luaCfg:get_translate_string(id), self.data.citylv) )


end 

function UIFundItem:setTBTouchEable(state)

    if state then 
        if not  self.tableView:isTouchEnabled()  then 

            self.tableView:setTouchEnabled(true)
        end
    else 
        
        self.tableView:setTouchEnabled(false)
    end 
end 


--CALLBACKS_FUNCS_END

return UIFundItem

--endregion
