--region UIGiftCodePanel.lua
--Author : anlitop
--Date   : 2017/03/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIGiftCodePanel  = class("UIGiftCodePanel", function() return gdisplay.newWidget() end )

function UIGiftCodePanel:ctor()
    self:CreateUI()
end

function UIGiftCodePanel:CreateUI()
    local root = resMgr:createWidget("settings/code_bg")
    self:initUI(root)
end

function UIGiftCodePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "settings/code_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.free_btn = self.root.Node_export.Node_5.free_btn_export
    self.input = self.root.Node_export.Node_1.input_export
    self.input = UIInputBox.new()
    uiMgr:configNestClass(self.input, self.root.Node_export.Node_1.input_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.free_btn, function(sender, eventType) self:freeSaveHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIGiftCodePanel:onEnter( )
    -- body
    self:setData()
end

function UIGiftCodePanel:setData( )
    -- 
end

 function  UIGiftCodePanel:showGift(msg,ret)
--     required int32      lID     = 1;
--     required int32      lCount      = 2;
        if ret.retcode ==1 then 
        -- global.tipsMgr
              global.tipsMgr:showWarning("CodeFailed")
        else 
            local gifttemp = {}
                for i=1, #msg.tgItems do 
                    gifttemp[i]={}
                    gifttemp[i][1] = msg.tgItems[i].lID
                     gifttemp[i][2] =msg.tgItems[i].lCount
                end 
              global.panelMgr:closePanel("UIGiftCodePanel")
              global.panelMgr:openPanel("UIItemRewardPanel"):setData(gifttemp)
        end 
end 


function UIGiftCodePanel:onCloseHanler(sender, eventType)
    self.input:setString("")
        global.panelMgr:closePanel("UIGiftCodePanel")
end

function UIGiftCodePanel:freeSaveHandler(sender, eventType)
    local string_giftcode = self.input:getString()
    self.input:setString("")
     if string.len(string_giftcode)<=0 then
             global.tipsMgr:showWarning("CodeEmpty")
     else  
        global.giftCodeAPI:ExChangeGiftCode(string_giftcode,function(msg,ret) self:showGift(msg,ret)end)
    end 
end
--CALLBACKS_FUNCS_END

return UIGiftCodePanel

--endregion
