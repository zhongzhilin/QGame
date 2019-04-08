--region UIMoJUsePanel.lua
--Author : yyt
--Date   : 2016/12/27
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIMoJUsePanel  = class("UIMoJUsePanel", function() return gdisplay.newWidget() end )

function UIMoJUsePanel:ctor()
    self:CreateUI()
end

function UIMoJUsePanel:CreateUI()
    local root = resMgr:createWidget("common/common_mojing_use")
    self:initUI(root)
end

function UIMoJUsePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_mojing_use")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.title = self.root.Node_export.title_export
    self.info = self.root.Node_export.info_export
    self.dia_icon = self.root.Node_export.diamondUseBtn.dia_icon_export
    self.dia_num = self.root.Node_export.diamondUseBtn.dia_num_export
    self.grayBg = self.root.Node_export.useCardBtn.grayBg_export
    self.dia_icon1 = self.root.Node_export.useCardBtn.dia_icon1_export
    self.dia_num1 = self.root.Node_export.useCardBtn.dia_num1_export
    self.tf_Input = self.root.Node_export.nameEdit.tf_Input_export
    self.tf_Input = UIInputBox.new()
    uiMgr:configNestClass(self.tf_Input, self.root.Node_export.nameEdit.tf_Input_export)
    self.randomNameBtn = self.root.Node_export.nameEdit.Node_6.randomNameBtn_export
    self.model = self.root.model_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.diamondUseBtn, function(sender, eventType) self:diamondUseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.useCardBtn, function(sender, eventType) self:useCardHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.randomNameBtn, function(sender, eventType) self:randomNameHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.model, function(sender, eventType) self:model_click(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIMoJUsePanel:onEnter()
    -- body
    self.tf_Input:addEventListener(handler(self, self.nameEditCall))
end

function UIMoJUsePanel:nameEditCall(eventType)
   
    if eventType == "began" then 
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_rename")
    end
   
    if eventType == "return" then
        self:checkNameStr(self.tf_Input:getString())
    end
end

function UIMoJUsePanel:checkNameStr(str)

    if str == "" then
            
        self.tf_Input:setString(userData:getUserName())
        global.tipsMgr:showWarningTime("CantEmpty")
        return
    end
    
    local errcode, spaceNum = 0, 0
    local list = string.utf8ToList(str)
    for i=1,#list do
        
        if list[1] == " "  then
            errcode = -1
        end

        if list[i] == " " then
            spaceNum = spaceNum + 1
        end

        if list[#list] == " "  then
            errcode = 1
        end 
    end

    -- 不能全部为空格
    if spaceNum == #list then
        self.tf_Input:setString(userData:getUserName())
        global.tipsMgr:showWarningTime("CantSpaceAll")
        return
    end

    -- 首尾不能为空
    if errcode ~= 0 then
        self.tf_Input:setString(userData:getUserName())
        global.tipsMgr:showWarningTime("CantSpace")
        return
    end

    -- 不能输入表情
    if string.isEmoji(str) then
        self.tf_Input:setString(userData:getUserName())
        global.tipsMgr:showWarning("13")
        return
    end

    global.unionApi:checkNameStr(str, function(msg)
        self.tf_Input:setString(msg.szName)
    end)
end

---- num  魔晶数量
---- content   使用说明
---- data  {num = 100, content = "使用说明", titleId = 10232, info=""}
function UIMoJUsePanel:setData(data, callback)
    
    self.model:setVisible(false)
    self.data = data
    self.m_callback = callback
    self.title:setString( luaCfg:get_local_string(data.titleId) )

    self.info:setString(luaCfg:get_local_string(10232))
    self.dia_num:setString(data.num)
    self:checkDiamondEnough(data.num)

    local itemBagCount = global.normalItemData:getItemById(11901).count
    global.colorUtils.turnGray(self.grayBg, itemBagCount == 0)
    self.dia_num1:setString(1)
    if itemBagCount == 0 then
        self.dia_num1:setTextColor(gdisplay.COLOR_RED)
    else
        self.dia_num1:setTextColor(cc.c3b(255, 192, 0))
    end

    self.tf_Input:setString(userData:getUserName())

end

function UIMoJUsePanel:checkDiamondEnough(num)
    if not global.propData:checkEnough(WCONST.ITEM.TID.DIAMOND,num) then
        self.dia_num:setTextColor(gdisplay.COLOR_RED)
        return false
    else
        self.dia_num:setTextColor(cc.c3b(255, 192, 0))
        return true
    end
end

-- 使用魔晶改名
function UIMoJUsePanel:diamondUseHandler(sender, eventType)
    
    if not self:checkDiamondEnough(self.data.num) then
        global.panelMgr:openPanel("UIRechargePanel")
        return
    end

    if userData:getUserName() == self.tf_Input:getString() then
        return global.tipsMgr:showWarningTime("NameCantChange")
    end

    global.itemApi:diamondUse(function(msg)
        self:dealCall()
    end,8,0,0,0,0, self.tf_Input:getString())
end

-- 使用改名道具
function UIMoJUsePanel:useCardHandler(sender, eventType)
    
    local itemBagCount = global.normalItemData:getItemById(11901).count
    if itemBagCount == 0 then
        global.tipsMgr:showWarning("NoNameItem")
        return
    end

    if userData:getUserName() == self.tf_Input:getString() then
        return global.tipsMgr:showWarningTime("NameCantChange")
    end
    
    global.itemApi:itemUse(11901, 1, 0, 0, function()
        self:dealCall()
    end, self.tf_Input:getString()) 
end

function UIMoJUsePanel:dealCall()
    self:exit_call()
    self.m_callback(self.tf_Input:getString())
end

-- 随机名字
function UIMoJUsePanel:randomNameHandler(sender, eventType)

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_RandomName")
    
    self.root:stopAllActions()
    local nodeTimeLine = resMgr:createTimeline("common/common_mojing_use")
    nodeTimeLine:play("animation0", false)
    self.root:runAction(nodeTimeLine)

    global.loginApi:getRandName(function(ret,msg)
        -- body
        if ret.retcode == WCODE.OK then
            local firstStr = luaCfg:get_rand_name_by(msg.lFirstName).text
            local secStr = luaCfg:get_rand_name_by(msg.lSecondName).text
            local addStr = ""
            if msg.lAddName then
                addStr = luaCfg:get_rand_name_by(msg.lAddName).text
            end
            local strName = string.format("%s%s%s",firstStr,secStr,addStr)
            if not tolua.isnull(self.tf_Input) then 
                self.tf_Input:setString(strName)
            end 
        end
    end)
end

function UIMoJUsePanel:exit_call(sender, eventType)
    global.panelMgr:closePanel("UIMoJUsePanel")
end

function UIMoJUsePanel:model_click(sender, eventType)
    self.model:setVisible(false)
end


function UIMoJUsePanel:namelick(sender, eventType)

end

function UIMoJUsePanel:useHandler(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIMoJUsePanel

--endregion
