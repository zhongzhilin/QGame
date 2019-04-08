--region UIUnionMemProDetails.lua
--Author : wuwx
--Date   : 2017/01/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPortraitWidget = require("game.UI.union.widget.UIPortraitWidget")
--REQUIRE_CLASS_END

local UIUnionMemProDetails  = class("UIUnionMemProDetails", function() return gdisplay.newWidget() end )

function UIUnionMemProDetails:ctor()
    
end

function UIUnionMemProDetails:CreateUI()
    local root = resMgr:createWidget("union/union_memdata_info")
    self:initUI(root)
end

function UIUnionMemProDetails:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_memdata_info")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.commonNode = self.root.Node_1.commonNode_export
    self.nameNode = self.root.Node_1.commonNode_export.nameNode_mlan_3_export
    self.name = self.root.Node_1.commonNode_export.nameNode_mlan_3_export.name_export
    self.unionNode = self.root.Node_1.commonNode_export.unionNode_export
    self.unionName = self.root.Node_1.commonNode_export.unionNode_export.union_mlan_3.unionName_export
    self.level = self.root.Node_1.commonNode_export.levle_mlan_4.level_export
    self.ranking = self.root.Node_1.commonNode_export.ranking_mlan_4.ranking_export
    self.battle = self.root.Node_1.commonNode_export.battle.battle_export
    self.kill = self.root.Node_1.commonNode_export.kill_mlan_2.kill_export
    self.ml_loss = self.root.Node_1.commonNode_export.ml_loss_mlan_2_export
    self.loss = self.root.Node_1.commonNode_export.ml_loss_mlan_2_export.loss_export
    self.title = self.root.Node_1.commonNode_export.title_mlan_4.title_export
    self.coordinate = self.root.Node_1.coordinate_export
    self.y = self.root.Node_1.coordinate_export.y_export
    self.x = self.root.Node_1.coordinate_export.x_export
    self.go_target = self.root.Node_1.coordinate_export.go_target_export
    self.friend1 = self.root.Node_1.friend1_export
    self.friend2 = self.root.Node_1.friend2_export
    self.equiment_node = self.root.Node_1.equiment_node_export
    self.equipment_bg1 = self.root.Node_1.equiment_node_export.equipment_bg1_export
    self.quality_1 = self.root.Node_1.equiment_node_export.equipment_bg1_export.quality_1_export
    self.back_bg_1 = self.root.Node_1.equiment_node_export.equipment_bg1_export.back_bg_1_export
    self.icon1 = self.root.Node_1.equiment_node_export.equipment_bg1_export.iconParent.icon1_export
    self.equipment_bg2 = self.root.Node_1.equiment_node_export.equipment_bg2_export
    self.quality_2 = self.root.Node_1.equiment_node_export.equipment_bg2_export.quality_2_export
    self.back_bg_2 = self.root.Node_1.equiment_node_export.equipment_bg2_export.back_bg_2_export
    self.icon2 = self.root.Node_1.equiment_node_export.equipment_bg2_export.iconParent.icon2_export
    self.equipment_bg3 = self.root.Node_1.equiment_node_export.equipment_bg3_export
    self.quality_3 = self.root.Node_1.equiment_node_export.equipment_bg3_export.quality_3_export
    self.back_bg_3 = self.root.Node_1.equiment_node_export.equipment_bg3_export.back_bg_3_export
    self.icon3 = self.root.Node_1.equiment_node_export.equipment_bg3_export.iconParent.icon3_export
    self.equipment_bg4 = self.root.Node_1.equiment_node_export.equipment_bg4_export
    self.quality_4 = self.root.Node_1.equiment_node_export.equipment_bg4_export.quality_4_export
    self.back_bg_4 = self.root.Node_1.equiment_node_export.equipment_bg4_export.back_bg_4_export
    self.icon4 = self.root.Node_1.equiment_node_export.equipment_bg4_export.iconParent.icon4_export
    self.equipment_bg5 = self.root.Node_1.equiment_node_export.equipment_bg5_export
    self.quality_5 = self.root.Node_1.equiment_node_export.equipment_bg5_export.quality_5_export
    self.back_bg_5 = self.root.Node_1.equiment_node_export.equipment_bg5_export.back_bg_5_export
    self.icon5 = self.root.Node_1.equiment_node_export.equipment_bg5_export.iconParent.icon5_export
    self.equipment_bg6 = self.root.Node_1.equiment_node_export.equipment_bg6_export
    self.quality_6 = self.root.Node_1.equiment_node_export.equipment_bg6_export.quality_6_export
    self.back_bg_6 = self.root.Node_1.equiment_node_export.equipment_bg6_export.back_bg_6_export
    self.icon6 = self.root.Node_1.equiment_node_export.equipment_bg6_export.iconParent.icon6_export
    self.portrait = UIPortraitWidget.new()
    uiMgr:configNestClass(self.portrait, self.root.portrait)
    self.contentLayout = self.root.contentLayout_export
    self.itemLayout = self.root.itemLayout_export
    self.node_tableView = self.root.node_tableView_export

    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:go_target_handler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.friend1, function(sender, eventType) self:addFriendHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.friend2, function(sender, eventType) self:deleteFriendHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.portrait:setCascadeOpacityEnabled(true)

    local UITableView = require("game.UI.common.UITableView")
    local UIUnionShareBRCell = require("game.UI.union.list.UIUnionShareBRCell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize())
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionShareBRCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
    self.param = 0

    self.lossMlan = self.ml_loss
    self.lossMlanPosX = self.lossMlan:getPositionX()

end

function UIUnionMemProDetails:setParam(param) 
   self.param = param
end

function UIUnionMemProDetails:setData(data,union,allData)
    self.data = data
    self.tableView:setData({})

    local unionInfo = {}
    if data then 
        unionInfo = data
    else
        unionInfo = union or global.unionData:getInUnion()
    end

    data = data or {}

    if self.param == 1 then
        self.unionNode:setVisible(true)
        self.nameNode:setPositionY(94)
        self.name:setString(data.szName or "-")
        if data.szAllyName and data.szAllyShortName then
            self.unionName:setString(string.format("【%s】%s",data.szAllyShortName, data.szAllyName))
        else
            self.unionName:setString("-")
        end
    else
        self.unionNode:setVisible(false)
        self.nameNode:setPositionY(60)
        if (data.lAllyID and data.lAllyID == 0) or (allData and allData.bindId >= 6) then
            self.name:setString(data.szName or "-")
        else
            if unionInfo.szAllyShortName and unionInfo.szAllyShortName ~= "" then
                self.name:setString(string.format("【%s】%s",unionInfo.szAllyShortName, data.szName or "-"))
            elseif unionInfo.szShortName and unionInfo.szShortName ~= "" then
                self.name:setString(string.format("【%s】%s",unionInfo.szShortName, data.szName or "-"))
            else
                self.name:setString(data.szName or "-")
            end
        end
    end

    self.commonNode:setPositionY(60)
    
    if data.lPosX == 0 or data.lPosX == nil then        
        self.coordinate:setVisible(false)
        self.commonNode:setPositionY(40)
    else
        if union and union.lID and global.unionData:isMineUnion(union.lID) and global.unionData:isHadPower(18) then            
            self.coordinate:setVisible(true)
        else            
            if data.lAllyID and global.unionData:isMineUnion(data.lAllyID) and global.unionData:isHadPower(18) then
                self.coordinate:setVisible(true)
            else
                self.coordinate:setVisible(false)
                self.commonNode:setPositionY(40)
            end            
        end
    end
    if data.lPosX then
        local worldConst = require("game.UI.world.utils.WorldConst")
        local pos = worldConst:converPix2Location(cc.p(data.lPosX, data.lPosY))
        self.x:setString(pos.x)
        self.y:setString(pos.y)
    end

    self.level:setString(data.lCityLevel)
    if data.lPowerRank and data.lPowerRank ~= -1 then
        self.ranking:setString(data.lPowerRank)
    else
        self.ranking:setString("-")
    end
    self.battle:setString(data.lPower)

    self.kill:setString(data.lKilled or "-")
    self.loss:setString(data.lDied or "-")
    self.portrait:setData(data.lFace,data.lBackID,data)

    if data.lExploit == 0 then 
        data.lExploit = #global.luaCfg:exploit_lv()
    end 
    
    self.title:setString(global.luaCfg:get_exploit_lv_by(data.lExploit or 1).exploitName)

--润稿翻译处理 张亮
    self.lossMlan:setPositionX(self.lossMlanPosX + 20)
    global.tools:adjustNodePosForFather(self.name:getParent(),self.name)
    global.tools:adjustNodePosForFather(self.kill:getParent(),self.kill)
    global.tools:adjustNodePosForFather(self.loss:getParent(),self.loss)
    global.tools:adjustNodePosForFather(self.level:getParent(),self.level)
    global.tools:adjustNodePosForFather(self.loss:getParent(),self.loss)   
    global.tools:adjustNodePosForFather(self.ranking:getParent(),self.ranking)
    global.tools:adjustNodePosForFather(self.unionName:getParent(),self.unionName)
    global.tools:adjustNodePosForFather(self.title:getParent(),self.title)

    
    
    self:refresh()
    self:refershFriendShip(data.lFriend)
    self:setLordEquip()
end

function UIUnionMemProDetails:setLordEquip()

    self.data.tgEquip = self.data.tgEquip or {}
    local configData = {}
    for _,v in ipairs(self.data.tgEquip) do
        table.insert(configData, global.luaCfg:get_lord_equip_by(v.lGID))
    end

    local getEquip = function (lkind)
        for k,v in pairs(configData) do
            if v.type == lkind then
                return v
            end
        end
        return nil
    end

    for i=1,6 do

        local bg = self["equipment_bg"..i]
        local icon = self["icon"..i]
        local quality= self["quality_"..i]
        local backbg = self["back_bg_"..i]
        icon:setTouchEnabled(false)
        icon:setVisible(false)
        quality:setVisible(false)
        backbg:setVisible(true)
        bg["Sprite_"..i]:setVisible(true)

        local confData = getEquip(i)
        if confData then
            quality:setVisible(true)
            backbg:setVisible(false)
            icon:setVisible(true)
            bg["Sprite_"..i]:setVisible(false)
            global.panelMgr:setTextureFor(quality,string.format("icon/item/item_bg_0%d.png",confData.quality))
            global.panelMgr:setTextureFor(icon,confData.icon)              
        end 
    end


end

function UIUnionMemProDetails:refershFriendShip(lFriend)

    self.friend1:setVisible(false)
    self.friend2:setVisible(false)
    if not lFriend or (self.param == 2) then return end
    -- 是否是好友
    local curUserId = self.data.lID or self.data.lUserID
    if curUserId ~= global.userData:getUserId() then
        if lFriend and lFriend == 1 then
            self.friend2:setVisible(true)
        else
            self.friend1:setVisible(true)
        end
    end
end

-- 好友监听
function UIUnionMemProDetails:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_FRIEND_UPDATE, function()
        -- 获取用户详细信息          
        global.chatApi:getUserInfo(function(msg)
            msg.tgInfo = msg.tgInfo or {}
            self:refershFriendShip(msg.tgInfo[1].lFriend)
        end, {self.data.lID or self.data.lUserID})
    end)
end

function UIUnionMemProDetails:refresh()

    if not self.data then 
        return 
    end 

    local function callback(msg)
        if not  tolua.isnull(self.tableView) then 
            self.tableView:setData(msg.tagSpl)
        end 
    end
    global.unionApi:getFightShareList(callback,self.data.lID or self.data.lUserID)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIUnionMemProDetails:onMemHandler(sender, eventType)
    --点击成员头像
end

function UIUnionMemProDetails:go_target_handler(sender, eventType)
    if self.data and self.data.lMapID then
        global.funcGame:gpsWorldCity(self.data.lMapID)
    end
end

function UIUnionMemProDetails:addFriendHandler(sender, eventType)

    global.unionApi:getFriendList(function (msg)
        gevent:call(global.gameEvent.EV_ON_FRIEND_UPDATE)
    end, 2, self.data.lID or self.data.lUserID)
end

function UIUnionMemProDetails:deleteFriendHandler(sender, eventType)
    
    local panel = global.panelMgr:openPanel("UIPromptPanel")
    panel:setData("Friend09", function()
        global.unionApi:getFriendList(function (msg)
            global.tipsMgr:showWarning("Friend10")
            gevent:call(global.gameEvent.EV_ON_FRIEND_UPDATE)
        end, 3, self.data.lID or self.data.lUserID)
    end, self.name:getString())
end
--CALLBACKS_FUNCS_END

return UIUnionMemProDetails

--endregion
