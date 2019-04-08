--region UIUnionVillageItem.lua
--Author : yyt
--Date   : 2017/08/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionVillageItem  = class("UIUnionVillageItem", function() return gdisplay.newWidget() end )

function UIUnionVillageItem:ctor()
    self:CreateUI()
end

function UIUnionVillageItem:CreateUI()
    local root = resMgr:createWidget("union/union_village_node")
    self:initUI(root)
end

function UIUnionVillageItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_village_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.Node_1.village_node.icon_export
    self.name = self.root.Node_1.village_node.name_export
    self.head_node = self.root.Node_1.head_node_export
    self.portrait_node = self.root.Node_1.head_node_export.portrait_node_export
    self.headFrame = self.root.Node_1.head_node_export.portrait_node_export.headFrame_export
    self.owName = self.root.Node_1.head_node_export.owName_export
    self.noOwner = self.root.Node_1.noOwner_mlan_4_export
    self.buffVal1 = self.root.Node_1.buffVal1_export
    self.buffName1 = self.root.Node_1.buffVal1_export.buffName1_export
    self.buffVal2 = self.root.Node_1.buffVal2_export
    self.buffName2 = self.root.Node_1.buffVal2_export.buffName2_export
    self.go_target_btn = self.root.Node_1.go_target_btn_export

    uiMgr:addWidgetTouchHandler(self.go_target_btn, function(sender, eventType) self:gpsHandler(sender, eventType) end, true)
--EXPORT_NODE_END
    self.go_target_btn:setSwallowTouches(false)
    self.buffPos1 = 80 
    self.buffPos2 = 45
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIUnionVillageItem:setData(data)

    self.data = data
    local campData = self:getCampData(data.lType)
    if campData then
        self.name:setString(campData.name)
        global.panelMgr:setTextureFor(self.icon, campData.icon)
    end

    data.tgBuffs = data.tgBuffs or {}
    for i=1,2 do
        local curBuff = data.tgBuffs[i]
        if curBuff then
            self["buffVal"..i]:setVisible(true)
            local dataType = luaCfg:get_data_type_by(curBuff.lBuffid)
            if dataType then
                self["buffName"..i]:setString(dataType.paraName)
                self["buffVal"..i]:setString(curBuff.lValue .. dataType.extra)
            end
        else
            self["buffVal"..i]:setVisible(false)
        end
    end
    if table.nums(data.tgBuffs) == 1 then
        self.buffVal1:setPositionY((self.buffPos1 + self.buffPos2)/2)
    else
        self.buffVal1:setPositionY(self.buffPos1)
        self.buffVal2:setPositionY(self.buffPos2)
    end

    if data.tgUser then
        
        self.head_node:setVisible(true)
        self.noOwner:setVisible(false)
        self.owName:setString(data.tgUser.szUserName)
        local head = luaCfg:get_rolehead_by(tonumber(data.tgUser.lHeadID))
        global.tools:setCircleAvatar(self.portrait_node, global.headData:convertHeadData(data.tgUser,head))
        local headInfo = luaCfg:get_role_frame_by(tonumber(data.tgUser.lBackID or 1))
        headInfo = global.headData:convertHeadData(data.tgUser,headInfo)
        if headInfo and headInfo.pic then
            global.panelMgr:setTextureFor(self.headFrame, headInfo.pic) 
        end 
    else
        self.head_node:setVisible(false)
        self.noOwner:setVisible(true)
    end

end

function UIUnionVillageItem:getCampData(lType)
    -- body
    for _,v in ipairs(luaCfg:world_camp()) do
        if v.type == lType then
            return v
        end
    end
    return nil
end

function UIUnionVillageItem:gpsHandler(sender, eventType)

    local sPanel = global.panelMgr:getPanel("UIUnionVillagePanel")
    if eventType == ccui.TouchEventType.began then
        sPanel.isPageMove = false
    end
    if eventType == ccui.TouchEventType.ended then
    
        if sPanel.isPageMove then 
            return
        end

        global.guideMgr:setStepArg({id=tonumber(self.data.lElementID or 0), isWild = 0})
        gevent:call(global.gameEvent.EV_ON_LOOP_GUIDE_PANDECT)   
    end

end
--CALLBACKS_FUNCS_END

return UIUnionVillageItem

--endregion
