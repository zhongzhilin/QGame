--region UITopItem.lua
--Author : Untory
--Date   : 2017/11/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITopItemForMotherKing  = class("UITopItemForMotherKing", function() return gdisplay.newWidget() end )

function UITopItemForMotherKing:ctor()
    
end

function UITopItemForMotherKing:CreateUI()
    local root = resMgr:createWidget("offical/offical_role_node")
    self:initUI(root)
end

function UITopItemForMotherKing:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "offical/offical_role_node")
 
-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top_btn = self.root.top_btn_export
    self.portrait_node = self.root.top_btn_export.portrait_node_export
    self.headFrame = self.root.top_btn_export.portrait_node_export.headFrame_export
    self.add_btn = self.root.top_btn_export.add_btn_export
    self.offical = self.root.offiacal_pic_6_8.offical_export
    self.lord_name = self.root.lord_name_export

    uiMgr:addWidgetTouchHandler(self.top_btn, function(sender, eventType) self:choose_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.top_btn_export.add_btn_export.Button_28, function(sender, eventType) self:choose_call(sender, eventType) end)
--EXPORT_NODE_END
end

function UITopItemForMotherKing:setData(id,data)
    
    local offData = luaCfg:get_official_post_by(id)
    self.offical:setString(offData.typeName)
    self.id = id
    self.data = data

    local selfOff = global.panelMgr:getPanel('UIOfficalPanel'):getSelfOfficalId()
    local offType = global.funcGame:checkOfficalType(selfOff,id)

    if data then        
        self.add_btn:setScale(0)
        self.lord_name:setVisible(true)
        self.portrait_node.pic:setVisible(true)

        self.lord_name:setString(data.lUserName)
        local head = luaCfg:get_rolehead_by(data.lHeadImg)
        head = global.headData:convertHeadData(data, head)
        if head.path then 
            global.tools:setCircleAvatar(self.portrait_node, head)
        end 

        self.headFrame:setVisible(true)
        local headInfo = global.luaCfg:get_role_frame_by(tonumber(data.lBackID))
        if headInfo and headInfo.pic then
            global.panelMgr:setTextureFor(self.headFrame,headInfo.pic)     
        end 
    else
        self.add_btn:setScale(0.6)
        self.lord_name:setVisible(false)
        self.headFrame:setVisible(false)
        self.portrait_node.pic:setVisible(false)
        
        self.add_btn.Button_28:setEnabled(offType == 1)
    end


end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITopItemForMotherKing:choose_call(sender, eventType)
    
    global.panelMgr:openPanel('UIOfficalInfoPanel'):setData(self.id,self.data)
end
--CALLBACKS_FUNCS_END

return UITopItemForMotherKing

--endregion
