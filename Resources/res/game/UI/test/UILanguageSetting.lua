--region UILanguageSetting.lua
--Author : song
--Date   : 2016/05/11
--generate by [generate_ui_code.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local ComboBox = require("game.UI.equip.UIComboBox")

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UILanguageSetting  = class("UILanguageSetting", function() return gdisplay.newWidget() end )

function UILanguageSetting:ctor()
    self:CreateUI()
end

function UILanguageSetting:CreateUI()
    local root = resMgr:createWidget("language_setting")
    self:initUI(root)
end

function UILanguageSetting:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "language_setting")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.lan_comboBox_drop_btn = self.root.lan_comboBox_drop_btn_export
    self.list_node = self.root.list_node_export
    self.button1 = self.root.list_node_export.container_node.button1_export
    self.label = self.root.list_node_export.container_node.button1_export.label_export
    self.button2 = self.root.list_node_export.container_node.button2_export
    self.label = self.root.list_node_export.container_node.button2_export.label_export
    self.button3 = self.root.list_node_export.container_node.button3_export
    self.label = self.root.list_node_export.container_node.button3_export.label_export
    self.button4 = self.root.list_node_export.container_node.button4_export
    self.label = self.root.list_node_export.container_node.button4_export.label_export

    uiMgr:addWidgetTouchHandler(self.root.btn_exit, function(sender, eventType) self:onBtnCloseClickHandler(sender, eventType) end)
--EXPORT_NODE_END

    local sourceData = {}
    local languages = global.luaCfg:languages()
    for id, lan in ipairs(languages) do
        table.insert(sourceData, {label = lan.name, data = lan.symbol})
    end

    local current_lan = global.languageData:getCurrentLanguage()
    local currentIdx = 1
    for i, data in ipairs(sourceData) do
        if data.data == current_lan then
            currentIdx = i
            break
        end
    end

    self.combox = ComboBox.new(self.lan_comboBox_drop_btn, self.list_node)
    self.combox:setData(sourceData)
    self.combox:setCurrentDataIndex(currentIdx)
    self.combox:setSelectedItemChangeHandler(handler(self, self.onLanChangeHandler))
    self.root:addChild(self.combox)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UILanguageSetting:onLanChangeHandler(data)
    local currLan = global.languageData:getCurrentLanguage()
    if data == currLan then
        return 
    end

    global.languageData:setCurrentLanguage(data)

    local stack = global.panelMgr:getStack()
    global.panelMgr:destroyAllPanel()
    
    local stack_len = #stack
    for i=1, stack_len, 1 do
        global.panelMgr:openPanel(stack[i])
    end
    -- global.panelMgr:openPanel("UIMainTopBarPanel")
end

function UILanguageSetting:onBtnCloseClickHandler(sender, eventType)
    global.panelMgr:closePanel("UILanguageSetting")
end
--CALLBACKS_FUNCS_END

return UILanguageSetting

--endregion
