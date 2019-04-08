--region UIMiracleDoorHistoryItem.lua
--Author : Untory
--Date   : 2017/09/07
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIMiracleDoorHistoryItem  = class("UIMiracleDoorHistoryItem", function() return gdisplay.newWidget() end )

function UIMiracleDoorHistoryItem:ctor()
    self:CreateUI()
end

function UIMiracleDoorHistoryItem:CreateUI()
    local root = resMgr:createWidget("wild/temple_history_node")
    self:initUI(root)
end

function UIMiracleDoorHistoryItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wild/temple_history_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_node = self.root.portrait_node_export
    self.headFream = self.root.portrait_node_export.headFream_export
    self.history = self.root.history_export
    self.lord_name = self.root.lord_name_export
    self.history_sort = self.root.history_sort_export

--EXPORT_NODE_END
end

function UIMiracleDoorHistoryItem:setData( data )
    
    if data.szAllyName then
        self.lord_name:setString('【' .. data.szAllyName .. '】' .. data.szUserName)
    else
        self.lord_name:setString(data.szUserName)
    end    

    self.history_sort:setString(luaCfg:get_local_string(10842, data.lOwnSort))

    local time = global.funcGame.formatTimeToTime(data.lOwnTime,true)    
    self.history:setString(luaCfg:get_local_string("%s %s-%s-%s",luaCfg:get_local_string(10843),time.year,time.month,time.day))


    local headInfo = global.luaCfg:get_role_frame_by(tonumber(data.lFaceRectID))

    if headInfo and headInfo.pic then
        global.panelMgr:setTextureFor(self.headFream,headInfo.pic)     
    end 


    local head = luaCfg:get_rolehead_by(data.lFaceID)
    head = global.headData:convertHeadData(data,head)
    if  head.path then 
        global.tools:setCircleAvatar(self.portrait_node, head)
    end 
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIMiracleDoorHistoryItem

--endregion
