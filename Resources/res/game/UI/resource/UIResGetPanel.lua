--region UIResGetPanel.lua
--Author : yyt
--Date   : 2016/11/03
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local panelMgr = global.panelMgr
local propData = global.propData
local luaCfg = global.luaCfg
local resData = global.resData
local normalItemData = global.normalItemData
local UIResGetItem = require("game.UI.resource.UIResGetItem")
local textScrollControl = require("game.UI.common.UITextScrollControl")

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
--REQUIRE_CLASS_END

local UIResGetPanel  = class("UIResGetPanel", function() return gdisplay.newWidget() end )

function UIResGetPanel:ctor()
    self:CreateUI()
end

function UIResGetPanel:CreateUI()
    local root = resMgr:createWidget("resource/res_get")
    self:initUI(root)
end

function UIResGetPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_get")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.FileNode_1 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.res_icon = self.root.titleRes.res_icon_export
    self.res_name = self.root.titleRes.res_name_export
    self.numMax = self.root.titleRes.numMax_export
    self.spliteLine = self.root.titleRes.spliteLine_export
    self.num = self.root.titleRes.num_export
    self.itemLayout = self.root.itemLayout_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.topLayout = self.root.topLayout_export
    self.btn_get = self.root.bottom_bg.btn_get_export
    self.botLayout = self.root.botLayout_export
    self.top = self.root.top_export
    self.btn_rmb = self.root.top_export.btn_rmb_export
    self.rmb_num = self.root.top_export.btn_rmb_export.rmb_num_export

    uiMgr:addWidgetTouchHandler(self.btn_get, function(sender, eventType) self:otherGetWayHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.top.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)
    uiMgr:addWidgetTouchHandler(self.btn_rmb, function(sender, eventType) self:onRmbClickHandler(sender, eventType) end)
    self.curResId = 0       -- 资源id
    self.curResNum = 0      -- 当前资源
    self.maxResNum = 0      -- 资源上限

    global.funcGame:initBigNumber(self.num , 1)
    global.funcGame:initBigNumber(self.numMax , 1 )

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIResGetPanel:onEnter()
    
    self:addEventListener(global.gameEvent.EV_ON_UI_RES_NUM_UPDATE,function (event, isNotify)
        self:setRmbScroll(isNotify)
    end)

    self.FileNode_1:setData(6)
end

function UIResGetPanel:onRmbClickHandler(sender, eventType)
    --钻石点击
    global.panelMgr:openPanel("UIRechargePanel")
end

function UIResGetPanel:setData(data, isBuild)
    
    if not data then return end
    self.isBuild = isBuild
    self.data = data
    local resTypeData = resData:getResTypeById(data.resId)
    self.res_icon:setSpriteFrame(resTypeData.resGetIcon)

    local itemData = luaCfg:get_item_by(data.resId)
    self.res_name:setString(itemData.itemName)

    if data.curRes > data.maxRes then
        data.curRes = data.maxRes
    end
    if resData:getFlag(data.resId) ~= 0 then
        self:scroNum( tonumber(self.num:getString()), data.curRes, 1)
        resData:updataFlag(data.resId, 0)
    else
        self.num:setString(data.curRes)

        global.tools:adjustNodePos(self.res_icon,self.res_name)
        global.tools:adjustNodePos(self.res_name,self.num)


    end
    self:checkPosition()

    
    self.curResId = data.resId
    self.curResNum = data.curRes
    self.maxResNum = data.maxRes
    self:initScroll()
    self:playAnimation()

    self:setRmbScroll(false)
end

-- 魔晶滚动特效
function UIResGetPanel:setRmbScroll(isNotify)
    local perNum = tonumber(self.rmb_num:getString())
    local rmbNum = tonumber(global.propData:getShowProp(WCONST.ITEM.TID.DIAMOND,""))
    if isNotify and (perNum ~= rmbNum) then
        textScrollControl.startScroll(self.rmb_num, rmbNum, 1, nil, nil, nil)
        self.rmb_num:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.075,1.2),cc.ScaleTo:create(0.075,1)), 8))
    else
        self.rmb_num:setString(rmbNum)
    end
end

function UIResGetPanel:scroNum(startNum, endNum, time )

    local scoreNode = cc.Node:create()
    self.root:addChild(scoreNode)

    scoreNode:setPositionX(startNum)

    if scoreNode:getPositionX() ~= endNum then
            scoreNode:runAction(cc.Sequence:create(cc.CallFunc:create(function()
                
                scoreNode:runAction(cc.MoveTo:create(time, cc.p(endNum,0)))
                scoreNode:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(time / 30),cc.CallFunc:create(function ()
                    
                    local numStr = scoreNode:getPositionX()
                    self.num:setString(math.floor(numStr))
                    self:checkPosition()
                end)), 30))          
            end)))            
    else
        self.num:setString(endNum)
    end
end

function UIResGetPanel:checkPosition()
    
    self.res_icon:setAnchorPoint(cc.p(1, 0.5))
    self.res_name:setAnchorPoint(cc.p(1, 0.5))
    self.res_name:setPositionX(self.res_icon:getPositionX()+self.res_name:getContentSize().width)
    self.num:setPositionX(self.res_name:getPositionX()+5)
    local px = self.num:getPositionX() + self.num:getContentSize().width
    self.spliteLine:setPositionX(px)
    self.numMax:setString(self.data.maxRes)
    self.numMax:setPositionX(px+self.spliteLine:getContentSize().width)
end


function UIResGetPanel:playAnimation()
    self:stopAllActions()
    local timelineAction = resMgr:createTimeline("resource/res_get")
    timelineAction:play("animation0", true)
    self:runAction(timelineAction)
end

function UIResGetPanel:initScroll()
    
    local itemData = self:getItemData()
    self.ScrollView_1:removeAllChildren()
    
    local contentSize = gdisplay.height -  self.topLayout:getContentSize().height - self.botLayout:getContentSize().height 
    local sH = self.itemLayout:getContentSize().height 
    local sW = self.itemLayout:getContentSize().width 
    local containerSize = sH*(#itemData)
    if contentSize > containerSize then
        containerSize = contentSize
    end
    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, contentSize))
    self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, containerSize))
    local pY = containerSize - sH/2

    local i = 0
    for _,v in pairs(itemData) do
        local item = UIResGetItem.new()
        item:setPosition(cc.p(gdisplay.width/2, pY - sH*i))
        item:setData(v, self.isBuild)
        self.ScrollView_1:addChild(item)
        i = i + 1
    end
    self.ScrollView_1:jumpToTop()
end

function UIResGetPanel:getItemData()
    
    local itemAll = {}
    local resTypeData = global.resData:getResTypeById(self.data.resId)
    local itemData = luaCfg:item()
    for _,v in pairs(itemData) do
        
        if v.itemType==resTypeData.itemType and v.typeorder==resTypeData.resItemType then

            local itemBagCount = normalItemData:getItemById(v.itemId).count
            local shopItem = luaCfg:get_shop_by(v.itemId)
            if itemBagCount == 0 and shopItem == nil  then
            else
                table.insert(itemAll, v)
            end
        end
    end
    table.sort( itemAll, function(s1, s2) return s1.effectPara1 < s2.effectPara1 end )
    return itemAll
end

function UIResGetPanel:exit_call(sender, eventType)
    panelMgr:closePanelForBtn("UIResGetPanel")
    local resPanel = panelMgr:getPanel("UIResPanel")
    resPanel:setData()
end


function UIResGetPanel:otherGetWayHandler(sender, eventType)
    local wayPanel = global.panelMgr:openPanel("UIHeroNoOrder")
    wayPanel:setEnterWay(1)
    wayPanel:setData(nil,nil)
end
--CALLBACKS_FUNCS_END

return UIResGetPanel

--endregion
