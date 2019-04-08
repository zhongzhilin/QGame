--region UIPetIcon.lua
--Author : zzl
--Date   : 2018/11/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPetIcon  = class("UIPetIcon", function() return gdisplay.newWidget() end )

function UIPetIcon:ctor()
    self:CreateUI()
end

function UIPetIcon:CreateUI()
    local root = resMgr:createWidget("city/pet_icon")
    self:initUI(root)
end

function UIPetIcon:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/pet_icon")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn_lvup = self.root.btn_lvup_export
    self.conPic = self.root.btn_lvup_export.conPic_export
    self.time = self.root.btn_lvup_export.time_export

    uiMgr:addWidgetTouchHandler(self.btn_lvup, function(sender, eventType) self:onClick(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIPetIcon:onEnter()

    self:schedule(function () 
        if self.timeCall then 
            self.timeCall()
        end 
    end, 1)

    -- self.root:runAction()
    
    local nodeTimeLine = resMgr:createTimeline("city/pet_icon")
    nodeTimeLine:play("animation0", true)
    self:runAction(nodeTimeLine)

end

function UIPetIcon:onExit()

end
    

local t = {} 

function UIPetIcon:setData(data)

    self.timeCall = nil

    if  data.serverData.lState == 2 then  --倒计时中 

        local endtime = data.serverData.lMeetTimes[4]  

        self.timeCall = function () 

            local time = endtime - global.dataMgr:getServerTime()
            if time < 0 then time = 0 end 

            self.time:setString(global.funcGame.formatTimeToHMS(time))
        end 
        
        self.timeCall()

        local type_ = data.type
        if type_ == 1 then 
            type_ = 2 
        elseif type_ == 2 then 
            type_ = 1
        end 

        global.panelMgr:setTextureFor(self.conPic,string.format("icon/pet/pet_%s01.png", type_))

    elseif data.serverData.lState == 3 then --点击 解锁中

        self.time:setString(gls(11161))

        local type_ = data.type
        if type_ == 1 then 
            type_ = 2 
        elseif type_ == 2 then 
            type_ = 1
        end 

        global.panelMgr:setTextureFor(self.conPic,string.format("icon/pet/pet_%s01.png", type_))

    else 

    end  


    self.data = data 
end 

function UIPetIcon:onClick(sender, eventType)
        
    -- global.funcGame.forceGpsCityBuilding(31)

    global.guideMgr:setStepArg(global.g_cityView:getTouchMgr():getBuildingNodeByType2(31):getId()) 
    gevent:call(global.gameEvent.EV_ON_GPSBUILID)

end
--CALLBACKS_FUNCS_END

return UIPetIcon

--endregion
