--region UIChatUnionRecruit.lua
--Author : yyt
--Date   : 2017/11/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIChatUnionRecruit  = class("UIChatUnionRecruit", function() return gdisplay.newWidget() end )

function UIChatUnionRecruit:ctor()
    
end

function UIChatUnionRecruit:CreateUI()
    local root = resMgr:createWidget("chat/chat_top")
    self:initUI(root)
end

function UIChatUnionRecruit:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chat/chat_top")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node_1 = self.root.Panel_3.Node_1_export
    self.unionFlag = self.root.Panel_3.Node_1_export.unionFlag_export
    self.unionFlag = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.unionFlag, self.root.Panel_3.Node_1_export.unionFlag_export)
    self.txtContent = self.root.Panel_3.Node_1_export.txtContent_export
    self.IconNode = self.root.Panel_3.Node_1_export.btnHead.IconNode_export
    self.headFrame = self.root.Panel_3.Node_1_export.btnHead.IconNode_export.headFrame_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_3.Node_1_export.Button_20, function(sender, eventType) self:clickTextHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Panel_3.Node_1_export.btnHead, function(sender, eventType) self:headClickHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.unionFlag:setCascadeOpacityEnabled(true)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIChatUnionRecruit:setData(data, isAnimation)

    -- -- 头像设置
    -- local head = global.headData:getCurHead()
    -- if data.lFrom ~= global.userData:getUserId() then
    --     head = luaCfg:get_rolehead_by(data.lFaceID)
    -- end
    -- global.tools:setClipCircleAvatarWithScale(self.IconNode, head)

    -- -- 头像框
    -- local info = global.luaCfg:get_role_frame_by(data.lBackID)
    -- if not info  then
    --    info =  global.luaCfg:get_role_frame_by(1)
    -- end 
    -- if data.lFrom == global.userData:getUserId()0 then
    --     info = global.userheadframedata:getCrutFrame()
    -- end
    -- global.panelMgr:setTextureFor(self.headFrame, info.pic)

    if isAnimation then

        self.root:stopAllActions()
        local nodeTimeLine = resMgr:createTimeline("chat/chat_top")
        nodeTimeLine:play("animation0", false)
        nodeTimeLine:setLastFrameCallFunc(function()

            self:initData(data)
            local nodeTimeLine1 = resMgr:createTimeline("chat/chat_top")
            nodeTimeLine1:play("animation1", false)
            self.root:runAction(nodeTimeLine1)
        end)
        self.root:runAction(nodeTimeLine)
    else
        self:initData(data)
    end
end

function UIChatUnionRecruit:initData(data)
    data.itemType = 1 
    data.itemKind = 2

    self.data = data

    if data.tagSpl then 

        local szParam = global.tools:strSplit(data.tagSpl.szParam, '@')  or {} 
        local showStr = " " .. luaCfg:get_local_string(10793, unpack(szParam))
        self.txtContent:setString(showStr)

        local szParam = global.tools:strSplit(data.tagSpl.szInfo, '@')   
        if szParam and szParam[1] then
            self.unionFlag:setData(tonumber(szParam[1]))
        else
            self.unionFlag:setData(1)
        end
    end 
end

function UIChatUnionRecruit:clickTextHandler(sender, eventType)
    
    -- 显示复制等功能节点
    local chatPanel = global.panelMgr:getPanel("UIChatPanel")
    local nodePos = cc.p(gdisplay.width/2, gdisplay.height-330)
    chatPanel:showFuncBorard(self.data, nodePos, gdisplay.width/2)
    chatPanel.FuncNode.row:setFlippedY(true)
    chatPanel.FuncNode.row:setPositionY(85)
end

function UIChatUnionRecruit:headClickHandler(sender, eventType)

    local selectUserId = global.userData:getUserId()
    if self.data.itemType == 1 then
        selectUserId = self.data.lFrom
    end

    -- 获取用户详细信息
    global.chatApi:getUserInfo(function(msg)
           
        msg.tgInfo = msg.tgInfo or {}
        local panel = global.panelMgr:openPanel("UIChatUserInfoPanel")
        panel:setData(msg.tgInfo[1])
    end, {selectUserId} )

end

--CALLBACKS_FUNCS_END

return UIChatUnionRecruit

--endregion
