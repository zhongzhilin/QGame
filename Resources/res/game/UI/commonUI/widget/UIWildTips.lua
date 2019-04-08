--region UIWildTips.lua
--Author : yyt
--Date   : 2017/11/06
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIWildTips  = class("UIWildTips", function() return gdisplay.newWidget() end )

function UIWildTips:ctor()
    
end

function UIWildTips:CreateUI()
    local root = resMgr:createWidget("common/wild_tips")
    self:initUI(root)
end

function UIWildTips:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/wild_tips")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.text = self.root.Node_1.text_export

    uiMgr:addWidgetTouchHandler(self.root.Node_1.bg.Button_1, function(sender, eventType) self:click_close_tips(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIWildTips:onEnter()

    self:cleanTimer()

    if not self.timer then 
         self.timer = gscheduler.scheduleGlobal(handler(self,self.checkshow) ,5)  -- 每  5 秒钟 检测一下tips 
    end 

    self:addEventListener(global.gameEvent.EV_ON_GAME_PAUSE,function()
        self:Action(false)
    end)


    self:addEventListener(global.gameEvent.EV_ON_RES_WIDELIST , function () 
        if self:getNumber() <= 0  then 
            self:Action(false)
        end 
    end)


    self.first_in  = true 

    self.delay1  = gscheduler.performWithDelayGlobal(function()

        if self and  self.checkshow  then 

            self:checkshow()
        end 

        if self.delay1 then
            gscheduler.unscheduleGlobal(self.delay1)
            self.delay1 = nil
        end

    end, global.EasyDev.WILD_TIPS_DELAYTIME)
end

function UIWildTips:Action(state)


    self.root:stopAllActions() 

    if state then 

        self.root:setVisible(true)

        local nodeTimeLine =resMgr:createTimeline("common/wild_tips")

        self.root:runAction(nodeTimeLine)

        nodeTimeLine:play("animation0",false)

        nodeTimeLine:setLastFrameCallFunc(function()

            self.scheduleId = gscheduler.performWithDelayGlobal(function()

                if self and self.root then 

                    self.root:setVisible(true)

                    local nodeTimeLine =resMgr:createTimeline("common/wild_tips")

                    self.root:runAction(nodeTimeLine)

                    nodeTimeLine:play("animation1",false)

                    global.EasyDev:removeTips(global.EasyDev.WILD_TIPS_TYPE)

                end 

            end, global.EasyDev.Part_RES_TIPS_TIME)

        end)

    else

        global.EasyDev:removeTips(global.EasyDev.WILD_TIPS_TYPE)

        if self and self.root then 

            self.root:setVisible(false)

            if self.scheduleId then
                gscheduler.unscheduleGlobal(self.scheduleId)
                self.scheduleId = nil
            end
        end 

    end 
end 


local part_time = global.luaCfg:get_config_by(1).resTipsTime or 10 
part_time  = part_time * 60 

function UIWildTips:checkshow()

    if global.scMgr:isWorldScene() then return end 

    local rest = self:getNumber()
    if rest <= 0 then return end 

    local addTips = function ()
        global.EasyDev:addTips(global.EasyDev.WILD_TIPS_TYPE ,  function () 
        global.uiMgr:setRichText(self,"text",50217,{num =rest})
        self:Action(true) end )
    end

    if (not  global.EasyDev.wild_tips_last_time ) or self.first_in  or ( global.dataMgr:getServerTime() - global.EasyDev.wild_tips_last_time > part_time )  then 
        self.first_in = false
        global.EasyDev.wild_tips_last_time = global.dataMgr:getServerTime() 
        addTips()
    end 
end 


function UIWildTips:getNumber()


    local nowNum, maxNum = 0, 0
    local occupyData = global.resData:getOccupyMaxInfo() 
    if occupyData and occupyData.tagResource then
        maxNum = occupyData.tagResource.lMaxOccupy
    end
    local worldWild = global.resData:getWorldWild()
    nowNum = table.nums(worldWild) 
    local vip_Resource = global.vipBuffEffectData:getCurrentVipLevelEffect(3078).quantity or 0 
    maxNum = maxNum + vip_Resource

    local rest = maxNum  - nowNum

    return rest 
end 


function UIWildTips:cleanTimer()

    if self.timer then

        gscheduler.unscheduleGlobal(self.timer)

        self.timer = nil
    end
end 


function UIWildTips:onExit()

    self:cleanTimer()

    global.EasyDev:removeTips(global.EasyDev.WILD_TIPS_TYPE)
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWildTips:click_close_tips(sender, eventType)

    self:Action(false)
end


--CALLBACKS_FUNCS_END

return UIWildTips

--endregion
