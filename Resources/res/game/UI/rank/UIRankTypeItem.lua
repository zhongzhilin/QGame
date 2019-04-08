--region UIRankTypeItem.lua
--Author : yyt
--Date   : 2017/02/15
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIRankTypeItem  = class("UIRankTypeItem", function() return gdisplay.newWidget() end )

function UIRankTypeItem:ctor()
    self:CreateUI()
end

function UIRankTypeItem:CreateUI()
    local root = resMgr:createWidget("rank/rank_type_node")
    self:initUI(root)
end

function UIRankTypeItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "rank/rank_type_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn = self.root.btn_export
    self.type = self.root.btn_export.type_export
    self.ownNode = self.root.btn_export.ownNode_export
    self.chatHeadNode = self.root.btn_export.ownNode_export.chatHeadNode_export
    self.headFrame = self.root.btn_export.ownNode_export.chatHeadNode_export.headFrame_export
    self.flagNode = self.root.btn_export.flagNode_export
    self.unionFlag = self.root.btn_export.flagNode_export.unionFlag_export
    self.unionFlagNation = self.root.btn_export.flagNode_export.unionFlagNation_export
    self.name = self.root.btn_export.name_export

--EXPORT_NODE_END
    self.btn:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn:setSwallowTouches(false)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIRankTypeItem:setData(data)

    dump(data ,"fuck")
    self.type:setString(data.name)
    self.btn.crown:setVisible(true)
    self.headFrame:setVisible(false)

    if data.serverData then

        self.ownNode:setVisible(false)
        self.flagNode:setVisible(false)
        -- 澶村儚
        if data.type == 1 then
            self.flagNode:setVisible(true)
            local flagData = global.unionData:getUnionFlagData(tonumber(data.serverData.lFlagID))
            -- self.unionFlag:setSpriteFrame(flagData.flag)
            global.panelMgr:setTextureFor(self.unionFlag,flagData.flag)
            if flagData.national ~= "" then
                self.unionFlagNation:setVisible(true)
                global.panelMgr:setTextureFor(self.unionFlagNation,flagData.national)
            else
                self.unionFlagNation:setVisible(false)
            end

            local szShortName = global.unionData:getUnionShortName(data.serverData.szValue)
            self.name:setString(string.format("%s%s",szShortName,data.serverData.szValueEx))
        else
            self.ownNode:setVisible(true)
            local head = {}
            if data.id == 8 then -- 英雄排行榜
                local headAll = luaCfg:rolehead()
                for _,v in pairs(headAll) do
                    if v.triggerId == data.serverData.lFlagID then
                        head = v 
                        break
                    end
                end
            elseif data.id == 11 then -- 神兽排行榜

                local petConfig = luaCfg:get_pet_type_by(data.serverData.lFlagID)
                local tempPet = global.petData:getPetConfig(data.serverData.lFlagID, data.serverData.lBackID)
                head.path = petConfig["iconRank"..tempPet.growingPhase]
                head.scale = 85

            else
                head = luaCfg:get_rolehead_by(data.serverData.lFlagID)
                head = global.headData:convertHeadData(data.serverData,head)
            end

            if  head.path  then 
                global.tools:setCircleAvatar(self.chatHeadNode, head)
            end 

            self.name:setString(" "..data.serverData.szValue)

            if data.serverData.lBackID then 
                self:setHeadFrame(data.serverData.lBackID)
            end 
        end
    else

        self.btn.crown:setVisible(false)
        self.ownNode:setVisible(false)
        self.flagNode:setVisible(false)
        self.name:setString("-")
    end
end


function UIRankTypeItem:setHeadFrame(id)

    local headInfo = global.luaCfg:get_role_frame_by(tonumber( id))

    if headInfo and headInfo.pic then
        -- print("设置头像框 //////////////")
        self.headFrame:setVisible(true)
        global.panelMgr:setTextureFor(self.headFrame,headInfo.pic)
    else 
    end 
end 

--CALLBACKS_FUNCS_END

return UIRankTypeItem

--endregion
