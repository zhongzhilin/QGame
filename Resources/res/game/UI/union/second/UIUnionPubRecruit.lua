--region UIUnionPubRecruit.lua
--Author : yyt
--Date   : 2017/08/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionPubRecruit  = class("UIUnionPubRecruit", function() return gdisplay.newWidget() end )

function UIUnionPubRecruit:ctor()
    self:CreateUI()
end

function UIUnionPubRecruit:CreateUI()
    local root = resMgr:createWidget("union/union_recruit")
    self:initUI(root)
end

function UIUnionPubRecruit:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_recruit")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.charge_btn = self.root.Node_export.Node_5.charge_btn_export
    self.gray_spite = self.root.Node_export.Node_5.charge_btn_export.gray_spite_export
    self.dia_icon = self.root.Node_export.Node_5.charge_btn_export.dia_icon_export
    self.dia_num = self.root.Node_export.Node_5.charge_btn_export.dia_num_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHanler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.charge_btn, function(sender, eventType) self:publishRecHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIUnionPubRecruit:onEnter()
    self:setData()
end

function UIUnionPubRecruit:setData()
    self:checkDiamondEnough()
end

function UIUnionPubRecruit:checkDiamondEnough()
    -- body
    local needDiamondNum = global.luaCfg:get_config_by(1).unionRecruit
    self.dia_num:setString(needDiamondNum)

    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND, needDiamondNum) then
        self.dia_num:setTextColor(gdisplay.COLOR_RED)
        return false
    else
        self.dia_num:setTextColor(cc.c3b(255, 184, 34))
        return true
    end
end

function UIUnionPubRecruit:onCloseHanler(sender, eventType)
    global.panelMgr:closePanel("UIUnionPubRecruit")
end

function UIUnionPubRecruit:publishRecHandler(sender, eventType)

    if self:checkDiamondEnough() then

        local mUnion = global.unionData:getInUnion()
        local unionShortName = global.unionData:getInUnionShortName()
        local unionName = global.unionData:getInUnionName()
        local flagId = mUnion.lTotem
        local power  = mUnion.lPower
        local curMem = mUnion.lCount
        local maxMem = mUnion.lMaxCount

        local tagSpl = {}
        tagSpl.lKey = 7
        tagSpl.lValue  = mUnion.lID
        tagSpl.szParam = unionShortName .. "@" .. unionName .. "@" .. power .. "@" .. curMem .. "@" ..maxMem
        tagSpl.szInfo = flagId 
        tagSpl.lTime  = global.dataMgr:getServerTime()   

        local panel = global.panelMgr:openPanel("UIPromptPanel")
        panel:setData("union_recruit02", function()

            global.chatApi:senderMsg(function(msg)
                
                global.chatData:setChatRecruitMsg(msg.tagMsg)
                global.chatData:addChat(2, msg.tagMsg or {})
                global.tipsMgr:showWarning("union_recruit01")

                global.panelMgr:closeAllUnionPanel()
                global.chatData:setCurLType(2)
                global.chatData:setCurChatPage(2)
                global.panelMgr:openPanel("UIChatPanel")

            end, 2, "union_recruit", global.userData:getUserId(), 0, tagSpl)
        end)
    else
        global.panelMgr:openPanel("UIRechargePanel")
        self:onCloseHanler()
    end
end
--CALLBACKS_FUNCS_END

return UIUnionPubRecruit

--endregion
