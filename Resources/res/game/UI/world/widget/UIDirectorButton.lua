--region UIDirectorButton.lua
--Author : untory
--Date   : 2016/09/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END
local g_worldview = global.g_worldview
local UIDirectorButton  = class("UIDirectorButton", function() return gdisplay.newWidget() end )

function UIDirectorButton:ctor()
    
 --    log.debug("-----------")
	-- log.debug(debug.traceback())

    -- self:CreateUI()
end

function UIDirectorButton:CreateUI()
    local root = resMgr:createWidget("world/world_distance")
    self:initUI(root)
end

function UIDirectorButton:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/world_distance")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Text = self.root.Node_13.Button_2.Text_export

    uiMgr:addWidgetTouchHandler(self.root.Node_13.Button_2, function(sender, eventType) self:return_mainCity(sender, eventType) end)
--EXPORT_NODE_END

    self:setVisible(false)
end


function UIDirectorButton:setDirectorPosAndAngle(pos,angle,len,isLine)
    
    if global.g_worldview.isStory then

        self:setVisible(false)
        return
    end

    if pos then

        self:setVisible(true)
        self:setRotation(angle)
        self:setPosition(pos)
   
        -- print(angle)

		if (angle < -90 and angle > -181) or (angle > 90 and angle < 181) then

			self.Text:setScaleX(-1)
			self.Text:setScaleY(-1)
			
		else

			self.Text:setScaleX(1)
			self.Text:setScaleY(1)			
		end

        uiMgr:setLabelText(self.Text, 10018, math.floor(len / 100))
    else

        self:setVisible(false)
    end    

    -- self:setVisible(true)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIDirectorButton:return_mainCity(sender, eventType)
    
	local panel = global.panelMgr:getPanel("UIWorldPanel")
    -- dump(panel.mainOffset)
    panel:cancelGpsSoldier()
    panel.m_scrollView:setOffset(panel.mainOffset)
    panel.m_scrollView:stopScrolling()

end
--CALLBACKS_FUNCS_END

return UIDirectorButton

--endregion
