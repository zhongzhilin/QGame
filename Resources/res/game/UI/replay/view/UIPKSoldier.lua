--region UIPKSoldier .lua
--Author : anlitop
--Date   : 2017/06/20
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIPKSoldier   = class("UIPKSoldier ", function() return gdisplay.newWidget() end )

local actionManger  =require("game.UI.replay.excute.actionManger")
local TextScrollControl = require("game.UI.common.UITextScrollControl")

local Player  =require("game.UI.replay.excute.Player")
local TextEffect  =require("game.UI.replay.excute.TextEffect")

function UIPKSoldier:ctor()
    -- self:CreateUI()
end

function UIPKSoldier:CreateUI()
    local root = resMgr:createWidget("player/node/player_pk1")
    self:initUI(root)
end

function UIPKSoldier:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/player_pk1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.blue = self.root.root.blue_export
    self.red = self.root.root.red_export
    self.soldier_node = self.root.root.Panel_1.soldier_node_export
    self.count = self.root.root.count_export
    self.type = self.root.root.type_export
    self.left_combat_icon = self.root.root.left_combat_icon_export
    self.combat_num = self.root.root.left_combat_icon_export.combat_num_export
    self.name = self.root.root.name_export
    self.hurt = self.root.root.hurt_export
    self.star = self.root.star_export
    self.star1_bj = self.root.star_export.star1_bj_export
    self.star1 = self.root.star_export.star1_bj_export.star1_export
    self.star2 = self.root.star_export.star1_bj_export.star2_export
    self.star2_bj = self.root.star_export.star2_bj_export
    self.star3 = self.root.star_export.star2_bj_export.star3_export
    self.star4 = self.root.star_export.star2_bj_export.star4_export
    self.star3_bj = self.root.star_export.star3_bj_export
    self.star5 = self.root.star_export.star3_bj_export.star5_export
    self.star6 = self.root.star_export.star3_bj_export.star6_export
    self.chief = self.root.chief_export

--EXPORT_NODE_END

end


function UIPKSoldier:onEnter()
    
    self.TextEffecttabe ={}

end 

--  "lcount"      = 356
-- [LUA-print] -     "soldierId"   = 72
-- [LUA-print] -     "soldierType" = 3

function UIPKSoldier:setData(data , fightDef, isaction)

    local naiijiudu = global.luaCfg:get_local_string(10737)
    local shuliang = global.luaCfg:get_local_string(10736)

    self.data = data 

    -- dump(data, "UIPKSoldier data")

    local name = ""
    local lv  = ""

    if not data then return end 

    self.str_type  = shuliang

    if fightDef  == 1 then 
        self.blue:setVisible(false)
        self.red:setVisible(true)
    else
        self.blue:setVisible(true)
        self.red:setVisible(false)
    end  


    if self.data.soldierId ==70 then  --城强

        global.tools:setSoldierBust(self.soldier_node,{id=3})
        self.str_type = naiijiudu
        name  = global.luaCfg:get_soldier_property_by(3).name

    elseif self.data.soldierId ==71 then  --j箭塔

        global.tools:setSoldierBust(self.soldier_node,{id = 8071})

        name  = global.luaCfg:get_soldier_train_by(8071).name

    elseif self.data.soldierId ==72 then  --陷阱

        global.tools:setSoldierBust(self.soldier_node,{id = 8072})

        name  = global.luaCfg:get_soldier_train_by(8072).name
    else 

        local info =  global.luaCfg:get_soldier_train_by(self.data.soldierId)
        if not info then 
            info  =  global.luaCfg:get_wild_property_by(self.data.soldierId)
        end 
        name  = info.name

        local  soldier_Type ={soldier =1 , monster =2 }
        local checkType = function(id) 
            if global.luaCfg:get_soldier_train_by(id) then 
                return soldier_Type.soldier
            else 
                return soldier_Type.monster
            end 
        end 

        if checkType(self.data.soldierId) == soldier_Type.monster then 
            global.tools:setMonsterHD(self.soldier_node,{id = self.data.soldierId},5)
        else 
            global.tools:setSoldierBust(self.soldier_node,{id = self.data.soldierId})
        end 


        -- self.solider_icon:setSpriteFrame(pic)
    end

    self.count:setString( self.str_type..":"..self.data.lcount)
    -- self.type:setString(self.str_type)

    self.fightDef  = fightDef

    local showlvStar = function (lGrade)
        self.star:setVisible(lGrade ~= -1)
        for i=1,6 do
            self["star"..i]:setVisible(lGrade >= i*5)
        end
    end
    if self.data.soldierLV then 
        showlvStar(self.data.soldierLV)
        self.name:setString(name)
    else 
        showlvStar(-1)
        self.name:setString(name)
    end 

    self.chief:setVisible(self.data.chief)

end 



function UIPKSoldier:updateCapacity(Capacity,isAction)

    if isAction then 
        TextEffect.new(self.combat_num ,Capacity, 0.4)
    else 
        self.combat_num:setString(Capacity)
    end 

end 

function UIPKSoldier:updateCount(count,isAction)

    if isAction then 
        TextEffect.new(self.count ,count, 0.4,
            function (string) 
                local string_table  = global.tools:strSplit(string , ":")
                return tonumber(string_table[2])
            end,
            function (num) 
                return self.str_type..":"..num
            end
        )

    else 
        self.count:setString(count)
    end 
end 

function UIPKSoldier:showHurt(hurt)

    if not hurt or hurt == 0 then 

        return 
    end
    self.hurt:setString("/"..hurt)
    actionManger.getInstance():createTimeline(self.root  ,"pKSoldier" , true , true)
end


function UIPKSoldier:hideSelfWithAction()

    actionManger.getInstance():createTimeline(self.root  ,"hideUIPKSoldier" , true , true)

end 


function UIPKSoldier:hideHurtNoAction()

    actionManger.getInstance():createTimeline(self.root  ,"hideHurtNoAction" , true , true)

end 


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIPKSoldier 

--endregion
