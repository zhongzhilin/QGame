--region UIChatGiftPanel.lua
--Author : yyt
--Date   : 2018/02/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIChatGiftPanel  = class("UIChatGiftPanel", function() return gdisplay.newWidget() end )

function UIChatGiftPanel:ctor()
    self:CreateUI()
end

function UIChatGiftPanel:CreateUI()
    local root = resMgr:createWidget("chat/chat_unionGift")
    self:initUI(root)
end

function UIChatGiftPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chat/chat_unionGift")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.node1 = self.root.Node_export.node1_export
    self.portrait_node = self.root.Node_export.node1_export.portrait_node_export
    self.headFrame = self.root.Node_export.node1_export.portrait_node_export.headFrame_export
    self.name = self.root.Node_export.node1_export.name_export
    self.t1 = self.root.Node_export.node1_export.t1_mlan_4_export
    self.t2 = self.root.Node_export.node1_export.t2_mlan_8_export
    self.t3 = self.root.Node_export.node1_export.t3_mlan_12_export
    self.node2 = self.root.Node_export.node2_export
    self.quit = self.root.Node_export.node2_export.item.quit_export
    self.itemName = self.root.Node_export.node2_export.item.itemName_export
    self.icon = self.root.Node_export.node2_export.item.icon_export
    self.node3 = self.root.Node_export.node3_export
    self.getState = self.root.Node_export.node3_export.getState_export
    self.getStateNum = self.root.Node_export.node3_export.getStateNum_export
    self.btnList = self.root.Node_export.node3_export.btnList_export
    self.t7 = self.root.Node_export.node3_export.btnList_export.t7_mlan_10_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.node1_export.getGiftBtn, function(sender, eventType) self:getGiftHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btnList, function(sender, eventType) self:giftListHandler(sender, eventType) end)
--EXPORT_NODE_END
end

function UIChatGiftPanel:onEnter()
    self.m_eventListenerCustomList = {}
end

function UIChatGiftPanel:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- szParam = "1+1101+10"   (1红包id、 2礼包id 3总共可领取个数)
function UIChatGiftPanel:setData(data, msg, retCode)

    dump(data, " ==>UIChatGiftPanel setData:")

    self.btnList:setVisible(true)
    self.getStateNum:setVisible(true)
    for i=1,3 do
        self["node"..i]:setVisible(false)
    end

    self.data = data
    local tagSpl = data.tagSpl
    local szPara = global.tools:strSplit(tagSpl.szParam, '+')
    self.giftId = tonumber(szPara[1] or "0")
    self.totalNum = tonumber(szPara[3] or "0")

    if retCode == 0 and msg then
        self:initData(msg)
    else
        self.btnList:setVisible(false)
        self.getStateNum:setVisible(false)
        self.node3:setVisible(true)
        self.getState:setString(luaCfg:get_local_string(11099))
    end

    if data.lType and data.lType == 2 then -- 世界聊天
        self.t2:setString(luaCfg:get_local_string(11131))
        self.t3:setString(luaCfg:get_local_string(11134))
        self.t7:setString(luaCfg:get_local_string(11132))
    else
        self.t2:setString(luaCfg:get_local_string(11130))
        self.t3:setString(luaCfg:get_local_string(11133))
        self.t7:setString(luaCfg:get_local_string(11132))
    end
   
end

function UIChatGiftPanel:initData(data)
    
    dump(data, "--> UIChatGiftPanel:initData: ")

    self.tagItem = data.tagItem or {}
    self.tagLog = data.tagLog or {}

    self.isGeted = false
    for k,v in pairs(self.tagLog) do
        if v.lUserID == global.userData:getUserId() then
            self.isGeted = true
            break
        end
    end

    local curGetNum = #self.tagLog
    if self.isGeted then  --已经领取过
        
        self.node3:setVisible(true)
        if curGetNum < self.totalNum then
            self.getState:setString(luaCfg:get_local_string(11096))
            self.getStateNum:setString(curGetNum .. "/" .. self.totalNum)
        else
            self.getState:setString(luaCfg:get_local_string(11097)) -- 已领完
            self.getStateNum:setString(self.totalNum .. "/" .. self.totalNum)
        end
    else

        if curGetNum >= self.totalNum then
            self.node3:setVisible(true)
            self.getState:setString(luaCfg:get_local_string(11097)) -- 已领完
            self.getStateNum:setString(self.totalNum .. "/" .. self.totalNum)
        else   
            self.node1:setVisible(true)
            self:senderInit()
            -- effect
            self.root:stopAllActions()
            local nodeTimeLine = resMgr:createTimeline("chat/chat_unionGift")
            nodeTimeLine:play("animation2", true)
            self.root:runAction(nodeTimeLine)
        end

    end

end

-- 礼包发送人
function UIChatGiftPanel:senderInit()
    
    local data = self.data
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

    self.name:setString(data.szFrom or "")

    -- 下载用户头像
    local data = {}
    table.insert(data,self.data.szCustomIco)
    local storagePath = global.headData:downloadPngzips(data)
    table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
        -- body
        if self and not tolua.isnull(self.portrait_node) then
            global.tools:setCircleAvatar(self.portrait_node, global.headData:convertHeadData(self.data,head))
        end
    end))
end

-- 查看已领取列表
function UIChatGiftPanel:giftListHandler(sender, eventType)
    self:onCloseHandler()
    global.panelMgr:openPanel("UIGiftListPanel"):setData(self.data, self.tagLog)
end

-- 领取联盟红包
function UIChatGiftPanel:getGiftHandler(sender, eventType)

    global.chatApi:chatRedGift(function (msg, ret)
        -- body
        dump(msg, " ==> getGiftHandler:")
        if ret and ret == 0 then
            self:getGiftCall(msg)
        else
            self:onCloseHandler()
            global.tipsMgr:showWarning("unionGiftInvalid")
        end
    end, 1, {self.giftId})
end

function UIChatGiftPanel:getGiftCall(msg)

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_daytask")
    
    -- body
    self.node1:setVisible(false)
    self.node2:setVisible(true)

    if msg.tagItem and msg.tagItem[1] then

        local itemId = msg.tagItem[1].lID
        local itemData = luaCfg:get_item_by(itemId) or luaCfg:get_equipment_by(itemId)
        global.panelMgr:setTextureForAsync(self.icon, itemData.itemIcon or itemData.icon, true)
        global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)
        self.itemName:setString(itemData.itemName or itemData.name)
    end

    self.node2.item:setOpacity(0)

    -- effect
    self.root:stopAllActions()
    local nodeTimeLine = resMgr:createTimeline("chat/chat_unionGift")
    nodeTimeLine:play("animation0", false)
    nodeTimeLine:setLastFrameCallFunc(function()
        nodeTimeLine:play("animation1", true)
    end)
    self.root:runAction(nodeTimeLine)

end

function UIChatGiftPanel:onCloseHandler(sender, eventType)

    global.panelMgr:closePanel("UIChatGiftPanel")
end

--CALLBACKS_FUNCS_END

return UIChatGiftPanel

--endregion
