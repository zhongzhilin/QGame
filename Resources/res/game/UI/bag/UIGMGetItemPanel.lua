--region UIGMGetItemPanel.lua
--Author : Administrator
--Date   : 2016/08/18
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIGMGetItemPanel  = class("UIGMGetItemPanel", function() return gdisplay.newWidget() end )

function UIGMGetItemPanel:ctor()
    self:CreateUI()
end

function UIGMGetItemPanel:CreateUI()
    local root = resMgr:createWidget("bag/bag_GM_test")
    self:initUI(root)
end

function UIGMGetItemPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "bag/bag_GM_test")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.itemId = UIInputBox.new()
    uiMgr:configNestClass(self.itemId, self.root.Node_export.itemId)
    self.itemCount = UIInputBox.new()
    uiMgr:configNestClass(self.itemCount, self.root.Node_export.itemCount)
    self.ScrollView = self.root.ScrollView_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.Button_4_0, function(sender, eventType) self:getItem_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.intro_btn, function(sender, eventType) self:info_click(sender, eventType) end)
--EXPORT_NODE_END

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIGMGetItemPanel:setData(callBack, titleData, defaultData, isString)

    self.callBack = callBack

    self.Node.bg.Text_1:setString(global.luaCfg:get_local_string(titleData[1] or "-"))
    self.Node.bg.Text_2:setString(global.luaCfg:get_local_string(titleData[2] or "-"))
    self.Node.bg.Text_2_0:setString(global.luaCfg:get_local_string(titleData[3] or "-"))

    self.isString = isString
    self.itemId:setString("")
    self.itemCount:setString("")
    if defaultData then
        self.itemId:setString(defaultData[1] or "")
        self.itemCount:setString(defaultData[2] or "")
    end
end

function UIGMGetItemPanel:setNextData(text1, text2, debugCall ,text3 ,text4 )

    self.debugCall = debugCall
    self.Node.bg.Text_2:setString(text1)
    self.Node.bg.Text_2_0:setString(text2)

    -- self.Node.bg.Text_2_0_0:setString(text3 or  "不需要填写")
    -- self.Node.bg.Text_2_0_0_0:setString(text4  or  "不需要填写")

end

function UIGMGetItemPanel:getItem_call(sender, eventType)
    
    local idTag = tonumber(self.itemId:getString())
    local countTag = tonumber(self.itemCount:getString())

    if self.debugCall then
        global.panelMgr:closePanel("UIGMGetItemPanel")
        self.debugCall(idTag, countTag)
        return 
    end

    if self.callBack then
        if self.isString then
            idTag = self.itemId:getString()
            countTag = self.itemCount:getString()
        end
        global.panelMgr:closePanel("UIGMGetItemPanel")
        self.callBack(idTag, countTag)
        return 
    end


    local itemData = luaCfg:get_item_by(idTag)

    if itemData == nil then

        if idTag == 110 then

            global.debugWorldSize = countTag / 100
            print("设置成功")
            return
        end

        global.tipsMgr:showWarningText("没有找到道具ID")
        
        return
    end

    global.itemApi:GMGetItem(function()
       
       global.panelMgr:closePanel("UIGMGetItemPanel")
    end,idTag,countTag)

    -- global.normalItemData:addItem({id = idTag,count = countTag})

    -- global.panelMgr:closePanel("UIGMGetItemPanel")

    -- global.tipsMgr:showWarningText(string.format("获得了%d个%s",countTag,itemData.itemName))
end

function UIGMGetItemPanel:exit(sender, eventType)
    
    global.panelMgr:closePanelForBtn("UIGMGetItemPanel")


    self.ScrollView:removeAllChildren()


end


function UIGMGetItemPanel:onEnter()

    self.ScrollView:setVisible(false)

end 

function UIGMGetItemPanel:info_click(sender, eventType)
    self.ScrollView:setVisible(true)

    local s = ""
    for key ,v in pairs(global.EasyDev.DEBUG or {} ) do 
        local a = require("game.UI.union.second.exp.UIHeroExpItem").new()
        a.exp_add:setString(v)
        a.time:setString(key)
        self.ScrollView:addChild(a)
        a:setPositionY(key * 30 )
        a:setPositionX(50)
    end 

    self.ScrollView:setInnerContainerSize(cc.size(720,#global.EasyDev.DEBUG * 31))

    self.ScrollView:jumpToBottom()
    
end
--CALLBACKS_FUNCS_END

return UIGMGetItemPanel

--endregion
