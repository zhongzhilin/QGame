--region UIMiracleDoorInfoPanel.lua
--Author : Untory
--Date   : 2017/08/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIMiracleDoorInfoPanel  = class("UIMiracleDoorInfoPanel", function() return gdisplay.newWidget() end )
local luaCfg = global.luaCfg

function UIMiracleDoorInfoPanel:ctor()
    self:CreateUI()
end

function UIMiracleDoorInfoPanel:CreateUI()
    local root = resMgr:createWidget("wild/temple_intro_bg")
    self:initUI(root)
end

function UIMiracleDoorInfoPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/temple_intro_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.touch = self.root.touch_export
    self.bt_bg = self.root.Node_2.bt_bg_export
    self.btn_node = self.root.Node_2.bt_bg_export.btn_node_export
    self.close_node = self.root.Node_2.close_node_export
    self.close_node = CloseBtn.new()
    uiMgr:configNestClass(self.close_node, self.root.Node_2.close_node_export)
    self.bg = self.root.Node_2.bg_export
    self.title = self.root.Node_2.title_export
    self.scrollView = self.root.Node_2.scrollView_export
    self.intro = self.root.Node_2.scrollView_export.intro_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exitCall(sender, eventType) end)
--EXPORT_NODE_END

    -- uiMgr:setRichText(self, "intro", 50135)
    
    
end

function UIMiracleDoorInfoPanel:setRichText(richID)
    
    uiMgr:setRichText(self, "intro", richID)
    local size = self.intro:getRichTextSize()



    self.scrollView:setInnerContainerSize(cc.size(size.width,size.height))

    if size.height <  self.scrollView:getContentSize().height then 
        self.intro:setPositionY(self.scrollView:getContentSize().height - 15 )
    else 
        self.intro:setPositionY(size.height)
    end 

    self.scrollView:jumpToTop()
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMiracleDoorInfoPanel:setData(activity,isHideBtn)

    self.data = activity

    self:setRichText(self.data.desc)

    self.bg:loadTexture(self.data.banner, ccui.TextureResType.plistType)

    self.bt_bg:setVisible( #self.data.btn > 0 and not isHideBtn )
    self.data =  activity
    if  #self.data.btn >  0  then 
        self:initBtn()
    end 


    self.title:setString(self.data.name)
end


function UIMiracleDoorInfoPanel:initBtn()

    local btnCount = #self.data.btn

    local btnNode = resMgr:createWidget("activity/activity_btns/btn_" .. btnCount)
    self.btn_node:removeAllChildren()
    self.btn_node:addChild(btnNode)

    uiMgr:configUITree(btnNode)

    for index, panel_index in pairs(self.data.btn) do

        local btn = btnNode["btn_" .. index]

        local btn_item =luaCfg:get_btn_by(self.data.btn[index])

        btn.text:setString(btn_item.name)

        btn:loadTextures(btn_item.pic,btn_item.pic,nil,ccui.TextureResType.plistType)

        uiMgr:addWidgetTouchHandler(btn, function(sender, eventType) 

            local call = global.ActivityData:getCallBack("UIMiracleDoorInfoPanel" , panel_index , self.data )
            if call then 
                call()
            end 
        end)
    end
end

function UIMiracleDoorInfoPanel:onExit()
    self.bt_bg:setVisible(false)
end

function UIMiracleDoorInfoPanel:exitCall(sender, eventType)
    
    global.panelMgr:closePanelForBtn("UIMiracleDoorInfoPanel")
end
--CALLBACKS_FUNCS_END

return UIMiracleDoorInfoPanel

--endregion
