--region UIHeadItem.lua
--Author : yyt
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIHeadItem  = class("UIHeadItem", function() return gdisplay.newWidget() end )

function UIHeadItem:ctor()
    self:CreateUI()
end

function UIHeadItem:CreateUI()
    local root = resMgr:createWidget("rolehead/head_node")
    self:initUI(root)
end

function UIHeadItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rolehead/head_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Button_1 = self.root.Button_1_export
    self.portrait_node = self.root.Button_1_export.Image_1.portrait_node_export
    self.head_select = self.root.Button_1_export.Image_1.head_select_export

    uiMgr:addWidgetTouchHandler(self.Button_1, function(sender, eventType) self:itemClickHanlder(sender, eventType) end, true)
--EXPORT_NODE_END
    self.Button_1:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIHeadItem:setData( data )

    self.data = data
    if global.headData:isSdefineHead() then
        self.head_select:setVisible(false)
    else
        self.head_select:setVisible(data.state == 1)
    end
    global.tools:setCircleAvatar(self.portrait_node, data)
    global.colorUtils.turnGray(self.Button_1, data.useState == 0)

end

function UIHeadItem:itemClickHanlder(sender, eventType)
    
    local sPanel = global.panelMgr:getPanel("UIRoleHeadPanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        if self.data.state == 1 and (not global.headData:isSdefineHead()) then return end
        if self.data.useState == 0 then

            if self.data.triggerType == 1 then
                
                local buildData = luaCfg:buildings_pos()
                local buildName = ""
                for _,v in pairs(buildData) do
                    if v.buildingType == self.data.triggerId then
                        buildName = v.buildsName
                    end
                end
                global.tipsMgr:showWarning(luaCfg:get_local_string(10258, buildName))

            elseif self.data.triggerType == 2 then 
                
                local heroName = ""
                local heroData = luaCfg:get_hero_property_by(self.data.triggerId)
                if heroData then heroName = heroData.name end
                global.tipsMgr:showWarning(luaCfg:get_local_string(10259, heroName))
            end
            return
        end

        if global.headData:isSdefineHead() then

            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("lossSdefinePortrait", function()
                global.headData:setSdefineHead()
                self.head_select:setVisible(true)
                global.headData:refershHeadState(self.data.id)
            end)
            return
        end

        global.loginApi:updateUserInfo(self.data.id, function(msg)

            self.head_select:setVisible(true)
            global.headData:refershHeadState(self.data.id)
        end)
    end

end
--CALLBACKS_FUNCS_END

return UIHeadItem

--endregion
