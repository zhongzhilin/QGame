--region UISearchPanel.lua
--Author : yyt
--Date   : 2016/11/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UISearchPanel  = class("UISearchPanel", function() return gdisplay.newWidget() end )

function UISearchPanel:ctor()
    self:CreateUI()
end

function UISearchPanel:CreateUI()
    local root = resMgr:createWidget("world/info/search_xy")
    self:initUI(root)
end

function UISearchPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/search_xy")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.name = self.root.Node_export.name_mlan_10_export
    self.textFieldX = self.root.Node_export.text_bj.textFieldX_export
    self.textFieldX = UIInputBox.new()
    uiMgr:configNestClass(self.textFieldX, self.root.Node_export.text_bj.textFieldX_export)
    self.textFieldY = self.root.Node_export.text_bj_0.textFieldY_export
    self.textFieldY = UIInputBox.new()
    uiMgr:configNestClass(self.textFieldY, self.root.Node_export.text_bj_0.textFieldY_export)
    self.btnAddItem2 = self.root.Node_export.btnAddItem2_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.btnAddItem2, function(sender, eventType) self:searchXY_click(sender, eventType) end)
--EXPORT_NODE_END

    self.textFieldX:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
    self.textFieldY:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UISearchPanel:onEnter()
    
    self.textFieldX:addEventListener(handler(self, self.checkX))
    self.textFieldY:addEventListener(handler(self, self.checkY))

end

function UISearchPanel:onExit(touch, event)
    if self.touchEventListener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEventListener)
        self.touchEventListener = nil
    end
end

function UISearchPanel:checkX(eventType)
    
    if eventType == "began" then
        self.textFieldX:setString("")
    end

    if eventType == "return" then

        local curX = tonumber(self.textFieldX:getString())
        local maxData = luaCfg:get_map_cfg_by(1)
        local mx = math.floor(14.46*maxData.maxX)

        if curX and curX > mx then
            self.textFieldX:setString(mx)
        end
    end

end

function UISearchPanel:checkY(eventType)
   
    if eventType == "began" then
        self.textFieldY:setString("")
    end

    if eventType == "return" then
        local curY = tonumber(self.textFieldY:getString())
        local maxData = luaCfg:get_map_cfg_by(1)
        local my = math.floor(14.46*maxData.maxY)

        if curY and curY > my then
            self.textFieldY:setString(my)
        end
    end

end

function UISearchPanel:setData()

    local x, y = global.collectData:getCurPos()
    self.textFieldX:setString(x)
    self.textFieldY:setString(y)

end

function UISearchPanel:exit_call(sender, eventType)
    global.panelMgr:closePanelForBtn("UISearchPanel")
end

function UISearchPanel:searchXY_click(sender, eventType)
    
    local x = tonumber(self.textFieldX:getString())
    local y = tonumber(self.textFieldY:getString())

    if x and y then
        local pos = global.g_worldview.const:converLocation2Pix(cc.p(y, x))
        local isExitXY = global.g_worldview.worldPanel.m_scrollView:setOffset(cc.p(-pos.x, -pos.y)) 
        if isExitXY then
            local worldPanel = global.panelMgr:getPanel("UIWorldPanel")
            if worldPanel then
                worldPanel.locationInfo:setPosLocation(cc.p(x, y))
            end
        end
        self:exit_call()
    else
        global.tipsMgr:showWarning("Searchempty")
    end
end
--CALLBACKS_FUNCS_END

return UISearchPanel

--endregion
