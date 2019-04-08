--region UIUnionMiracleItem.lua
--Author : wuwx
--Date   : 2017/01/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionMiracleItem  = class("UIUnionMiracleItem", function() return gdisplay.newWidget() end )

function UIUnionMiracleItem:ctor()
    self:CreateUI()
end

function UIUnionMiracleItem:CreateUI()
    local root = resMgr:createWidget("union/union_miracle_list")
    self:initUI(root)
end

function UIUnionMiracleItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_miracle_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.icon_export
    self.miracle = self.root.miracle_export
    self.name = self.root.name_export
    self.add = self.root.add_export
    self.go_target = self.root.go_target_export
    self.boom = self.root.boom_export

    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:go_target_handler(sender, eventType) end)
--EXPORT_NODE_END
end

-- required int32      lMapID      = 1;
-- required int32      lPosX           = 2;
-- required int32      lPosY           = 3;
-- required int32      lType           = 4;
-- repeated Pair       tagPlus     = 5;    //加成属性
-- optional string     szOccupyName    = 6;
function UIUnionMiracleItem:setData(data)
    self.data = data
    self.dData = self:getRewardData(self.data.lType)


    local getIcon = function (lType) 
         for _ ,v in pairs(global.luaCfg:world_surface()) do
                if lType == v.type then 
                    return v.worldmap
                end 
         end 
    end 

    --self.icon:setSpriteFrame(getIcon(data.lType))    

    global.panelMgr:setTextureFor(self.icon, getIcon(data.lType))

    self.name:setString(self.data.szOccupyName)
    self.miracle:setString(self.dData.name)
    local sname = luaCfg:get_all_miracle_name_by(self.data.lMapID)
    if sname then
        self.miracle:setString(sname.name)
    end

    for i,v in ipairs(data.tagPlus) do
        if v.lID == 29 then
            self.add:setString(v.lValue)
        else
            self.boom:setString(v.lValue)
        end
    end
end


function UIUnionMiracleItem:getRewardData(magicType)
    
    local miracle_reward = luaCfg:miracle_reward()
    for _,v in ipairs(miracle_reward) do

        if v.type == magicType then

            return v
        end
    end
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionMiracleItem:go_target_handler(sender, eventType)
    -- global.tipsMgr:showWarning("FuncNotFinish")
    global.panelMgr:closePanelShowWorld()
    global.funcGame:gpsWorldCity(self.data.lMapID,self.data.lType > 500 and 1 or 0)
end
--CALLBACKS_FUNCS_END

return UIUnionMiracleItem

--endregion
