--region UISelectHeadFramePanel.lua
--Author : anlitop
--Date   : 2017/07/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISelectHeadFramePanel  = class("UISelectHeadFramePanel", function() return gdisplay.newWidget() end )


local UITableView = require("game.UI.common.UITableView")
local UIHeadFrameItemCell = require("game.UI.roleHead.UIHeadFrameItemCell")


function UISelectHeadFramePanel:ctor()
    self:CreateUI()
end

function UISelectHeadFramePanel:CreateUI()
    local root = resMgr:createWidget("rolehead/frame_panel")
    self:initUI(root)
end

function UISelectHeadFramePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rolehead/frame_panel")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top = self.root.top_export
    self.tableviewcontent = self.root.tableviewcontent_export
    self.tableviewitemcontent = self.root.tableviewitemcontent_export
    self.tableviewbottom = self.root.tableviewbottom_export
    self.tableviewadd = self.root.tableviewadd_export
    self.tableviewtop = self.root.tableviewtop_export

    uiMgr:addWidgetTouchHandler(self.root.Node_10.Button_1, function(sender, eventType) self:onSelectHead(sender, eventType) end)
--EXPORT_NODE_END
        
    
    self.tableView = UITableView.new()
    :setSize(self.tableviewcontent:getContentSize(), self.tableviewtop)
    :setCellSize(self.tableviewitemcontent:getContentSize())
    :setCellTemplate(UIHeadFrameItemCell)
    :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)--
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)--
    :setColumn(1)
    self.tableviewadd:addChild(self.tableView)


   global.uiMgr:addWidgetTouchHandler(self.top.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.root.Node_10.Button_1:setZoomScale(0)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UISelectHeadFramePanel:onEnter()

     global.userheadframedata:updateInfo()

    self:addEventListener(global.gameEvent.EV_ON_HEAMFREAM_UPDATE, function ()

        self:setData()

    end)

    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function() 
        
        self:setData()
    end)

    self:setData()


    global.userData:setHeadFrameRed(0)-- 清除本地小红点
    gevent:call(global.gameEvent.EV_ON_LOGIC_NOTIFY_RED_POINT)

end 


function UISelectHeadFramePanel:setData(data)

    local headframedata =  global.userheadframedata:getFrameData()


    self.tableView:setData(headframedata , true)

end


function UISelectHeadFramePanel:exit_call()
    gsound.stopEffect("city_click")
    global.panelMgr:closePanel("UISelectHeadFramePanel")
    global.panelMgr:closePanel("UIRoleHeadPanel")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
    global.panelMgr:openPanel("UILordPanel")

end 


function UISelectHeadFramePanel:onSelectHead(sender, eventType)
    gsound.stopEffect("city_click")
    global.panelMgr:closePanel("UISelectHeadFramePanel")
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_flip")
    global.panelMgr:openPanel("UIRoleHeadPanel")
end
--CALLBACKS_FUNCS_END

return UISelectHeadFramePanel

--endregion
