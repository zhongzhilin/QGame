--region UIDeviceDetailTPanel.lua
--Author : yyt
--Date   : 2016/10/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local funcGame = global.funcGame
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDeviceDetailTPanel  = class("UIDeviceDetailTPanel", function() return gdisplay.newWidget() end )

function UIDeviceDetailTPanel:ctor()
    self:CreateUI()
end

function UIDeviceDetailTPanel:CreateUI()
    local root = resMgr:createWidget("wall/wall_second_info_2")
    self:initUI(root)
end

function UIDeviceDetailTPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/wall_second_info_2")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.trim_top = self.root.trim_top_export
    self.title = self.root.title_export
    self.scrollView = self.root.scrollView_export
    self.ps_node = self.root.scrollView_export.ps_node_export
    self.name = self.root.scrollView_export.name_export
    self.des = self.root.scrollView_export.des_export
    self.icon = self.root.scrollView_export.icon_export
    self.space_num = self.root.scrollView_export.space_num_export
    self.kill_num = self.root.scrollView_export.kill_num_export
    self.effect_percent = self.root.scrollView_export.effect_percent_export
    self.najiu_num = self.root.scrollView_export.najiu_num_export
    self.food_num = self.root.scrollView_export.food_num_export
    self.wood_num = self.root.scrollView_export.wood_num_export
    self.stone_num = self.root.scrollView_export.stone_num_export
    self.time_num = self.root.scrollView_export.time_num_export
    self.perTime_num = self.root.scrollView_export.perTime_num_export

--EXPORT_NODE_END
    -- global.panelMgr:trimScrollView(self.scrollView,self.trim_top)
    self:adapt()

    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIDeviceDetailTPanel:onEnter()
    
    self.scrollView:jumpToTop()
end

function UIDeviceDetailTPanel:adapt()

    local sHeight =(gdisplay.height - self.trim_top:getContentSize().height)
    local defY = self.scrollView:getContentSize().height
    self.scrollView:setContentSize(cc.size(gdisplay.width, sHeight))
     if sHeight < defY then 

    else
        self.scrollView:setTouchEnabled(false)
        self.scrollView:setInnerContainerSize(cc.size(gdisplay.width, sHeight))
        local tt =  self.scrollView:getContentSize().height- self.ps_node:getPositionY()
        for _ ,v in pairs(self.scrollView:getChildren()) do 
            v:setPositionY(v:getPositionY()+tt)
        end 
    end 

end 


function UIDeviceDetailTPanel:setData(data)
    local proData = global.luaCfg:get_def_device_by(data.type*10+data.skill)
    -- self.icon:setSpriteFrame(data.pic)
    global.panelMgr:setTextureFor(self.icon,data.pic)
    self.name:setString(proData.name)
    self.des:setString(proData.info)
    self.space_num:setString(proData.space)
    self.kill_num:setString(proData.manpowerDamage)
    self.effect_percent:setString(proData.robEffect)
    self.najiu_num:setString(proData.hp)
    self.food_num:setString(proData.foodCost)
    self.wood_num:setString(proData.woodCost)
    self.stone_num:setString(proData.stoneCost)
    self.time_num:setString(funcGame.formatTimeToHMS(proData.perTime))
    self.perTime_num:setString(funcGame.formatTimeToHMS(proData.perTime))

    local clipData = global.luaCfg:get_picture_by(data.id*10+3)
    self.icon:setScale(clipData.scale/100)
end

function UIDeviceDetailTPanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanelForBtn("UIDeviceDetailTPanel")
end

--CALLBACKS_FUNCS_END

return UIDeviceDetailTPanel

--endregion
