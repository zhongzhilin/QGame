--region UIBagPanel.lua
--Author : Administrator
--Date   : 2016/08/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local propData = global.propData
local gameEvent = global.gameEvent
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



-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local shopwidget = require("game.UI.bag.shopwidget")
--REQUIRE_CLASS_END

local UIBagPanel  = class("UIBagPanel", function() return gdisplay.newWidget() end )

function UIBagPanel:ctor()
    self:CreateUI()

    
end

function UIBagPanel:CreateUI()
    local root = resMgr:createWidget("bag/bag_bg")
    self:initUI(root)
end

function UIBagPanel:itemChange(noAnimation)
    -- body

    -- dump()
    -- dump(self.tableView:minContainerOffset())



    local contentOffset = self.tableView:getContentOffset()
    self:onTabButtonChanged(self.tabIndex,noAnimation)
    
    contentOffset.y = contentOffset.y + 200
    self:checkIsOutOffset(contentOffset)
    -- local minOffset = self.tableView:minContainerOffset()
    -- -- contentOffset.y = contentOffset.y + 200        
    -- if contentOffset.y > 0 then contentOffset.y = 0 end
    -- if contentOffset.y < minOffset.y then contentOffset.y = minOffset.y end

    -- self.tableView:setContentOffset(contentOffset, false)
end

function UIBagPanel:checkIsOutOffset(contentOffset)
    
    local minOffset = self.tableView:minContainerOffset()
    -- contentOffset.y = contentOffset.y + 200        
    if contentOffset.y > 0 then contentOffset.y = 0 end
    if contentOffset.y < minOffset.y then contentOffset.y = minOffset.y end

    self.tableView:setContentOffset(contentOffset, false)
end

function UIBagPanel:showUse(sort,isHide)
    -- body
    
    local preOff = self.tableView:getContentOffset()

    -- UIBagUseBoard:getInstance():hideSelf()

    if isHide then        

        self.tableView:chooseItem(-1)
    else

        if self.tableView:getChooseSort() ~= -1 then
            preOff.y = preOff.y + 200
        end

        self.tableView:chooseItem(sort)
    end

    self.tableView:reloadData()

    if isHide then

        preOff.y = preOff.y + 200
        self.tableView:setContentOffset(preOff,false)
    else
    
        preOff.y = preOff.y - 200
        self.tableView:setContentOffset(preOff,false)
    end

    self:checkIsOutOffset(preOff)
end

function UIBagPanel:changeToEquip()
    

end

function UIBagPanel:initUI(root)

    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_bg")

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
    self.bag_tab = self.root.bag_tab_export
    self.tbsize = self.root.tbsize_export
    self.mall_small_item = self.root.mall_small_item_export
    self.itsize = self.root.itsize_export
    self.tableView_node = self.root.tableView_node_export
    self.equipTop_tableview_node = self.root.equipTop_tableview_node_export
    self.top_tab = self.root.top_tab_export
    self.title = self.root.title_export
    self.btn_rmb = self.root.title_export.btn_rmb_export
    self.rmb_num = self.root.title_export.btn_rmb_export.rmb_num_export
    self.top = self.root.top_export
    self.equipTop = self.root.equipTop_export
    self.itsizeEquip = self.root.itsizeEquip_export
    self.shop_top_node = self.root.shop_top_node_export
    self.shop_top_content = self.root.shop_top_content_export
    self.shop_top_item_content = self.root.shop_top_item_content_export
    self.tableView_node2 = self.root.tableView_node2_export
    self.tbsize2 = self.root.tbsize2_export
    self.tbsize3 = self.root.tbsize3_export
    self.bag_mall_tab = self.root.bag_mall_tab_export
    self.bag_limit_node = self.root.bag_limit_node_export
    self.bag_equip_num = self.root.bag_limit_node_export.bag_equip_num_export
    self.bag_equip_limit = self.root.bag_limit_node_export.bag_equip_limit_export
    self.lord_equiment_tab = self.root.lord_equiment_tab_export
    self.tips_node = self.root.tips_node_export

    uiMgr:addWidgetTouchHandler(self.btn_top1_normal, function(sender, eventType) self:onbt_top1normalbuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_top1_discount, function(sender, eventType) self:onbt_top1discountbuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_top2_normal, function(sender, eventType) self:onbt_top2normalonBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_top2_discount, function(sender, eventType) self:onbt_top2discountonBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_top3_normal, function(sender, eventType) self:onbt_top3normalBuy(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_top3_discount, function(sender, eventType) self:onbt_top3discoutBuy(sender, eventType) end)
  --EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.root.title_export.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.root.title_export:setLocalZOrder(1)
    self.top_tab:setLocalZOrder(1)

    self.bag_equip_limit:setString(luaCfg:get_config_by(1).equipLimit)

    self.tableView = UIBagTableView.new()
        :setSize(self.tbsize:getContentSize(),self.top)
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UIBagItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(4)

    self.equipTableView = UIEquipTableView.new()
        :setSize(self.tbsize:getContentSize(),self.equipTop)
        :setCellSize(self.itsizeEquip:getContentSize())
        :setCellTemplate(UIEquipItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(4)

    -- self.tableView.tableCellSizeForIndex = function(tableView, idx)
    --     log.debug("check ui")
    --     return self.__cellSize.width, self.__cellSize.height + idx * 50
    -- end

    self.tableView_node:addChild(self.tableView)
    self.equipTop_tableview_node:addChild(self.equipTableView)
    self.equipTableView:setEquipInfoData({

            isShowButton = false,
            buttonStr = 10392,
            isSinglePanel = false,
            callback = nil,
        }) 


    self.tabControl = TabControl.new(self.bag_tab, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.bag_mall_tab_Control = TabControl.new(self.bag_mall_tab, handler(self, self.onTabMallChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.tabTopControl = TabControl.new(self.top_tab, handler(self, self.onTopButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

    self.equiment_tab_Control = TabControl.new(self.lord_equiment_tab, handler(self, self.equipmentChange), 1,
    cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))

     -- mall  商城
    self.TableViewforsmallitem = UITableView.new()
        :setSize(self.tbsize3:getContentSize(),self.top)
        :setCellSize(self.mall_small_item:getContentSize())
        :setCellTemplate(mall_small_cell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(2)
        self.tableView_node2:addChild( self.TableViewforsmallitem)

    self.TableViewforShopToItem = UITableView.new()
        :setSize(self.shop_top_content:getContentSize(),self.shop_top_node)
        :setCellSize(self.shop_top_item_content:getContentSize())
        :setCellTemplate(ShopTopItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
        self.tableView_node2:addChild( self.TableViewforShopToItem)

 

    self.ResSetControl = ResSetControl.new(self.root,self)


     self.tips_node:setLocalZOrder(100)
    -- TableViewforShopToItem:
end

-- function registerLongPress()
--     -- body
--     global.tipsMgr:registerLongPress(self, self.mall_icon_node.icon_view, global.panelMgr:getPanel("UIBagPanel").FileNode_1,
--     handler(self, self.initTextTips),  handler(self, self.longPressDeal))
-- end



function UIBagPanel:onTabMallChanged(index)
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

function UIBagPanel:equipmentChange(index)

    if not self.equipTableView:isVisible() then
        return
    end

    self.equipTableView:cleanFocus()

    local fcount = global.equipData:getFreeEquipCount()
    if fcount > luaCfg:get_config_by(1).equipLimit then
        self.bag_equip_num:setString(luaCfg:get_config_by(1).equipLimit .. "/")
    else
        self.bag_equip_num:setString(fcount .. "/")
    end

    if index == 2 then 

        self.equipTableView:setData(global.equipData:getAllEquipsForUI(1),nil,true)

    elseif index == 1 then 

        self.equipTableView:setData(global.equipData:getAllEquipsForUI(2),nil,true)
    end 

    global.equipData:signMaxID()
end 

function UIBagPanel:cleanEvent(table)
    for _ , k  in pairs(table:getCells()) do 
        if k and k.item and  k.item.getIcon then 
            k.item:getIcon():onExit()
        end 
    end 
end
 
function UIBagPanel:addTop3TipsEvent()
    for i = 1,3 do
        self.shoptop3data[i].tips_node =self.tips_node
        self["item"..i]:setData(self.shoptop3data[i])
    end
end

function UIBagPanel:cleanTop3Event()
     for i = 1,3 do
        self["item"..i]:onExit()
    end
end 

function UIBagPanel:MallTableView(table_view_type)
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

        self.TableViewforsmallitem:setData({}, false)

        self.TableViewforsmallitem:setVisible(false)
        self.TableViewforShopToItem:setVisible(true)
        self.shop_node:setVisible(true)
        -- self.getTopShopData()
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

    local malldata =global.ShopData:getShopDataByType(mall_type , isOpposite)

    for _ ,v in pairs(malldata) do 
        v.tips_node = self.tips_node
    end 

    self.TableViewforsmallitem:setData(malldata,true)
    
    self.isdalayintab = true 

end 


function UIBagPanel:updateTopUI(topdata)

    local  topdata = global.ShopData:getTopShopData()

    for i =1  ,3 do 
        self:updateTop3UINode(self["shop_top"..i], topdata[i] , i )
    end
    
    self.shoptop3data = {
        [1]=topdata[1],
        [2]=topdata[2],
        [3]=topdata[3],
    }

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function() 

        for i =1  ,3 do 
            self:updateTop3UINode(self["shop_top"..i], self.shoptop3data[i] , i )
        end
    end)


    for  i= 1 , 3 do 
         table.remove(topdata , 1)
    end 

    self:addTop3TipsEvent()


    if  self.isdalayintab then 

        self.TableViewforShopToItem:setData(topdata,true,true)
    else 
        self.TableViewforShopToItem:setData(topdata,nil,true)
        self.isdalayintab = true 
    end 

end 


local yellow = cc.c3b( 255 ,185 , 34) 

function UIBagPanel:updateTop3UINode(node, data,index)
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



function UIBagPanel:flushInfoPanel()
    
    self.equipTableView:flush()
end


function UIBagPanel:onTopButtonChanged(index)
    self.isinShop = nil 

    self.TableViewforsmallitem:setData({}, false)
    
    self:cleanTop3Event()

    if index == 1 then
        self.TableViewforsmallitem:setVisible(false)
        self.bag_mall_tab:setVisible(false)
        self.bag_tab:setVisible(true)
        self.tableView:setVisible(true)
        self.equipTableView:setVisible(false)
        self.TableViewforShopToItem:setVisible(false)
        self.shop_node:setVisible(false)
        self:onTabButtonChanged(1)
        self.bag_limit_node:setVisible(false)
        self.lord_equiment_tab:setVisible(false)
    elseif index == 2 then
        
        self.TableViewforsmallitem:setVisible(false)
        self.TableViewforShopToItem:setVisible(false)
        self.bag_mall_tab:setVisible(false)
        self.bag_tab:setVisible(false)
        self.tableView:setVisible(false)
        self.shop_node:setVisible(false)
        self.equipTableView:setVisible(true)
        self.equipTableView:cleanFocus()
        self.bag_limit_node:setVisible(true)
        self.lord_equiment_tab:setVisible(true)

        self.equiment_tab_Control:setSelectedIdx(1)
        self:equipmentChange(1)

        -- global.tools:faceInIconForCells(self.equipTableView)
    elseif index == 3 then 

        self.equipTableView:setVisible(false)
        self.bag_mall_tab:setVisible(false)
        self.bag_tab:setVisible(false)
        self.tableView:setVisible(false)
        self.TableViewforsmallitem:setVisible(true)
        self.bag_tab:setVisible(false)
        self.bag_mall_tab:setVisible(true)
        self.bag_mall_tab_Control:setSelectedIdx(389)
        self:onTabMallChanged(389)
        self.isinShop = true 
        self.bag_limit_node:setVisible(false)
        self.lord_equiment_tab:setVisible(false)


     end 
end

-- noAnimation :手动调用传入整形0，1--》是否需要播放刷新动画
-- tabcontrol 调用传入的是bool--》是否选中
function UIBagPanel:onTabButtonChanged(index,noAnimation)
    self.tabControl:setSelectedIdx(index)
    self.tabIndex = index
    self.tableView:chooseItem(-1)
    local data = self:getSortTabData(index)
    local isUpdateWithAnimation = true
    if noAnimation==1 then
        isUpdateWithAnimation = nil
    end
    self.tableView:setData(data,nil,isUpdateWithAnimation)
    -- global.tools:faceInIconForCells(self.tableView)
    -- self.equipTableView:setData(global.equipData:getAllEquipsForUI())
    -- self.bag_equip_num:setString(global.equipData:getFreeEquipCount() .. "/")
end

function UIBagPanel:getCutTabData()
    
    local preData = global.normalItemData:getItems()
    local resData = {}
    for i,v in ipairs(preData) do
        
        print(v.id)
        local itemData = luaCfg:get_item_by(v.id)
        if itemData then
            local cutCount = v.count / itemData.stuckable
            local singleCount = v.count % itemData.stuckable
            
            if singleCount ~= 0 then
                table.insert( resData , {id = v.id,count = singleCount} )
            end

            if cutCount >= 1 then

                for i=1,cutCount do

                    table.insert( resData , {id = v.id,count = itemData.stuckable} )
                end
            end
        end
    end

    return resData
end

function UIBagPanel:getSortTabData( index )
    
    local preData = self:getPreTabData(index)
    
    local com = function( item1,item2 )
        
        local itemData1 = luaCfg:get_item_by(item1.id)
        local itemData2 = luaCfg:get_item_by(item2.id)
        
        if itemData1.useWay == 0 then return false end
        if itemData2.useWay == 0 then return true end

        if itemData1.typeorder == itemData2.typeorder then
        
            if itemData1.quality == itemData2.quality then
        
                if itemData1.queue == itemData2.queue then
                   
                    return item1.count < item2.count 
                else
                    
                    return itemData1.queue < itemData2.queue
                end               
            else
                
                return itemData1.quality > itemData2.quality
            end
        else
            
            return itemData1.typeorder < itemData2.typeorder
        end
    end

    table.sort(preData,com)

    local sortTag = 0
    for i,v in ipairs(preData) do

        v.sort = sortTag
        sortTag = sortTag + 1
    end

    return preData
end

function UIBagPanel:getPreTabData( index )
    -- body

    local tabType = {

        [1] = {true,true,true,true},
        [2] = {true,false,false,false},
        [3] = {false,true,false,false},
        [4] = {false,false,true,false},
        [5] = {false,false,false,true},
    }

    local itemDatas = self:getCutTabData()

    local resData = {}

    for i,v in ipairs(itemDatas or {}) do
    
        local itemData = luaCfg:get_item_by(v.id)
        
        if itemData and tabType[index][itemData.class] then

            table.insert(resData,v)
        end
    end

    return resData
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIBagPanel:onExit()
     self.isinShop = nil 

    self.equipTableView:out()
end


function UIBagPanel:changePage(index)

    self.tabTopControl:setSelectedIdx(index)

    self:onTopButtonChanged(index)

end 


function UIBagPanel:onEnter()    

    self.tabTopControl:setSelectedIdx(1)
    self.tabControl:setSelectedIdx(1)
    self:onTabButtonChanged(1) 
    self:onTopButtonChanged(1)


    self.ResSetControl:setRmbDelay(0)
    self.ResSetControl:setData()

    local nodeTimeLine = resMgr:createTimeline("bag/bag_bg")
    nodeTimeLine:setTimeSpeed(0.5)
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

    local callBB = function(eventname,res,noAnimation)        

        self:itemChange(noAnimation)
    end

    self:addEventListener(gameEvent.EV_ON_ITEM_UPDATE, callBB)

    self:addEventListener(gameEvent.EV_ON_UI_EQUIP_FLUSH, function()

        self:equipmentChange(self.equiment_tab_Control:getSelectedIdx())
    end)    

    self:addEventListener(global.gameEvent.EV_ON_REFRESH_STORE,function()
        if self.isinShop then 
            self:MallTableView(self.shop_view_type)
        end 
    end)

    local refresh  = function ()
        if self.isinShop then 
             global.panelMgr:closePanel("UIBuyShopPanel")
            self:MallTableView(self.shop_view_type)
        end 
    end
    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE,refresh)


    global.ShopData:updateTop10()
end


function UIBagPanel:checkXianGou(index)

    if not self.shoptop3data then return end
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
            
            global.panelMgr:openPanel("UIBuyShopPanel"):setData(self.shoptop3data[index])
        end 
    end 
end 



function UIBagPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIBagPanel")
end
 
function UIBagPanel:onbt_top1normalbuy(sender, eventType)
    self:checkXianGou(1)
end

function UIBagPanel:onbt_top1discountbuy(sender, eventType)
    self:checkXianGou(1)
end

function UIBagPanel:onbt_top2normalonBuy(sender, eventType)
    self:checkXianGou(2)
end

function UIBagPanel:onbt_top2discountonBuy(sender, eventType)
        self:checkXianGou(2)
end

function UIBagPanel:onbt_top3normalBuy(sender, eventType)
    self:checkXianGou(3)
end

function UIBagPanel:onbt_top3discoutBuy(sender, eventType)
    self:checkXianGou(3)
end
--CALLBACKS_FUNCS_END

return UIBagPanel

--endregion
