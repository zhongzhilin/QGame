

--region UIUnionDynamicItem.lua
--Author : yyt
--Date   : 2017/02/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionDynamicItem  = class("UIUnionDynamicItem", function() return gdisplay.newWidget() end )

function UIUnionDynamicItem:ctor()
    self:CreateUI()
end

function UIUnionDynamicItem:CreateUI()
    local root = resMgr:createWidget("union/union_trigger_list")
    self:initUI(root)
end

function UIUnionDynamicItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_trigger_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.icon_export
    self.text = self.root.text_export
    self.time = self.root.time_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIUnionDynamicItem:setData(data)

    dump(data)
    
    local triggerData = luaCfg:get_union_trigger_by(data.lCfgID) 
    -- self.icon:setSpriteFrame(triggerData.icon)
    global.panelMgr:setTextureFor(self.icon,triggerData.icon)
    self.time:setString(global.mailData:getDataTime(data.lTime))

    local spliteData = self:strSplit(data.szParam,'|')

    -- 特殊动态处理
    spliteData = self:dealSpecial(data, spliteData)

    self.text:setString(string.fformat(triggerData.text,   unpack(spliteData)))
    self.text:setTextColor(cc.c3b(unpack(triggerData.color)))

end

function UIUnionDynamicItem:dealSpecial(data, spliteData)
    
    if data.lCfgID == 6 then
        spliteData[3] = luaCfg:get_union_position_btn_by(tonumber(spliteData[3])).text
    elseif data.lCfgID == 12 or data.lCfgID == 23 then
        if luaCfg:get_wild_res_by(tonumber(spliteData[2])) then 
            spliteData[2] =luaCfg:get_wild_res_by(tonumber(spliteData[2])).name
        end 
    elseif data.lCfgID == 2 or data.lCfgID == 24 or data.lCfgID == 25 then
        spliteData[2] = luaCfg:get_world_type_by(tonumber(spliteData[2])).name
    elseif data.lCfgID == 26 then
        spliteData[1] = luaCfg:get_union_build_by(tonumber(spliteData[1])).name
    elseif data.lCfgID == 27 or data.lCfgID == 28 then

        local id = 0
        local temp = luaCfg:union_class_btn()
        for _,v in pairs(temp) do
            if tonumber(spliteData[3]) == v.id then 
                id = v.level
            end
        end
        local temp = luaCfg:get_union_class_btn_by(tonumber(id))
        if temp then
            spliteData[3] = temp.text
        end
    elseif data.lCfgID == 34 then
        spliteData[3] = luaCfg:get_wild_res_by(tonumber(spliteData[3])).name
    elseif data.lCfgID == 40 then
        spliteData[4] = luaCfg:get_wild_res_by(tonumber(spliteData[4])).name
    elseif data.lCfgID == 42 then
        spliteData[3] = luaCfg:get_world_type_by(tonumber(spliteData[3])).name
    elseif data.lCfgID == 43 then
        spliteData[4] = luaCfg:get_world_type_by(tonumber(spliteData[4])).name
    end
    return spliteData
end

function UIUnionDynamicItem:strSplit(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end
    
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

--CALLBACKS_FUNCS_END

return UIUnionDynamicItem

--endregion
