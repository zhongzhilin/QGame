--region UISoldier .lua
--Author : anlitop
--Date   : 2017/06/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local actionManger  =require("game.UI.replay.excute.actionManger")

local UISoldier   = class("UISoldier ", function() return gdisplay.newWidget() end )
local UIISoldierTipsControl = require("game.UI.common.UIISoldierTipsControl")
local UIWildTipsControl = require("game.UI.common.UIWildTipsControl")




function UISoldier:ctor()
    self:CreateUI()
end

function UISoldier:CreateUI()
    local root = resMgr:createWidget("player/node/player_soldier")
    self:initUI(root)
end

function UISoldier:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/player_soldier")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.portrait_view = self.root.portrait_view_export
    self.portrait_node = self.root.portrait_view_export.portrait_node_export
    self.node_killed = self.root.portrait_view_export.node_killed_export
    self.num_type = self.root.portrait_view_export.num_type_export
    self.num = self.root.portrait_view_export.num_export
    self.chief = self.root.portrait_view_export.chief_export
    self.select_bg = self.root.select_bg_export
    self.effect_light = self.root.effect_light_export
    self.effect_light2 = self.root.effect_light2_export

--EXPORT_NODE_END
end

-- rint] - "UISoldier data" = {
-- [LUA-print] -     "lcount"    = 217
-- [LUA-print] -     "ltroopid"  = 69626
-- [LUA-print] -     "soldierId" = 31
-- [LUA-print] - }

function UISoldier:setData(data)

    dump(data ,"UISoldier data")

    local naiijiudu = global.luaCfg:get_local_string(10737)
    local shuliang = global.luaCfg:get_local_string(10736)

    self.data = data 


    -- dump(self.data , "你的部队id呢？？？？")

    self:setId()

    self.num:setString(data.lcount)
    self.num_type:setString(shuliang)

    if self.data.soldierId ==70 then  --城强

        global.tools:setSoldierAvatar(self.portrait_node,{id=3})

        self.num:setString(data.lcount)

        self.num_type:setString(naiijiudu)

    elseif self.data.soldierId ==71 then  --j箭塔

        global.tools:setSoldierAvatar(self.portrait_node,{id=8071})

    elseif self.data.soldierId ==72 then  --陷阱

        global.tools:setSoldierAvatar(self.portrait_node,{id=8072})

    else 
        global.tools:setSoldierAvatar(self.portrait_node,{id=data.soldierId})

        self.soldier_id = data.soldierId
    end 

    self:test()

    self:addtips()
    self:updateChief()
end 


function  UISoldier:setId ()
     if self.data.soldierId ==70 then  --城强
        self.soldier_id = 3 
    elseif self.data.soldierId ==71 then  --j箭塔
        self.soldier_id = 8071
    elseif self.data.soldierId ==72 then  --陷阱
        self.soldier_id = 8072
    else 
        self.soldier_id = self.data.soldierId
    end 
end 



function UISoldier:updateCount(data)
    self.data = data
    self.num:setString(data.lcount)
    self:setId()
    self:test()
    self:addtips()
    self:updateChief()
end 


function UISoldier:updateChief()
    self.chief:setVisible(self.data.chief)
end 


function UISoldier:test()

    global.colorUtils.turnGray(self.portrait_view, self.data.lcount <= 0 ) 

    global.colorUtils.turnGray(self.portrait_node, self.data.lcount <= 0 ) 

    self:turnGray(not (self.data.lcount <= 0)) 

    global.colorUtils.turnGray(self.num, false)

    self.node_killed:setVisible(self.data.lcount <= 0)
    global.colorUtils.turnGray(self.node_killed, false)

    if self.data.lcount <=0 then 

        self.num:setTextColor(gdisplay.COLOR_RED)
    else 
        self.num:setTextColor(gdisplay.COLOR_GREEN)
    end 
end 

function UISoldier:turnGray(status)
    self.select_bg:setVisible(status)
    self.effect_light:setVisible(status)
    self.effect_light2:setVisible(status)
end 


local soldier_type = {soldier= "solider", wall = "wall" , monster = "monster" , city = "city"}

local tips_type = {wall=1 , wild= 2 , city = 3 } 

local wall = {70,71,72}

function UISoldier:checkType(data , soldier_id)

    local  temp  ={soldier =1 , monster =2 }
    local check = function(id) 
        if global.luaCfg:get_soldier_train_by(id) then 
            return temp.soldier
        else 
            return temp.monster
        end 
    end 

    if data.soldierType == 1 then 

        if  check(soldier_id)  == temp.soldier then 
            return soldier_type.soldier
        else 
            return soldier_type.monster
        end 
    else
        if self.data.soldierId ==72  or self.data.soldierId ==71 then 

            return soldier_type.city

        elseif self.data.soldierId == 70  then 

            return soldier_type.wall
        else 
            print("error 161 ,",soldier_id)
        end 
    end 
end 

function UISoldier:addtips()

    -- if  self.m_TipsControl then return end 


    local s_type = self:checkType(self.data , self.soldier_id) 

    if  self.m_TipsControl then  -- 城墙需要每次都更新数据
        if s_type  == soldier_type.wall then 
            if self.m_TipsControl.updateData then 
                self.m_TipsControl:updateData(self.data)
            end 
        end 
        return
     end 

    local  node = global.panelMgr:getPanel("UIRePlayerPanel").tips_node

    if  self.soldier_id  then 

        local  soldier_train_data = nil 

        if s_type  == soldier_type.soldier then 

            self.m_TipsControl = UIISoldierTipsControl.new()

            soldier_train_data = clone(global.luaCfg:get_soldier_train_by(self.soldier_id))

            if not soldier_train_data  or  not self.m_TipsControl  then return end 

            self.m_TipsControl:isExitNoHideTips(true)

            local clone_data = clone(self.data)
            clone_data.id =  self.soldier_id
            clone_data.hideBuff = true

            self.m_TipsControl:setdata(self.portrait_view.Sprite_5 ,clone_data ,node)

        elseif  s_type  == soldier_type.monster then 

            self.m_TipsControl = UIWildTipsControl.new()
            soldier_train_data = clone(global.luaCfg:get_wild_property_by(self.soldier_id))

            soldier_train_data.tips_type = tips_type.wild

             if not soldier_train_data  or  not self.m_TipsControl  then return end 
            soldier_train_data.hideBuff = true
            self.m_TipsControl:setdata(self.portrait_view.Sprite_5 ,soldier_train_data,node)
            self.m_TipsControl:isExitNoHideTips(true)

        elseif s_type  == soldier_type.wall then 

             self.data.tips_type = tips_type.wall

            self.m_TipsControl = UIWildTipsControl.new()

            self.m_TipsControl:setdata(self.portrait_view.Sprite_5 ,self.data ,node)

            return 
        elseif  s_type  == soldier_type.city then 

            self.data.tips_type = tips_type.city

            self.m_TipsControl = UIWildTipsControl.new()

            self.m_TipsControl:setdata(self.portrait_view.Sprite_5, self.data ,node)

            return 
        end 


    end 
end



function UISoldier:onExit()
    self:cleanTips()
end


function UISoldier:cleanTips()
    if  self.m_TipsControl then 
        self.m_TipsControl:ClearEventListener()
        self.m_TipsControl = nil 
    end 
end 


function UISoldier:hideLight()
    
    -- print("隐藏光//////////////")
    actionManger.getInstance():createTimeline(self.root,"soldier2" , true , true)
end 


function UISoldier:showAction()

     actionManger.getInstance():createTimeline(self.root ,"soldier1" , true , true)
    
end


function UISoldier:showAction1()

     actionManger.getInstance():createTimeline(self.root ,"soldier" , true , true)

end

function UISoldier:hideSelfNoAction()

     actionManger.getInstance():createTimeline(self.root ,"hidesoldier" , true , true)

end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UISoldier 

--endregion
