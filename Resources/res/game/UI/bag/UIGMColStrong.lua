--region UIGMColStrong.lua
--Author : untory
--Date   : 2017/03/14
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIInputBox = require("game.UI.common.UIInputBox")
--REQUIRE_CLASS_END

local UIGMColStrong  = class("UIGMColStrong", function() return gdisplay.newWidget() end )

function UIGMColStrong:ctor()
    self:CreateUI()
end

function UIGMColStrong:CreateUI()
    local root = resMgr:createWidget("ui/debug_strengthen")
    self:initUI(root)
end

function UIGMColStrong:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "ui/debug_strengthen")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.txt_Title = self.root.Node_export.txt_Title_export
    self.target = self.root.Node_export.target_export
    self.itemId = self.root.Node_export.itemId_export
    self.itemId = UIInputBox.new()
    uiMgr:configNestClass(self.itemId, self.root.Node_export.itemId_export)
    self.itemCount = self.root.Node_export.itemCount_export
    self.itemCount = UIInputBox.new()
    uiMgr:configNestClass(self.itemCount, self.root.Node_export.itemCount_export)
    self.itemTime = self.root.Node_export.itemTime_export
    self.itemTime = UIInputBox.new()
    uiMgr:configNestClass(self.itemTime, self.root.Node_export.itemTime_export)

    uiMgr:addWidgetTouchHandler(self.root.Panel_1, function(sender, eventType) self:exit(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.btn01, function(sender, eventType) self:testSuccess(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.Node_export.btn02, function(sender, eventType) self:testCount(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIGMColStrong:exit(sender, eventType)

end

function UIGMColStrong:testSuccess(sender, eventType)
        
    local res = function(data)

        self.target:setString("成功次数" .. data.lSuccCnt .. "\n" ..
            "失败次数" .. data.lFailCnt .. "\n" ..
            "总次数" .. data.lStrongCnt .. "\n" ..
            "掉等级次数" .. data.lDownCnt .. "\n" ..
            "失败不掉等级次数" .. data.lBalanceCnt .. "\n" ..
            "当前等级" .. data.lCurlv .. "\n")

        -- local success = data.lSuccCnt
        -- local lose = data.lFailCnt

        -- self.target:setString(math.floor(success / (lose + success) * 100) .. "%")    
    end

    self:getRes(res)
end

function UIGMColStrong:getRes(call)
    
    local beginLv = tonumber(self.itemId:getString())
    local toLv = tonumber(self.itemCount:getString())
    local count = tonumber(self.itemTime:getString())

    global.gmApi:gmColStrong(beginLv,toLv,count,function(msg)
        
        dump(msg,"check msg")
        call(msg)
    end)
end

function UIGMColStrong:testCount(sender, eventType)
    
    local res = function(data)


    end

    self:getRes(res)
end
--CALLBACKS_FUNCS_END

return UIGMColStrong

--endregion
