--region UIPortraitWidget.lua
--Author : wuwx
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPortraitWidget  = class("UIPortraitWidget", function() return gdisplay.newWidget() end )

function UIPortraitWidget:ctor()
    -- self:CreateUI()
end

function UIPortraitWidget:CreateUI()
    local root = resMgr:createWidget("union/portrait_btn")
    self:initUI(root)
end

function UIPortraitWidget:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/portrait_btn")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_node = self.root.btn.portrait_node_export
    self.headFrame = self.root.btn.portrait_node_export.headFrame_export

    uiMgr:addWidgetTouchHandler(self.root.btn, function(sender, eventType) self:goHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.root.btn:setSwallowTouches(false)
    self.root.btn:setPressedActionEnabled(false)
end

function UIPortraitWidget:onEnter()
end

function UIPortraitWidget:setData(lFace,headframe,data)

    local head = global.luaCfg:get_rolehead_by(lFace)
    if not head then
        head = global.headData:getCurHead() or {}
    end
    global.tools:setCircleAvatar(self.portrait_node, global.headData:convertHeadData(data,head))
    
    if headframe then 

        local info  = global.luaCfg:get_role_frame_by(headframe)

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


function UIPortraitWidget:goHandler(sender, eventType)
    -- global.tipsMgr:showWarning("FuncNotFinish")
end
--CALLBACKS_FUNCS_END

return UIPortraitWidget

--endregion
