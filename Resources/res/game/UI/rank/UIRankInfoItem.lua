--region UIRankInfoItem.lua
--Author : yyt
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRankInfoItem  = class("UIRankInfoItem", function() return gdisplay.newWidget() end )

function UIRankInfoItem:ctor()
    self:CreateUI()
end

function UIRankInfoItem:CreateUI()
    local root = resMgr:createWidget("rank/rank_person_node")
    self:initUI(root)
end

function UIRankInfoItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rank/rank_person_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn_bg = self.root.Node_1.btn_bg_export
    self.rank_pic = self.root.Node_1.btn_bg_export.rank_pic_export
    self.rank_num = self.root.Node_1.btn_bg_export.rank_num_export
    self.up_node = self.root.Node_1.btn_bg_export.up_node_export
    self.up_num = self.root.Node_1.btn_bg_export.up_node_export.up_num_export
    self.down_node = self.root.Node_1.btn_bg_export.down_node_export
    self.down_num = self.root.Node_1.btn_bg_export.down_node_export.down_num_export
    self.nochange_node = self.root.Node_1.btn_bg_export.nochange_node_export
    self.NodeP = self.root.Node_1.btn_bg_export.NodeP_export
    self.union_name = self.root.Node_1.btn_bg_export.NodeP_export.union_name_export
    self.person_unionFlag_node = self.root.Node_1.btn_bg_export.NodeP_export.union_name_export.person_unionFlag_node_export
    self.NodeUHave = self.root.Node_1.btn_bg_export.NodeP_export.NodeUHave_export
    self.vipNode = self.root.Node_1.btn_bg_export.NodeP_export.NodeUHave_export.vipNode_export
    self.vipbg = self.root.Node_1.btn_bg_export.NodeP_export.NodeUHave_export.vipNode_export.vipbg_export
    self.vip_lv = self.root.Node_1.btn_bg_export.NodeP_export.NodeUHave_export.vipNode_export.vip_lv_export
    self.vip_lv1 = self.root.Node_1.btn_bg_export.NodeP_export.NodeUHave_export.vipNode_export.vip_lv1_export
    self.name = self.root.Node_1.btn_bg_export.NodeP_export.NodeUHave_export.name_export
    self.portrait_node = self.root.Node_1.btn_bg_export.NodeP_export.portrait_node_export
    self.headFrame = self.root.Node_1.btn_bg_export.NodeP_export.portrait_node_export.headFrame_export
    self.NodeU = self.root.Node_1.btn_bg_export.NodeU_export
    self.unionU = self.root.Node_1.btn_bg_export.NodeU_export.unionU_export
    self.icon = self.root.Node_1.btn_bg_export.icon_export
    self.num = self.root.Node_1.btn_bg_export.num_export

--EXPORT_NODE_END
    self.btn_bg:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn_bg:setSwallowTouches(false)

end

local bgViews = {
    [1] = "rank_1st_bg.jpg",
    [2] = "rank_2nd_bg.jpg",
    [3] = "rank_3rd_bg.jpg",
    [4] = "wall_label_bg.jpg",
}
local rankViews = {
    [1] = "ui_surface_icon/rank_1st_icon.png",
    [2] = "ui_surface_icon/rank_2nd_icon.png",
    [3] = "ui_surface_icon/rank_3rd_icon.png",
}
local colors = {
    [1] = cc.c3b(255,205,69),
    [2] = cc.c3b(249,165,51),
    [3] = cc.c3b(164,110,40),
    [4] = cc.c3b(151,106,65),
}


local heroQuality = {
    [1] = cc.c3b(255,255,255),
    [2] = cc.c3b(232,67,237),
    [3] = cc.c3b(225,120,54),
}

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

-- t] - "<var>" = {
-- [LUA-print] -     "tagItem" = {
-- [LUA-print] -         1 = {
-- [LUA-print] -             "lFindID"  = 3000060
-- [LUA-print] -             "lRank"    = 1
-- [LUA-print] -             "lValue"   = 150
-- [LUA-print] -             "szParams" = {
-- [LUA-print] -                 1 = "6"
-- [LUA-print] -                 2 = "MVP"
-- [LUA-print] -                 3 = "MVP"
-- [LUA-print] -             }
-- [LUA-print] -         }
-- [LUA-print] -     }
-- [LUA-print] - }

-- t] nil  self.isActivity
-- [LUA-print] dump from: [string "res/game/UI/rank/UIRankInfoItem.lua"]:135: in function 'setData'
-- [LUA-print] - "<var>" = {
-- [LUA-print] -     "lFindID"  = 3000060
-- [LUA-print] -     "lRank"    = 1
-- [LUA-print] -     "lValue"   = 21
-- [LUA-print] -     "szParams" = {
-- [LUA-print] -         1 = "3000060"
-- [LUA-print] -         2 = "6"
-- [LUA-print] -         3 = "MVP"
-- [LUA-print] -         4 = "MVP"
-- [LUA-print] -         5 = "0"
-- [LUA-print] -     }
-- [LUA-print] - }

 

function UIRankInfoItem:setData(data)

    self.data = data

    self.num:setVisible(true)
    self.icon:setVisible(true)
    if not tolua.isnull(self.star) then
        self.star:setVisible(false)
    end
    self.headFrame:setVisible(false)
    self.name:setTextColor(cc.c3b(255,255,255))
    self.name:setPositionX(256)
    self.rank_num:setString(data.lRank)
    self.person_unionFlag_node:setVisible(true)


    local infoPanel = global.panelMgr:getPanel("UIRankInfoPanel")
    local typeId = infoPanel:getInfoData().id
    self.isActivity  = infoPanel.isActivity

    if  not self.isActivity and table.hasval({1 , 4 , 8, 13  } , typeId) then 
        self.num:setString(global.funcGame:_formatBigNumber(  data.lValue , 1 ))
    else 
        self.num:setString(data.lValue)
    end 

    local rankData  = nil 
    typeId = typeId or -1 
    
    print("infoPanel:getInfoData().id",infoPanel:getInfoData().id)
    if infoPanel.isActivity then 
        rankData = luaCfg:get_activity_rank_by(typeId)
        global.panelMgr:setTextureFor(self.icon,rankData.icon)
    else  
        rankData = luaCfg:get_rank_by(typeId)
        -- self.icon:setSpriteFrame(rankData.icon)
        if rankData then 
            global.panelMgr:setTextureFor(self.icon,rankData.icon)
        end 
    end 

    if data.lRank <= 3 and data.lRank > 0 then
        self.rank_pic:setVisible(true)
        self.rank_num:setVisible(false)
        self.rank_pic:setSpriteFrame(rankViews[data.lRank])
        -- global.panelMgr:setTextureFor(self.rank_pic,rankViews[data.lRank])
        self.btn_bg:loadTextures(bgViews[data.lRank],bgViews[data.lRank],bgViews[data.lRank],ccui.TextureResType.plistType)
        -- global.panelMgr:setTextureFor(self.btn_bg,bgViews[data.lRank])
        --self.name:setTextColor(colors[data.lRank])
    else
        self.rank_pic:setVisible(false)
        self.rank_num:setVisible(true)
        self.btn_bg:loadTextures(bgViews[4],bgViews[4],bgViews[4],ccui.TextureResType.plistType)
        -- global.panelMgr:setTextureFor(self.btn_bg,bgViews[4])
        --self.name:setTextColor(colors[4])
    end

    -- 排名升降情况
    self.nochange_node:setVisible(false)
    self.up_node:setVisible(false)
    self.down_node:setVisible(false)
    self.NodeP:setVisible(false)
    self.NodeU:setVisible(false)


    -- dump(data ,"rank data ")

    local setPersonUnionFlag =function (unionId) 

        if not self.flagSigleNode then
            self.flagSigleNode = require("game.UI.union.widget.UIUnionFlagWidget").new()
            self.flagSigleNode:CreateUI()
            self.flagSigleNode:setPosition(cc.p(177, 10))
            self.person_unionFlag_node:addChild(self.flagSigleNode)
        end
        self.flagSigleNode:setVisible(true)
        self.flagSigleNode:setData(tonumber(unionId))

    end

    if rankData.type == 1 then
        self.NodeU:setVisible(true)
        if data.szParams[2] and data.szParams[3] and data.szParams[4] and data.szParams[5] then

            if not self.flagNode then
                self.flagNode = require("game.UI.union.widget.UIUnionFlagWidget").new()
                self.flagNode:CreateUI()
                self.flagNode:setPosition(cc.p(208, 20))
                self.flagNode:setScale(0.28)
                self.NodeU:addChild(self.flagNode)                
            end
            self.flagNode:setVisible(true)
            self.flagNode:setData(tonumber(data.szParams[2]))

            local szShortName = global.unionData:getUnionShortName(data.szParams[3])
            self.unionU:setString(string.format("%s%s",szShortName,data.szParams[4]))
            self:checkRank(data.szParams[5], data.lRank)

        end 
    else

        self.NodeP:setVisible(true)

        -- 头像
        if data.szParams and data.szParams[1] then

            local head = {}
            if typeId == 8 and (not self.isActivity) then -- 英雄排行榜
                local headAll = global.luaCfg:rolehead()
                for _,v in pairs(headAll) do
                    if v.triggerId == tonumber(data.szParams[1]) then
                        head = v 
                        break
                    end
                end
            elseif typeId == 11 and  (not self.isActivity) then

                local petConfig = luaCfg:get_pet_type_by(tonumber(data.szParams[1]))
                local tempPet = global.petData:getPetConfig(tonumber(data.szParams[1]), data.lValue)
                if tempPet then 
                    head.path = petConfig["iconRank"..tempPet.growingPhase]
                end 
                head.scale = 83
            else
                head = luaCfg:get_rolehead_by(tonumber(data.szParams[1]))
                head = global.headData:convertHeadData(data,head)
            end
            global.tools:setCircleAvatar(self.portrait_node, head)
        end

        if data.szParams and data.szParams[2] then
            self.name:setString(data.szParams[2])
        end


        local setVip = function (vipLv)

            self.vipNode:setVisible(true)
            self.name:setPositionX(336)
            self.vip_lv1:setVisible(false)
            self.vip_lv:setPositionX(50)
            self.vip_lv:setString(vipLv)
            self.vipbg:setSpriteFrame(string.format("ui_surface_icon/vip_bg_%d.png", (vipLv+1)/2))
            if vipLv and vipLv >= 10 then
                self.vip_lv:setString(vipLv/10)
                self.vip_lv1:setString(vipLv%10)
                self.vip_lv1:setVisible(true)   
                self.vip_lv:setPositionX(45)
            end  
        end 

        -- vip
        typeId = typeId or 0
        if typeId == 8 or self.isActivity or typeId == 11 then 
            self.vipNode:setVisible(false)
            self.name:setPositionX(260)
        else
            if data.szParams and data.szParams[4] and tonumber(data.szParams[4]) > 0 then
                setVip(tonumber(data.szParams[4]))
            else
                self.vipNode:setVisible(false)
                self.name:setPositionX(260) 
            end 
        end

        self.union_name:setPositionX(285)
        if typeId == 8 or typeId == 11 and (not self.isActivity) then  

            if typeId == 8 then
                local heroData = luaCfg:get_hero_property_by(tonumber(data.szParams[1]))
                if heroData then 
                    self.name:setString(heroData.name)
                    self.name:setTextColor(heroQuality[heroData.Strength])
                end 
            else
                local petConfig = luaCfg:get_pet_type_by(tonumber(data.szParams[1]))
                if petConfig then
                    self.name:setString(petConfig.name)
                end
            end
 
            self.NodeUHave:setPositionY(0)
            if data.szParams and data.szParams[2] then
                local isHaveUnion = data.szParams and ((#data.szParams) > 5)
                self.union_name:setVisible(true)
                if isHaveUnion then
                    local szShortName = global.unionData:getUnionShortName(data.szParams[6] or "")
                    self.union_name:setString(szShortName .. data.szParams[2])
                    self.union_name:setPositionX(285)
                    self.person_unionFlag_node:setVisible(true)
                    setPersonUnionFlag(data.szParams[5])
                else
                    self.union_name:setPositionX(260)
                    self.person_unionFlag_node:setVisible(false)
                    self.union_name:setString(data.szParams[2])
                end
            end

        else

            if data.szParams[6] and data.szParams[7] then
                setPersonUnionFlag(data.szParams[5])
                self.NodeUHave:setPositionY(0)
                self.union_name:setVisible(true)
                local szShortName = global.unionData:getUnionShortName(data.szParams[6])
                self.union_name:setString(string.format("%s%s",szShortName,data.szParams[7]))
                self.union_name:setPositionX(285)
            else
                self.NodeUHave:setPositionY(-17)
                self.union_name:setVisible(false)
            end
        end

        self:checkRank(data.szParams[3], data.lRank)

        -- dump(data ,"sdfsdfsdfsdf")

        if self.isActivity then

            if data.szParams[5] and data.szParams[6] then
                self.NodeUHave:setPositionY(0)
                self.union_name:setVisible(true)
                local szShortName = global.unionData:getUnionShortName(data.szParams[5])
                self.union_name:setString(string.format("%s%s",szShortName,data.szParams[6]))
                self:setHeadFrame(data.szParams[7])
                self.union_name:setPositionX(285)

                setPersonUnionFlag(data.szParams[4])
            else
                self:setHeadFrame(data.szParams[4])
            end

           if data.szParams[3] and tonumber(data.szParams[3]) > 0 then 
                setVip(tonumber(data.szParams[3]))
            end 

        else 

            if data.szParams[6] and data.szParams[7] then
                self:setHeadFrame(data.szParams[8])
            else 
                self:setHeadFrame(data.szParams[5])
            end 
        end 
    end

    -- 神兽等级
    if typeId == 11 and (not self.isActivity) then 

        self.num:setVisible(false)
        self.icon:setVisible(false)

        if not self.star then
            self.star = require("game.UI.rank.UIRankInfoStar").new()
            self.btn_bg:addChild(self.star)
            self.star:setPosition(cc.p(525, 26))
        end
        self.star:setVisible(true)
        self.star:setData(data)

    end
    
end

function UIRankInfoItem:onExit( )
    -- body
    self.isActivity = nil 
end


function UIRankInfoItem:checkRank(value, rank)

    if tonumber(rank) <= 0 then return end

    value = tonumber(value)
    if value == 0 then
        self.nochange_node:setVisible(true)
    elseif  value > 0 then
        self.up_node:setVisible(true)
        self.up_num:setString(value)
    else
        self.down_node:setVisible(true)
        self.down_num:setString(math.abs(value))
    end


    if  self.isActivity or global.panelMgr:getPanel("UIRankInfoPanel"):getInfoData().id== 13 then 
        self.nochange_node:setVisible(false)
        self.up_node:setVisible(false)
        self.up_num:setVisible(false)
        self.down_node:setVisible(false)
        self.down_num:setVisible(false)
        return 
    end 

end

function UIRankInfoItem:setHeadFrame(id)

    local headInfo = global.luaCfg:get_role_frame_by(tonumber( id))

    if headInfo and headInfo.pic then
        -- print("设置头像框 //////////////")
        self.headFrame:setVisible(true)
        global.panelMgr:setTextureFor(self.headFrame,headInfo.pic)
    else 
    end 
end 



--CALLBACKS_FUNCS_END

return UIRankInfoItem

--endregion
