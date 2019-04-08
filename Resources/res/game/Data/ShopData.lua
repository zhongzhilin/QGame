--
-- Author: Your Name
-- Date: 2017-04-07 22:03:08
--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local _M = {}

local luaCfg = global.luaCfg

function _M:init()

    self.data =  luaCfg:shop()

    if not self.limiteShopData  then  -- 防止游戏中重连接发送请求 , 没必要
        self:RequestlimiteShopData()
    end 

    if not self.server_top10_data then  -- 防止游戏中重连接发送请求 ，没必要
        self:updateTop10()
    end 

end

function  _M:updateTop10()
    global.ShopActionAPI:getTopReq(0,0,function(ret,msg)
          if  ret.retcode ==0 then 
                self.server_top10_data  = msg 
          end 
    end)
end 


function _M:checkCanUseAll(itemId)

    if not itemId then return false end  

    return global.luaCfg:get_local_item_by(itemId).select_all == 1
end 

function _M:checkInShop(itemId)

     return global.luaCfg:get_shop_by(itemId) ~= nil 
end 


function _M:RequestlimiteShopData(requestfinsh_call)
    global.ShopActionAPI:getTopReq(2,0,function (ret,msg)
        if ret.retcode ==0 then
            self.limiteShopData = msg.tgshopinfo
            if requestfinsh_call then 
                requestfinsh_call()
            end 
        end 
    end)
end 


function _M:buyShop(item_id ,buy_OK_call)
    
    local data = luaCfg:get_local_item_by(item_id)

    self.buy_call = buy_OK_call 

    global.ShopActionAPI:getTopReq(1,data.itemId ,function(ret,msg)

            local shpopdata = clone( global.luaCfg:get_shop_by(item_id))

            if shpopdata == nil then 
                return 
            end 
             if ret.retcode ==0 then 
                if msg.tgshopinfo then 
                     shpopdata.already_buy =msg.tgshopinfo.limite 
                else
                     shpopdata.already_buy =-1 
                     shpopdata.limited = 0 
                end 
            elseif ret.retcode ==1 then 
                shpopdata.already_buy =-1 
                shpopdata.limited = 0 
            end
            shpopdata.information = data
            self:checkXianGou(shpopdata) 
     end)
end

function _M:checkXianGou(data) -- 检测限购 

    -- if tonumber(global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,"")) <  data.cost then
    --      global.panelMgr:openPanel("UIRechargePanel") 
    -- else 
        if  data.limited ~= 0 then 
            if  data.already_buy == 0 then 
                global.tipsMgr:showWarning("shop02")
            else 
                 global.panelMgr:openPanel("UIBuyShopPanel"):setData(data,  self.buy_call)
            end 
         else
             global. panelMgr:openPanel("UIBuyShopPanel"):setData(data,  self.buy_call)
         end
    -- end 
end 

function _M:getItemNumber(item_id)
    if global.normalItemData:getItemById(item_id) then 
        return  global.normalItemData:getItemById(item_id).count
    end 
    return 0 
end  


function  _M:getMallDateBytype(goodstype,isother)
    local  shopdata = luaCfg:shop()
    local goodsdata ={} 
    for _ ,v  in pairs(shopdata) do 
        local  goods = luaCfg:get_local_item_by(v.itemId)
        if self:checkItemAvailable(v.itemId) then 
            if not isother then 
                if goods.class  == goodstype then 
                    local vclone = clone(v)
                    vclone.tips_node = self.tips_node
                    vclone.information = goods
                    table.insert(goodsdata,vclone)
                end 
            else
                local isInpairs =false
                for k,vv in pairs(goodstype) do 
                    if  goods.class  == vv  and goods.itemType ~=2000 then --领主装备特俗处理 
                        isInpairs =true 
                    end 
                end
                if not  isInpairs then 
                    local vclone = clone(v)
                    vclone.tips_node = self.tips_node
                    vclone.information = goods
                    table.insert(goodsdata,vclone)
                end 
            end 
        end 
    end

    table.sort(goodsdata , function(A ,B) return A.array < B.array end )
    return goodsdata 
end 


function _M:setLimiteData(data)
    if self.limiteShopData then 
        for _ ,v in pairs(self.limiteShopData) do
            for _ ,vv in pairs(data) do 
                 if v.lId == vv.itemId then 
                        vv.already_buy =v.limite
                    break
                 end
            end 
        end
    else 
       for _ ,vv in pairs(data) do   
             vv.already_buy = -1  --设置一个虚拟限购 以防后面代码nil报错
       end 
    end

    for _ ,vv in pairs(data) do 
        if vv.already_buy == nil then 
            vv.already_buy =-1
        end 
    end
    return data 
end

function _M:getShopDataByType(type , isopposite)
    local shop_data =   self:getMallDateBytype(type , isopposite)
    shop_data = self:setLimiteData(shop_data)
    return shop_data
end

local item_type = {1, 2, 3}

function _M:getItemShopType(itemId )


    local data = self:getMallDateBytype(v) or {} 

    for _ ,v in pairs(item_type) do 

         for key , vv in pairs(data) do

            if vv.information.itemId == itemId  then 

                return v ,key , #data
            end 

         end 
    end 

    data = self:getMallDateBytype(item_type , true)

    for key , vv in pairs(data or {} ) do

        if vv.information.itemId == itemId  then 

            return 4 ,key ,  #data
        end 
    end 
    
end

function _M:replaceTop(topData)  -- 
    local  tempdata = luaCfg:shop()
    for k ,v in pairs(tempdata) do 
        if self:checkItemAvailable(v.itemId) then 
            if  v.top ~=0 and not self:ActivityToped(v.itemId) then 
                local isToped = false 
                for kk , vv in pairs(topData) do  -- 
                     if v.itemId  == vv.itemId then
                        local tempindex = vv.top 
                        vv.top = v.top 
                        topData[v.top].top =tempindex
                        isToped =true 
                        table.sort(topData , function(A,B) return A.top<B.top end)
                        break
                     end 
                end
                if not isToped then 
                     for kk , vv in pairs(topData) do  -- 
                         if v.top  == vv.top then 
                            topData[vv.top] ={} 
                             topData[vv.top]=clone(v)
                             topData[vv.top].top =v.top
                             topData[vv.top].information=clone(luaCfg:get_local_item_by(v.itemId))
                            break
                         end 
                     end
                end 
            end 
        end 
    end
    table.sort(topData , function(A,B) return A.top<B.top end)
    return topData
end

function _M:getTableItemCount(table)
    if not table then 
        return  0 
    end  
    local count =0
    for _ ,v in pairs(table) do 
        count =count+1 
    end 
    return count 
end 

function _M:initTopByLocal(topData)
    local temptopdata ={}
     if self:getTableItemCount(topData)<=0 then 
        local tempdata = luaCfg:shop()
        for _ ,v in pairs(tempdata) do 
            if  v.initial ~= 0  then 
                local topdata={} 
                topdata= clone(v)
                topdata.top =  v.initial
                topdata.information = luaCfg:get_local_item_by(v.itemId)
                table.insert(temptopdata,topdata)
            end 
        end 
     end 
     table.sort(temptopdata , function(A,B) return A.initial<B.initial end)
     return temptopdata
end 

local top_number = 10 

function _M:getTopShopData() -- 如果top 没有数据 则从不嗯
    -- dump(topdata,"鐣呴攢top10=-=-=-=-=-=-=-=-=-=-=-=-")

    local null_index = {}
    local toptable  ={}

    if  self.server_top10_data ==nil or self.server_top10_data.tgshopinfo==nil  then  -- 濡傛灉鏈嶅姟鍣ㄦ病鏁版嵁 鍒欎粠鏈湴璇诲彇
       toptable = self:initTopByLocal(self.server_top10_data)  -- 浠庢湰鍦拌幏鍙�
    else 
        for i=1 , top_number do 
            if self.server_top10_data.tgshopinfo[i] then 
                local  topdata2 = clone(luaCfg:get_shop_by(self.server_top10_data.tgshopinfo[i].lId))
                if topdata2 and self:checkItemAvailable(topdata2.itemId)then 
                    topdata2.top = i 
                    topdata2.information = clone(luaCfg:get_local_item_by(self.server_top10_data.tgshopinfo[i].lId))
                    table.insert(toptable,topdata2)
                else
                    table.insert(null_index, i) -- 排行榜 没有 top 位置
                end
            else 
                    table.insert(null_index, i) -- 排行榜 没有 top 位置
            end  
        end 
    end 

    if #toptable < top_number then 
        for _ ,v in pairs(luaCfg:shop()) do 
            for _ ,vv in pairs(null_index) do 
                if v.initial == vv then 
                    local topdata2 = clone(v)
                    topdata2.top = vv 
                    topdata2.information = clone(luaCfg:get_local_item_by(v.itemId))
                    table.insert(toptable,topdata2)
                end 
            end 
        end 
    end 

    if #toptable < top_number then 
         toptable = self:initTopByLocal({})  -- 浠庢湰鍦拌幏鍙�
    end 

    local topdata = self:replaceTop(toptable) -- 需要检测
    topdata =self:setLimiteData(topdata) -- 设置限购数据

    return topdata
end 


function _M:checkItemAvailable(item_id) --检查次活动商品是否可用
    if  luaCfg:get_shop_by(item_id) == nil  then return false end  
    if luaCfg:get_shop_by(item_id).act == 0 then 
        return true 
    else 
        self.activity_item =self:getAvailableActivityItem()
        for _ ,v in  pairs(self.activity_item) do 
            if v.itemId == item_id then 
                return true 
            end 
        end 
    end 
    return false
end 

function _M:getAvailableActivityItem()
    local temp_data ={}
    for _ ,v in pairs(luaCfg:shop()) do 
        if v.act ~= 0 then 
            local activity  = global.ActivityData:getServerDataByActivityid(v.act)
            dump(activity,"activity===================")
           if activity and  activity.lStatus == 1 then --活动物品可用
                table.insert(temp_data,v)
          end 
        end 
    end
    dump(temp_data,"getAvailableActivityItem")
    return temp_data
end


function _M:ActivityToped(id) -- 优先 活动显示 强制 top
    local item = luaCfg:get_shop_by(id) 
    local activity_item =self:getAvailableActivityItem()
    if item.top ~= 0 then 
        for _ ,v in pairs(activity_item) do 
            if item.top == v.top and item.itemId~= v.itemId then 
                return true 
            end 
        end 
    end 
    return false  
end 


global.ShopData = _M

--endregion
