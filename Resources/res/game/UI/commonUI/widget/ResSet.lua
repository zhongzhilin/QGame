--region ResSet.lua
--Author : wuwx
--Date   : 2016/09/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local propData = global.propData
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local ResourceNum = require("game.UI.commonUI.unit.ResourceNum")
--REQUIRE_CLASS_END

local ResSet  = class("ResSet", function() return gdisplay.newWidget() end )

local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")

local resList = {
    WCONST.ITEM.TID.FOOD,
    WCONST.ITEM.TID.GOLD,
    WCONST.ITEM.TID.WOOD,
}

function ResSet:ctor()
    
end

function ResSet:CreateUI()
    local root = resMgr:createWidget("common/common_resource")
    self:initUI(root)
end

function ResSet:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/common_resource")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.res_10 = ResourceNum.new()
    uiMgr:configNestClass(self.res_10, self.root.res_10)
    self.res_4 = ResourceNum.new()
    uiMgr:configNestClass(self.res_4, self.root.res_4)
    self.res_3 = ResourceNum.new()
    uiMgr:configNestClass(self.res_3, self.root.res_3)
    self.res_2 = ResourceNum.new()
    uiMgr:configNestClass(self.res_2, self.root.res_2)
    self.res_1 = ResourceNum.new()
    uiMgr:configNestClass(self.res_1, self.root.res_1)
    self.btn_rmb = self.root.btn_rmb_export
    self.rmb_icon = self.root.btn_rmb_export.rmb_icon_export
    self.rmb_num = self.root.btn_rmb_export.rmb_num_export

--EXPORT_NODE_END
        

    local call = function (i)
    
         local icon = self["res_"..i].num_icon
        global.funcGame:initBigNumber(self["res_"..i].num  , 1 , function (text , setString) 
            local str = text._showText
            local endstr = string.sub(str, #str,#str)
            if endstr =="K" or endstr =="M" or endstr =="T" then 
                icon:setVisible(true)
                local str = string.sub(str, 1 ,#str-1)
                str = string.gsub( str ,"%D","/")
                local is = "ui_surface_icon/"..endstr..".png"
                if icon.is and icon.is == is then 
                else 
                    icon:setSpriteFrame(is)
                end  
                icon.is = is
                setString(text , str)
                text:setPositionX(96)
            else 
                icon:setVisible(false)
                setString(text , str)
                text:setPositionX(107)
            end 
        end)
    end

    for i= 1 , 4  do 
        call(i)
    end 
    call(10)

    self.ResSetControl = ResSetControl.new(self.root,self)

    local nodeTimeLine = resMgr:createTimeline("common/common_resource")
    nodeTimeLine:setLastFrameCallFunc(function()

    end)
    nodeTimeLine:setTimeSpeed(0.5)
    nodeTimeLine:play("animation0", true)
    self.root:runAction(nodeTimeLine)

    --主界面跳转至 兵源界面
    uiMgr:addWidgetTouchHandler(self.res_10.root.resBtn, function(sender, eventType) self:onResClickHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.res_10.root.resBtn.btn_click_export, function(sender, eventType) self:onResClickHandler(sender, eventType) end)
    -- self.res_10.num_icon:setVisible(false)
    -- self.res_10.num:setPositionX(107)

end

function ResSet:onResClickHandler(sender, eventType)
    local buildingData = global.cityData:getBuildingById(4)
    global.panelMgr:openPanel("UISoldierSourcePanel"):setData(buildingData)
end

function ResSet:setData()
    self.ResSetControl:setData()
end

function ResSet:setFirstScroll(s)
    self.ResSetControl:setFirstScroll(s)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return ResSet

--endregion
