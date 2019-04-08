--region UIStrongRewardItem.lua
--Author : anlitop
--Date   : 2017/08/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local item = require("game.UI.activity.Node.UIIconNode")

local UIStrongRewardItem  = class("UIStrongRewardItem", function() return gdisplay.newWidget() end )

local UIRewardItemCell = require("game.UI.activity.cell.UIRewardItemCell")
local UITableView =  require("game.UI.common.UITableView")

function UIStrongRewardItem:ctor()
    self:CreateUI()
end

function UIStrongRewardItem:CreateUI()
    local root = resMgr:createWidget("activity/upgrade_reward_node")
    self:initUI(root)
end

function UIStrongRewardItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/upgrade_reward_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.scrollView = self.root.bg_export.reward_bg.scrollView_export
    self.target_text = self.root.bg_export.target_text_export
    self.now = self.root.bg_export.now_mlan_4_export
    self.target = self.root.bg_export.target_export
    self.current = self.root.bg_export.current_export
    self.table_add = self.root.table_add_export
    self.node_killed = self.root.node_killed_export
    self.table_item = self.root.table_item_export
    self.table_contont = self.root.table_contont_export
    self.receive = self.root.receive_export
    self.grayBg = self.root.receive_export.grayBg_export

    uiMgr:addWidgetTouchHandler(self.receive, function(sender, eventType) self:receiveHandler(sender, eventType) end)
--EXPORT_NODE_END
	-- self.scrollView:setSwallowTouches(false)
    self.tableView = UITableView.new()
        :setSize(self.table_contont:getContentSize())-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.table_item:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIRewardItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
        :setColumn(1)
    self.table_add:addChild(self.tableView)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIStrongRewardItem:receiveHandler(sender, eventType)
    
    if not self.isCanGet then
        return global.tipsMgr:showWarning("cantGetReward")
    end

    global.ActivityAPI:getActivityReward(function (msg)
        -- body
        if not self.setData then return end
        self.data.killed = true
        self:setData(self.data)

        msg.tgItem = msg.tgItem or {}
        local data = {}
        for i,v in ipairs(msg.tgItem) do
            local temp = {} 
            table.insert(temp, v.lID)
            table.insert(temp, v.lCount)
            table.insert(data, temp)
        end

        global.panelMgr:openPanel("UIItemRewardPanel"):setData(data, true) 
        global.panelMgr:getPanel("UILevelUpRewordPanel"):referSchedule(msg.lSection or 0)

    end, self.data.activity_id, self.data.rank)
end

--CALLBACKS_FUNCS_END

function UIStrongRewardItem:setData(data)

    local  color ={

        red = cc.c3b( 180,29 , 11) , 
        back = cc.c3b( 0,0 ,0),
    } 


    self.data = data
	self.node_killed:setVisible(data.killed)

    self.isCanGet = false
    self.receive:setVisible(false)
    local checkCanReceive = function ()
        -- body
        self.receive:setVisible(not data.killed)
        global.colorUtils.turnGray(self.grayBg, true)
        local curPro = tonumber(self.current:getString())
        local tarPro = data.point
        if (not data.killed) and curPro >= tarPro then
            self.receive:setVisible(true)
            global.colorUtils.turnGray(self.grayBg, false)
            self.isCanGet = true
        end
    end
    

    if data.killed then 

        self.current:setString(data.point)        
        self.current:setTextColor(color.back)
    else

        self.current:setString(data.cruntPoint)        
        self.current:setTextColor(color.red)

    end  

    self.target:setString("/"..data.point)


   if global.UILevelUpRewordPanelCell then 
        global.UILevelUpRewordPanelCell[self.data.id] = self
   end 


    if self.data.activity_id == 16001 then 

        checkCanReceive()
        self.target_text:setString(global.luaCfg:get_translate_string(10814  , data.point))
    elseif self.data.activity_id == 15001 then 

        checkCanReceive()
        self.target_text:setString(global.luaCfg:get_translate_string(10815  , data.point))
         
    elseif self.data.activity_id == 3001 then 

        self.target_text:setString(global.luaCfg:get_translate_string(10813  , data.point))

    elseif self.data.activity_id == 21001 then 

        self.target_text:setString(global.luaCfg:get_local_string(10961  , data.point))


    elseif self.data.activity_id == 72001 then 


        -- self.target_text:setString(global.luaCfg:get_local_string(10961  , data.point))
        checkCanReceive()
        -- self.target_text:setString(gls(11159)..data.point)
        self.target_text:setString(global.luaCfg:get_local_string(11165  , data.point))


    elseif self.data.activity_id == 73001 then 

        checkCanReceive()

        self.target_text:setString(global.luaCfg:get_local_string(11163  , data.point))

    elseif self.data.activity_id == 22001 then 

        self.target_text:setString(global.luaCfg:get_local_string(10962  , data.point))

    end 
        

    local temp = {} 

    for index ,v in pairs(global.luaCfg:get_drop_by(self.data.reward).dropItem) do 


	        local data = {} 
	        
	        data.tips_panel =  self.data.tips_panel

	        data.data = global.luaCfg:get_local_item_by(v[1])

	       	data.isshownumber =  true

	       	data.number = v[2]

            table.insert(temp   , clone(data) )
	end



    table.sort(temp  , function(A ,B) return A.data.quality >  B.data.quality end)


    for _ ,v in pairs(temp) do 

        v.scale = 1.285
    end 

    self.tableView:setData(temp)

 

    self.current:setPositionX(self.target:getPositionX()-self.target:getContentSize().width)
    self.now:setPositionX(self.current:getPositionX()-self.current:getContentSize().width)
    
end



function UIStrongRewardItem:setTBTouchEable(state)


    if state then 
        if not  self.tableView:isTouchEnabled()  then 

            self.tableView:setTouchEnabled(true)
        end
    else 
        
        self.tableView:setTouchEnabled(false)
    end 
        -- self.scrollView:setTouchEnabled(false)
        -- self.scrollView:setTouchEnabled(true)
        -- self.scrollView:setSwallowTouches(true)
end 



function UIStrongRewardItem:onExit()

    if global.UILevelUpRewordPanelCell then 
        global.UILevelUpRewordPanelCell[self.data.id] = nil
    end 
end 


return UIStrongRewardItem

--endregion
