--region UIPKRewordPanel.lua
--Author : zzl
--Date   : 2018/02/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIPKRewordPanel  = class("UIPKRewordPanel", function() return gdisplay.newWidget() end )

local UITableView =  require("game.UI.common.UITableView")
local UIKillItemCell = require("game.UI.pk.UIPKRewordItemCell")
local luaCfg = global.luaCfg

function UIPKRewordPanel:ctor()
    self:CreateUI()
end

function UIPKRewordPanel:CreateUI()
    local root = resMgr:createWidget("player_kill/pk_rank_reword")
    self:initUI(root)
end

function UIPKRewordPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/pk_rank_reword")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.banner = self.root.Node_export.bg.banner_export
    self.rank = self.root.Node_export.bg.time_bg.rank_node_mlan_6.rank_export
    self.time_node = self.root.Node_export.bg.time_bg.time_node_mlan_21_export
    self.time = self.root.Node_export.bg.time_bg.time_node_mlan_21_export.time_export
    self.leagueReward = self.root.Node_export.bg.time_bg.leagueReward_mlan_17_export
    self.colse_bt = self.root.Node_export.colse_bt_export
    self.colse_bt = CloseBtn.new()
    uiMgr:configNestClass(self.colse_bt, self.root.Node_export.colse_bt_export)
    self.intro_btn = self.root.Node_export.intro_btn_export
    self.tb_content = self.root.Node_export.tb_content_export
    self.tb_bottom = self.root.Node_export.tb_bottom_export
    self.tb_item_content = self.root.Node_export.tb_item_content_export
    self.tb_top = self.root.Node_export.tb_top_export
    self.tb_add = self.root.Node_export.tb_add_export
    self.btn_node = self.root.Node_export.btn_node_export

    uiMgr:addWidgetTouchHandler(self.root.touch, function(sender, eventType) self:close_panel(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.intro_btn, function(sender, eventType) self:infoCall(sender, eventType) end)
--EXPORT_NODE_END

    self.colse_bt:setData(function()
        self:close_panel(0)
    end)

    self.tableView = UITableView.new()
    :setSize(self.tb_content:getContentSize(), self.tb_top, self.tb_bottom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
    :setCellSize(self.tb_item_content:getContentSize()) -- 每个小intem 的大小
    :setCellTemplate(UIKillItemCell) -- 
    :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
    :setColumn(1)
    self.tb_add:addChild(self.tableView)

    self.isScring = false 
    self.tableView:registerScriptHandler(handler(self, function()

        self.isScring = true 

        if self.testA then 
            gscheduler.unscheduleGlobal(self.testA)
        end 

        if self.setCellTouch then 
            self:setCellTouch(false)
        end 
        self.testA = gscheduler.scheduleGlobal(function()
            
            if self.setCellTouch then 
                self:setCellTouch(true)
            end
            self.isScring = false 

            if self.testA then 
                gscheduler.unscheduleGlobal(self.testA)
            end
        end , 0.2)

    end), cc.SCROLLVIEW_SCRIPT_SCROLL)


    self.tips_node = cc.Node:create()
    self.root:addChild(self.tips_node)



end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIPKRewordPanel:onEnter()


    self:setData()

end 



function UIPKRewordPanel:setData()

    -- self.data = activity

    -- self.banner:loadTexture(self.data.banner, ccui.TextureResType.plistType)

    -- self.rank:setString("0")
    -- self.time_node:setVisible(false)
    -- self.act_name:setString(self.data.name)

    -- global.tools:adjustNodePosForFather(self.rank:getParent() , self.rank)

    -- global.ActivityAPI:ActivityListReq({self.data.activity_id},function(ret,msg)

    --     if msg and msg.tagAct then 
    --         self.rank:setString(msg.tagAct[1].lParam2 or 0 )

    --         global.tools:adjustNodePosForFather(self.rank:getParent() , self.rank)

    --         if  global.ActivityData:isPointActiviy(self.data.activity_id) then 
    --         else 
    --         end 
    --     end 
    -- end)

    -- local drop_data =  global.ActivityData:getRankRewardByActivityID(self.data.activity_id)

    -- self:cleanTimer()

    -- if self.data.serverdata and self.data.serverdata.lStatus ==  1 then 

    --     self.time_node:setVisible(true)

    --     self.timer = gscheduler.scheduleGlobal(handler(self,self.updateOverTime), 1)
        
    --     self:updateOverTime()
    -- end

    -- table.sort( drop_data , function (A , B) return A.rank_min < B.rank_min end )

    global.netRpc:delHeartCall(self)

    global.netRpc:addHeartCall(function()

        self.time:setString(global.funcGame.formatTimeToHMS( global.advertisementData:getAdOverTime() - global.dataMgr:getServerTime()))

    end,  self)


    global.tools:adjustNodePosForFather(self.time:getParent() , self.time)

    self.rank:setString(global.pkdata.lRank)

    global.tools:adjustNodePosForFather(self.rank:getParent() , self.rank)


    local drop_data = clone(global.luaCfg:daily_rank_reward())

    for _ ,v in pairs(drop_data) do 
        v.tips_panel = self
    end 
 
    self.tableView:setData(drop_data)

    self:initTouch()

    -- self:initBtn()
end 

function UIPKRewordPanel:initBtn()

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

            local call = global.ActivityData:getCallBack("UIPKRewordPanel" , panel_index , self.data )
            if call then 
                call()
            end 
        end)
    end
end


function UIPKRewordPanel:updateOverTime()

    local time = self.data.serverdata.lEndTime - global.dataMgr:getServerTime()

    if time >  0 then 

        self.time:setString( global.funcGame.formatTimeToHMS(time))
        global.tools:adjustNodePosForFather(self.time:getParent(),self.time)

    else 

        self.time_node:setVisible(false)
        self:cleanTimer()

    end 

end 


function UIPKRewordPanel:onExit()

    gsound.stopEffect("city_click")

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")

    global.netRpc:delHeartCall(self)

    self:cleanTimer()
end 

function UIPKRewordPanel:cleanTimer()

   if self.timer then

        gscheduler.unscheduleGlobal(self.timer)

        self.timer = nil
    end
end 


function UIPKRewordPanel:close_panel(sender, eventType)

    global.panelMgr:closePanel("UIPKRewordPanel")
end


function UIPKRewordPanel:initTouch()
    local touchNode = cc.Node:create()
     self.root:addChild(touchNode)
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchBegan) , cc.Handler.EVENT_TOUCH_BEGAN)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(handler(self, self.onTouchCancel), cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, touchNode)
end


local moveMax_x = 30
local moveMax_y = 30
local  prohibit_slide= 0 

function UIPKRewordPanel:onTouchMoved(touch, event)

    if prohibit_slide == 1 then return  end 

    local y =  math.abs((self.y - touch:getLocation().y)) > moveMax_y
    local x =  math.abs((self.x - touch:getLocation().x)) > moveMax_x
    
    if  y  then 

        prohibit_slide = 1

        return 
    end 
    if x and  not self.isScring then 

        self.tableView:setTouchEnabled(false)

        prohibit_slide = 1 
    end 

end

    
function UIPKRewordPanel:setCellTouch(state)

    for _ ,v in pairs(self.tableView:getCells()) do 
        
        if v.tv_target and  v.tv_target.item  and v.tv_target.item.setTBTouchEable then 

            v.tv_target.item:setTBTouchEable(state)
        end 
    end 
end 


function UIPKRewordPanel:onTouchBegan(touch, event)

    if self.isScring then 
        return 
     end 

    prohibit_slide =  0 

    local beganPoint = touch:getLocation()
    self.x = beganPoint.x 
    self.y = beganPoint.y 

    return true
end

function UIPKRewordPanel:onTouchEnded(touch, event)

    if not  self.tableView:isTouchEnabled() then 
        self.tableView:setTouchEnabled(true)
    end 

    self:setCellTouch(true)

end


function UIPKRewordPanel:onTouchCancel()

    self:onTouchEnded()
end 


function UIPKRewordPanel:infoCall(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIPKRewordPanel

--endregion
