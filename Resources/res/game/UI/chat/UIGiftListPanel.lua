--region UIGiftListPanel.lua
--Author : yyt
--Date   : 2018/02/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIGiftListPanel  = class("UIGiftListPanel", function() return gdisplay.newWidget() end )

function UIGiftListPanel:ctor()
    self:CreateUI()
end

function UIGiftListPanel:CreateUI()
    local root = resMgr:createWidget("chat/chat_unionGoftList")
    self:initUI(root)
end

function UIGiftListPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chat/chat_unionGoftList")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.portrait_node = self.root.Node_export.portrait_node_export
    self.headFrame = self.root.Node_export.portrait_node_export.headFrame_export
    self.name = self.root.Node_export.name_export
    self.closeBtn = self.root.Node_export.closeBtn_export
    self.closeBtn = CloseBtn.new()
    uiMgr:configNestClass(self.closeBtn, self.root.Node_export.closeBtn_export)
    self.tbSize = self.root.Node_export.tbSize_export
    self.cellSize = self.root.Node_export.cellSize_export
    self.tbNode = self.root.Node_export.tbNode_export
    self.botNode = self.root.Node_export.botNode_export
    self.topNode = self.root.Node_export.topNode_export

    uiMgr:addWidgetTouchHandler(self.root.Panel, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
--EXPORT_NODE_END
    local UITableView = require("game.UI.common.UITableView")
    local UIGiftListItemCell = require("game.UI.chat.UIGiftListItemCell")
    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize(), self.topNode, self.botNode)
        :setCellSize(self.cellSize:getContentSize())
        :setCellTemplate(UIGiftListItemCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tbNode:addChild(self.tableView)
    
    self.closeBtn:setData(function () 
        global.panelMgr:closePanelForBtn("UIGiftListPanel")
    end)

end

function UIGiftListPanel:onEnter()
    self.m_eventListenerCustomList = {}
end

function UIGiftListPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIGiftListPanel:setData(data, logData)

    self.tableView:setData(logData or {})
    self:senderInit(data)

    -- 下载用户头像
    if logData then
        local data = {}
        for i,v in pairs(logData) do
            if v.szCustomIco ~= "" then
                table.insert(data,v.szCustomIco)
            end
        end
        local storagePath = global.headData:downloadPngzips(data)
        table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
            -- body
            if self and not tolua.isnull(self.tableView) then
                self.tableView:setData(self.tableView:getData(),true)
            end
        end))
    end
end

-- 礼包发送人
function UIGiftListPanel:senderInit(data)
    if not data then return end
    local head = {}
    head.path = luaCfg:get_rolehead_by(data.lFaceID or 101).path
    head.scale = 85
    global.tools:setCircleAvatar(self.portrait_node, global.headData:convertHeadData(data,head))

    if not data.lBackID then 
        self.headFrame:setVisible(false)
    else
        self.headFrame:setVisible(true)
        local info = luaCfg:get_role_frame_by(data.lBackID) or luaCfg:get_role_frame_by(1)
        if data.lFrom == global.userData:getUserId() then
            info = global.userheadframedata:getCrutFrame()
        end       
        global.panelMgr:setTextureFor(self.headFrame, info.pic)
    end 
    self.name:setString(luaCfg:get_local_string(11098, data.szFrom or ""))
end

function UIGiftListPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanel("UIGiftListPanel")
end
--CALLBACKS_FUNCS_END

return UIGiftListPanel

--endregion
