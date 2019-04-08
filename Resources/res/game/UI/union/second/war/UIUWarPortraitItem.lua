--region UIUWarPortraitItem.lua
--Author : wuwx
--Date   : 2017/02/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUWarPortraitItem  = class("UIUWarPortraitItem", function() return gdisplay.newWidget() end )

function UIUWarPortraitItem:ctor()
   self:CreateUI() 
end

function UIUWarPortraitItem:CreateUI()
    local root = resMgr:createWidget("union/union_battle_portrait_btn")
    self:initUI(root)
end

function UIUWarPortraitItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_battle_portrait_btn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_node = self.root.btn.scale.portrait_node_export
    self.headFrame = self.root.btn.scale.portrait_node_export.headFrame_export

    uiMgr:addWidgetTouchHandler(self.root.btn, function(sender, eventType) self:goHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.root.btn:setSwallowTouches(false)
    self.root.btn:setPressedActionEnabled(false)
end

function UIUWarPortraitItem:setData(data)
    
    local head = global.luaCfg:get_rolehead_by(data.lHeadID)
    
    global.tools:setCircleAvatar(self.portrait_node, head)

    if data.lBackID then 

        local info  = global.luaCfg:get_role_frame_by( data.lBackID)

        if info then 

            self.headFrame:setVisible(true)

            -- self.headFrame:setSpriteFrame(info.pic)
            global.panelMgr:setTextureFor(self.headFrame,info.pic)
        else 

            self.headFrame:setVisible(false)
        end 

    else 

        self.headFrame:setVisible(false)  
    end 

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUWarPortraitItem:goHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIUWarPortraitItem

--endregion
