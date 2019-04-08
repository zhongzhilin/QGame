--region UITurntableFirItem.lua
--Author : wuwx
--Date   : 2017/11/17
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UITurntableFirItem  = class("UITurntableFirItem", function() return gdisplay.newWidget() end )

function UITurntableFirItem:ctor()
    self:CreateUI()
end

function UITurntableFirItem:CreateUI()
    local root = resMgr:createWidget("turntable/turntable_list")
    self:initUI(root)
end

function UITurntableFirItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "turntable/turntable_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg = self.root.bg_export
    self.img = self.root.img_export
    self.name = self.root.name_export
    self.text = self.root.text_export
    self.red_point = self.root.red_point_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UITurntableFirItem:setData(data)

    self.data = data

    self.name:setString(self.data.name)
    self.text:setString(self.data.text)

    -- global.panelMgr:setTextureFor(self.bg,self.data.image)

    self.bg:setSpriteFrame(self.data.image)

    if self.data.id == 2 then
        self.red_point:setVisible(global.userData:getFreeLotteryCount() <= 0)
    --elseif self.data.id == 3 then
        -- self.red_point:setVisible(global.userData:getDyFreeLotteryCount() <= 0)
    else
        self.red_point:setVisible(false)
    end

    self:addEventListener(global.gameEvent.EV_ON_UI_RED_TURNTABLE_HERO_FREE_TIMES , function () 
        if self.data.id == 2 then
            self.red_point:setVisible(global.userData:getFreeLotteryCount() <= 0)
        --elseif self.data.id == 3 then
        --    self.red_point:setVisible(global.userData:getDyFreeLotteryCount() <= 0)
        else
            self.red_point:setVisible(false)
        end
    end)
end


--CALLBACKS_FUNCS_END

return UITurntableFirItem

--endregion
