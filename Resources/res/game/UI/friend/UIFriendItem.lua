--region UIFriendItem.lua
--Author : yyt
--Date   : 2017/08/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIFriendItem  = class("UIFriendItem", function() return gdisplay.newWidget() end )

function UIFriendItem:ctor()
    self:CreateUI()
end

function UIFriendItem:CreateUI()
    local root = resMgr:createWidget("friend/friend_list")
    self:initUI(root)
end

function UIFriendItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "friend/friend_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.Button_1.bg.name_export
    self.portrait = self.root.Button_1.bg.portrait_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.Button_1.bg.portrait_export)
    self.onLineState = self.root.Button_1.bg.onLineState_export
    self.btn_refuse = self.root.Button_1.bg.btn_refuse_export
    self.btn_agree = self.root.Button_1.bg.btn_agree_export

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:userInfoHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.btn_refuse, function(sender, eventType) self:refuseHandler(sender, eventType) end, true)
    uiMgr:addWidgetTouchHandler(self.btn_agree, function(sender, eventType) self:agreeHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.root.Button_1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.root.Button_1:setSwallowTouches(false)
    self.btn_refuse:setSwallowTouches(false)
    self.btn_agree:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIFriendItem:setData(data)
    
    self.refuseClick = false
    self.agreeClick  = false

    self.data = data
    self.portrait:setData(data.lheadimg or 108, data.lbackid or nil, data)
    if data.lAllyFlag and data.lAllyFlag == "" then
        self.name:setPositionX(118)
        self.name:setString(luaCfg:get_local_string(10333, data.lAllyFlag) .. data.lszname )
    else
        self.name:setPositionX(130)
        self.name:setString(data.lszname)
    end

    -- 是否公开
    if data.lisonline then
        self.onLineState:setVisible(true)
        if data.lisonline == 0 then -- 离线
            self.onLineState:setString(global.luaCfg:get_local_string(10775))
            self.onLineState:setTextColor(cc.c3b(109, 79, 53))
        else
            self.onLineState:setString(global.luaCfg:get_local_string(10774))
            self.onLineState:setTextColor(cc.c3b(87, 213, 63))
        end
    else
        self.onLineState:setVisible(false)
    end

    -- 是否申请
    self.btn_refuse:setVisible(false)
    self.btn_agree:setVisible(false)
    if data.lrequest == 2 then
        self.btn_refuse:setVisible(true)
        self.btn_agree:setVisible(true)
    end

end

function UIFriendItem:refuseHandler(sender, eventType)
    
    local sPanel = global.panelMgr:getPanel("UIFriendPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isStartMove = false
        self.root.Button_1:setZoomScale(0)
    end
    if eventType == ccui.TouchEventType.ended then
        
        self.root.Button_1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
        if sPanel.isStartMove then 
            return
        end

        self.refuseClick = true
        global.unionApi:getFriendList(function (msg)
            gevent:call(global.gameEvent.EV_ON_FRIEND_UPDATE)
            global.tipsMgr:showWarning("Friend07")
        end, 5, self.data.lUid)

    end

    if eventType == ccui.TouchEventType.canceled then
        self.root.Button_1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    end

end

function UIFriendItem:agreeHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIFriendPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isStartMove = false
        self.root.Button_1:setZoomScale(0)
    end
    if eventType == ccui.TouchEventType.ended then
        
        self.root.Button_1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
        if sPanel.isStartMove then 
            return
        end

        self.agreeClick = true
        global.unionApi:getFriendList(function (msg)
            gevent:call(global.gameEvent.EV_ON_FRIEND_UPDATE)
            global.tipsMgr:showWarning("Friend08")
        end, 4, self.data.lUid)

    end

    if eventType == ccui.TouchEventType.canceled then
        self.root.Button_1:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    end
end

function UIFriendItem:userInfoHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIFriendPanel")
    if eventType == ccui.TouchEventType.began then
        self.agreeClick  = false
        self.refuseClick = false
        sPanel.isStartMove = false
    end
    if eventType == ccui.TouchEventType.ended then
        
        if sPanel.isStartMove or self.agreeClick or self.refuseClick then 
            return
        end

        -- 获取用户详细信息
        global.chatApi:getUserInfo(function(msg)
               
            msg.tgInfo = msg.tgInfo or {}
            local panel = global.panelMgr:openPanel("UIChatUserInfoPanel")
            panel:setData(msg.tgInfo[1])
        end, {self.data.lUid})
        
    end

end
--CALLBACKS_FUNCS_END

return UIFriendItem

--endregion
