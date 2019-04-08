--region UILordLvUpPanel.lua
--Author : yyt
--Date   : 2016/10/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local userData = global.userData
local UIBagItem = require("game.UI.bag.UIBagItem")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UILordLvUpPanel  = class("UILordLvUpPanel", function() return gdisplay.newWidget() end )

function UILordLvUpPanel:ctor()
    self:CreateUI()
end

function UILordLvUpPanel:CreateUI()
    local root = resMgr:createWidget("common/lord_lvup")
    self:initUI(root)
end

function UILordLvUpPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "common/lord_lvup")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.PanelModel = self.root.PanelModel_export
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.lv = self.root.Node_export.bg_export.lv_export
    self.combat_num = self.root.Node_export.bg_export.combat_num_export
    self.data1_num = self.root.Node_export.bg_export.data1_mlan_8.data1_num_export
    self.data1_add = self.root.Node_export.bg_export.data1_mlan_8.data1_add_export
    self.data2_num = self.root.Node_export.bg_export.data2_mlan_8.data2_num_export
    self.data2_add = self.root.Node_export.bg_export.data2_mlan_8.data2_add_export
    self.data3_num = self.root.Node_export.bg_export.data3_mlan_8.data3_num_export
    self.data3_add = self.root.Node_export.bg_export.data3_mlan_8.data3_add_export
    self.data4_num = self.root.Node_export.bg_export.data4_mlan_8.data4_num_export
    self.data4_add = self.root.Node_export.bg_export.data4_mlan_8.data4_add_export
    self.data5_num = self.root.Node_export.bg_export.data5_mlan_12.data5_num_export
    self.data5_add = self.root.Node_export.bg_export.data5_mlan_12.data5_add_export
    self.itemLayout = self.root.Node_export.bg_export.Panel_2.itemLayout_export
    self.ScrollView = self.root.Node_export.bg_export.Panel_2.ScrollView_export
    self.close_noe = self.root.Node_export.bg_export.close_noe_export
    self.close_noe = CloseBtn.new()
    uiMgr:configNestClass(self.close_noe, self.root.Node_export.bg_export.close_noe_export)
    self.effect = self.root.Node_export.effect_export
    self.itemNode = self.root.Node_export.itemNode_export
    self.itemL = self.root.Node_export.itemNode_export.itemL_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
--EXPORT_NODE_END
    self.nodex, self.nodey = self.itemNode:getPosition()

    self.close_noe:setData(function ()
        self:exit()
    end)

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UILordLvUpPanel:setData( data )
    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_levelup")
    
    self.lv:setString(userData:getLevel())
    self:initRewardPanel()

    self.itemNode:setPosition(cc.p(self.nodex, self.nodey))
    self.effect:setVisible(true)
    self.bg:setVisible(true)
    self.PanelModel:setVisible(false)
    self.root.Panel_1:setVisible(true)
    local nodeTimeLine = resMgr:createTimeline("common/lord_lvup")
    nodeTimeLine:setTimeSpeed(1)
    self:runAction(nodeTimeLine)
    self.isStart = true 
    nodeTimeLine:setLastFrameCallFunc(function()
        self.isStart = false 
    end)
    nodeTimeLine:play("animation0", false)

    -- 上限信息
    self:initLimit()

end

function UILordLvUpPanel:initLimit()

    -- 上一等级
    local lastLv = userData:getLevel()-1
    self.lastNum1 = luaCfg:get_lord_exp_by(lastLv).energy
    self.lastNum2 = luaCfg:get_troop_max_by(lastLv).num
    self.lastNum3 = luaCfg:get_config_by(1).heroLvMax * lastLv
    self.lastNum4 = luaCfg:get_city_max_by(lastLv).max
    self.lastNum5 = luaCfg:get_lord_exp_by(lastLv).bossNum

    local curLv = userData:getLevel()
    self.num1 = luaCfg:get_lord_exp_by(curLv).energy
    self.num2 = luaCfg:get_troop_max_by(curLv).num
    self.num3 = luaCfg:get_config_by(1).heroLvMax * curLv
    self.num4 = luaCfg:get_city_max_by(curLv).max
    self.num5 = luaCfg:get_lord_exp_by(curLv).bossNum

    local dataText = {}
    for i=1,5 do
        local curNum = self["num"..i]
        local lastNum = self["lastNum"..i]
        self["data"..i.."_num"]:setString(curNum)
        if (curNum-lastNum) > 0 then
            self["data"..i.."_add"]:setVisible(true)
            self["data"..i.."_add"]:setString("+"..(curNum-lastNum))
        else
            self["data"..i.."_add"]:setVisible(false)
        end
        table.insert(dataText, curNum-lastNum)
    end

    self:cleanEffect()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function ()
        self:showTextEffect(dataText)
    end)))

end

function UILordLvUpPanel:cleanEffect()
    for i = 1,4 do
        local parentText = self["data"..i.."_add"]  
        parentText:getParent():removeChildByTag(98) 
    end
end

function UILordLvUpPanel:showTextEffect(dataText)

    for i = 1,5 do
        local addNum = dataText[i]
        if addNum > 0 then
            local text = ccui.Text:create()        
            text:setTag(98)
            local parentText = self["data"..i.."_add"]      
            
            text:setString(string.format("+%s",addNum))        
            text:setTextColor(parentText:getTextColor())       
           
            text:setAnchorPoint(cc.p(0,0.5))
            text:setPositionY(parentText:getPositionY() + 4)
            text:setPositionX(parentText:getPositionX() + parentText:getContentSize().width + 20)        
            text:setFontSize(26)
            parentText:getParent():addChild(text)
            parentText:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15,1.05),cc.DelayTime:create(0.1),cc.ScaleTo:create(0.3,0.9),cc.ScaleTo:create(0.3,1)))
            text:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),cc.EaseInOut:create(cc.MoveBy:create(1.5,cc.p(0,20)),5),cc.RemoveSelf:create()))
            text:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.FadeOut:create(0.75)))
        end        
    end 

end

function UILordLvUpPanel:initRewardPanel()
    
    self.ScrollView:removeAllChildren()
    self.itemData = {}

    local rewardData = luaCfg:get_lord_exp_by(global.userData:getLevel())
    self:scroCombatNum()
    -- self:scroSkillNum()

    local dropData = luaCfg:get_drop_by(rewardData.reward)

    local itemH = self.itemLayout:getContentSize().height
    local scroW = self.ScrollView:getContentSize().width
    self.ScrollView:setInnerContainerSize(cc.size( scroW , math.ceil(#dropData.dropItem / 4)*itemH ))

    local pY = self.ScrollView:getInnerContainerSize().height - itemH
    local i,j = 0, 0
    for _,v in pairs(dropData.dropItem) do

        local item = UIBagItem.new()
        item:setScale(0.62)
        item:setPosition(cc.p(itemH*(i%4)+10, pY - itemH*(math.floor(j/4))))
        item:setItemData(v)
        item:setTag(100+i)
        self.ScrollView:addChild(item)
        i = i + 1
        j = j + 1
    end
    self.itemData = clone(dropData.dropItem)

end

function UILordLvUpPanel:scroCombatNum()
    local rewardData = luaCfg:get_lord_exp_by(global.userData:getLevel())

    local scoreNode = cc.Node:create()
    self.root:addChild(scoreNode)

    if scoreNode:getPositionX() ~= rewardData.combat then

            scoreNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
                
                scoreNode:runAction(cc.MoveTo:create(1,cc.p(rewardData.combat,0)))
                scoreNode:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(1 / 30),cc.CallFunc:create(function ()
                
                    local numStr = scoreNode:getPositionX()
                    self.combat_num:setString(math.floor(numStr))
                end)),30))
                self.combat_num:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.075,1),cc.ScaleTo:create(0.075,0.8)),8))             
            end)))          
           
    else
        self.combat_num:setString(rewardData.combat)
    end
end

-- function UILordLvUpPanel:scroSkillNum()
--     local rewardData = luaCfg:get_lord_exp_by(global.userData:getLevel())

--     local scoreNode = cc.Node:create()
--     self.root:addChild(scoreNode)

--     if scoreNode:getPositionX() ~= rewardData.skill then

--             scoreNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
                
--                 scoreNode:runAction(cc.MoveTo:create(1,cc.p(rewardData.skill,0)))
--                 scoreNode:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(1 / 30),cc.CallFunc:create(function ()
                
--                     local numStr = scoreNode:getPositionX()
--                     self.point_num:setString(math.floor(numStr))
--                 end)),30))
--                 self.point_num:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.075,1.2),cc.ScaleTo:create(0.075,1)),8))             
--             end)))          
--     else
--         self.point_num:setString(rewardData.skill)
--     end

-- end

function UILordLvUpPanel:itemAnmation()
    
    self.effect:setVisible(false)
    self.bg:setVisible(false)
    self:itemAction()
end

function UILordLvUpPanel:itemAction()


    local itemX, itemY = self.ScrollView:getChildByTag(100):getPosition()
    local itemW = self.ScrollView:getChildByTag(100).quit:getContentSize().width

    local pX, pY = self.itemL:getPosition()

    local itemH = self.itemLayout:getContentSize().height
    local i,j = 0, 0
    for _,v in pairs(self.itemData) do
        
        local data = luaCfg:get_item_by(v[1])
        local itemBg = cc.Sprite:create()
        if not data then
            data = luaCfg:get_equipment_by(v[1])
            -- itemBg:setSpriteFrame(data.icon)
            global.panelMgr:setTextureFor(itemBg,data.icon)
        else
            -- itemBg:setSpriteFrame(data.itemIcon)
            global.panelMgr:setTextureFor(itemBg,data.itemIcon)
        end

        local item = cc.Sprite:create()
        
        item:setAnchorPoint(cc.p(0, 0))
        itemBg:setAnchorPoint(cc.p(0, 0))
        item:setScale(0.62)
        itemBg:setScale(0.62)
        item:setTag(100+i)
        itemBg:setTag(200+i)
        -- item:setSpriteFrame(string.format("ui_surface_icon/item_bg_0%d.png",data.quality))
        global.panelMgr:setTextureFor(item,string.format("icon/item/item_bg_0%d.png",data.quality))
        item:setPosition(cc.p(itemH*(i%4)+ pX , pY - itemH*(math.floor(j/4))))
        itemBg:setPosition(cc.p(itemH*(i%4)+ pX , pY - itemH*(math.floor(j/4))))

        self.itemNode:addChild(item)
        self.itemNode:addChild(itemBg)
        
        i = i + 1
        j = j + 1
    end 

    local delayT = 0.1
    local nodeX, nodeY = self.itemNode:getPosition()
    local spw = cc.Spawn:create( cc.MoveTo:create(delayT, cc.p(nodeX, nodeY+200)), cc.ScaleTo:create(delayT, 0.5)  )
    self.itemNode:runAction( cc.Sequence:create( cc.CallFunc:create(function ()
        -- self.PanelModel:setVisible(false)
        -- self.root.Panel_1:setVisible(false)
    end),  spw, 
     cc.Repeat:create(cc.Sequence:create(  cc.ScaleTo:create(delayT, 1),cc.ScaleTo:create(delayT, 0.8),cc.ScaleTo:create(delayT, 1)  ), 1), cc.DelayTime:create(delayT*0.2), cc.CallFunc:create(function ()
        
        self:itemMove()
     end )))

end

function UILordLvUpPanel:itemMove()

    for i=0,#self.itemData-1 do
   
        local item = self.itemNode:getChildByTag(100+i)
        local itemBg = self.itemNode:getChildByTag(200+i)
        self:itemMoveAction(item, i)
        self:itemMoveAction(itemBg, i)
    end
end

function UILordLvUpPanel:itemMoveAction( item, i )

    local moveSpeed =  0.08
    local pox = self.itemNode:convertToNodeSpace(cc.p(gdisplay.width/3-50, 50))
    local spa = cc.Spawn:create(  cc.MoveTo:create(moveSpeed, cc.p(pox.x, pox.y)),  cc.ScaleTo:create(moveSpeed, 0))
    item:runAction( cc.Sequence:create( cc.DelayTime:create(moveSpeed*i), spa, cc.CallFunc:create(function ()
            
            if item:getTag() == 100 then--(100+(#self.itemData-1)) then
                local nodeTimeLine = resMgr:createTimeline("common/lord_lvup")
                nodeTimeLine:setTimeSpeed(0.5)
                nodeTimeLine:play("animation1", false)
                nodeTimeLine:setLastFrameCallFunc(function()
                end)
                self:runAction(nodeTimeLine)
            end

            if #self.itemData == 1 then
                uiMgr:addSceneModel(0.5)
                gevent:call(global.gameEvent.EV_ON_UI_BAGEFFECT_PLAY, 0 )
                self:runAction( cc.Sequence:create( cc.DelayTime:create(0), cc.CallFunc:create(function () 
                    gevent:call(global.gameEvent.EV_ON_UI_BAGEFFECT_PLAY, 1 )          
                    self:exitCall() 
                end))) 
             
            else

                if i == 0 then
                    gevent:call(global.gameEvent.EV_ON_UI_BAGEFFECT_PLAY, 0 )
                elseif i ==  (#self.itemData-1) then  
                    uiMgr:addSceneModel(0.5)               
                    gevent:call(global.gameEvent.EV_ON_UI_BAGEFFECT_PLAY, 1 )
                    self:runAction( cc.Sequence:create( cc.DelayTime:create(0), cc.CallFunc:create(function ()  
                        self:exitCall() 
                    end)))  
                end
            end

            item:removeFromParent()
    end) ))
end

function UILordLvUpPanel:exit(sender, eventType)
    
    -- if self.isStart then return end 

    self:stopAllActions()
    self.PanelModel:setVisible(true)
    self.root.Panel_1:setVisible(false)

    self:itemAnmation()
end

function UILordLvUpPanel:exitCall()
    
    self.PanelModel:setVisible(false)
    self.root.Panel_1:setVisible(true)
    if self.scheduleCutNum then
        gscheduler.unscheduleGlobal(self.scheduleCutNum)
        self.scheduleCutNum = nil
    end
    global.panelMgr:closePanel("UILordLvUpPanel") 
end
--CALLBACKS_FUNCS_END

return UILordLvUpPanel

--endregion
