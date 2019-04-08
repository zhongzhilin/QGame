--region UIPKChoosePanel.lua
--Author : zzl
--Date   : 2018/02/01
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIPKHeroItem = require("game.UI.pk.UIPKHeroItem")
--REQUIRE_CLASS_END

local UIPKChoosePanel  = class("UIPKChoosePanel", function() return gdisplay.newWidget() end )

function UIPKChoosePanel:ctor()
    self:CreateUI()
end

function UIPKChoosePanel:CreateUI()
    local root = resMgr:createWidget("player_kill/pk_choose_hero")
    self:initUI(root)
end

function UIPKChoosePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player_kill/pk_choose_hero")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.FileNode_1 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.FileNode_1)
    self.FileNode_2 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.FileNode_2, self.root.Node_export.FileNode_2)
    self.FileNode_3 = UIPKHeroItem.new()
    uiMgr:configNestClass(self.FileNode_3, self.root.Node_export.FileNode_3)
    self.describe = self.root.Node_export.describe_mlan_14_export
    self.my_start = self.root.Node_export.my_start_export

    uiMgr:addWidgetTouchHandler(self.root.Panel_15, function(sender, eventType) self:exit_call(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.my_start, function(sender, eventType) self:attack_call(sender, eventType) end)
--EXPORT_NODE_END
    
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIPKChoosePanel:onEnter()

    -- local key = tostring(global.userData:getUserId()).."chooseHero"

    -- local st =  cc.UserDefault:getInstance():getStringForKey(key)

    -- local data = {} 

    -- if st and  st ~="" then

    --     for _ ,v in pairs(global.tools:strSplit(st ,"|") or {}) do 
    --         table.insert(data , global.heroData:getHeroDataById(tonumber(v)))
    --     end 

    -- else
    --     local herodata =  global.heroData:getGotHeroData()
    --     table.insert(data ,herodata[1])
    --     table.insert(data ,herodata[2])
    --     table.insert(data ,herodata[3])
    -- end 

    -- self.key = key 
    -- self:setData(data)
end 

function UIPKChoosePanel:onExit()

    if self.chooseExitCall then 
        self.chooseExitCall()
    end 

end 

function UIPKChoosePanel:checkDefenseHero(curHeroId, id)
    for i=1,3 do 
        local item = self["FileNode_"..i]
        if item.data and item.data.heroId and item.data.heroId == curHeroId and item.bt_bg:getTag() ~= id then 
            item:setData({})
        end 
    end 
end

function UIPKChoosePanel:setData(data , choose_type , call)

    self.data = data 

    self.attatk_call = call

    if choose_type ==  1 then  --出战

        self.key = tostring(global.userData:getUserId()).."chooseHero"

        local getDefArr = function () 
            local data = global.heroData:getGotHeroData()
            return data
        end 

        for i= 1, 3 do 

            local item = self["FileNode_"..i]
            -- table.insert(data , item.data)
            item:setData(self.data[i] or {})
            item.bt_bg:setTag(i)
            item.default:setVisible(false)
            item.canchange:setVisible(true)

            local call = function(sender, eventType)

                local curItem = item
                local panel = global.panelMgr:openPanel("UISelectHeroPanel")

                local curSelectHero = nil
                if curItem.data and curItem.data.heroId then curSelectHero = curItem.data.heroId end
                panel:setData(nil, curSelectHero ,nil ,getDefArr())
                panel:setTarget(curItem)
                panel:setExitCall(function()
                    if curItem.data.heroId then 
                        self:checkDefenseHero(curItem.data.heroId, curItem.bt_bg:getTag())
                    end 
                    self.data[i] = curItem.data
                    -- saveStr()
                    self:saveChoose(self.key)
                end)
            end

            item.choose_hero:setData(nil ,nil ,call)
            uiMgr:addWidgetTouchHandler(item.bt_bg, call)
        end 
    end  

end

function UIPKChoosePanel:checkFull()

    local index = 0
    for i= 1, 3 do 
        local item = self["FileNode_"..i]
        if item.data and item.data.heroId then
            index = index + 1
        end
    end
    return index >= 3
end 

function UIPKChoosePanel:getHeroIdArr()
    local arr =  {} 
    for i= 1, 3 do 
        local item = self["FileNode_"..i]
        if item.data and item.data.heroId then
            if not table.hasval(arr, item.data.heroId) then 
                table.insert(arr ,item.data.heroId)
            end 
        end
    end
    return arr
end 


function UIPKChoosePanel:saveChoose(key)

    local arr =  {} 
    for i= 1, 3 do 
        local item = self["FileNode_"..i]
        if item.data and item.data.heroId then
            if not table.hasval(arr,item.data.heroId ) then 
                table.insert(arr ,item.data.heroId)
            end 
        end
    end

    self:savedef(arr , key)
end 

function UIPKChoosePanel:savedef(arr , key)

    local str = ""
    for _ ,v in ipairs(arr) do 
        if str =="" then 
            str = tostring(v)
        else 
            str= str.."|"..tostring(v)
        end 
    end 
    cc.UserDefault:getInstance():setStringForKey( key, str)
end 


function UIPKChoosePanel:attack_call(sender, eventType)
    
    if self.attatk_call then
        self.attatk_call()
    else 
        if self:checkFull() then 
            self:exit_call()

            local idarr =  self:getHeroIdArr()

            if #idarr < 3 then return global.tipsMgr:showWarning("data errors") end 

            global.commonApi:PKRequest(1 , global.PKRequestID , idarr,function (msg) 

                global.panelMgr:getPanel("UIPKPanel"):reFreshData(msg)

                global.panelMgr:openPanel("UIPKRePlayPanel"):setData(msg)

            end)

        else 
            global.tipsMgr:showWarning("pk01")
        end 
    end 
end

function UIPKChoosePanel:exit_call(sender, eventType)

    global.panelMgr:closePanel("UIPKChoosePanel")

end
--CALLBACKS_FUNCS_END

return UIPKChoosePanel

--endregion
