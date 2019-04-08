--region UIPKUserItem.lua
--Author : zzl
--Date   : 2018/02/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPKHeroItem = require("game.UI.pk.UIPKHeroItem")
--REQUIRE_CLASS_END

local UIPKUserItem  = class("UIPKUserItem", function() return gdisplay.newWidget() end )

function UIPKUserItem:ctor()
    self:CreateUI()
end

function UIPKUserItem:CreateUI()
    local root = resMgr:createWidget("player_kill/pk_user_item")
    self:initUI(root)
end

function UIPKUserItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/pk_user_item")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.hero_1 = self.root.hero_1_export
    self.hero_1 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.hero_1, self.root.hero_1_export)
    self.hero_2 = self.root.hero_2_export
    self.hero_2 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.hero_2, self.root.hero_2_export)
    self.hero_3 = self.root.hero_3_export
    self.hero_3 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.hero_3, self.root.hero_3_export)
    self.rank = self.root.rank_mlan_4.rank_export
    self.portrait_node = self.root.portrait_node_export
    self.frame = self.root.portrait_node_export.frame_export
    self.user_name = self.root.portrait_node_export.user_name_export
    self.icon = self.root.icon_export
    self.my_start = self.root.my_start_export
    self.defenPowerIcon = self.root.defenPowerIcon_export
    self.power = self.root.power_export
    self.reword = self.root.reword_export

    uiMgr:addWidgetTouchHandler(self.my_start, function(sender, eventType) self:challengeCall(sender, eventType) end)
--EXPORT_NODE_END

    for i=1 , 3 do 
        self["hero_"..i].bt_bg:setSwallowTouches(false)
    end 
   self.my_start:setSwallowTouches(false)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


local resType = {
    [1] = { itemId=1,  itemType=101, buildResType=3, resItemType=5, resIcon="ui_surface_icon/res_food_icon.png", resGetIcon="ui_surface_icon/city_res_food.png",    
        bgViewPic="ui_surface_icon/food_loadingbar.png"    ,ligPic="ui_surface_icon/food_loadingtip.png" },
    [2] = { itemId=2,  itemType=101, buildResType=11, resItemType=8, resIcon="ui_surface_icon/res_coin_icon.png", resGetIcon="ui_surface_icon/city_res_coin.png",   
        bgViewPic="ui_surface_icon/coin_loadingbar.png"    ,ligPic="ui_surface_icon/coin_loadingtip.png" },
    [3] = { itemId=3,  itemType=101, buildResType=9, resItemType=6, resIcon="ui_surface_icon/res_wood_icon.png", resGetIcon="ui_surface_icon/city_res_wood.png",    
        bgViewPic="ui_surface_icon/wood_loadingbar.png"    ,ligPic="ui_surface_icon/wood_loadingtip.png" },
    [4] = { itemId=4,  itemType=101, buildResType=10, resItemType=7, resIcon="ui_surface_icon/res_stone_icon.png", resGetIcon="ui_surface_icon/city_res_stone.png", 
        bgViewPic="ui_surface_icon/stone_loadingbar.png"   ,ligPic="ui_surface_icon/stone_loadingtip.png"},
}


-- message GroupInfo
-- {
--     required int32  lID = 1;
--     required int32  lFaceID = 2;
--     required string szName = 3;
--     required int32  lRank = 4;
--     required int64  lPower = 5;
--     required PKGroup    tagPKGroup = 6;
--     repeated Item   tagItem = 7;
--     optional string szParam = 8;
-- }

 -- tagPKGroup = {
 --                lPower = 8246,
 --                tagHero = {
 --                    [1] = {
 --                        lGrade = 69,
 --                        lID = 8222,
 --                        lPower = 6290,
 --                        lStar = 1,
 --                    },
 --                    [2] = {
 --                        lGrade = 2,
 --                        lID = 8104,
 --                        lPower = 974,
 --                        lStar = 1,
 --                    },
 --                    [3] = {
 --                        lGrade = 2,
 --                        lID = 8101,
 --                        lPower = 982,
 --                        lStar = 1,
 --                    },
 --                },
 --            },


function UIPKUserItem:onEnter()

end 

function UIPKUserItem:onExit()

end 


local luaCfg = global.luaCfg
local panelMgr = global.panelMgr

function UIPKUserItem:setData(data)

	self.data = data 

    self.rank:setString(self.data.lRank)

    self.power:setString(self.data.lPower)

    self.user_name:setString(self.data.szName)

    self.reword:setString(self.data.tagItem[1].lCount)

    -- global.panelMgr:setTextureFor(self.icon, global.luaCfg:get_local_item_by(self.data.tagItem[1].lID).itemIcon)
    self.icon:setSpriteFrame(global.luaCfg:get_local_item_by(self.data.tagItem[1].lID).itemIcon)

    self.icon:setScale(0.3)        

    if self.data.tagItem[1].lID <= 4 then 
        self.icon:setScale(1)        
    end 

    local head = {}
    head.path =global.luaCfg:get_rolehead_by(data.lFaceID or 101).path
    head.scale = 85
    global.tools:setCircleAvatar(self.portrait_node, global.headData:convertHeadData(data,head))

    local headData = global.luaCfg:get_role_frame_by(self.data.lBackID or 1)
    global.panelMgr:setTextureFor(self.frame,headData.pic)

    for i= 1, 3 do 

        local item = self["hero_"..i]

        local data = global.luaCfg:get_hero_property_by(self.data.tagPKGroup.tagHero[i].lID)

        data.serverData = self.data.tagPKGroup.tagHero[i]

        item:setData(data or {})

        local id =  self.data.tagPKGroup.tagHero[i].lID
        local userid =  self.data.tagPKGroup.tagHero[i].lOwnID

        uiMgr:addWidgetTouchHandler(item.bt_bg, function(sender, eventType) 

            local panel  = global.panelMgr:getPanel("UIPKPanel")    
            if panel.isMove then 
                gsound.stopEffect("city_click")
                return 
            end 
            global.commonApi:getPKRankInfo(userid ,function(msg)
                    local call = function(msg)
                            msg.tgHero = msg.tgHero or {}
                            msg.tgEquip = msg.tgEquip or {}
                            if not msg.tgHero.lID then return end                   
                            local heroData  = {}
                            local equipData = {}
                            for index,v in ipairs(msg.tgEquip) do        
                                local equipLua = luaCfg:equipment()  
                                for _,vv in pairs(equipLua) do
                                    if vv.id == v.lGID then
                                        v.lType = vv.type
                                        break
                                    end
                                end
                                equipData[v.lType] = {id = v.lGID, lv = v.lStronglv, lType = v.lType, lCombat=v.lCombat, tgAttr=v.tgAttr}
                            end
                            heroData.equipData = equipData
                            heroData.serverData = msg.tgHero
                            panelMgr:openPanel("UIShareHero", nil, true):setData(heroData)
                    end
                    local msg =self:getheroInfo(msg , id)
                    call(msg)
            end)
        end)
    end 

end 


function UIPKUserItem:getheroInfo(data ,  heroId )

    local msg ={}
    msg.tgHero = msg.tgHero or {}
    msg.tgEquip = msg.tgEquip or {}

    for _ , v in pairs(data.tagEquip or {} ) do 
        if v.lHeroID == heroId then 
            table.insert( msg.tgEquip , v)
        end 
    end 

    for _ , v in pairs(data.tagHero or {} ) do 
        if v.lID ==heroId then 
             msg.tgHero  = v
        end 
    end 

    return msg
end 

function UIPKUserItem:challengeCall(sender, eventType)

    local panel  = global.panelMgr:getPanel("UIPKPanel")    
    if panel.isMove then 

        gsound.stopEffect("city_click")

    return end 

    if not  panel.mydata or panel.mydata.lCount <=0 then 

        return global.tipsMgr:showWarning("pk04")
    end 

    local iscd , time = panel:isCd()

    if iscd then 

        return global.tipsMgr:showWarning("pkcd")
    end 
    
    -- dump(self.data , "self.data")    


    local call = function () 

        local key = tostring(global.userData:getUserId()).."chooseHero"
        local st =  cc.UserDefault:getInstance():getStringForKey(key ,"")
        local data = {} 

        dump(global.tools:strSplit(st ,"|")  ,"global.tools:strSplit ")

        if st and  st ~="" and st~="nil" then
            for _ ,v in pairs(global.tools:strSplit(st ,"|") or {}) do 
                if v~="nil" then 
                    table.insert(data , global.heroData:getHeroDataById(tonumber(v)))
                else 
                    table.insert(data , {})
                end 
            end 
        else
            local herodata =  global.heroData:getGotHeroData()
            -- table.insert(data ,herodata[1])
            -- table.insert(data ,herodata[2])
            -- table.insert(data ,herodata[3])

            table.insert(data ,{})
            table.insert(data ,{})
            table.insert(data ,{})
        end 

        global.PKRequestID = self.data.lID
        global.panelMgr:openPanel("UIPKChoosePanel"):setData(data , 1 )

    end 

    if self.data.tagItem[1].lID <=4 then 
        if  global.propData:checkFull(self.data.tagItem[1].lID ,  self.data.tagItem[1].lCount) then 
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("resFullArena", function()
                call()
            end)
        else 
            call()
        end 
    else 
        call()
    end 

end
--CALLBACKS_FUNCS_END

return UIPKUserItem

--endregion
