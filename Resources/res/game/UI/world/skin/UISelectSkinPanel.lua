--region UISelectSkinPanel.lua
--Author : anlitop
--Date   : 2017/08/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISelectSkinPanel  = class("UISelectSkinPanel", function() return gdisplay.newWidget() end )
local UISelectSkinlItemCell = require("game.UI.world.skin.UISelectSkinlItemCell")
local UISkinBuffTextCell = require("game.UI.world.skin.UISkinBuffTextCell")
local UITableView = require("game.UI.common.UITableView")
local TabControl = require("game.UI.common.UITabControl")

local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")


function UISelectSkinPanel:ctor()
    self:CreateUI()
end

function UISelectSkinPanel:CreateUI()
    local root = resMgr:createWidget("world/mapavatar/mapavatar_bj")
    self:initUI(root)
end

function UISelectSkinPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mapavatar/mapavatar_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.shipei.bg_export
    self.effect_node = self.root.shipei.effect_node_export
    self.icon = self.root.shipei.icon_export
    self.tab = self.root.shipei.tab_export
    self.ps_node = self.root.shipei.tab_export.ps_node_export
    self.tt = self.root.shipei.tab_export.tt_export
    self.text_bg = self.root.shipei.tab_export.text_bg_export
    self.name = self.root.shipei.tab_export.text_bg_export.name_export
    self.time = self.root.shipei.tab_export.text_bg_export.name_export.time_export
    self.text = self.root.shipei.tab_export.text_bg_export.text_export
    self.charge_btn = self.root.shipei.btna.charge_btn_export
    self.dia_icon = self.root.shipei.btna.charge_btn_export.dia_icon_export
    self.dia_num = self.root.shipei.btna.charge_btn_export.dia_num_export
    self.btn_apply = self.root.shipei.btna.btn_apply_export
    self.table_top = self.root.shipei.table_top_export
    self.table_bottom = self.root.shipei.table_bottom_export
    self.table_content = self.root.shipei.table_content_export
    self.table_add = self.root.shipei.table_add_export
    self.table_item = self.root.shipei.table_item_export
    self.title = self.root.shipei.title_export
    self.btn_rmb = self.root.shipei.title_export.btn_rmb_export
    self.rmb_num = self.root.shipei.title_export.btn_rmb_export.rmb_num_export
    self.buff_item_content = self.root.buff_item_content_export
    self.buff_content = self.root.buff_content_export
    self.buff_top_node = self.root.buff_top_node_export
    self.buff_add_node = self.root.buff_add_node_export
    self.buff_bottom_node = self.root.buff_bottom_node_export

    uiMgr:addWidgetTouchHandler(self.charge_btn, function(sender, eventType) self:onChargeClick(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btn_apply, function(sender, eventType) self:applyHandler(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType)  

        global.panelMgr:closePanel("UISelectSkinPanel")

    end)

    self.tabControl = TabControl.new(self.tab, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))


    self.tableView = UITableView.new()
    :setSize(self.table_content:getContentSize(), self.table_top , self.table_bottom)
    :setCellSize(self.table_item:getContentSize())
    :setCellTemplate(UISelectSkinlItemCell)
    :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
    :setColumn(3)
    self.table_add:addChild(self.tableView)


    self.buffTableView = UITableView.new()
    :setSize(self.buff_content:getContentSize(), self.buff_top_node,self.buff_bottom_node )
    :setCellSize(self.buff_item_content:getContentSize())
    :setCellTemplate(UISkinBuffTextCell)
    :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
    :setColumn(1)
    self.buff_add_node:addChild(self.buffTableView)


    self.ResSetControl = ResSetControl.new(self.root,self)

    self:adapt()
end


function UISelectSkinPanel:adapt()
    local sHeight =(gdisplay.height - self.tab:getPositionY()-90)
    self.bg:setContentSize(cc.size(gdisplay.width ,sHeight ))
    self.tt:setContentSize(cc.size(gdisplay.width ,self.tt:getContentSize().height))
end 

local red =   cc.c3b(180, 29, 11)

local green = cc.c3b(87, 213, 67)

local yellow  =cc.c3b(255,185,34)
function UISelectSkinPanel:onEnter()

    self.ResSetControl:setRmbDelay(0)
    self.ResSetControl:setData()

    local nodeTimeLine = resMgr:createTimeline("world/mapavatar/mapavatar_bj")
    nodeTimeLine:setTimeSpeed(0.5)
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

    self.tabControl:setSelectedIdx(1)

    self:addEventListener(global.gameEvent.EV_ON_CASTLE_SKILL_UPDATE, function ()

        self:updataUI()

    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE, function ()

        self:updataUI()
    end)


    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME, function ()

        global.userCastleSkinData:updateInfo()
    end)


     self:addEventListener(global.gameEvent.EV_ON_CASTLE_SKILL_CLICK, function (event , id)
        self:setClickUI()
    end)


    -- self:onTabButtonChanged(1)
    self.index = 1
    global.userCastleSkinData:setPanelIndex(self.index )

    self:setData()

    self.buffTableView:setTouchEnabled(false)

    global.userCastleSkinData:setClickSkin(global.userCastleSkinData:getDefaulSelectId())
end 

function UISelectSkinPanel:setData()

    global.userCastleSkinData:updateInfo()

end


function UISelectSkinPanel:updataUI()

    self:setTableData(self.index , true )

    self:setClickUI()

    self.charge_btn:setVisible(self.index ==1)
    self.btn_apply:setVisible(self.index ==2 )

end


local buffRichText= {   
    50145 , 
    50146,
    50147,
} 

function UISelectSkinPanel:setClickUI()

    self:cleanTimer()

    local click_data  = global.userCastleSkinData:getClickSkin()

    if  not click_data then return end 

    self.click_data =click_data

    global.panelMgr:setTextureFor(self.icon,click_data.worldmap)


    if self.effect_node then 
        self.effect_node:removeAllChildren()
    end 

    if  click_data.worldeffect ~="" then 

        self.icon:setVisible(false)

        local effect = resMgr:createCsbAction(click_data.worldeffect,"animation0",true)
        effect:setScale(self.icon:getScale())
        -- self.effect:setPosition(cc.p(self.icon:getPositionX()+150,self.icon:getPositionY()-30))

        self.effect_node:addChild(effect)
        
    else

        self.icon:setVisible(true)
    end 

    self.name:setString(click_data.name)
    self.text:setString(click_data.text)

    global.tools:adjustNodePosForFather(self.name,self.time)


    if self.index == 1 then     --显示多少天，， 
 
        self.time:setString(self:getTimeStr(click_data))

        self.time:setTextColor(green)

        self.dia_num:setString(click_data.num)

        local DIAMOND = tonumber( global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))

        if  DIAMOND <  click_data.num     then 

            self.dia_num:setTextColor(gdisplay.COLOR_RED)

        else

            self.dia_num:setTextColor(yellow)
        end 

    else 

        if click_data.serverData then 

            if click_data.serverData.lBeginTime then 

              self.timer = gscheduler.scheduleGlobal(handler(self,self.overtime), 1)

              self:overtime()
            
             self.time:setTextColor(red)

            else-- 默认城堡

                local str = global.luaCfg:get_local_string(10769)
                str ="(".. str ..")"
                self.time:setString(str)
                self.time:setTextColor(green)
            end 
        else 

             --= //////////
        end 

    end 

    -- self.buftext:getParent():setVisible(click_data.buffnum > 0 )

    if click_data.buffnum > 0 then 
        local buff_arr = {} 
        for i= 1  , click_data.buffnum  do 
            local temp ={}
            -- buff_arr["buff"..i]=global.luaCfg:get_data_type_by(click_data["buff"..i][1]).paraName
            -- buff_arr["effect"..i]=click_data["buff"..i][2]
            temp.buff =global.luaCfg:get_data_type_by(click_data["buff"..i][1]).paraName
            temp.effect =click_data["buff"..i][2]..global.luaCfg:get_data_type_by(click_data["buff"..i][1]).extra
            table.insert(buff_arr , temp )
        end
        self.buffTableView:setData(buff_arr)
    else 
        self.buffTableView:setData({{buff=global.luaCfg:get_local_string(10845)}})
    end 

end 



function UISelectSkinPanel:getTimeStr(data)

    local d_t = 24 * 60 

    local h_t  = 60 

    local day  = (data.time - data.time %  d_t )  /  d_t

    local h  =data.time  - day *  d_t 

    h  = (h - ( h %  h_t )) / h_t 
    
    local m =data.time  - day *  d_t   -  h * h_t

    local str = "" 

    if m > 0 and day < 1 and h < 1 then 

            str= global.luaCfg:get_local_string(10777 ,  m )

            str ="(".. str ..")"

    elseif  m > 0  and  day < 1   then  -- 时 分 

            str= global.luaCfg:get_local_string(10773 , h , m )

            str ="(".. str ..")"

    elseif m > 0   then --时 分  天 
        str= global.luaCfg:get_local_string(10770 , day  , h , m )

        str ="(".. str ..")"

    elseif h > 0 then  -- 天 时 

        str= global.luaCfg:get_local_string(10771 , day  , h  )
        str ="(".. str ..")"

    else -- 天  

        str= global.luaCfg:get_local_string(10772 ,  day  )

        str ="(".. str ..")"
    end 


    return  str 
end 



function UISelectSkinPanel:overtime()

   if self.click_data.serverData then 

       if self. click_data.serverData.lBeginTime then 

            local time  = global.vipBuffEffectData:getDayTime(self.click_data.serverData.lEndTime - ( global.dataMgr:getServerTime() ))

            self.time:setString(time)
      end 
  end 

end 


function UISelectSkinPanel:cleanTimer()
  if self.timer then
       gscheduler.unscheduleGlobal(self.timer)
      self.timer = nil
    end
end 



function UISelectSkinPanel:onTabButtonChanged(index) 

    self.index = index

    if index == 1 then 

        global.userCastleSkinData:setClickSkin(global.userCastleSkinData:getDefaulSelectId())


    elseif index ==2  then 

        global.userCastleSkinData:setClickSkin(global.userCastleSkinData:getCrutSkin().id)
    end 

    global.userCastleSkinData:setPanelIndex(self.index )

end



function UISelectSkinPanel:setTableData(index , stay ) 

    local skindata  = nil 

    if index == 1 then 

        skindata= global.userCastleSkinData:getAllCanBuykin()

        for _ ,v in ipairs(skindata)  do
            v.isChongzhi = true 
        end 

    elseif index ==2  then 

        skindata =  global.userCastleSkinData:getUnlockSkill()

        for _ ,v in ipairs(skindata)  do

            v.isChongzhi = false 
        end 

    end 
    
    table.sort(skindata , function(A  , B ) return A.array < B.array  end )

    self.tableView:setData(skindata , stay)
end 



function UISelectSkinPanel:onExit()
    self:cleanTimer()
    self.tableView:setData({})
    if self.pandectCall then self.pandectCall() end
end 

function UISelectSkinPanel:setPandectCall(callBack)
    -- body
    self.pandectCall = callBack
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISelectSkinPanel:onChargeClick(sender, eventType)
   
    local DIAMOND = tonumber( global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))

    local state =  self.click_data.state 
    local name =   self.click_data.name 


    if  DIAMOND <  self.click_data.num     then 

         global.tipsMgr:showWarning("ItemUseDiamond")

        return 
    end 

    local str = ""

    if state  == 1  then  -- 如果已经解锁 则提示 续费时间

        str= global.luaCfg:get_local_string("avaatr02")

    else 

        str= string.format(global.luaCfg:get_errorcode_by("avaatr04").text ,name..self:getTimeStr(self.click_data))

    end 

    local panel = global.panelMgr:openPanel("UIPromptPanel")

    panel:setData(str , function()
            
        global.itemApi:diamondUse(function (msg) 

            global.userCastleSkinData:deblockingSkin(msg.tagAvatarSkin or {})

            local str = ""

            -- if state  == 1  then  -- 如果已经解锁 则提示 续费时间

            --     -- str = "成功增加时间 "
            -- else 
                str = global.luaCfg:get_local_string("avaatr05")
            -- end  

            global.tipsMgr:showWarning(str)

        end , 12 ,  self.click_data.id)
    end)    

end

function UISelectSkinPanel:applyHandler(sender, eventType)

    
    if self.click_data.id == global.userCastleSkinData:getCrutSkin().id  then 
         global.tipsMgr:showWarning("avaatr07")
         return 
    end 

    
    global.loginApi:updateUserCastleSkin(self.click_data.id  , function () 

        global.userCastleSkinData:setCrutSkin(self.click_data.id)

        local str=  global.luaCfg:get_local_string("avaatr06")
        global.tipsMgr:showWarning(str)

    end)

end
--CALLBACKS_FUNCS_END

return UISelectSkinPanel

--endregion
