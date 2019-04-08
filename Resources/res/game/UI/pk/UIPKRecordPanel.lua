--region UIPKRecordPanel.lua
--Author : zzl
--Date   : 2018/02/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPKRecordPanel  = class("UIPKRecordPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local UIPKRecordItemCell = require("game.UI.pk.UIPKRecordItemCell")

function UIPKRecordPanel:ctor()
    self:CreateUI()
end

function UIPKRecordPanel:CreateUI()
    local root = resMgr:createWidget("player_kill/pk_record")
    self:initUI(root)
end

function UIPKRecordPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/pk_record")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.tb_add = self.root.tb_add_export
    self.tb_cotent = self.root.tb_cotent_export
    self.item_content = self.root.item_content_export
    self.title = self.root.title_export
    self.tb_top = self.root.tb_top_export
    self.tb_bot = self.root.tb_bot_export
    self.flushNode = self.root.flushNode_export

--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType)  
        global.panelMgr:closePanel("UIPKRecordPanel")
    end)

    self.tableView = UITableView.new()
        :setSize(self.tb_cotent:getContentSize(), self.tb_top , self.tb_bot)
        :setCellSize(self.item_content:getContentSize())
        :setCellTemplate(UIPKRecordItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_add:addChild(self.tableView)

    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIPKRecordPanel:onEnter()

    local loading_TimeLine = resMgr:createTimeline("world/map_Load")  
    loading_TimeLine:play("animation0", true)
    self.flushNode:runAction(loading_TimeLine)

    self.isPushOver = false
    self.lFightID = 0
    self.lastData = {}
    self:showFlush()
    self.lFightID = nil
end 

function UIPKRecordPanel:tableMove()

    local curOffsetY = self.tableView:getContentOffset().y
    local minOffsetY = self.tableView:minContainerOffset().y
    local maxOffsetY = self.tableView:maxContainerOffset().y
    local tbSize = self.tb_cotent:getContentSize().height

    local isFlush = false
    if minOffsetY > 0 and curOffsetY > (minOffsetY+tbSize/8) then
        isFlush = true 
    elseif minOffsetY <= 0 and curOffsetY > (maxOffsetY+tbSize/8) then
        isFlush = true
    end

    if isFlush and (not self.isPushOver) and (not self.isVisFlush) then
        -- 刷新
        self:showFlush()

    else
        if self.isVisFlush and (curOffsetY < ( maxOffsetY +64 ) ) then
            self:hideFlush()
        end
    end
end

--- 上拉刷新
function UIPKRecordPanel:showFlush()

    self.isVisFlush = true
    self.flushNode:setVisible(true)

    self:pullServerData(self.lFightID)
end

function UIPKRecordPanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end

function UIPKRecordPanel:onExit()

    gsound.stopEffect("city_click")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")

    self.tableView:setData({})
end 

-- 分页拉取联盟动态
function UIPKRecordPanel:pullServerData(page)

    print(page ,"page-->>>>")

    global.commonApi:getPKRecordList(page ,function(msg)

        self:hideFlush()
        msg = msg or {}
        
        if msg.tagPKRecord and #msg.tagPKRecord > 0 then

            -- 当前offset
            self:setCurTableOffset()

            self:connectData(msg.tagPKRecord)

            self.tableView:setData(self.lastData)
            
            -- 调整offset
            self:adjustTableOffset()

            for _ ,v in pairs(self.lastData or {} ) do 

                if not self.lFightID then 
                    self.lFightID =tonumber( v.lFightID)
                end 
                if v.lFightID < self.lFightID then 
                    self.lFightID = tonumber(v.lFightID)
                end 
            end 

        else
            self.isPushOver = true
        end

    end)
end

function UIPKRecordPanel:setCurTableOffset()
    
    -- 当前位置
    self.lastOffset = self.tableView:getContentOffset()
    self.lastMinOffset = self.tableView:minContainerOffset()

end

function UIPKRecordPanel:adjustTableOffset()
    if not self.lFightID  then return end

    -- 重置
    local curOffset = self.lastOffset
    local minOffset = self.tableView:minContainerOffset()
    if minOffset.y < 0 then

        curOffset.y = curOffset.y - (math.abs(minOffset.y) - math.abs(self.lastMinOffset.y))
        self.tableView:setContentOffset(curOffset)
    end

end


function UIPKRecordPanel:connectData(cur)
    if #cur == 0 then return end

    for _,v in pairs(cur) do
        table.insert(self.lastData, v)
    end
end



--CALLBACKS_FUNCS_END

return UIPKRecordPanel

--endregion
