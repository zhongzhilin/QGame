--region UIStorePanel.lua
--Author : anlitop
--Date   : 2017/06/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr

local luaCfg = global.luaCfg
local propData = global.propData
local gameEvent = global.gameEvent
local shopData=  global.ShopData 
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local shopwidget = require("game.UI.bag.shopwidget")
--REQUIRE_CLASS_END

local UIStorePanel  = class("UIStorePanel", function() return gdisplay.newWidget() end )

local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
local UIBagUseBoard = require("game.UI.bag.UIBagUseBoard")
local UIBagTableView = require("game.UI.bag.UIBagTableView")
local UIBagItemCell = require("game.UI.bag.UIBagItemCell")
local TabControl = require("game.UI.common.UITabControl")
local UIEquipTableView = require("game.UI.equip.UIEquipTableView")
local UIEquipItemCell = require("game.UI.equip.UIEquipItemCell")
-- mall 
local UITableView = require("game.UI.common.UITableView")
local mall_small_cell = require("game.UI.bag.UIMallsmallitemCell")
local ShopTopItemCell = require("game.UI.bag.UIShopTopItemCell")

function UIStorePanel:ctor()
    self:CreateUI()
end

function UIStorePanel:CreateUI()
    local root = resMgr:createWidget("store/store_panel")
    self:initUI(root)
end

function UIStorePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "store/store_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.shop_node = self.root.shop_node_export
    self.shop_top1 = self.root.shop_node_export.shop_top1_export
    self.item1 = shopwidget.new()
    uiMgr:configNestClass(self.item1, self.root.shop_node_export.shop_top1_export.item1)
    self.btn_top1_normal = self.root.shop_node_export.shop_top1_export.btn_top1_normal_export
    self.node_gray1 = self.root.shop_node_export.shop_top1_export.btn_top1_normal_export.node_gray1_export
    self.text1 = self.root.shop_node_export.shop_top1_export.btn_top1_normal_export.text1_export
    self.btn_top1_discount = self.root.shop_node_export.shop_top1_export.btn_top1_discount_export
    self.node_gray2 = self.root.shop_node_export.shop_top1_export.btn_top1_discount_export.node_gray2_export
    self.oldprice_text = self.root.shop_node_export.shop_top1_export.btn_top1_discount_export.oldprice_text_export
    self.newprice_text = self.root.shop_node_export.shop_top1_export.btn_top1_discount_export.newprice_text_export
    self.shop_top2 = self.root.shop_node_export.shop_top2_export
    self.item2 = shopwidget.new()
    uiMgr:configNestClass(self.item2, self.root.shop_node_export.shop_top2_export.item2)
    self.btn_top2_normal = self.root.shop_node_export.shop_top2_export.btn_top2_normal_export
    self.node_gray1 = self.root.shop_node_export.shop_top2_export.btn_top2_normal_export.node_gray1_export
    self.text1 = self.root.shop_node_export.shop_top2_export.btn_top2_normal_export.text1_export
    self.btn_top2_discount = self.root.shop_node_export.shop_top2_export.btn_top2_discount_export
    self.node_gray2 = self.root.shop_node_export.shop_top2_export.btn_top2_discount_export.node_gray2_export
    self.oldprice_text = self.root.shop_node_export.shop_top2_export.btn_top2_discount_export.oldprice_text_export
    self.newprice_text = self.root.shop_node_export.shop_top2_export.btn_top2_discount_export.newprice_text_export
    self.shop_top3 = self.root.shop_node_export.shop_top3_export
    self.item3 = shopwidget.new()
    uiMgr:configNestClass(self.item3, self.root.shop_node_export.shop_top3_export.item3)
    self.btn_top3_normal = self.root.shop_node_export.shop_top3_export.btn_top3_normal_export
    self.node_gray1 = self.root.shop_node_export.shop_top3_export.btn_top3_normal_export.node_gray1_export
    self.text1 = self.root.shop_node_export.shop_top3_export.btn_top3_normal_export.text1_export
    self.btn_top3_discount = self.root.shop_node_export.shop_top3_export.btn_top3_discount_export
    self.node_gray2 = self.root.shop_node_export.shop_top3_export.btn_top3_discount_export.node_gray2_export
    self.oldprice_text = self.root.shop_node_export.shop_top3_export.btn_top3_discount_export.oldprice_text_export
    self.newprice_text = self.root.shop_node_export.shop_top3_export.btn_top3_discount_export.newprice_text_export
    self.tbsize = self.root.tbsize_export
    self.mall_small_item = self.root.mall_small_item_export
    self. tableView_node = self.root. tableView_node_export
    self.top = self.root.top_export
    self.title = self.root.title_export
    self.btn_rmb = self.root.title_export.btn_rmb_export
    self.rmb_num = self.root.title_export.btn_rmb_export.rmb_num_export
    self.shop_top_node = self.root.shop_top_node_export
    self.shop_top_content = self.root.shop_top_content_export
    self.shop_top_item_content = self.root.shop_top_item_content_export
    self.tableView_node2 = self.root.tableView_node2_export
    self.tbsize2 = self.root.tbsize2_export
    self.bag_mall_tab = self.root.bag_mall_tab_export
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.btn_top1_normal, function(sender, eventType) self:onbt_top1normalbuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_top1_discount, function(sender, eventType) self:onbt_top1discountbuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_top2_normal, function(sender, eventType) self:onbt_top2normalonBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_top2_discount, function(sender, eventType) self:onbt_top2discountonBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_top3_normal, function(sender, eventType) self:onbt_top3normalBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_top3_discount, function(sender, eventType) self:onbt_top3discoutBuy(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.root.title_export.esc, function(sender, eventType) 
        global.panelMgr:closePanel("UIStorePanel")
    end)

    self.bag_mall_tab_Control = TabControl.new(self.bag_mall_tab, handler(self, self.onTabMallChanged), 1,
    cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

     -- mall  商店
    self.TableViewforsmallitem = UITableView.new()
        :setSize(self.tbsize2:getContentSize(),self.top)
        :setCellSize(self.mall_small_item:getContentSize())
        :setCellTemplate(mall_small_cell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(2)
        self.tableView_node2:addChild( self.TableViewforsmallitem)

    self.TableViewforsmallitem:setName("TableViewforsmallitem")
    
    self.TableViewforShopToItem = UITableView.new()
        :setSize(self.shop_top_content:getContentSize(),self.shop_top_node)
        :setCellSize(self.shop_top_item_content:getContentSize())
        :setCellTemplate(ShopTopItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
        self.tableView_node2:addChild( self.TableViewforShopToItem)

    self.ResSetControl = ResSetControl.new(self.root,self)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIStorePanel:onTabMallChanged(index)

        self.isdalayintab = nil
        if index ==389 then
            self:MallTableView('top')
        elseif index ==391 then 
            self:MallTableView('resource')
        elseif index ==393 then
             self:MallTableView('speed')
        elseif index ==395 then
            self:MallTableView('war')
        elseif index ==397 then
             self:MallTableView('other')
        end 

end 

function UIStorePanel:cleanEvent(table)
    for _ , k  in pairs(table:getCells()) do 
        if k and k.tv_target.item and  k.tv_target.item.getIcon then 
           k.tv_target.item:getIcon():onExit()
        end 
    end 
end
 
function UIStorePanel:changeToOther()
    
    self.bag_mall_tab_Control:setSelectedIdx(397)
    self:MallTableView('other')
    self.TableViewforsmallitem:setContentOffset(cc.p(0,0))
end

 
function UIStorePanel:GpsItem(itemId)

    local t , key , num = global.ShopData:getItemShopType(itemId)

    -- print(key ,"key->>>")
    -- print(num ,"num->>>")
    -- print(num -math.floor(key/2) ,"num -math.floor(key/2)->>>")

    if t and key then 

        local tt ={391,393,395,397}

        local index = tt[t]

        if index ==391 then 
            self:MallTableView('resource')
        elseif index ==393 then
             self:MallTableView('speed')
        elseif index ==395 then
            self:MallTableView('war')
        elseif index ==397 then
             self:MallTableView('other')
        end 
        
        self.bag_mall_tab_Control:setSelectedIdx(index)

        self.TableViewforsmallitem:jumpToCellYByIdx(math.floor(num/2) -math.floor(key/2) , true)
    end 

end

function UIStorePanel:addTop3TipsEvent()
    -- self.shop_top1.item:setData(self.shoptop3data[1])
    -- self.shop_top2.item:setData(self.shoptop3data[2])
    -- self.shop_top3.item:setData(self.shoptop3data[3])
    for i = 1,3 do
        self.shoptop3data[i].tips_node =self.tips_node
        self["item"..i]:setData(self.shoptop3data[i])
    end
end

function UIStorePanel:cleanTop3Event()
     for i = 1,3 do
        self["item"..i]:onExit()
    end
end 

function UIStorePanel:MallTableView(table_view_type)

    self.shop_view_type =table_view_type

    self.shop_node:setVisible(false)
    self.TableViewforsmallitem:setVisible(true)
    self.TableViewforShopToItem:setVisible(true)

    self:cleanEvent(self.TableViewforsmallitem)
    self:cleanEvent(self.TableViewforShopToItem)
    self:cleanTop3Event()

    local mall_type =  nil 
    local isOpposite = nil 

     if table_view_type ~= 'top' then

        self.TableViewforShopToItem:setVisible(false)

    end 

    if table_view_type == 'top' then

        self.TableViewforsmallitem:setVisible(false)

        self.shop_node:setVisible(true)

        self:updateTopUI()
        return 

    elseif table_view_type =='resource' then 
        mall_type =  1  

    elseif table_view_type =='speed' then

        mall_type =  2 
  
    elseif table_view_type =='war'   then

        mall_type =  3 

    elseif table_view_type =='other' then 

        mall_type =  {1,2,3}

        isOpposite = true  
    end

    local malldata = shopData:getShopDataByType(mall_type , isOpposite)
        
    -- dump(malldata ,"malldata")

    for _ ,v in pairs(malldata) do 
        v.tips_node = self.tips_node
    end 

    self.TableViewforsmallitem:setData(malldata,self.isdalayintab)
    
    self.isdalayintab = true 

end 


function UIStorePanel:updateTopUI()

    local top10_data =shopData:getTopShopData()

    self:updateTop3UINode(self.shop_top1,top10_data[1],1)
    self:updateTop3UINode(self.shop_top2,top10_data[2],2)
    self:updateTop3UINode(self.shop_top3,top10_data[3],3)

    self.shoptop3data = {
        [1]=top10_data[1],
        [2]=top10_data[2],
        [3]=top10_data[3],
    }

    self:addTop3TipsEvent()

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function() 

        for i =1  ,3 do 
            self:updateTop3UINode(self["shop_top"..i], self.shoptop3data[i] , i )
        end
    end)

     for i =1 , 3 do 
        table.remove(top10_data,1)
     end

      if  self.isdalayintab then 
            self.TableViewforShopToItem:setData(top10_data,true)
        else 
            self.TableViewforShopToItem:setData(top10_data)
            self.isdalayintab = true 
     end 
end 


local yellow = cc.c3b( 255 ,185 , 34) 

function UIStorePanel:updateTop3UINode(node, data,index)
    if not data then  return end 
    if data.limited == 0 then 
        node['item'..index].xian_export:setVisible(false )
         print("xian_export")
          print("xian_export",false )
    else
        node['item'..index].xian_export:setVisible(true )
        --闄愯喘 鍙樼伆
           print("xian_export",true )
    end 
   node.top_name_text:setString(data.name)
   -- node['item'..index].icon_export:setSpriteFrame(data.information.itemIcon)
   -- node['item'..index].icon_view_export:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",data.information.quality))
    global.panelMgr:setTextureFor(node['item'..index].icon_view_export,string.format("icon/item/item_bg_0%d.png",data.information.quality))
    global.panelMgr:setTextureFor(node['item'..index].icon_export,data.information.itemIcon or data.information.icon)

    local nowMoney = tonumber( global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))

    if  data.price == 0 then 
        node["btn_top"..index.."_normal_export"]:setVisible(true)
        node["btn_top"..index.."_discount_export"]:setVisible(false)
        node["btn_top"..index.."_normal_export"].text1_export:setString( data.cost)

        if  data.already_buy == 0  then
             global.colorUtils.turnGray(node["btn_top"..index.."_normal_export"],true)
        else

            global.colorUtils.turnGray(node["btn_top"..index.."_normal_export"],false)

            if  nowMoney >= data.cost then 

                node["btn_top"..index.."_normal_export"].text1_export:setTextColor(gdisplay.COLOR_WHITE)
            else 
                node["btn_top"..index.."_normal_export"].text1_export:setTextColor(gdisplay.COLOR_RED)
            end 
        end 

    else 
        node["btn_top"..index.."_normal_export"]:setVisible(false)
        node["btn_top"..index.."_discount_export"]:setVisible(true)
        node["btn_top"..index.."_discount_export"].oldprice_text_export:setString( data.price)
        node["btn_top"..index.."_discount_export"].newprice_text_export:setString( data.cost)


        if  data.already_buy == 0  then
             global.colorUtils.turnGray(node["btn_top"..index.."_discount_export"],true)
        else
            global.colorUtils.turnGray(node["btn_top"..index.."_discount_export"],false)

            if  nowMoney >= data.cost then 

                node["btn_top"..index.."_discount_export"].oldprice_text_export:setTextColor(gdisplay.COLOR_WHITE)
                node["btn_top"..index.."_discount_export"].newprice_text_export:setTextColor(yellow)

            else 
                node["btn_top"..index.."_discount_export"].oldprice_text_export:setTextColor(gdisplay.COLOR_RED)
                node["btn_top"..index.."_discount_export"].newprice_text_export:setTextColor(gdisplay.COLOR_RED)
            end 
        end 

     end
end 

 
function UIStorePanel:onExit()
     self.isinShop = nil 
end


function UIStorePanel:changePage(index)

    self.tabTopControl:setSelectedIdx(index)

end 


function UIStorePanel:onEnter()


    local nodeTimeLine = resMgr:createTimeline("store/store_panel")
    nodeTimeLine:setTimeSpeed(0.5)
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

    self.bag_mall_tab_Control:setSelectedIdx(389)
    self:onTabMallChanged(389)

    self.ResSetControl:setRmbDelay(0)
    self.ResSetControl:setData()

    local function refresh()
        global.panelMgr:closePanel("UIBuyShopPanel")
        self:MallTableView(self.shop_view_type)
        -- self:RequestlimiteShopData()
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE,refresh)

    self:addEventListener(global.gameEvent.EV_ON_REFRESH_STORE,function()
        self:MallTableView(self.shop_view_type)
    end)


    shopData:updateTop10()
end


function UIStorePanel:checkXianGou(index)
    if tonumber(propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))< self.shoptop3data[index].cost then
            global.panelMgr:openPanel("UIRechargePanel")
    else 
        if self.shoptop3data[index].limited ~= 0 then 
            if self.shoptop3data[index].already_buy ==0 then 
                 global.tipsMgr:showWarning("shop02")
            else 
                 global.panelMgr:openPanel("UIBuyShopPanel"):setData(self.shoptop3data[index])
            end 
            else
            global. panelMgr:openPanel("UIBuyShopPanel"):setData(self.shoptop3data[index])
        end 
    end 
end 


function UIStorePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIStorePanel")
end
 
function UIStorePanel:onbt_top1normalbuy(sender, eventType)
    self:checkXianGou(1)
end

function UIStorePanel:onbt_top1discountbuy(sender, eventType)
    self:checkXianGou(1)
end

function UIStorePanel:onbt_top2normalonBuy(sender, eventType)
    self:checkXianGou(2)
end

function UIStorePanel:onbt_top2discountonBuy(sender, eventType)
        self:checkXianGou(2)
end

function UIStorePanel:onbt_top3normalBuy(sender, eventType)
    self:checkXianGou(3)
end

function UIStorePanel:onbt_top3discoutBuy(sender, eventType)
    self:checkXianGou(3)
end
--CALLBACKS_FUNCS_END

return UIStorePanel

--endregion
