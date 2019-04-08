--region UITipsWritePanel.lua
--Author : untory
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UITipsColorChooseItem = require("game.UI.world.widget.UserTips.UITipsColorChooseItem")
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UITipsWritePanel  = class("UITipsWritePanel", function() return gdisplay.newWidget() end )

function UITipsWritePanel:ctor()
    self:CreateUI()
end

function UITipsWritePanel:CreateUI()
    local root = resMgr:createWidget("world/info/stickers_write")
    self:initUI(root)
end

function UITipsWritePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/stickers_write")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.time1 = self.root.Node_export.time1_mlan_5_export
    self.time = self.root.Node_export.time_mlan_5_export
    self.tf_Input = self.root.Node_export.Image_7.tf_Input_export
    self.tf_Input = UIInputBox.new()
    uiMgr:configNestClass(self.tf_Input, self.root.Node_export.Image_7.tf_Input_export)
    self.btn1 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn1, self.root.Node_export.Node_6.btn1)
    self.btn2 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn2, self.root.Node_export.Node_6.btn2)
    self.btn3 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn3, self.root.Node_export.Node_6.btn3)
    self.btn4 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn4, self.root.Node_export.Node_6.btn4)
    self.btn5 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn5, self.root.Node_export.Node_6.btn5)
    self.btn6 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn6, self.root.Node_export.Node_6.btn6)
    self.btn7 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn7, self.root.Node_export.Node_6.btn7)
    self.btn8 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn8, self.root.Node_export.Node_6.btn8)
    self.btn9 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn9, self.root.Node_export.Node_6.btn9)
    self.btn10 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn10, self.root.Node_export.Node_6.btn10)
    self.btn11 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn11, self.root.Node_export.Node_6.btn11)
    self.btn12 = UITipsColorChooseItem.new()
    uiMgr:configNestClass(self.btn12, self.root.Node_export.Node_6.btn12)
    self.info1 = self.root.Node_export.info1_mlan_20_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Node_5.create, function(sender, eventType) self:saveHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITipsWritePanel:onEnter()
      
    self.tf_Input:setString("")

    for i = 1,12 do

        self["btn"..i]:setIndex(i)
    end

    self:choose(1)
end

function UITipsWritePanel:choose(index)
   
    self.index = index 
    for i = 1,12 do

        self["btn"..i]:setChooseState(i == index)
    end
end

function UITipsWritePanel:onCloseHanler(sender, eventType)

    global.panelMgr:closePanelForBtn("UITipsWritePanel")
end

function UITipsWritePanel:saveHandler(sender, eventType)

    if #self.tf_Input:getString() == 0 then

        global.tipsMgr:showWarning("Testtips004")
        return
    end

    global.worldApi:addTips(global.g_worldview.worldPanel.chooseCityId,self.tf_Input:getString(),self.index,function(msg)

        global.panelMgr:closePanel("UITipsWritePanel")
        global.panelMgr:getPanel("UITipsPanel"):flushContent()

        if msg.lCurNum == 0 then
            global.tipsMgr:showWarning("StickersOver")
        else
            global.tipsMgr:showWarning("StickersOK",msg.lCurNum)
        end
        
    end)
end
--CALLBACKS_FUNCS_END

return UITipsWritePanel

--endregion
