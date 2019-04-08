--region UICityBufferPanel.lua
--Author : anlitop
--Date   : 2017/03/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local funcGame = global.funcGame
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIDivineItem = require("game.UI.divine.UIDivineItem")
--REQUIRE_CLASS_END

local UICityBufferPanel  = class("UICityBufferPanel", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UICityBufferItemCell = require("game.UI.citybuffer/UICityBufferItemCell")
function UICityBufferPanel:ctor()
    self:CreateUI()
end

function UICityBufferPanel:CreateUI()
    local root = resMgr:createWidget("citybuff/citybuff_bj")
    self:initUI(root)
end

function UICityBufferPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "citybuff/citybuff_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.back = self.root.bg1.back_export
    self.divination_null_result_text = self.root.bg1.divination.divination_null_result_text_mlan_6_export
    self.divination_title = self.root.bg1.divination.divination_title_mlan_8_export
    self.diviation_describe = self.root.bg1.divination.diviation_describe_export
    self.diviation_overtime__title = self.root.bg1.divination.diviation_overtime__title_mlan_4_export
    self.diviation_progress_view = self.root.bg1.divination.diviation_progress_view_export
    self.diviation_progress_bar = self.root.bg1.divination.diviation_progress_view_export.diviation_progress_bar_export
    self.diviation_overtime__text = self.root.bg1.divination.diviation_progress_view_export.diviation_overtime__text_export
    self.divination_btn = self.root.bg1.divination.divination_btn_export
    self.old_divination_icon = self.root.bg1.divination.old_divination_icon_export
    self.divination_icon = self.root.bg1.divination.divination_icon_export
    self.divination_icon = UIDivineItem.new()
    uiMgr:configNestClass(self.divination_icon, self.root.bg1.divination.divination_icon_export)
    self.title_second = self.root.bg1.title_second_export
    self.Layout_bttom_node = self.root.bg1.Layout_bttom_node_export
    self.Layout_top_node = self.root.bg1.Layout_top_node_export
    self.Layout_add_node = self.root.bg1.Layout_add_node_export
    self.Layout_item_content = self.root.bg1.Layout_item_content_export
    self.Layout_content_node = self.root.bg1.Layout_content_node_export

    uiMgr:addWidgetTouchHandler(self.divination_btn, function(sender, eventType) self:onBuy(sender, eventType) end)
    --EXPORT_NODE_END
    -- 为exitbutton 添加退出监听
    uiMgr:addWidgetTouchHandler(self.back.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    -- 创建TableView
    self.tableView = UITableView.new()
        :setSize(self.Layout_content_node:getContentSize(), self.Layout_top_node, self.Layout_bttom_node)-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.Layout_item_content:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UICityBufferItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
        :setColumn(1)
    self.Layout_add_node:addChild(self.tableView)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UICityBufferPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UICityBufferPanel")
end

function UICityBufferPanel:onEnter() 
    self:setData()
    local function onResume()
        self:setData(true)
    end

    self:addEventListener(global.gameEvent.EV_ON_CITY_BUFF_UPDATE, function ()
        self:setData(true)
    end)


    self:addEventListener(global.gameEvent.EV_ON_GAME_RESUME,onResume)
end 
--    30640000 = {
-- [LUA-print] -         "lEndTime"   = 1491406944
-- [LUA-print] -         "lID"        = 3064
-- [LUA-print] -         "lIsPer"     = 1
-- [LUA-print] -         "lParam"     = 20
-- [LUA-print] -         "lStartTime" = 1491403344
-- [LUA-print] -         "lTarget"    = 0
-- [LUA-print] -     }
function UICityBufferPanel:setData(is_stay_old_point)
    self.stay_old_point = is_stay_old_point  -- 是否reload tableview
    self.data  = luaCfg:citybuff()
    global.techApi:divineList(4, function (msg)
        if self.setProphesyData then 
            self:setProphesyData(msg)
        end 
    end)
    for i=1 ,#self.data do
        self.data[i].status={isvalid =false,toaltime = 0,beggintime=0} 
    end  
    local  allbuffs = global.buffData:getBuffs()
    for _ , v in pairs(allbuffs) do 
        for _ ,vv in pairs(self.data) do 
            if v.lID == vv.datatype then 
                vv.status.beggintime = v.lStartTime
                vv.status.toaltime   = v.lEndTime-v.lStartTime
                if v.lEndTime > global.dataMgr:getServerTime() then
                    vv.status.isvalid =true
                    vv.valid_describe = self:getItemDescribe(vv.datatype)
                    vv.effect = v.lParam
                end 
            end 
        end 
    end 
    self.tableView:setData(self.data,self.stay_old_point)
 end 

function UICityBufferPanel:getItemDescribe(datatype)
    for _ ,v  in pairs(self.data) do 
        if v. typePara3  == datatype then 
            return  v.text
        end 
    end
    return  "" 
end 

function UICityBufferPanel:setProphesyData(msg)
    self.data.prophesy={}
    if msg and msg.tgDivine then 
        self.data.prophesy.lRestTime = msg.lEndTime-global.dataMgr:getServerTime()
        self.data.prophesy.lBindID = msg.tgDivine[1].ID
        self.data.prophesy.isvalid =true 
        self.data.prophesy.lEndTime=msg.lEndTime
        self.data.prophesy.lTotleTime = 24*60*60
    else 
         self.data.prophesy.isvalid =false
    end 
    self:updateProphesyUI() 
end 


function UICityBufferPanel:onExit()
 if self.timer then
       gscheduler.unscheduleGlobal(self.timer)
      self.timer = nil
        self.progress =nil
    end
    self.isEffectd = nil 
    self.stay_old_point =nil
end

function UICityBufferPanel:updateProphesyProgress()
    if self.data and  self.data.prophesy then 
        self.data.prophesy.lRestTime = self.data.prophesy.lRestTime-1
        if self.data.prophesy.lRestTime  >0 then 
            self.diviation_overtime__text:setString(funcGame.formatTimeToHMS(self.data.prophesy.lRestTime))
            self.diviation_progress_bar:setPercent(self.data.prophesy.lRestTime/self.data.prophesy.lTotleTime*100)
        else 
            if self.timer then
                gscheduler.unscheduleGlobal(self.timer)
                self.timer = nil
                self.progress =nil
            end
            self.data.prophesy.isvalid =false
            self:updateProphesyUI()
        end
    end 
end 

local frameBg = {
    [1] = "icon/divine/divination_1.png",
    [3] = "icon/divine/divination_2.png",
    [5] = "icon/divine/divination_3.png",
}

function UICityBufferPanel:updateProphesyUI() 

    if self.data.prophesy.isvalid then 
        local  prophesy = luaCfg:get_divine_by(self.data.prophesy.lBindID) 
        dump(prophesy)
        self.divination_null_result_text:setVisible(false)
        self.divination_btn:setVisible(false)
        self.divination_title :setVisible(true)
        self.diviation_describe:setVisible(true)
   
        self.diviation_overtime__title:setVisible(true)
        self.diviation_progress_view :setVisible(true)
        self.diviation_overtime__text :setVisible(true)
        self.diviation_progress_bar:setVisible(true)
        self.old_divination_icon:setVisible(false)
        uiMgr:setRichText(self,"diviation_describe",50043,{desc =prophesy.name ,effect = prophesy.des})
        -- 卡牌
        if not  self.isEffectd then 
             local nodeTimeLine = resMgr:createTimeline("citybuff/divine_card_node")
            nodeTimeLine:play("animation1", true)
            self.divination_icon.root:runAction(nodeTimeLine)
            self.isEffectd = 1 
        end 
        self.divination_icon.root.Button_11:setEnabled(false)
        self.divination_icon:setVisible(true)
        -- self.divination_icon.icon:setSpriteFrame(prophesy.icon)
        -- self.divination_icon.quality:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",prophesy.quality))
        
        global.panelMgr:setTextureFor(self.divination_icon.quality,string.format("icon/item/item_bg_0%d.png",prophesy.quality))
        global.panelMgr:setTextureFor(self.divination_icon.icon,prophesy.icon)
        self.divination_icon.buff:setString(prophesy.name)
        -- self.divination_icon.frame:setSpriteFrame(frameBg[prophesy.quality])
        global.panelMgr:setTextureFor(self.divination_icon.frame,frameBg[prophesy.quality])
        -- 启动定时器
        if not self.timer then 
            self.timer = gscheduler.scheduleGlobal(handler(self,self.updateProphesyProgress), 1)
        end 
         self:updateProphesyProgress()
    else 
        -- 卡牌
        self.divination_icon:setVisible(false)
        self.divination_title :setVisible(false)
        self.diviation_describe:setVisible(false)
        self.diviation_overtime__title:setVisible(false)
        self.diviation_progress_view :setVisible(false)
        self.diviation_progress_bar:setVisible(false)
        self.diviation_overtime__text :setVisible(false)

        self.divination_null_result_text:setVisible(true)
        self.divination_btn:setVisible(true)
        self.old_divination_icon:setVisible(true)
        

        if self.timer then
            gscheduler.unscheduleGlobal(self.timer)
            self.timer = nil
        end 

    end 
end

function UICityBufferPanel:onBuy(sender, eventType)
    local isbuding = nil 
    local  i_buildingType  = 25
    for _ ,v in pairs(global.cityData:getBuildings()) do 
       if v.buildingType == i_buildingType  and v.serverData.lStatus == WDEFINE.CITY.BUILD_STATE.BUILDED then
             isbuding = true 
        end    
    end 
    if  isbuding  then
        local id = luaCfg:get_buildings_pos_by(i_buildingType).triggerId[1]
        if global.cityData:checkTrigger(id) then
                global.panelMgr:closePanel("UICityBufferPanel")
                global.panelMgr:openPanel("UIDivinePanel")  
        else
                local triggerData = luaCfg:get_triggers_id_by(id)
                local triggerBuilding = luaCfg:get_buildings_pos_by(triggerData.buildsId)
                local str = luaCfg:get_local_string(10043,triggerBuilding.buildsName,triggerData.triggerCondition,luaCfg:get_buildings_pos_by(i_buildingType).buildsName)
                global.tipsMgr:showWarning(str)
        end
    else
         global.tipsMgr:showWarning(string.format(luaCfg:get_localization_by(10549).value, luaCfg:get_buildings_pos_by(i_buildingType).buildsName))
    end  
end 
--CALLBACKS_FUNCS_END

return UICityBufferPanel

--endregion
