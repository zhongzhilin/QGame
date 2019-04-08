--region UIOfficalInfoPanel.lua
--Author : Untory
--Date   : 2017/11/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIOfficalInfoPanel  = class("UIOfficalInfoPanel", function() return gdisplay.newWidget() end )
local UITableView = require("game.UI.common.UITableView")
local UIBuffCell = require("game.UI.offical.UIBuffCell")

function UIOfficalInfoPanel:ctor()
    self:CreateUI()
end

function UIOfficalInfoPanel:CreateUI()
    local root = resMgr:createWidget("offical/offical_info_bg")
    self:initUI(root)
end

function UIOfficalInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "offical/offical_info_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.tb_node = self.root.Node_export.tb_node_export
    self.tb_size = self.root.Node_export.tb_size_export
    self.it_size = self.root.Node_export.it_size_export
    self.node1 = self.root.Node_export.node1_export
    self.skill_name_lv = self.root.Node_export.node1_export.skill_name_lv_export
    self.top_btn = self.root.Node_export.node1_export.top_btn_export
    self.portrait_node = self.root.Node_export.node1_export.top_btn_export.portrait_node_export
    self.headFrame = self.root.Node_export.node1_export.top_btn_export.portrait_node_export.headFrame_export
    self.add_btn = self.root.Node_export.node1_export.top_btn_export.add_btn_export
    self.no_post = self.root.Node_export.node1_export.no_post_mlan_17_export
    self.lord_name = self.root.Node_export.node1_export.lord_name_export
    self.close_btn = self.root.Node_export.node1_export.close_btn_export
    self.self_go = self.root.Node_export.node1_export.self_go_export
    self.be_gone = self.root.Node_export.node1_export.be_gone_export
    self.desc = self.root.Node_export.node1_export.desc_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.top_btn, function(sender, eventType) self:choose_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.node1_export.top_btn_export.add_btn_export.Button_28, function(sender, eventType) self:choose_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.close_btn, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.self_go, function(sender, eventType) self:goSelfHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.be_gone, function(sender, eventType) self:goHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.tableView = UITableView.new()
        :setSize(self.tb_size:getContentSize())
        :setCellSize(self.it_size:getContentSize())
        :setCellTemplate(UIBuffCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.tb_node:addChild(self.tableView)

end

function UIOfficalInfoPanel:reloadData()
    self:setData(self.id , self.data)
end 

function UIOfficalInfoPanel:setData(id,data)
    
    local selfOff = global.panelMgr:getPanel('UIOfficalPanel'):getSelfOfficalId()
    local offType = global.funcGame:checkOfficalType(selfOff,id)

    print ('....check off type',offType)

    local offData = luaCfg:get_official_post_by(id)
    self.skill_name_lv:setString(offData.typeName)
    self.id = id
    self.data = data

    self.top_btn:setTouchEnabled(false)
    self.add_btn:setVisible(false)

    if data then        

        self.add_btn:setScale(0)
        self.lord_name:setVisible(true)
        self.portrait_node.pic:setVisible(true)
        self.no_post:setVisible(false)
        self.desc:setVisible(false)
        self.be_gone:setVisible(false)
        self.self_go:setVisible(false)
        self.add_btn:setVisible(true)
        self.top_btn:setTouchEnabled(true)
        self.headFrame:setVisible(true)
        self.lord_name:setString(data.lUserName)
        local head = luaCfg:get_rolehead_by(data.lHeadImg)
        head = global.headData:convertHeadData(data, head)
        if head.path then 
            global.tools:setCircleAvatar(self.portrait_node, head)
        end


        local headInfo = global.luaCfg:get_role_frame_by(tonumber(data.lBackID))
        if headInfo and headInfo.pic then
            global.panelMgr:setTextureFor(self.headFrame,headInfo.pic)     
        end 

        -- 本级
        if offType == 2 then
            -- 王者不能卸任
            if id ~= 101 then
                self.self_go:setVisible(true)
            end            
        elseif offType == 1 then -- 是上级
            self.be_gone:setVisible(true)        
        end
    else
        self.be_gone:setVisible(false) 
        self.self_go:setVisible(false)
        self.no_post:setVisible(true)
        self.desc:setVisible(true)
        self.add_btn:setScale(0.6)      
        self.lord_name:setVisible(false)
        self.portrait_node.pic:setVisible(false)
        self.headFrame:setVisible(false)

        local topOffical = global.funcGame:getTopOffical(offData.senior)
        if topOffical then
            uiMgr:setRichText(self, 'desc', 50226, {postname = topOffical.typeName})                
            self.desc:setVisible(true)
        else
            uiMgr:setRichText(self, 'desc', 50226, {postname = 'topOffical.typeName'})                
            self.desc:setVisible(false)
        end

        if offType == 2 then            
        elseif offType == 1 then -- 是上级
            self.add_btn:setVisible(true)
            self.top_btn:setTouchEnabled(true)
        end
    end 

    self:initBuff(offData)
end

function UIOfficalInfoPanel:initBuff(offData)
    
    local buff = offData.buff
    self.tableView:setData(buff)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIOfficalInfoPanel:onCloseHandler(sender, eventType)

    global.panelMgr:closePanel('UIOfficalInfoPanel')
end

function UIOfficalInfoPanel:exit_call(sender, eventType)

    global.panelMgr:closePanel('UIOfficalInfoPanel')
end

-- 罢免或者卸任
function UIOfficalInfoPanel:doSendNo()
    local landId = global.panelMgr:getPanel('UIOfficalPanel'):getCurLandId()
    global.worldApi:dropOffical(landId,self.id,function()
        self:setData(self.id,nil)
        global.panelMgr:getPanel('UIOfficalPanel'):cleanId(self.id)
    end)
end

function UIOfficalInfoPanel:goHandler(sender, eventType)

    if self.data.lCoolTime > global.dataMgr:getServerTime() then
        local str = global.funcGame.formatTimeToHMS( self.data.lCoolTime - global.dataMgr:getServerTime())
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData('getOffPost', function()
            self:doSendNo()
        end,str)    
    else
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData('confirmGetOff', function()
            self:doSendNo()
        end,str)
    end    
end

function UIOfficalInfoPanel:choose_call(sender, eventType)

    if self.data then

        -- 获取用户详细信息
        global.chatApi:getUserInfo(function(msg)
               
            msg.tgInfo = msg.tgInfo or {}
            local panel = global.panelMgr:openPanel("UIChatUserInfoPanel")
            panel:setData(msg.tgInfo[1])
            -- local currPanel = global.panelMgr:getPanel(currPanel)
            -- if currPanel.refershData then currPanel:refershData(msg.tgInfo[1]) end

        end, {self.data.lUserID} )
    else
      
        global.panelMgr:getPanel('UIOfficalPanel'):setCurOffId(self.id)
        global.panelMgr:openPanel("UIUnionAskPanel"):setData(nil, nil, 3)
    end    
end

function UIOfficalInfoPanel:goSelfHandler(sender, eventType)
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData('confirmSelfGetOff', function()
        self:doSendNo()
    end,str)
end
--CALLBACKS_FUNCS_END

return UIOfficalInfoPanel

--endregion
