--region UICustomNoticePanel.lua
--Author : zzl
--Date   : 2019/02/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UICustomNoticePanel  = class("UICustomNoticePanel", function() return gdisplay.newWidget() end )


local luaCfg = global.luaCfg
local json    = require "json"
local crypto  = require "hqgame"
local app_cfg = require "app_cfg"

function UICustomNoticePanel:ctor()
    self:CreateUI()
end

function UICustomNoticePanel:CreateUI()
    local root = resMgr:createWidget("loading/plat_update_panel_0")
    self:initUI(root)
end

function UICustomNoticePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "loading/plat_update_panel_0")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.close_bg = self.root.close_bg_export
    self.Node_1 = self.root.Node_1_export
    self.ScrollView = self.root.Node_1_export.ScrollView_export
    self.maintain = self.root.Node_1_export.ScrollView_export.maintain_export

    uiMgr:addWidgetTouchHandler(self.close_bg, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_1_export.confirm_btn, function(sender, eventType) self:confirmHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UICustomNoticePanel:confirmHandler(sender, eventType)
    self:exit_call()
end

function UICustomNoticePanel:onEnter()

    -- global.SimpleHttpAPI:SimpleHttpCall(self.url,self.method,self:getDictionaryData(),self.transFormat ,handler(self,self.baseResqonseCall))

    self:setVisible(false)

    local dictionaryData = clone(global.ServerData:getDictionaryData())
    global.SimpleHttpAPI:SimpleHttpCall(app_cfg.notice_url,app_cfg.server_list_method,dictionaryData,
    "json",function (request)
        self:setVisible(true)
        dump(request:getResponseData() ,"request")
        self:setData(request:getResponseData())
    end)

end 

function UICustomNoticePanel:setData(richText)

    print(richText ,"richText")
    richText = string.gsub(richText,"\\n","\n")        
    uiMgr:setRichText(self, "maintain",   richText or "" )
    local size = self.maintain:getRichTextSize()
    self.ScrollView:setInnerContainerSize(cc.size(size.width,size.height))
    if size.height <  self.ScrollView:getContentSize().height then 
        self.maintain:setPositionY(self.ScrollView:getContentSize().height - 15 )
    else 
        self.maintain:setPositionY(size.height)
    end 
    self.ScrollView:jumpToTop() 
end 


function UICustomNoticePanel:setExitCall(call)
    -- global.panelMgr:closePanel("UICustomNoticePanel")
    self.call = call
end

function UICustomNoticePanel:exit_call(sender, eventType)
    global.panelMgr:closePanel("UICustomNoticePanel")
end

function UICustomNoticePanel:onExit( ... )
        if self.call then 
            self.call()
            self.call = nil 
        end 
end
--CALLBACKS_FUNCS_END

return UICustomNoticePanel

--endregion
