--region UITransferPanel.lua
--Author : zzl
--Date   : 2018/04/23
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UITransferItem1 = require("game.UI.transfer.UITransferItem1")
local UITransferItem2 = require("game.UI.transfer.UITransferItem2")
--REQUIRE_CLASS_END

local UITransferPanel  = class("UITransferPanel", function() return gdisplay.newWidget() end )

function UITransferPanel:ctor()
    self:CreateUI()
end

function UITransferPanel:CreateUI()
    local root = resMgr:createWidget("resource/res_transport_bg")
    self:initUI(root)
end

function UITransferPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_transport_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.top = self.root.top_export
    self.btn_get = self.root.bottom_bg.btn_get_export
    self.time = self.root.bottom_bg.btn_get_export.time_export
    self.res = self.root.res_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.FileNode_1 = UITransferItem1.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.ScrollView_1_export.FileNode_1)
    self.FileNode_2 = UITransferItem1.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.ScrollView_1_export.FileNode_2)
    self.FileNode_3 = UITransferItem1.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.ScrollView_1_export.FileNode_3)
    self.FileNode_4 = UITransferItem1.new()
    uiMgr:configNestClass(self.FileNode_4, self.root.ScrollView_1_export.FileNode_4)
    self.bot_node = self.root.bot_node_export
    self.res_1 = UITransferItem2.new()
    uiMgr:configNestClass(self.res_1, self.root.bot_node_export.res_1)
    self.res_2 = UITransferItem2.new()
    uiMgr:configNestClass(self.res_2, self.root.bot_node_export.res_2)
    self.res_3 = UITransferItem2.new()
    uiMgr:configNestClass(self.res_3, self.root.bot_node_export.res_3)
    self.res_4 = UITransferItem2.new()
    uiMgr:configNestClass(self.res_4, self.root.bot_node_export.res_4)
    self.get_user = self.root.bot_node_export.get_user_export
    self.rate = self.root.bot_node_export.rate_export
    self.rate_desc = self.root.bot_node_export.rate_desc_mlan_6_export
    self.rate_weight = self.root.bot_node_export.rate_weight_export

    uiMgr:addWidgetTouchHandler(self.btn_get, function(sender, eventType) self:onFreeRefresh(sender, eventType) end)
--EXPORT_NODE_END

    uiMgr:addWidgetTouchHandler(self.top.esc, function(sender, eventType) 

        global.panelMgr:closePanel("UITransferPanel")

    end)
    local ResSetControl = require("game.UI.commonUI.widget.ResSetControl")
    self.ResSetControl = ResSetControl.new(self.res)

    self:adapt()

    self.defcolor = self.rate_weight:getTextColor()
end


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UITransferPanel:adapt()
    if gdisplay.height - 128 - 470 < self.ScrollView_1:getContentSize().height then 
        self.ScrollView_1:setContentSize(cc.size(self.ScrollView_1:getContentSize().width , gdisplay.height - 128 - 510 ))
    end 
end 

function UITransferPanel:onEnter()

    self.ResSetControl:setData()
    self.ResSetControl:playAnimation(self.res)
end
 

function UITransferPanel:sliserCall(id , per)

    local count = math.floor(per * (1- self.rate_ /100 ))

    self.res_[id] = count
    self.res_origin[id] = count
    self["res_"..id]:setData(self.res_[id])

    local count = 0 
    for i= 1, #self.res_ do 
        count  = count + self.res_[i]
    end 

    self.rate_weight:setString(count .."/"..self.weight_)

    self.rate_desc:setPositionX(self.rate_weight:getPositionX() -  self.rate_weight:getContentSize().width)

    if count >  self.weight_ then 
        self.rate_weight:setTextColor(gdisplay.COLOR_RED)
        self.state = 1
    else 
        self.rate_weight:setTextColor(self.defcolor)
        self.state = 0
    end     
end

function UITransferPanel:checkCall(id , per)

    local old =  self.res_[id]
    local add = math.floor(per - self.rate_ /100 * per)
    self.res_[id]= add
    local count = 0 
    for i= 1, #self.res_ do 
        count  = count + self.res_[i]
    end 
    self.res_[id] = old 
    if count > self.weight_ then
        global.tipsMgr:showWarning("transResToMax")
    end

    return  count > self.weight_ , self:getteset(old)
end

function UITransferPanel:getteset(old)
    local t =self.weight_- self:getAll() + old
    return  math.ceil( t  / (1-self.rate_/100))
end 

function UITransferPanel:getAll()
    local count = 0 
    for i= 1, #self.res_ do 
        count  = count + self.res_[i]
    end 
    return  count
end

function UITransferPanel:onExit()

end

function UITransferPanel:setData(msg , data)

    dump(msg ,"msg->>>")
    dump(data ,"data->>>")
    self.data = data

    local cityData = global.cityData:getBuildingById(34)
    local config = global.luaCfg:get_buildings_lvup_by(34000+cityData.serverData.lGrade)

    self.res_  = {0 , 0 , 0 , 0 }
    self.res_origin  = {0 , 0 , 0 , 0 }
    self.rate_ = config.extraPara
    self.weight_ = config.extraPara1

    self.rate:setString(global.luaCfg:get_local_string(11155)..self.rate_.."%")

    for i =1 , 4 do 

        self["FileNode_"..i]:setData({id=i ,max = global.propData:getProp(i)} , function(id , per) 
            self:sliserCall(id , per)
        end)

        self["res_"..i]:setData(self.res_[i])     

        self["FileNode_"..i].icon:setSpriteFrame(global.luaCfg:get_item_by(i).itemIcon)

        self["res_"..i].icon:setSpriteFrame(global.luaCfg:get_item_by(i).itemIcon)

        -- self:sliserCall(i , 0 )
        self["FileNode_"..i].sliderControl:changeCount(0)

    end

    self.time:setString(global.funcGame.formatTimeToHMS(msg.lRoadTime))

    self.get_user:setString(global.luaCfg:get_local_string(11156,data.szName))

end



function UITransferPanel:onFreeRefresh(sender, eventType)

    if self:getAll() <= 0 then
        return global.tipsMgr:showWarning("zeroTranRes")
    end

    if self.state == 1 then 

        -- return global.tipsMgr:showWarning("超过部队运载量!")
    else
        local attackMode = 11
        local forceType = 0
        local troopId = global.troopData:getShoperTroopId()
        local tgParam = {}
        for i=1,4 do
            table.insert(tgParam,{lID=i,lValue=self["FileNode_"..i]:getCurCount()})
        end
        dump(tgParam)

        local pbmsg = {}
        pbmsg.lStartUniqueID = global.userData:getWorldCityID()
        pbmsg.lEndUniqueID = self.data.lMapID
        pbmsg.lAttackType = attackMode
        pbmsg.lTroopID = troopId
        pbmsg.tgParam = tgParam
        global.unionApi:unionTroopTransportRes(pbmsg,function(data)
            -- body
            global.funcGame:gpsWorldTroop(troopId,global.userData:getUserId())
        end)
    end

end


--CALLBACKS_FUNCS_END

return UITransferPanel

--endregion
