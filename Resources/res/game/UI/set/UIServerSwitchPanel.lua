--region UIServerSwitchPanel.lua
--Author : anlitop
--Date   : 2017/04/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UISetTIme = require("game.UI.set.UISetTIme")
--REQUIRE_CLASS_END
local UIServerSwitchPanel  = class("UIServerSwitchPanel", function() return gdisplay.newWidget() end )
local UITableView =  require("game.UI.common.UITableView")
local UIServerSwitchItemCell = require("game.UI.set.UIServerSwitchItemCell")


function UIServerSwitchPanel:ctor()
    self:CreateUI()
end

function UIServerSwitchPanel:CreateUI()
    local root = resMgr:createWidget("settings/server_switch")
    self:initUI(root)
end

function UIServerSwitchPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/server_switch")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.TimeNode = UISetTIme.new()
    uiMgr:configNestClass(self.TimeNode, self.root.TimeNode)
    self.title = self.root.title_export
    self.tableview_item = self.root.tableview_item_export
    self.tableview_content = self.root.tableview_content_export
    self.tableview_top = self.root.tableview_top_export
    self.tableview_bootom = self.root.tableview_bootom_export
    self.tableview_add = self.root.tableview_add_export
    self.flushNode = self.root.flushNode_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    self.tableView = UITableView.new()
            :setSize(self.tableview_content:getContentSize(), self.tableview_top, self.tableview_bootom)-- 设置大小， scrollview滑动区域（定位置， 低位置）
            :setCellSize(self.tableview_item:getContentSize()) -- 每个小intem 的大小
            :setCellTemplate(UIServerSwitchItemCell) -- 回调函数
            :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
            :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
            :setColumn(2)
    self.tableview_add:addChild(self.tableView)

    self.tableView:registerScriptHandler(handler(self, self.tableMove), cc.SCROLLVIEW_SCRIPT_SCROLL)
end

function UIServerSwitchPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

function UIServerSwitchPanel:onEnter()

    self.m_eventListenerCustomList = {}
    self:setData()

    -- 加载
    local loading_TimeLine = resMgr:createTimeline("world/map_Load")
    loading_TimeLine:play("animation0", true)
    self.flushNode:runAction(loading_TimeLine)
    self.flushNode:setVisible(false)
end 


function UIServerSwitchPanel:tableMove()

    local curOffsetY = self.tableView:getContentOffset().y
    local minOffsetY = self.tableView:minContainerOffset().y
    local maxOffsetY = self.tableView:maxContainerOffset().y
    local tbSize = self.tableview_content:getContentSize().height

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



function UIServerSwitchPanel:setData()

    self.isPushOver = false
    self.curlPage = 1
    self.lastData = {}

    self:showFlush(true)
end

--- 上拉刷新
function UIServerSwitchPanel:showFlush(isForce)

    self.isVisFlush = true
    self.flushNode:setVisible(true)

    self:pullServerData(isForce)
end

function UIServerSwitchPanel:hideFlush()
    self.isVisFlush = false
    self.flushNode:setVisible(false)
end


local backlist = {} 

-- 分页拉取联盟动态
function UIServerSwitchPanel:pullServerData(isForce)

    local min = nil 

    local cancheck = function (v , id)  -- 取min的时候就要排除 isfirst<>0 和 server 7 和 8的干扰

        if  v.sortid== "0" or v.isfirst == "1" then   

            return false 
        end 

        return true
    end  

    for _ ,v in pairs(global.ServerData:getSeverList()) do 

        local serverid = tonumber(v.serverid)
        if not min and cancheck(v ,  tonumber(v.serverid)) then min = tonumber(v.serverid) end 
        if min and  tonumber(v.serverid) < min and cancheck(v ,  tonumber(v.serverid)) then 
             min = tonumber(v.serverid)
        end 
    end 

    if self.min == min and not isForce then 

        self.isPushOver = true
        self:hideFlush()

        return 
    end 
    self.min  = min

    global.ServerData:addDictionaryData("min" , min)

    global.ServerData:requestServerList(function (status)
        
        if tolua.isnull(self) then return end 

        self:hideFlush()
        self:setCurTableOffset()

        if status=="completed" and self.updataUI then 
            self.data = global.ServerData:getSeverList()
            self:updataUI()
        end
        self:adjustTableOffset()

         self.curlPage =  self.curlPage +1 
    end)

    global.ServerData:addDictionaryData("min" , nil)

    print(self.curlPage ,"self.curlPage")

end

function UIServerSwitchPanel:setCurTableOffset()
    
    -- 当前位置
    self.lastOffset = self.tableView:getContentOffset()
    self.lastMinOffset = self.tableView:minContainerOffset()

end

function UIServerSwitchPanel:adjustTableOffset()
    if self.curlPage == 1 then return end

    -- 重置
    local curOffset = self.lastOffset
    local minOffset = self.tableView:minContainerOffset()
    if minOffset.y < 0 then

        curOffset.y = curOffset.y - (math.abs(minOffset.y) - math.abs(self.lastMinOffset.y))
        self.tableView:setContentOffset(curOffset)
    end
    
end

function UIServerSwitchPanel:connectData(cur)
    if #cur == 0 then return end

    for _,v in pairs(cur) do
        table.insert(self.lastData, v)
    end
end



function UIServerSwitchPanel:updataUI()
    if not self.data then return  end 

    local temp = {}
    if _CPP_RELEASE == 1 then
        temp,_ = self:checkServer(self.data)
    else
        _,temp = self:checkServer(self.data)
    end
    table.sort(temp,function(A,B) return tonumber(A.serverid)< tonumber(B.serverid) end )

    self.tableView:setData(temp)

end 

function UIServerSwitchPanel:checkServer(data)
    -- body
    local temp = {}
    local inner = {}
    for _,v in pairs(data) do
        if tonumber(v.status) == WCODE.SERVER_STATE_OK then
            table.insert(temp, v)
        else
            table.insert(inner, v)
            if v.dop then
                table.insert(temp, v)
            end
        end
    end
    return temp,inner
end

function UIServerSwitchPanel:exit_call(sender, eventType) 
    global.panelMgr:closePanel("UIServerSwitchPanel")
end 


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIServerSwitchPanel

--endregion
