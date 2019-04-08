--region UIFriendNew.lua
--Author : yyt
--Date   : 2017/08/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIFriendNew  = class("UIFriendNew", function() return gdisplay.newWidget() end )

function UIFriendNew:ctor()
    self:CreateUI()
end

function UIFriendNew:CreateUI()
    local root = resMgr:createWidget("friend/friend_list_free")
    self:initUI(root)
end

function UIFriendNew:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "friend/friend_list_free")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Sprite_1 = self.root.Button_1.Sprite_1_export
    self.icon1 = self.root.Button_1.Sprite_1_export.icon1_export
    self.text1 = self.root.Button_1.Sprite_1_export.text1_export
    self.Sprite_2 = self.root.Button_1.Sprite_2_export
    self.text2 = self.root.Button_1.Sprite_2_export.text2_export

    uiMgr:addWidgetTouchHandler(self.root.Button_1, function(sender, eventType) self:friendHandler(sender, eventType) end)
--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIFriendNew:onEnter()
    
    self.root:stopAllActions()
    local nodeTimeLine = resMgr:createTimeline("friend/friend_list_free")
    nodeTimeLine:play("sleep", true)
    self.root:runAction(nodeTimeLine)
end

function UIFriendNew:setData(isDiplomatic, isExploit, isHeroSleep)
    
    self.isExploit    = isExploit
    self.isDiplomatic = isDiplomatic
    self.isHeroSleep  = isHeroSleep
    self.icon1:setScale(0.6)
    self.icon1:setVisible(true)
    self.icon1:setSpriteFrame("ui_surface_icon/Friend_icon2.png")  
    self.text1:setString(global.luaCfg:get_local_string(10921))

    self.Sprite_1:setVisible(true)
    self.Sprite_2:setVisible(false)
    
    if isExploit then

        self.icon1:setScale(0.5)
        self.icon1:setSpriteFrame("ui_surface_icon/exploit_d03.png")
        self.text1:setString(global.luaCfg:get_local_string(10922))
    elseif isDiplomatic then

        self.icon1:setScale(1)
        self.icon1:setSpriteFrame("ui_surface_icon/diplomatic_icon1.png")
    elseif isHeroSleep then
        
        self.Sprite_1:setVisible(false)
        self.Sprite_2:setVisible(true)
        self.text2:setString(global.luaCfg:get_local_string(10967))
        self.Sprite_2:setContentSize(cc.size( self.text2:getContentSize().width+20,self.Sprite_2:getContentSize().height))
        self.text2:setPositionY(self.Sprite_2:getContentSize().height * 60 /100)
        self.text2:setPositionX(self.Sprite_2:getContentSize().width * 50 /100)

    end

end

function UIFriendNew:friendHandler(sender, eventType)

    if self.isExploit then
        global.panelMgr:openPanel("UIExploitPanel")
    elseif self.isDiplomatic then
        global.panelMgr:openPanel("UIDiplomaticPanel")
    elseif self.isHeroSleep then
        global.panelMgr:openPanel("UIHeroPanel"):setMode4()
        global.funcGame:cleanContionTag()
        gevent:call(global.gameEvent.EV_ON_HERO_FREE)
    else
	   global.panelMgr:openPanel("UIFriendPanel")
    end
end
--CALLBACKS_FUNCS_END

return UIFriendNew

--endregion
