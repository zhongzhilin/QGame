--region UIAttackInfo.lua
--Author : untory
--Date   : 2016/09/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIAttackInfo  = class("UIAttackInfo", function() return gdisplay.newWidget() end )
local UIAttackInfoItemCell = require("game.UI.world.widget.UIAttackInfoItemCell")
local UITableView = require("game.UI.common.UITableView")

function UIAttackInfo:ctor()
    self.m_canFlush = false
end

function UIAttackInfo:CreateUI()
    local root = resMgr:createWidget("world/world_state")
    self:initUI(root)
end

function UIAttackInfo:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_state")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.mainBoard = self.root.mainBoard_export
    self.childBoard = self.root.mainBoard_export.childBoard_export
    self.att_btn = self.root.mainBoard_export.tab_con.att_btn_export
    self.def_btn = self.root.mainBoard_export.tab_con.def_btn_export
    self.ger_btn = self.root.mainBoard_export.tab_con.ger_btn_export
    self.attack_num_board = self.root.mainBoard_export.tab_con.attack_num_board_export
    self.attack_num = self.root.mainBoard_export.tab_con.attack_num_board_export.attack_num_export
    self.def_num_board = self.root.mainBoard_export.tab_con.def_num_board_export
    self.def_num = self.root.mainBoard_export.tab_con.def_num_board_export.def_num_export
    self.ger_num_board = self.root.mainBoard_export.tab_con.ger_num_board_export
    self.ger_num = self.root.mainBoard_export.tab_con.ger_num_board_export.ger_num_export
    self.dir = self.root.mainBoard_export.tab_con.dir_export
    self.tbsize = self.root.mainBoard_export.tbsize_export
    self.itsize = self.root.mainBoard_export.itsize_export
    self.incall = self.root.mainBoard_export.d2.incall_export

    uiMgr:addWidgetTouchHandler(self.att_btn, function(sender, eventType) self:show_att(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.def_btn, function(sender, eventType) self:def_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.ger_btn, function(sender, eventType) self:ger_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.incall, function(sender, eventType) self:in_call(sender, eventType) end)
--EXPORT_NODE_END

  	self.tableView = UITableView.new()
        :setSize(self.tbsize:getContentSize())
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UIAttackInfoItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.defTableView = UITableView.new()
        :setSize(self.tbsize:getContentSize())
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UIAttackInfoItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.stayTableView = UITableView.new()
        :setSize(self.tbsize:getContentSize())
        :setCellSize(self.itsize:getContentSize())
        :setCellTemplate(UIAttackInfoItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)

    self.tableView:setBounceable(false)
    self.defTableView:setBounceable(false)
    self.stayTableView:setBounceable(false)

    -- self.tbsize:setTouchEnabled(true)
    -- self.tbsize
    -- self.itsize:setEnabled(false);

    -- self.tableView:setSwallowTouches(true)
    self.tableView:setLocalZOrder(998)
    self.dir:getParent():setLocalZOrder(1111)
    self.tableView:setPosition(self.tbsize:getPosition())
    self.defTableView:setPosition(self.tbsize:getPosition())
    self.stayTableView:setPosition(self.tbsize:getPosition())

    self.mainBoard:addChild(self.tableView)
    self.mainBoard:addChild(self.defTableView)
    self.mainBoard:addChild(self.stayTableView)

    self.prePos = cc.p(self:getPositionX(),self:getPositionY())

    self.contentAttactData = {}
    self.contentDefData = {}
    
    self.attack_num_board:setScale(0)

    self:addEventListener(global.gameEvent.EV_ON_UI_TROOP_REFERSH,function()        
        if self.flushTableView then 
            self:flushTableView()
        end 
    end)
end

function UIAttackInfo:cleanAttack()
    
    self.contentDefData = {}
    self.contentAttactData = {}
    self:flushTableView()
end

function UIAttackInfo:onEnter()
	
    -- self.isNode1Out = true
    -- self.incall:runAction(cc.RotateTo:create(0,0))
    -- self.mainBoard:setPositionX(5)    
    self.isOnEnter = true
	self:flushTableView()
    self:ger_call()

    self.incall:stopAllActions()
    self.isNode1Out = false
    self.incall:runAction(cc.RotateTo:create(0,180))
    self.mainBoard:setPositionX(-280) 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIAttackInfo:insertAttactBoard(data,attackType)

    if attackType == "attack" then

        self:show_att()
        table.insert(self.contentAttactData,1,{troopData = data.troopData, startTime = data.startTime,overTime = data.startTime + data.attackTime,id = data.troopId,uiInfo = data.uiInfo})
        -- self:showBoard()
    elseif attackType == "def" then

        self:def_call() 
        table.insert(self.contentDefData,1,{troopData = data.troopData, startTime = data.startTime,overTime = data.startTime + data.attackTime,id = data.troopId,uiInfo = data.uiInfo})            
        -- self:showBoard()
    end       

    self:flushTableView()
end

function UIAttackInfo:removeAttactBoard(id,lParty)
	
    if lParty == nil then

        for k,v in pairs(self.contentAttactData) do

            if v.id == id then

                table.remove(self.contentAttactData,k)
            end
        end

        for k,v in pairs(self.contentDefData) do

            if v.id == id then

                table.remove(self.contentDefData,k)
            end
        end
    else

        if lParty == 1 then

            for k,v in pairs(self.contentAttactData) do

                if v.id == id then

                    table.remove(self.contentAttactData,k)
                end
            end
        else
            
            for k,v in pairs(self.contentDefData) do

                if v.id == id then

                    table.remove(self.contentDefData,k)
                end
            end
        end
    end

	self:flushTableView()
end

function UIAttackInfo:isTroopExist(id)

    for k,v in pairs(self.contentAttactData) do

        if v.id == id then

            return true
        end
    end

    for k,v in pairs(self.contentDefData) do

        if v.id == id then

            return true
        end
    end

    return false
end

function UIAttackInfo:flushTableView()
    self.m_canFlush = true
end

function UIAttackInfo:flushRealTableView()
    if not self.m_canFlush then return end
    
    self.contentStayData = global.troopData:getStayTroop()

    local dataCount = #self.contentAttactData
    local defDataCount = #self.contentDefData
    local stayDataCount = #self.contentStayData

    -- self:setVisible(dataCount ~= 0 or defDataCount ~= 0 or stayDataCount ~= 0)

    if dataCount > 0 then

        self.attack_num_board:stopAllActions()
        self.attack_num_board:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,1.2),cc.ScaleTo:create(0.2,1)))
        self.attack_num:setString(dataCount)
    else

        self.attack_num_board:stopAllActions()
        self.attack_num_board:runAction(cc.EaseBackIn:create(cc.ScaleTo:create(0.4,0)))
        self.attack_num:setString(dataCount)
    end

    if defDataCount > 0 then

        self.def_num_board:stopAllActions()
        self.def_num_board:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,1.2),cc.ScaleTo:create(0.2,1)))
        self.def_num:setString(defDataCount)
    else

        self.def_num_board:stopAllActions()
        self.def_num_board:runAction(cc.EaseBackIn:create(cc.ScaleTo:create(0.4,0)))
        self.def_num:setString(defDataCount)
    end

    if stayDataCount > 0 then

        self.ger_num_board:stopAllActions()
        self.ger_num_board:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,1.2),cc.ScaleTo:create(0.2,1)))
        self.ger_num:setString(stayDataCount)
    else

        self.ger_num_board:stopAllActions()
        self.ger_num_board:runAction(cc.EaseBackIn:create(cc.ScaleTo:create(0.4,0)))
        self.ger_num:setString(stayDataCount)
    end

	self.tableView:setData(self.contentAttactData)
    self.defTableView:setData(self.contentDefData)

    table.sortBySortList(self.contentStayData,{{'lCollectSpeed','true'},{'lAttackStartTime','min'}})
    self.stayTableView:setData(self.contentStayData)

    self:resizeBoard()

    local collectCount = 0
    for _,v in ipairs(self.contentStayData) do
        if v.lCollectSpeed then
            collectCount = collectCount + 1
        end
    end

    if dataCount == 0 and defDataCount == 0 and collectCount == 0 then

        -- self.isNode1Out = false
        -- self.mainBoard:stopAllActions()
        -- self.incall:runAction(cc.RotateTo:create(0.35,180))
        -- self.mainBoard:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(-280,15)),2))
    else

        if collectCount ~= 0 and dataCount == 0 and defDataCount == 0 then
            self:ger_call()
        end

        if self.isOnEnter then
            self:showBoard()     
            self.isOnEnter = nil
        end
    end
end

function UIAttackInfo:out_call(sender, eventType)

	
    local nodeTimeLine = resMgr:createTimeline("world/world_state")
    nodeTimeLine:setLastFrameCallFunc(function()

    end)
    nodeTimeLine:play("int", false)
    self.root:runAction(nodeTimeLine)
    
end

function UIAttackInfo:in_call(sender, eventType)

    if self.isNode1Out then
        self.isNode1Out = false
        self.mainBoard:stopAllActions()
        self.incall:runAction(cc.RotateTo:create(0.35,180))
        self.mainBoard:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(-280,15)),2))        
    else
        self.isNode1Out = true
        self.mainBoard:stopAllActions()
        self.incall:runAction(cc.RotateTo:create(0.35,0))        
        self.mainBoard:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(5,15)),2))        
    end 
end

function UIAttackInfo:showBoard()
    self.isNode1Out = true
    self.mainBoard:stopAllActions()
    self.incall:runAction(cc.RotateTo:create(0.35,0))        
    self.mainBoard:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(5,15)),2))        
end

function UIAttackInfo:hideBoard()
    self.isNode1Out = false
    self.mainBoard:stopAllActions()
    self.incall:runAction(cc.RotateTo:create(0.35,180))
    self.mainBoard:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.35,cc.p(-280,15)),2))     
end

function UIAttackInfo:resizeBoard()

    local itemCount = math.max(math.max(#self.contentAttactData,#self.contentDefData),#self.contentStayData)
    if itemCount == 0 then itemCount = 1 end
    local height = math.min(itemCount * self.itsize:getContentSize().height,self.tbsize:getContentSize().height)
    self.childBoard:setContentSize(cc.size(290,52 + height))

    self.incall:getParent():setPositionY(-(52 + height) / 2 + 48)
end

function UIAttackInfo:show_att(sender, eventType)

    self.att_btn:setEnabled(false)
    self.def_btn:setEnabled(true)
    self.ger_btn:setEnabled(true)
    -- self.notouch_def:setTouchEnabled(false)
    -- self.notouch_att:setTouchEnabled(true)

    self.defTableView:setVisible(false)
    self.tableView:setVisible(true)
    self.stayTableView:setVisible(false)

    self.dir:setPositionX(self.att_btn:getPositionX())
end

function UIAttackInfo:def_call(sender, eventType)

    self.att_btn:setEnabled(true)
    self.def_btn:setEnabled(false)
    self.ger_btn:setEnabled(true)
    -- self.notouch_def:setTouchEnabled(true)
    -- self.notouch_att:setTouchEnabled(false)

    self.defTableView:setVisible(true)
    self.tableView:setVisible(false)
    self.stayTableView:setVisible(false)

    self.dir:setPositionX(self.def_btn:getPositionX())
end

function UIAttackInfo:ger_call(sender, eventType)

    self.att_btn:setEnabled(true)
    self.def_btn:setEnabled(true)
    self.ger_btn:setEnabled(false)
    -- self.notouch_def:setTouchEnabled(true)
    -- self.notouch_att:setTouchEnabled(false)

    self.stayTableView:setVisible(true)
    self.defTableView:setVisible(false)
    self.tableView:setVisible(false)

    self.dir:setPositionX(self.ger_btn:getPositionX())
end
--CALLBACKS_FUNCS_END

return UIAttackInfo

--endregion
