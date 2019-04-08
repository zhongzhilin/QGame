--region UIAchievePanel.lua
--Author : yyt
--Date   : 2017/02/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
local UITaskTab = require("game.UI.mission.UITaskTab")
--REQUIRE_CLASS_END

local UIAchievePanel  = class("UIAchievePanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIAchieveCell = require("game.UI.achieve.UIAchieveCell")
local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")

function UIAchievePanel:ctor()
    self:CreateUI()
end

function UIAchievePanel:CreateUI()
    local root = resMgr:createWidget("achievement/acm_bg")
    self:initUI(root)
end

function UIAchievePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "achievement/acm_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top_show = self.root.background.top_show_export
    self.FileNode_1 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.paging = self.root.paging_export
    self.paging = UITaskTab.new()
    uiMgr:configNestClass(self.paging, self.root.paging_export)
    self.title = self.root.title_export
    self.bottomNode = self.root.bottomNode_export
    self.cellSize = self.root.cellSize_export
    self.tbSize = self.root.tbSize_export
    self.table_node = self.root.table_node_export
    self.topNode = self.root.topNode_export
    self.topNode2 = self.root.topNode2_export
    self.btn_rmb = self.root.Node_3.btn_rmb_export
    self.rmb_num = self.root.Node_3.btn_rmb_export.rmb_num_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIAchieveCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.table_node:addChild(self.tableView)

    self.ResSetControl = ResSetControl.new(self.root,self)

    self.effectNode = cc.Node:create()
    self.root:addChild(self.effectNode)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGINs

function UIAchievePanel:onEnter()

    self.tableView:setData({})
    self.effectNode:removeAllChildren()
    self:getTaskList(true) 

    self.ResSetControl:setRmbDelay(0)
    self.ResSetControl:setData()

    local nodeTimeLine = resMgr:createTimeline("achievement/acm_bg")
    nodeTimeLine:setTimeSpeed(0.5)
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

    self:closeTab()
    -- self:showTab()

    self.FileNode_1:setData(4,false,nil)

    self.paging:setIndex(2)
end

function UIAchievePanel:showTab()

    self.FileNode_1:setVisible(true)

    self.paging:setVisible(true)
    self.top_show:setVisible(false)

    self.tableView:setSize(self.tbSize:getContentSize(), self.topNode2, self.bottomNode)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
end

function UIAchievePanel:closeTab()

    self.FileNode_1:setVisible(false)

    self.paging:setVisible(false)
    self.top_show:setVisible(true)
    -- self.top_show:setPositionY(0)

    self.tableView:setSize(self.tbSize:getContentSize(), self.topNode, self.bottomNode)
    -- 改变tableview 尺寸大小，重新设置下填充方向，不然会是倒序显示
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
end

function UIAchievePanel:setData(data,isInit)

    self.tableView:setData(data,not isInit)
    --对比数据
    global.achieveData:refershEffectData(data)
end

function UIAchievePanel:getTaskList(isInit)
    
    global.taskApi:getAchieveTaskList(function (msg)

        msg.tgTasks = msg.tgTasks or {}
        self:setData(global.achieveData:changeServerData(msg.tgTasks), isInit)
    end) 
end

function UIAchievePanel:refersh()
    self:getTaskList()
end

function UIAchievePanel:playHarvestEffect(posX, posY, diamondNum)

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_FlyMoney")
    self:runAction(cc.Repeat:create(cc.Sequence:create(cc.CallFunc:create(function()
        
        local sp = cc.Sprite:create()
        sp:setSpriteFrame("ui_surface_icon/item_icon_005.png")
        sp:setPosition(cc.p(posX, posY))
        self.effectNode:addChild(sp)

        local endX, endY = gdisplay.width - 50,  gdisplay.height - 50
        local bezier = {}
        bezier[1] = cc.p(200 - math.random(100),endY + 50 - math.random(100))
        bezier[2] = cc.p(400 - math.random(200),endY + 150 - math.random(300))
        bezier[3] = cc.p(endX, endY)

        sp:runAction(cc.BezierTo:create(0.6,bezier))
        sp:setScale(0)
        sp:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3,1),cc.ScaleTo:create(0.3,0),cc.RemoveSelf:create()))

        local mms = cc.MotionStreak:create(0.5, 0.1, 7, cc.c3b(255,255,255),"map/stoneLine.png")
        mms:setFastMode(true)
        self.effectNode:addChild(mms)

        mms:setPosition(sp:getPosition())
        mms:setBlendFunc(cc.blendFunc(gl.ONE , gl.ONE))

        mms:runAction(cc.BezierTo:create(0.6,bezier))
    end),cc.DelayTime:create(0.1)),4))

    local number = ccui.TextAtlas:create(":"..math.floor(diamondNum),"fonts/number_white.png",33,40,"0")
    number:setPosition(cc.p(posX, posY))
    self.effectNode:addChild(number)

    number:setScale(0.7)
    number:setColor(cc.c3b(143, 222, 255))
    number:runAction(cc.Sequence:create(cc.DelayTime:create(0.6),cc.FadeOut:create(0.6)))
    number:runAction(cc.Sequence:create(cc.EaseIn:create(cc.MoveBy:create(1.2,cc.p(0,150)),1),cc.RemoveSelf:create()))

end
function UIAchievePanel:setPageViewCurrentPageIndex(index)
    self.FileNode_1:setPageViewCurrentPageIndex(index)
end

function UIAchievePanel:getPageViewCurrentPageIndex()
   return self.FileNode_1:getPageViewCurrentPageIndex()
end 


function UIAchievePanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIAchievePanel")  
end
--CALLBACKS_FUNCS_END

return UIAchievePanel

--endregion
