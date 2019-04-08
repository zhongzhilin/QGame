--region UISelectSkinlItem.lua
--Author : anlitop
--Date   : 2017/08/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UISelectSkinlItem  = class("UISelectSkinlItem", function() return gdisplay.newWidget() end )

function UISelectSkinlItem:ctor()
    self:CreateUI()
end

function UISelectSkinlItem:CreateUI()
    local root = resMgr:createWidget("world/mapavatar/mapavatar_list")
    self:initUI(root)
end

function UISelectSkinlItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/mapavatar/mapavatar_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.name = self.root.Node_1.name_export
    self.kuang = self.root.Node_1.kuang_export
    self.icon = self.root.Node_1.icon_export
    self.time = self.root.Node_1.time_export
    self.ius = self.root.Node_1.ius_export
    self.dia_node = self.root.dia_node_export
    self.dia_num = self.root.dia_node_export.dia_num_export
    self.dia_icon = self.root.dia_node_export.dia_icon_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

local red =   cc.c3b(180, 29, 11)

local green = cc.c3b(87, 213, 67)


function UISelectSkinlItem:setData(data)

    self:cleanTimer()

    self.data = data 

    self.kuang:setVisible(global.userCastleSkinData:getClickSkin().id == self.data.id )

    self.name:setString(self.data.name)

    self.ius:setVisible(global.userCastleSkinData:getCrutSkin().id == self.data.id)

    global.panelMgr:setTextureFor( self.icon,self.data.worldmap)


    if self.data.isChongzhi then 

        self.dia_node:setVisible(true )
        self.time:setVisible(false)

        self.dia_num:setString(self.data.num)

    else 

        self.dia_node:setVisible(false )
        self.time:setVisible(true)

    end 
    

    self:addEventListener(global.gameEvent.EV_ON_CASTLE_SKILL_CLICK, function (event , id)

        self:updateClick(id)
    end)


    if self.data.serverData then 

        if self.data.serverData.lBeginTime then 

          self.timer = gscheduler.scheduleGlobal(handler(self,self.overtime), 1)

          self:overtime()

          self.time:setTextColor(red)

        else-- 默认城堡

            local str = global.luaCfg:get_local_string(10769)
            str ="(".. str ..")"
            self.time:setString(str)

            self.time:setTextColor(green)
        end 
    end 

end 

function UISelectSkinlItem:cleanTimer()
  if self.timer then
       gscheduler.unscheduleGlobal(self.timer)
      self.timer = nil
    end
end 

function UISelectSkinlItem:overtime()

   if self.data.serverData then 

       if self. data.serverData.lBeginTime then 

            local time  = global.vipBuffEffectData:getDayTime(  self.data.serverData.lEndTime - ( global.dataMgr:getServerTime() ) )

            self.time:setString( time)
      end 
  end 

end 

function UISelectSkinlItem:onExit()

    self:cleanTimer()
end 

function UISelectSkinlItem:updateClick(id)
     self.kuang:setVisible(self.data.id == id )
     if self.data.id  == id then 
        self.data.click = true 
     else 
        self.data.click = false 
     end  
end 


function UISelectSkinlItem:onUseClick(sender, eventType)


    if not self.data.click then 
        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_List")
        global.userCastleSkinData:setClickSkinNoUpdateUI(self.data.id)
        gevent:call(global.gameEvent.EV_ON_CASTLE_SKILL_CLICK,self.data.id)

    end 

    global.loginApi:updateUserCastleSkin(self.data.id  , function () 

        global.userCastleSkinData:setCrutSkin(self.data.id)

        local str=  global.luaCfg:get_local_string("avaatr06")
        global.tipsMgr:showWarning(str)

    end)


end




function UISelectSkinlItem:onChargeClick(sender, eventType)

   if not self.data.click then 

        gevent:call(gsound.EV_ON_PLAYSOUND,"ui_List")
        global.userCastleSkinData:setClickSkinNoUpdateUI(self.data.id)
        gevent:call(global.gameEvent.EV_ON_CASTLE_SKILL_CLICK,self.data.id)

    end 

    local state = self.data.state 
    local name =  self.data.name 


    if self.DIAMOND < self.data.num     then 

         global.tipsMgr:showWarning("ItemUseDiamond")

        return 
    end 

    local str = ""

    if state  == 1  then  -- 如果已经解锁 则提示 续费时间

        str= global.luaCfg:get_local_string("avaatr02")

    else 

        str= string.format(global.luaCfg:get_errorcode_by("avaatr04").text ,name..self:getTimeStr())

    end 

    local panel = global.panelMgr:openPanel("UIPromptPanel")

    panel:setData(str , function()
            
        global.itemApi:diamondUse(function (msg) 

            global.userCastleSkinData:deblockingSkin(msg.tagAvatarSkin or {})

            local str = ""

            -- if state  == 1  then  -- 如果已经解锁 则提示 续费时间

            --     -- str = "成功增加时间 "
            -- else 
                str = global.luaCfg:get_local_string("avaatr05")
            -- end  

            global.tipsMgr:showWarning(str)

        end , 12 , self.data.id)
    end)    


end
--CALLBACKS_FUNCS_END

return UISelectSkinlItem

--endregion
