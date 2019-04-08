--region UIResult.lua
--Author : anlitop
--Date   : 2017/06/21
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIResult  = class("UIResult", function() return gdisplay.newWidget() end )
local actionManger  =require("game.UI.replay.excute.actionManger")

function UIResult:ctor()
    -- self:CreateUI()
end

function UIResult:CreateUI()
    local root = resMgr:createWidget("player/node/result")
    self:initUI(root)
end

function UIResult:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/result")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.old_result = self.root.Node_3.old_result_export
    self.new_result = self.root.Node_4.new_result_export

--EXPORT_NODE_END
    self.standardX = self:getPositionX()
end


local  textWidth = 357

function UIResult:setData(data)

    data[1]="【"..data[1].."】"
    data[2]="【"..data[2].."】"

    self:setPositionX(self.standardX)

    if self.old_result_data then 
        global.uiMgr:setRichText(self,"old_result",50099,{soldier1 =self.old_result_data[1]  , soldier2=self.old_result_data[2] , num1=self.old_result_data[3]  , num2 =self.old_result_data[4] })
    else 
        self.old_result:setString("")
    end 

    global.uiMgr:setRichText(self,"new_result",50099,{soldier1 =data[1]  , soldier2=data[2] , num1=data[3]  , num2 =data[4] })

    self:updateResult()

    self.old_result_data =data

    local size = self.new_result:getRichTextSize()
    
    local part =size.width - textWidth

    self:setPositionX(self:getPositionX()-part/2)
end


function UIResult:updateResult()

     actionManger.getInstance():createTimeline(self ,"scrollResultAction" , true , true)
end 

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIResult

--endregion
