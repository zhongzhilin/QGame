--region BuildListPanel.lua
--Author : wuwx
--Date   : 2016/07/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local ResSet = require("game.UI.commonUI.widget.ResSet")
--REQUIRE_CLASS_END

local BuildListPanel  = class("BuildListPanel", function() return gdisplay.newWidget() end )

local UITableView = require("game.UI.common.UITableView")
local BuildListCell = require("game.UI.city.widget.BuildListCell")

function BuildListPanel:ctor()
    self:CreateUI()
end

function BuildListPanel:CreateUI()
    local root = resMgr:createWidget("city/build_ui")
    self:initUI(root)
end

function BuildListPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_ui")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.cell_tableview = self.root.cell_tableview_export
    self.panel_tableview = self.root.panel_tableview_export
    self.top = self.root.top_export
    self.res = ResSet.new()
    uiMgr:configNestClass(self.res, self.root.res)

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.top.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)

    self.tableView = UITableView.new()
        :setSize(self.panel_tableview:getContentSize())
        :setCellSize(self.cell_tableview:getContentSize())
        :setCellTemplate(BuildListCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.tableView:setName("buildlistTableview")
    self.panel_tableview:addChild(self.tableView)

    self.m_canTouch = true
    self:initTouch()
end

function BuildListPanel:initTouch()
    self.touchEventListener = cc.EventListenerTouchOneByOne:create()
    self.touchEventListener:setSwallowTouches(false)
    self.touchEventListener:registerScriptHandler(function(touch, event)
        -- body
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    -- self.touchEventListener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.touchEventListener:registerScriptHandler(function(touch, event)
        -- body
        if not self:isVisible() or not self.m_canTouch then return end
        local btn_build = global.g_cityView:getUIBtnBuild()
        -- local btn_build = global.g_cityView:getUIBtnBuild()
        local touchPos = touch:getLocation()
        local size = btn_build:getContentSize()
        local pos = btn_build:convertToWorldSpace(cc.p(0,0))
        if cc.rectContainsPoint(cc.rect(pos.x,pos.y,size.width,size.height), touchPos) then
        else
            self:onCloseHandler()
        end
    end, cc.Handler.EVENT_TOUCH_ENDED)
    -- self.touchEventListener:registerScriptHandler(function()
    --     -- body
    -- end, cc.Handler.EVENT_TOUCH_CANCELLED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEventListener, self.touch)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function BuildListPanel:onCloseHandler()
    global.g_cityView:hideBuildListPanel()
end

--CALLBACKS_FUNCS_END

function BuildListPanel:onEnter()
    self:reload(true)
    self.res:setFirstScroll(true)
    self.res:setData()

    -- self.tableView:scrollToLeft()
end

function BuildListPanel:reload(isReloadByOnEnter)

    if global.guideMgr:isPlaying() and not isReloadByOnEnter then return end

    local data = global.cityData:getBuildList()
    self.tableView:setData(data)
end

function BuildListPanel:gpsCardByBuildingType(_type)
    local _type = tonumber(_type)
    local data = self.tableView:getData()
    for i,v in ipairs(data) do
        -- log.trace("@@BuildListPanel:gpsCardByBuildingType->v.id:%s,_type:%s",v.id,_type)
        -- log.trace("v.id_type:%s,_type_type:%s",type(v.id),type(_type))
        if v.id == _type then
            -- self.tableView:jumpToCellByIdx(i)
            local cells = self.tableView:getCells()
            for k,cell in pairs(cells) do
                if cell:getData().id == _type then
                    log.trace("@@BuildListPanel:gpsCardByBuildingType->_type:%s,cellId:%s",_type,cell:getData().id )
                    return cell:getItem()
                end
            end
            log.error("@@BuildListPanel:gpsCardByBuildingType->cells:%s,cellId:%s",vardump(cells))
            return nil
        end
    end
    log.error("@@BuildListPanel:gpsCardByBuildingType->can not find buildingtype:%s,nowdata:%s",_type,vardump(data))
    return nil
end

function BuildListPanel:setTouchState(s)
    self.tableView:setTouchEnabled(s)
    self.m_canTouch = s
end

function BuildListPanel:isCanTouch()
    return self.m_canTouch
end


return BuildListPanel

--endregion
