--region UIEquipInfo.lua
--Author : untory
--Date   : 2017/02/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIEquipBaseIcon = require("game.UI.equip.UIEquipBaseIcon")
local UIEquipInfoNode1 = require("game.UI.equip.UIEquipInfoNode1")
local UIEquipInfoNode2 = require("game.UI.equip.UIEquipInfoNode2")
--REQUIRE_CLASS_END

local UIEquipInfo  = class("UIEquipInfo", function() return gdisplay.newWidget() end )

function UIEquipInfo:ctor(isNeedCreate)
    
    if isNeedCreate then
        self:CreateUI()
    end
    
    self.panel = global.panelMgr:getTopPanel()
end

function UIEquipInfo:CreateUI()
    local root = resMgr:createWidget("equip/equip_info_node")
    self:initUI(root)
end

function UIEquipInfo:initUI(root)

    -- print('UIEquipInfo init UI ')

    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "equip/equip_info_node")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.board = self.root.board_export
    self.node1 = self.root.board_export.node1_export
    self.dir = self.root.board_export.node1_export.dir_export
    self.equip_name = self.root.board_export.node1_export.equip_name_export
    self.plus_icon = self.root.board_export.node1_export.plus_icon_export
    self.strengthen_lv = self.root.board_export.node1_export.plus_icon_export.strengthen_lv_export
    self.combat_num = self.root.board_export.node1_export.combat_mlan_9.combat_num_export
    self.type = self.root.board_export.node1_export.type_mlan_9.type_export
    self.lv_num = self.root.board_export.node1_export.lv_mlan_9.lv_num_export
    self.suit_name = self.root.board_export.node1_export.suit_name_export
    self.baseIcon = UIEquipBaseIcon.new()
    uiMgr:configNestClass(self.baseIcon, self.root.board_export.node1_export.baseIcon)
    self.close_btn = self.root.board_export.node1_export.close_btn_export
    self.put = self.root.board_export.node1_export.put_export
    self.wear = self.root.board_export.node1_export.put_export.wear_mlan_6_export
    self.strengthen = self.root.board_export.node1_export.strengthen_export
    self.share = self.root.board_export.node1_export.share_export
    self.node2 = self.root.board_export.node2_export
    self.infoNode1 = self.root.board_export.node2_export.infoNode1_export
    self.infoNode1 = UIEquipInfoNode1.new()
    uiMgr:configNestClass(self.infoNode1, self.root.board_export.node2_export.infoNode1_export)
    self.infoNode2 = self.root.board_export.node2_export.infoNode2_export
    self.infoNode2 = UIEquipInfoNode2.new()
    uiMgr:configNestClass(self.infoNode2, self.root.board_export.node2_export.infoNode2_export)
    self.desc = self.root.board_export.node2_export.desc_export

    uiMgr:addWidgetTouchHandler(self.close_btn, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.put, function(sender, eventType) self:put_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.strengthen, function(sender, eventType) self:strengthen_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.share, function(sender, eventType) self:share_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.board_export.open_call, function(sender, eventType) self:open_call(sender, eventType) end)
--EXPORT_NODE_END
        
    self.old_ps_node =  cc.Node:create()
    self:addChild(self.old_ps_node)
    self.old_ps_node:setPosition(self.put:getPosition())

end

function UIEquipInfo:setData(data,heroId)

    -- dump(data,'...equipnfo data')

    if not data then return end
    self.data = data
    self.heroId = heroId or self.panel.heroId

    local buttom_height = 140

    local equipData = data.confData
    local kind = equipData.kind
    if kind == 0 then
        self.suit_name:setVisible(false)
    else
        self.suit_name:setVisible(true)
        local equip = luaCfg:get_equipment_suit_by(kind)
        if not equip then 
            equip  = luaCfg:get_lord_equip_by(kind)
        end 
        equip = equip or {} 
        self.suit_name:setString(equip.suitName or "")
    end
    self.equip_name:setTextColor(cc.c3b(unpack(luaCfg:get_quality_color_by(data.confData.quality).rgb)))
    self.equip_name:enableOutline(self.equip_name:getTextColor(),1)
    self.baseIcon:setData(equipData)
    self.equip_name:setString(equipData.name)    
    self.combat_num:setString(data.lCombat)    
    self.type:setString(luaCfg:get_local_string(10377 + equipData.type))
    self.lv_num:setString(equipData.lv)
    self.infoNode1:setData(data)
    self.infoNode2:setData(data,heroId,self.isLongTips)
    self.infoNode2:setPositionY(buttom_height)
    self.infoNode1:setPositionY(self.infoNode2:getHeight() + self.infoNode2:getPositionY())
    self.desc:setString(equipData.des)    
    if data.lStronglv > 0 then
        self.strengthen_lv:setString(data.lStronglv)
        self.strengthen_lv:setVisible(true)
        self.plus_icon:setVisible(true)
    else
        self.strengthen_lv:setVisible(false)
        self.plus_icon:setVisible(false)
    end

    self.plus_icon:setPositionX(self.equip_name:getContentSize().width * 0.58 + 20 + self.equip_name:getPositionX())

    self.openHeight = self.infoNode2:getHeight() + self.infoNode1:getHeight() + buttom_height

    self.dir:setVisible(false)


    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.type:getParent(),self.type)
    global.tools:adjustNodePosForFather(self.combat_num:getParent(),self.combat_num)
    global.tools:adjustNodePosForFather(self.lv_num:getParent(),self.lv_num)

end

function UIEquipInfo:setData_longTipsModal(equipId)
    local confData = luaCfg:get_equipment_by(equipId)
    local tmpData = {lCombat = confData.baseCombat,confData = confData,lID = 0,_tmpData = {isInBagPanel = true,isShowLv = true},lGID = equipId,lStronglv = 0,tgAttr = global.equipData:colServerAtt(0,equipId)}
    self.isLongTips = true
    self:setData(tmpData,0,true,true)
    self:setButton(false,'',true)
    self.close_btn:setVisible(false)
end

function UIEquipInfo:setButton(isShow,str,isSinglePanel,callback)

    self.put:setVisible(isShow)
    
    if isShow then
        self.wear:setString(luaCfg:get_local_string(str))
    end    

    self.close_btn:setVisible(isSinglePanel)
    if isSinglePanel then
        self:changeToOpen(true)
        self.board:setTouchEnabled(true)       
    else
        self:changeToClose()

        self.put:setEnabled(self.data._tmpData.isCanSuit)
        self.lv_num:setTextColor(cc.c3b(255,185,34))
        if self.data._tmpData.isCanSuit == false then

            if self.data._tmpData.cannotRes == 1 then

                self.lv_num:setTextColor(cc.c3b(180,29,11))        
            end
        end

        self:initBoard()
    end        

    self.callback = callback

    self.strengthen:setVisible(global.equipData:isEquipGot(self.data.lID) and  global.equipData:checkCanStrong(self.data.lID))
    self.share:setVisible(global.equipData:isEquipGot(self.data.lID))

    self:adjustps()
end


function UIEquipInfo:adjustps()

    if  not self.strengthen:isVisible() then 

        if self.put:isVisible() then 

            self.put:setPosition(self.strengthen:getPosition())    
        end 
    else 
        self.put:setPosition(self.old_ps_node:getPosition())
    end 
end 


function UIEquipInfo:setDirIndex(index)
    
    local offsetX = index * 170 + 24
    self.dir:stopAllActions()
    self.dir:runAction(cc.EaseInOut:create(cc.MoveTo:create(0.3,cc.p(offsetX + 62,self.dir:getPositionY())),1.5))
    self.dir:setVisible(true)
end

function UIEquipInfo:showUse()

    self.root:setOpacity(0)
    self.root:stopAllActions()

    local action = cc.Sequence:create(cc.FadeIn:create(0.4))
    action:setTag(213)
    self.root:runAction(action)

    self.baseIcon.root:setOpacity(0)
    self.baseIcon.root:stopAllActions()
    self.baseIcon.root:runAction(cc.Sequence:create(cc.FadeIn:create(0.4)))
end

function UIEquipInfo:getIsInTouch()
    
    local res = self.isInTouch
    self.isInTouch = false
    return res
end

function UIEquipInfo:checkOutScreen()
        
    if not self.tb then return end

    local y = self:convertToWorldSpace(cc.p(0,0)).y
    if y < 0 then

        local off = self.tb:getContentOffset()
        local tbHeight = self.tb:getViewSize().height
        local moveHeight = self:getContentHeigth() + 170

        print("tbHeight",tbHeight,"moveHeight",moveHeight)

        if moveHeight > tbHeight then

            off.y = off.y - y + (tbHeight - moveHeight)
            self.tb:setContentOffset(off, true)
        else
            
            off.y = off.y - y
            self.tb:setContentOffset(off, true)  
        end     
    end
end

function UIEquipInfo:initBoard()
    
    local widget = self.board

    local onTouchHandler = function(sender, eventType)

        local callNextStep = function(fun)
            
            self:runAction(cc.CallFunc:create(fun))
        end

        if eventType == ccui.TouchEventType.ended then

            callNextStep(function()
                
                print("self.isInTouch = false")
                self.isInTouch = false
            end)
        elseif eventType == ccui.TouchEventType.began then

            print("self.isInTouch = true")
            self.isInTouch = true
        elseif eventType == ccui.TouchEventType.canceled then

            callNextStep(function()
                
                print("self.isInTouch = false")
                self.isInTouch = false
            end)
        end
    end

    self.board:setTouchEnabled(true)
    self.board:setSwallowTouches(false)
    widget:addTouchEventListener(onTouchHandler)
end

function UIEquipInfo:changeToClose()
   
    self.root.board_export.open_call:setVisible(true)

    self.board:setContentSize(cc.size(672,400))
    self.node2:setVisible(false)
    self.node1:setPosition(cc.p(0,0))
end

function UIEquipInfo:changeToOpen(isNotCheck)

    local dir_btn_height = 30

    self.openHeight = self.openHeight or 0 

    self.board:setContentSize(cc.size(672,400 + self.openHeight - dir_btn_height))
    self.node2:setVisible(true)
    self.node1:setPosition(cc.p(0,self.openHeight - dir_btn_height))

    if not isNotCheck then        
        if self.panel and self.panel.flushInfoPanel then -- protect  
            self.panel:flushInfoPanel()
        end 
        self:checkOutScreen()
    end    

    self.root.board_export.open_call:setVisible(false)
end

function UIEquipInfo:getContentHeigth()
    
    return self.board:getContentSize().height + 23
end

function UIEquipInfo:onEnter()
    
    self:addEventListener(global.gameEvent.EV_ON_UI_EQUIP_FLUSH,function()
        
        if not self.data then return end 
        self:setData(global.equipData:getEquipById(self.data.lID),self.heroId)        
    end)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIEquipInfo:put_call(sender, eventType)

    local tmpHeroData = clone(global.panelMgr:getPanel("UIHeroPanel").chooseHeroData)

    if self.callback then self.callback(self.data) end

    -- if self.isDown then

    --     global.itemApi:swapEquip(1,self.data.lID,self.data.lHeroID,self.data.confData.type,function(msg)
        
    --         global.panelMgr:getPanel("UIHeroPanel"):showEquipEffect(self.data,tmpHeroData,msg.tgHero[1],true)

    --         global.panelMgr:closePanel("UIEquipPutDown")
    --         global.heroData:updateVipHero(msg.tgHero[1])
    --     end)
    -- else
    
    --     global.itemApi:swapEquip(0,self.data.lID,self.panel.heroId,self.data.confData.type,function(msg)
        
    --         global.panelMgr:getPanel("UIHeroPanel"):showEquipEffect(self.data,tmpHeroData,msg.tgHero[1])

    --         global.panelMgr:closePanel("UIEquipPanel")
    --         global.heroData:updateVipHero(msg.tgHero[1])            
    --     end)
    -- end    
end

function UIEquipInfo:open_call(sender, eventType)

    if self.root:getActionByTag(213) then
        return
    end

    self:changeToOpen()    
end

function UIEquipInfo:exit_call(sender, eventType)

    global.panelMgr:closePanel("UIEquipPutDown")
end

function UIEquipInfo:strengthen_call(sender, eventType)    

    local gotoData = self.data

    if global.panelMgr:getTopPanelName() == "UIEquipPanel" then

        global.panelMgr:closePanel("UIEquipPanel")
    end

    local buildInfo = global.cityData:getTopLevelBuild(20)
    if buildInfo then
        global.panelMgr:openPanel("UIEquipStrongPanel"):setEquipData(gotoData)
    else
        global.tipsMgr:showWarning("NeedSmithy")
    end         
end

function UIEquipInfo:share_call(sender, eventType)

    local tagSpl = {}
    tagSpl.lKey = 2
    tagSpl.lValue = 0
    tagSpl.szParam = ""--vardump(self.data)
    local sendData = clone(self.data) or {} 
    sendData.confData = nil
    tagSpl.szInfo = vardump(sendData,"test")--global.mailData:getCurMailTitleStr()
    tagSpl.lTime = 0

    global.panelMgr:openPanel("UISharePanel"):setData(tagSpl)        
end
--CALLBACKS_FUNCS_END

return UIEquipInfo

--endregion
