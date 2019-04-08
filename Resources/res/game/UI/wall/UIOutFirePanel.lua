--region UIOutFirePanel.lua
--Author : yyt
--Date   : 2016/09/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local CountSliderControl = require("game.UI.common.UICountSliderControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIOutFirePanel  = class("UIOutFirePanel", function() return gdisplay.newWidget() end )

function UIOutFirePanel:ctor()
    self:CreateUI()
end

function UIOutFirePanel:CreateUI()
    local root = resMgr:createWidget("wall/wall_outfire_sec_bg")
    self:initUI(root)
end

function UIOutFirePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/wall_outfire_sec_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.slider = self.root.bg.slider_export
    self.cur = UIInputBox.new()
    uiMgr:configNestClass(self.cur, self.root.bg.slider_export.cur)
    self.icon_bg = self.root.bg.icon_bg_export
    self.icon = self.root.bg.icon_export
    self.choseAllBtn = self.root.bg.choseAllBtn_export
    self.useBtn = self.root.bg.useBtn_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.choseAllBtn, function(sender, eventType) self:chooseAll(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.useBtn, function(sender, eventType) self:use_call(sender, eventType) end)
--EXPORT_NODE_END
    self.slider.cur = self.cur
    self.cur:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.sliderControl = CountSliderControl.new(self.slider,handler(self,self.sliderUpdate))

    self.wallNumPanel = global.panelMgr:getPanel("UIWallNumPanel")
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIOutFirePanel:setData(data, callback)
    
    self.data = data
    self.m_recoverCall = callback
    local num = global.normalItemData:getItemById(11501).count   --　水桶数量
    if num <= 0 then
        self.useBtn:setEnabled(false)
        self.choseAllBtn:setEnabled(false)
        self.sliderControl:reSetMaxCount(0)
    else
        self.useBtn:setEnabled(true)
        self.choseAllBtn:setEnabled(true)
         self.sliderControl:setMaxCount(num)
    end
    
end

function UIOutFirePanel:sliderUpdate()

    log.debug("count: "..self.sliderControl:getContentCount())
end

function UIOutFirePanel:chooseAll(sender, eventType)
    self.sliderControl:chooseAll()
end

function UIOutFirePanel:use_call(sender, eventType)
    
    if self.wallNumPanel.duraValue == 0 then

        global.tipsMgr:showWarning(" 城池已被烧毁！")
        self:exit()
    else

        local count = tonumber(self.sliderControl:getContentCount()) 
        global.itemApi:itemUse(11501, count, 0 , self.data.buildId , function(msg)
            global.normalItemData:updateItem({id = msg.lID, count = msg.lCount})
            self.m_recoverCall(msg)
            self:exit()
        end)
    end
end

function UIOutFirePanel:exit(sender, eventType)
    global.panelMgr:closePanelForBtn("UIOutFirePanel")
end
--CALLBACKS_FUNCS_END

return UIOutFirePanel

--endregion
