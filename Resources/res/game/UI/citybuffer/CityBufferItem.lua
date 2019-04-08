--region CityBufferItem.lua
--Author : anlitop
--Date   : 2017/03/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local funcGame = global.funcGame
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local CityBufferItem  = class("CityBufferItem", function() return gdisplay.newWidget() end )

function CityBufferItem:ctor()
    self:CreateUI()
end

function CityBufferItem:CreateUI()
    local root = resMgr:createWidget("citybuff/citybuff_list")
    self:initUI(root)
end

function CityBufferItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "citybuff/citybuff_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.bg_bt = self.root.bg_bt_export
    self.name = self.root.bg_bt_export.name_export
    self.describe = self.root.bg_bt_export.describe_export
    self.icon_view = self.root.bg_bt_export.icon.icon_view_export
    self.icon = self.root.bg_bt_export.icon.icon_export
    self.loadingbar_bg = self.root.bg_bt_export.loadingbar_bg_export
    self.LoadingBar = self.root.bg_bt_export.loadingbar_bg_export.LoadingBar_export
    self.time = self.root.bg_bt_export.loadingbar_bg_export.time_export
    self.num_info = self.root.bg_bt_export.loadingbar_bg_export.num_info_mlan_4_export
    self.node_effect = self.root.bg_bt_export.node_effect_export

--EXPORT_NODE_END
    self.bg_bt:setSwallowTouches(false)
    self.bg_bt:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
end

function CityBufferItem:setData(data)
    self.data = data
    self.node_effect:stopAllActions()
    self.node_effect:setVisible(false)
    self.name:setString(data.name)
    self.describe:setString(data.des)
    -- self.icon:setSpriteFrame(data.icon)
    -- self.icon_view:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",data.quality))
    global.panelMgr:setTextureFor(self.icon_view,string.format("icon/item/item_bg_0%d.png",data.quality))
    global.panelMgr:setTextureFor(self.icon,data.icon)

    print(global.userData:inNewProtect(),"global.userData:inNewProtect()")

    if global.userData:inNewProtect()then 

         if self.data.id ==1 then  --检测新手保护

            self.data.status.isvalid =true 

            -- 没有城池不能修改名称
            local m_cityId = global.userData:getWorldCityID()
            
            if m_cityId == 0 then

                self.data.status.isvalid = false  
            end

                self.data.status.toaltime = 60 * 60 * 24 * 3 
                
                self.data.status.beggintime =  global.userData:getNewPlayBuff().lExpire  - self.data.status.toaltime 

                self.data.valid_describe = global.luaCfg:get_local_string(10670)

         end 
    end 


    if self.data.status.isvalid then

        if  self.data.id ==1 and global.userData:inNewProtect() then 
            self.describe:setString(self.data.valid_describe)
        else 

            local time  = math.floor(self.data.status.toaltime / global.define.HOUR)
            
            local effect = self.data.effect.."%"

            self.describe:setString(string.format(self.data.text, time ,effect))

        end 

        self.loadingbar_bg:setVisible(self.data.status.isvalid)

        -- 启动定时器 界面显示倒计时
        if not self.timer then 
            self.timer = gscheduler.scheduleGlobal(handler(self,self.updateBar), 1)
        end 
       self.progress = global.dataMgr:getServerTime() -self.data.status.beggintime
       self:updateBar()
        self.node_effect:setVisible(true)
        self.node_effect:stopAllActions()
        local nodeTimeLine =resMgr:createTimeline("citybuff/city_buff_effect")
        self.node_effect:runAction(nodeTimeLine)
        nodeTimeLine:play("animation0",true)
    else 
        self.data.status.isvalid = false 
        self.node_effect:stopAllActions()
        self.node_effect:setVisible(false)
        self.loadingbar_bg:setVisible(data.status.isvalid)
        self.m_buffTimeLine = nil
    end  

end 



function CityBufferItem:onExit()
    if self.timer then
       gscheduler.unscheduleGlobal(self.timer)
      self.timer = nil
        self.progress =nil
    end
end 

function CityBufferItem:updateBar()

    if self.data.status.toaltime  then 
        self.progress = self.progress +1        
        if(self.data.status.toaltime-self.progress>0) then 
            self.time:setString(funcGame.formatTimeToHMS(self.data.status.toaltime-self.progress) )
            self.LoadingBar:setPercent((self.data.status.toaltime-self.progress)/self.data.status.toaltime*100) 
        else
            self.data.status.isvalid =false 
            self.m_buffTimeLine = nil
            self.node_effect:stopAllActions()
            self.node_effect:setVisible(false)
            self.loadingbar_bg:setVisible(false)
        end  
    else 
         global.tipsMgr:showWarning("CityBufferItem toaltime is NULL")
    end  
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return CityBufferItem

--endregion
