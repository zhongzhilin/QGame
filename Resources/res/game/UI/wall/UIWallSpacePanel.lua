--region UIWallSpacePanel.lua
--Author : wuwx
--Date   : 2016/11/10
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIWallSpaceItem = require("game.UI.wall.ItemNode.UIWallSpaceItem")
--REQUIRE_CLASS_END

local UIWallSpacePanel  = class("UIWallSpacePanel", function() return gdisplay.newWidget() end )

function UIWallSpacePanel:ctor()
    self:CreateUI()
end

function UIWallSpacePanel:CreateUI()
    local root = resMgr:createWidget("wall/wall_space_bg")
    self:initUI(root)
end

function UIWallSpacePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "wall/wall_space_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.device_combat = self.root.top_bg.device_combat_export
    self.device_combat_info = self.root.top_bg.device_combat_info_mlan_6_export
    self.loadingbar_bg = self.root.top_bg.loadingbar_bg_export
    self.LoadingBar = self.root.top_bg.loadingbar_bg_export.LoadingBar_export
    self.now_num = self.root.top_bg.loadingbar_bg_export.now_num_export
    self.total_num = self.root.top_bg.loadingbar_bg_export.total_num_export
    self.scrollView = self.root.top_bg.scrollView_export
    self.FileNode_1 = UIWallSpaceItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.top_bg.scrollView_export.Node_15.FileNode_1)
    self.FileNode_2 = UIWallSpaceItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.top_bg.scrollView_export.Node_15.FileNode_2)
    self.top = self.root.top_export
    self.trim_top = self.root.trim_top_export

    uiMgr:addWidgetTouchHandler(self.root.top_export.intro_btn, function(sender, eventType) self:onHelpHandler(sender, eventType) end)
--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.top.esc, function(sender, eventType) self:onCloseHandler(sender, eventType) end)
    
    -- global.panelMgr:trimScrollView(self.scrollView,self.trim_top)

    self.device_combat1 = self.device_combat_info
end

function UIWallSpacePanel:onCloseHandler(sender, eventType)
    global.panelMgr:closePanelForBtn("UIWallSpacePanel")
end

function UIWallSpacePanel:onEnter()
end

function UIWallSpacePanel:onExit()

end

function UIWallSpacePanel:getSpaceBuff()
    -- body
    local effTotal = 0
    local effectReqData = {{lType = 4,lBind = 14}}
    global.gmApi:effectBuffer(effectReqData, function (msg)
        
        msg.tgEffect = msg.tgEffect or {}
        for _,v in pairs(msg.tgEffect) do
            if v.tgEffect then 
                for _,vv in pairs(v.tgEffect) do
                    if vv.lEffectID == 3055 then
                        effTotal = effTotal + vv.lVal
                    end
                end
                global.userData:setDefPopBuff(effTotal)
                if not tolua.isnull(self.total_num) then 
                    self.total_num:setString(global.userData:getMaxDefPop())
                end
            end
        end
    end)

end

function UIWallSpacePanel:setData(data)
    self.data = data or self.data

    local soldierData = global.soldierData
    self.device_combat:setString(soldierData:getTrapsTotalPower())

    local userData = global.userData
    self.now_num:setString(userData:getDefPop())
    self.total_num:setString(userData:getMaxDefPop())
    self.LoadingBar:setPercent(userData:getDefPop()/userData:getMaxDefPop()*100)

    local traps = soldierData:getTraps()

    table.sort( traps, function(s1, s2) return s1.lID < s2.lID end )

    for i=1,2 do

        self["FileNode_"..i]:setData(traps[i])

        if  self.data.trainCall ==  true then  --直接通过界面打开训练士兵  

            self["FileNode_"..i].trainCall = function() 

               global.panelMgr:openPanel("TrainPanel"):setData( self.data)
            end 

        end 

    end

    self:getSpaceBuff()

    global.tools:adjustNodePos(self.device_combat1,self.device_combat,5)
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIWallSpacePanel:onHelpHandler(sender, eventType)
    local data = luaCfg:get_introduction_by(3)
    if not data then return end
    local infoPanel = global.panelMgr:openPanel("UIIntroducePanel")
    infoPanel:setData(data)
end
--CALLBACKS_FUNCS_END

return UIWallSpacePanel

--endregion
