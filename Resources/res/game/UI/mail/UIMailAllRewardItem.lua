--region UIMailAllRewardItem.lua
--Author : yyt
--Date   : 2018/03/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMailAllRewardItem  = class("UIMailAllRewardItem", function() return gdisplay.newWidget() end )
local UIMailAllRewardNodeCell = require("game.UI.mail.UIMailAllRewardNodeCell")
local UITableView =  require("game.UI.common.UITableView")

function UIMailAllRewardItem:ctor()
    self:CreateUI()
end

function UIMailAllRewardItem:CreateUI()
    local root = resMgr:createWidget("mail/mail_getReward_all_item")
    self:initUI(root)
end

function UIMailAllRewardItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "mail/mail_getReward_all_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.mailTime = self.root.Node_1.nodeTop.mailTime_export
    self.mailTitle = self.root.Node_1.nodeTop.mailTitle_export
    self.itemSize = self.root.Node_1.Node_2.itemSize_export
    self.tbNode = self.root.Node_1.Node_2.tbNode_export
    self.tbSize = self.root.Node_1.Node_2.tbSize_export
    self.cellSize = self.root.Node_1.Node_2.cellSize_export

    uiMgr:addWidgetTouchHandler(self.root.Node_1.nodeTop.detailMailBtn, function(sender, eventType) self:detailMailHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tbSize:getContentSize())-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.cellSize:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIMailAllRewardNodeCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
        :setColumn(1)
    self.tbNode:addChild(self.tableView)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMailAllRewardItem:setData(data)

    self.data = data
    self.mailTime:setString(global.mailData:getFormatTime(data.lTime))
    self.mailTitle:setString(self:getMailTitle(data))
    self.tableView:setData(data.tgItems or {})

end

function UIMailAllRewardItem:getMailTitle(data)
    -- body
    local str = ""
    -- if data.lType == 2 then 
    --     str = luaCfg:get_email_by(12001).Title
    -- else
    --     if data.lMailID and data.lMailID ~= 0 then
    --         local lmailData = luaCfg:get_email_by(data.lMailID)
    --         if lmailData then
    --             str = lmailData.Sender
    --         else
    --             str = data.szFromName or ""
    --         end
    --     else
    --         str = luaCfg:get_email_by(11001).Sender
    --     end
    -- end

    local lmailData = luaCfg:get_email_by(data.lMailID or 0) 
   
    -- 邮件标题
    if lmailData then

        local titleStr = luaCfg:get_local_string(tonumber(lmailData.mailName))
        if titleStr == "" then
            str = lmailData.mailName
        else
            str = titleStr
        end
    else
        str = data.szTitle
        if data.lCustom and data.lCustom == 1 and str ~= "" then -- 自定义邮件
            local cjson = require "base.pack.json"
            local responseData = cjson.decode(str)
            local curLan = global.languageData:getCurrentLanguage()
            str = responseData[curLan] or responseData["en"]
        end
            
    end

    return str
end

function UIMailAllRewardItem:detailMailHandler(sender, eventType)
    
    global.mailData._MAILTITLE = global.luaCfg:get_type_by(self.data.lType).name
    local data = global.mailData:changeServerData(clone(self.data))
    local detailPanel = global.mailData:getMailPanel(data.firstType) or "UIMailDetailPanel"  
    global.panelMgr:openPanel(detailPanel):setData(data)
end
--CALLBACKS_FUNCS_END

return UIMailAllRewardItem

--endregion
