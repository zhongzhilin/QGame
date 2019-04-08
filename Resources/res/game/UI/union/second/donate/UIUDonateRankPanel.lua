--region UIUDonateRankPanel.lua
--Author : wuwx
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUDonateRankPanel  = class("UIUDonateRankPanel", function() return gdisplay.newWidget() end )

function UIUDonateRankPanel:ctor()
    self:CreateUI()
end

function UIUDonateRankPanel:CreateUI()
    local root = resMgr:createWidget("union/union_donate_top_bj")
    self:initUI(root)
end

function UIUDonateRankPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_donate_top_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.title = self.root.title_export
    self.buttonList = self.root.buttonList_export
    self.all_combat = self.root.rank_self_bg.all_combat_export
    self.icon = self.root.rank_self_bg.icon_export
    self.num = self.root.rank_self_bg.num_export
    self.up_node = self.root.rank_self_bg.up_node_export
    self.down_node = self.root.rank_self_bg.down_node_export
    self.nochange_node = self.root.rank_self_bg.nochange_node_export
    self.portrait_node = self.root.rank_self_bg.portrait_node_export
    self.headFrame = self.root.rank_self_bg.portrait_node_export.headFrame_export
    self.name = self.root.rank_self_bg.name_export
    self.node_tableView = self.root.node_tableView_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemLayout = self.root.itemLayout_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    local UITableView = require("game.UI.common.UITableView")
    local UIUDonateRankCell = require("game.UI.union.second.donate.UIUDonateRankCell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUDonateRankCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)

    local TabControl = require("game.UI.common.UITabControl")
    self.tabControl = TabControl.new(self.buttonList, handler(self, self.onTabButtonChanged), 1,
        cc.c3b(255, 226, 165),cc.c3b(255, 255, 255))
end

function UIUDonateRankPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UIUDonateRankPanel")  
end

function UIUDonateRankPanel:onEnter()
    self.m_eventListenerCustomList = {}
    self:setData()
end

function UIUDonateRankPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end

function UIUDonateRankPanel:setData()
    self.headFrame:setVisible(false)
    self.all_combat:setString("")
    self.num:setString("")
    self.name:setString(global.userData:getUserName())
    self.tableView:setData({})    
    local head = global.headData:getCurHead()
    global.tools:setCircleAvatar(self.portrait_node, head)
    self.tabControl:setSelectedIdx(1)
    self:refresh(1,handler(self , self.playAnimation))
end

function UIUDonateRankPanel:refresh(index,call)

    print(index,"index")
    global.unionApi:getUserRankList(function(msg)
        -- body
        local data = msg.tgRankItems or {}
        
        if not tolua.isnull(self.tableView) then 
            self.tableView:setData(data)
        end 

        for i,v in ipairs(data) do
            if global.userData:isMine(v.lFindID) then
                if not tolua.isnull(self.all_combat) then 
                    self.all_combat:setString(v.lRank)
                    self.num:setString(v.lValue)
                    self.name:setString(global.userData:getUserName())
                    self:setHeadFrame(v.szParams[3])
                end 
                break
            end
        end
        if call then call() end

        
        -- 下载用户头像
        if msg.tgRankItems then
            local data = {}
            for i,v in pairs(msg.tgRankItems) do
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
    end, index)
end


function UIUDonateRankPanel:playAnimation()

    global.uiMgr:addSceneModel(1)
    local allCell = self.tableView:getCells()
    table.sort( allCell, function(a,b)
        -- bod
        return a:getPositionY()>b:getPositionY()
    end )
    local speed = 5000
    for i = 1, #allCell do
        local target = allCell[i]
        if target:getIdx() >= 0 then
            
            local overCall = function ()
                gsound.stopEffect("city_click")
                gevent:call(gsound.EV_ON_PLAYSOUND,"ui_list")
            end

            local opacity = 0
            local dt = 0.1*i
            local dy = -dt*speed
            if dy >= -gdisplay.height then
                dy = -gdisplay.height
            end
            local dp = cc.p(0,dy)
            local speedType = nil
            if i >= #allCell then
                global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
            else
                global.tools:moveInFromAnyOrient(target,dp,opacity,dt,speedType,overCall)
            end
        end
    end

end 


function UIUDonateRankPanel:onTabButtonChanged(index)

    self:refresh(index,handler(self , self.playAnimation))
end


function UIUDonateRankPanel:setHeadFrame(id)

    local headInfo = global.luaCfg:get_role_frame_by(tonumber( id))

    if headInfo and headInfo.pic then
        -- print("设置头像框 //////////////")
        self.headFrame:setVisible(true)
        global.panelMgr:setTextureFor(self.headFrame,headInfo.pic)
    else 
    end 
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUDonateRankPanel

--endregion
