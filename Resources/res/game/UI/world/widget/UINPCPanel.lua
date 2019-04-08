--region UINPCPanel.lua
--Author : untory
--Date   : 2017/03/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local UITalkTextControl = require("game.UI.common.UITalkTextControl")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UINPCPanel  = class("UINPCPanel", function() return gdisplay.newWidget() end )

function UINPCPanel:ctor()
    self:CreateUI()
end

function UINPCPanel:CreateUI()
    local root = resMgr:createWidget("world/director/npc_picture")
    self:initUI(root)
end

function UINPCPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "world/director/npc_picture")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.text = self.root.text_export
    self.speak = self.root.text_export.speak_export
    self.npc = self.root.text_export.npc_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
--EXPORT_NODE_END
end

function UINPCPanel:onExit()

    print("release npc panel")

    if self.npcData.png then
        gdisplay.removeImage(self.npcData.png)
    end    

    if self.npcData.plist ~= "" then
        gdisplay.removeSpriteFrames(self.npcData.plist .. ".plist",self.npcData.plist .. ".png")
    end

end

function UINPCPanel:setData(data)
   
    -- if self.contentSoundKey then
    --     gsound.stopEffect(self.contentSoundKey)
    --     self.contentSoundKey = nil
    -- end

    self.data = data

    self.root:stopAllActions()
    self.isCanTouch = false
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.7),cc.CallFunc:create(function()
        self.isCanTouch = true
    end)))
    local timeline = resMgr:createTimeline("world/director/npc_picture")    
    self.root:runAction(timeline)    

    if data.isSkipAction then

        if data.side == 0 then
            timeline:play("animation2",false)
        else
            timeline:play("animation3",false)
        end
    else

        if data.side == 0 then
            timeline:play("animation0",false)
        else
            timeline:play("animation1",false)
        end
    end    

    timeline:setLastFrameCallFunc(function()
                    
    end)

    if data.des then
        -- self.speak:setString(data.des)
  

        self.speak:setString("")

        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function()

            UITalkTextControl.startScroll(self.speak,data.des)     
        end)))
    elseif data.desId then
        
        print(data.desId,'data.desId')
        local chatData = luaCfg:get_dialogue_by(data.desId)

        self.speak:setString("")

        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function()

            UITalkTextControl.startScroll(self.speak,chatData.text)    
        end)))

        -- self.speak:setString(chatData.text)

        if chatData.SoundKey and chatData.SoundKey ~= "nil" then
            
            timeline:setLastFrameCallFunc(function()
                self.contentSoundKey = chatData.SoundKey
                gevent:call(gsound.EV_ON_PLAYSOUND,chatData.SoundKey)             
            end)            
        end       

        if chatData.delayTime ~= 0 then

            self:runAction(cc.Sequence:create(cc.DelayTime:create(chatData.delayTime),cc.CallFunc:create(function()
                self:exit()                
            end)))
        end 
    end    

    local npcData = luaCfg:get_npc_by(data.npc)        

    self.npcData = npcData

    self.npc:removeAllChildren()

    local npcAction = nil

    if npcData.pathType == 0 then

        npcAction = resMgr:createCsbAction(npcData.path, "animation0", true)
        self.npc:addChild(npcAction)
    elseif npcData.pathType == 1 then

        npcAction = cc.Sprite:create()
        npcAction:setSpriteFrame(npcData.path)
        self.npc:addChild(npcAction)
    end    

    if npcData.turnTo == 1 then

        npcAction:setScaleX(-1)
    end
end

function UINPCPanel:getPreSoundKey()
    
    return self.contentSoundKey
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UINPCPanel:exit(sender, eventType)

    if not self.isCanTouch then return end

    if UITalkTextControl.endTalk(self.speak) then
        return
    end

    if not self.data.keepSound then

        if self.contentSoundKey then
            gsound.stopEffect(self.contentSoundKey)
            self.contentSoundKey = nil
        end
    end

    global.panelMgr:closePanel("UINPCPanel")
    global.guideMgr:dealScript() 
end
--CALLBACKS_FUNCS_END

return UINPCPanel

--endregion
