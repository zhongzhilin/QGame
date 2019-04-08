--region UIGarrisonItem.lua
--Author : yyt
--Date   : 2016/11/30
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIGarrisonItem  = class("UIGarrisonItem", function() return gdisplay.newWidget() end )

function UIGarrisonItem:ctor()
    self:CreateUI()
end

function UIGarrisonItem:CreateUI()
    local root = resMgr:createWidget("world/info/garrison_bj_info")
    self:initUI(root)
end

function UIGarrisonItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/info/garrison_bj_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.lord_name = self.root.lord_name_export
    self.troop_name = self.root.troop_name_export
    self.troop_scale = self.root.troop_scale_export
    self.union = self.root.union_export
    self.textContent = self.root.textContent_export
    self.orderBtn = self.root.orderBtn_export

    uiMgr:addWidgetTouchHandler(self.orderBtn, function(sender, eventType) self:orderBack_click(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIGarrisonItem:setData(data)

    self.data = data
    self.lord_name:setString(data.szUserName)
    self.troop_name:setString(data.szName)
    self.troop_scale:setString(self:getScaleSizeStr(data))
    if  data.lAllyName and data.lAllyName ~= "" then
        self.union:setString( data.lAllyName )
    else
        self.union:setString( "-" )
    end
    self.orderBtn:setEnabled(self:isCanRepatriate(data))
end

function UIGarrisonItem:getScaleSizeStr(data)
    
    local str = global.troopData:getTroopsScaleByData(data.tgWarrior)
    if (data.lAvator == 0 or data.lAvator == 4) and (data.lTargetAvator ~= 1) then
        str = "-"
    end
    return str
end

function UIGarrisonItem:isCanRepatriate(data)

    local isCanEnabled = false
    local m_useId = global.userData:getUserId()
    if m_useId == data.lUserID then
        isCanEnabled = true
    else
        if data.lOwnerAvator == 1 then
            isCanEnabled = true
        end
    end
    return isCanEnabled 
end

function UIGarrisonItem:orderBack_click(sender, eventType)

    local m_useId = global.userData:getUserId()
    if m_useId == self.data.lUserID then
        
        global.worldApi:callBackTroop(self.data.lID,1,function()
            print("------ 召回成功！")
            self:refershCall()
        end)
    else

        global.worldApi:callStayBack(self.data.lCityID, self.data.lID,function()
            print("------ 遣返成功！")
            self:refershCall()
        end)
    end
end

function UIGarrisonItem:refershCall()
    
    self.orderBtn:setEnabled(false)
    local garrPanel = global.panelMgr:getPanel("UIGarrisonPanel")
    garrPanel:refershTroopData()
end
--CALLBACKS_FUNCS_END

return UIGarrisonItem

--endregion
