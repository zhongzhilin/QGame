--region UIComat.lua
--Author : anlitop
--Date   : 2017/07/19
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIComat  = class("UIComat", function() return gdisplay.newWidget() end )

local actionManger  =require("game.UI.replay.excute.actionManger")
local TextScrollControl = require("game.UI.common.UITextScrollControl")

local Player  =require("game.UI.replay.excute.Player")
local TextEffect  =require("game.UI.replay.excute.TextEffect")


function UIComat:ctor()
    
end

function UIComat:CreateUI()
    local root = resMgr:createWidget("player/node/comat")
    self:initUI(root)
end

function UIComat:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/comat")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.left_combat_icon = self.root.left_combat_icon_export
    self.left_combat_num = self.root.left_combat_icon_export.left_combat_num_export
    self.right_combat_icon = self.root.right_combat_icon_export_0
    self.right_combat_num = self.root.right_combat_icon_export_0.right_combat_num_export
    self.left_loadingbar_bg = self.root.left_loadingbar_bg_export
    self.left_LoadingBar = self.root.left_loadingbar_bg_export.left_LoadingBar_export
    self.right_loadingbar_bg = self.root.right_loadingbar_bg_export
    self.right_LoadingBar = self.root.right_loadingbar_bg_export.right_LoadingBar_export

    uiMgr:addWidgetTouchHandler(self.root.attackt_exprot, function(sender, eventType) self:battle_click(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIComat:setData(data , isAction)

    local left_max = data[1].original
    local left_now = data[1].new

    local right_max =data[2].original
    local right_now  = data[2].new


    local left_part = data[1].new - data[1].last

    local right_part = data[2].new - data[2].last

    if isAction then 

        TextEffect.new(self.right_combat_num ,right_now, 0.4)
        TextEffect.new(self.left_combat_num ,left_now, 0.4)

        local leftfrom =  (data[1].last / left_max)*100

        local rightfrom =  (data[2].last / right_max)*100
    
    
        print(leftfrom,"leftfrom")
        print(rightfrom,"rightfrom")

        print((left_now / left_max)*100,"leftto ")
        print((right_now / right_max)*100,"rightto")

        self.left_LoadingBar:runAction(cc.ProgressFromTo:create(0.3,  leftfrom ,(left_now / left_max)*100))
        self.right_LoadingBar:runAction(cc.ProgressFromTo:create(0.3, rightfrom ,(right_now / right_max)*100))
    else 
        self.left_combat_num:setString(left_now)
        self.right_combat_num:setString(right_now)

        self.left_LoadingBar:setPercent(left_now / left_max * 100 )
        self.right_LoadingBar:setPercent(right_now / right_max * 100 )
    end 
end


function UIComat:battle_click(sender, eventType)

end


function UIComat:showComatWithAction()
    
    actionManger.getInstance():createTimeline(self.root ,"showComatWithAction" , true , true)

end


function UIComat:hideComatNoAction()
    
    actionManger.getInstance():createTimeline(self.root ,"hideComatNoAction" , true , true)

end 


--CALLBACKS_FUNCS_END

return UIComat

--endregion
