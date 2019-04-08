--region UIPKResultPanel.lua
--Author : zzl
--Date   : 2018/02/08
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIfail = require("game.UI.replay.view.UIfail")
--REQUIRE_CLASS_END

local UIPKResultPanel  = class("UIPKResultPanel", function() return gdisplay.newWidget() end )

local UIfail = require("game.UI.replay.view.UIfail")
local UIwin = require("game.UI.replay.view.UIwin")

function UIPKResultPanel:ctor()
    self:CreateUI()
end

function UIPKResultPanel:CreateUI()
    local root = resMgr:createWidget("player_kill/player/pk_rsult")
    self:initUI(root)
end

function UIPKResultPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/player/pk_rsult")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.bg = self.root.Node_export.bg_export
    self.Button_confirm = self.root.Node_export.bg_export.Button_confirm_export
    self.info_node = self.root.Node_export.bg_export.info_node_export
    self.up_icon = self.root.Node_export.bg_export.info_node_export.up_icon_export
    self.up_num = self.root.Node_export.bg_export.info_node_export.up_icon_export.up_num_export
    self.now = self.root.Node_export.bg_export.info_node_export.day_times_mlan_8.now_export
    self.old = self.root.Node_export.bg_export.info_node_export.old_mlan_10.old_export
    self.reword_node = self.root.Node_export.bg_export.reword_node_export
    self.count_text = self.root.Node_export.bg_export.reword_node_export.Node_1.count_text_export
    self.quit = self.root.Node_export.bg_export.reword_node_export.Node_1.quit_export
    self.icon = self.root.Node_export.bg_export.reword_node_export.Node_1.icon_export
    self.item_name = self.root.Node_export.bg_export.reword_node_export.Node_1.item_name_export
    self.rank_reword = self.root.Node_export.bg_export.rank_reword_mlan_4_export
    self.diaCurNum = self.root.Node_export.bg_export.rank_reword_mlan_4_export.diaCurNum_export
    self.diamond_icon_sprite = self.root.Node_export.bg_export.rank_reword_mlan_4_export.diamond_icon_sprite_export
    self.FileNode_1 = UIfail.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.Button_confirm, function(sender, eventType) self:confirm_click(sender, eventType) end)
--EXPORT_NODE_END

    self.old_contsize  = self.bg:getContentSize()

end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIPKResultPanel:onEnter()

    if self.result_effect and not tolua.isnull(self.result_effect) then 

        self.result_effect:removeFromParent()
    end 

end 


local panel  = global.panelMgr:getPanel("UIPKPanel")


function UIPKResultPanel:setData(data)

    self.reword_node:setVisible(false)
    self.rank_reword:setVisible(false)
   self.up_icon:setVisible(false)


    self.data = data 

    dump(self.data ,"self.data")

    data.szParam = data.szParam or "auto-create|EudeJoyse|4|1|6+50"

    local st = global.tools:strSplit(data.szParam, '|') or {}

    self.old:setString(st[4] or "")

    if  global.pkdata  then 
        self.now:setString(global.pkdata.lRank)
    end 


    local havemojing = st[5] ~=""

    local y = 50


    if self.data.lResult[1] == 1 then --

       self.up_icon:setVisible(true)

        if data.lAtkRank > data.lDefRank then 

            self.up_num:setString(data.lAtkRank -  data.lDefRank)
        else 

            self.up_num:setString("0")
        end 

        local setItem = function ()
            self.count_text:setString("x"..self.data.tagItem[1].lCount)
            local itemData =global.luaCfg:get_local_item_by(self.data.tagItem[1].lID)
            -- global.panelMgr:setTextureForAsync(self.icon,itemData.itemIcon or itemData.icon, true)
            self.icon:setSpriteFrame(global.luaCfg:get_local_item_by(self.data.tagItem[1].lID).itemIcon)
            global.panelMgr:setTextureForAsync(self.quit,string.format("icon/item/item_bg_0%d.png",itemData.quality),true)

            self.icon:setScale(0.5)        
            if self.data.tagItem[1].lID <= 4 then 
                self.icon:setScale(1.2)        
            end 
        end 

        if self.data.tagItem and havemojing then 

            self.reword_node:setVisible(true)
            self.rank_reword:setVisible(true)
            self.bg:setContentSize((cc.size(self.old_contsize.width, 400)))
            self.info_node:setPositionY(260.32)
            self.reword_node:setPositionY(43.67)
            self.rank_reword:setPositionY(180)
            self.diaCurNum:setString(global.tools:strSplit(data.szParam, '+')[2])
            
            setItem()

        elseif self.data.tagItem then 
            
            self.bg:setContentSize((cc.size(self.old_contsize.width, 300)))
            self.info_node:setPositionY(190)
            self.reword_node:setVisible(true)
            self.reword_node:setPositionY(42)
            setItem()

        elseif havemojing then 

            self.rank_reword:setVisible(true)
            self.info_node:setPositionY(190)
            self.rank_reword:setPositionY(100)

            self.diaCurNum:setString(global.tools:strSplit(data.szParam, '+')[2])

        else 
            self.bg:setContentSize((cc.size(self.old_contsize.width, 300)))
            self.info_node:setPositionY(self.bg:getContentSize().height/2)

        end 

    else


          self.bg:setContentSize((cc.size(self.old_contsize.width, 300)))
          self.info_node:setPositionY(self.bg:getContentSize().height/2)

    end 


    global.tools:adjustNodePosForFather(self.now:getParent() , self.now)
    global.tools:adjustNodePosForFather(self.old:getParent() , self.old)


    self.up_icon:setPositionX(self.now:getParent():getContentSize().width + self.now:getContentSize().width + 30)

    self:resultEffect(y)
end     


function UIPKResultPanel:resultEffect(y)

    if self.data.lResult[1] == 1 then 

       self.result_effect= UIwin.new()

        global.delayCallFunc(function()
                 self.timer=gevent:call(gsound.EV_ON_PLAYSOUND, "Player_VS")
        end, 0 , 0.2)
        
    else
        self.result_effect = UIfail.new()

    end 

    self.result_effect:setScale(1.2)

    self.result_effect:setPosition(cc.p(-69.37 , y))

    self.Node:addChild(self.result_effect)

    self.result_effect:showAction()

end 


function UIPKResultPanel:getRank(data)
    
    if self:getResult(data) == 0 then --赢了

        if data.lAtkRank > data.lDefRank then 

            return data.lDefRank
        else 
            return data.lAtkRank
        end 
    else 

        return data.lAtkRank
    end     
end 

function UIPKResultPanel:getResult(data)

     if data.lResult[1] == 2 then 

        return 1 
     end 

     return 0
end

function UIPKResultPanel:onExit()


end 

function UIPKResultPanel:confirm_click(sender, eventType)

    if  global.panelMgr:isPanelOpened('UIPKRePlayPanel') then
         global.panelMgr:closePanel("UIPKRePlayPanel")
    end 

     global.panelMgr:closePanel("UIPKResultPanel")
end

function UIPKResultPanel:onCloseHandler(sender, eventType)

    if  global.panelMgr:isPanelOpened('UIPKRePlayPanel') then
         global.panelMgr:closePanel("UIPKRePlayPanel")
    end 

     global.panelMgr:closePanel("UIPKResultPanel")

end
--CALLBACKS_FUNCS_END

return UIPKResultPanel

--endregion
