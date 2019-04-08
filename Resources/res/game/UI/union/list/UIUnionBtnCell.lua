local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIUnionBtnCell  = class("UIUnionBtnCell", function() return cc.TableViewCell:create() end )
local UIUnionBtnItem = require("game.UI.union.widget.UIUnionBtnItem")

function UIUnionBtnCell:ctor()
    self:CreateUI()
end

function UIUnionBtnCell:CreateUI()

    self.item = UIUnionBtnItem.new() 
    self:addChild(self.item)
end


local btnCall = {
    [1] = "editGG",
    [2] = "editXY",
    [3] = "quitUnion",
    [4] = "dismissUnion",
    [5] = "newFlag",
    [6] = "changePermission",
    [7] = "otherUnion",
    [8] = "changeModel",
    [9] = "newName",
    [10] = "newShortName",
    [11] = "setLanguage",
    [12] = "publishRecruit",
}
function UIUnionBtnCell:onClick()
	print("##########UIUnionBtnCell:onClick()  self.data.id="..self.data.id)
	if self[btnCall[self.data.id]] then
        if self.data.isPower then
            self[btnCall[self.data.id]](self)
        else
            global.tipsMgr:showWarning("unionPowerNot")
        end
	else
    	global.tipsMgr:showWarning("FuncNotFinish")
	end
end

function UIUnionBtnCell:setData(data)
    self.data = data
    self:updateUI()
end

function UIUnionBtnCell:updateUI()
    self.item:setData(self.data)
end

function UIUnionBtnCell:quit()
    global.unionData:setInUnion({})
    global.panelMgr:closePanel("UIHadUnionPanel")
    global.panelMgr:closePanel("UIUnionMgrPanel")
end

---------------------------------按钮功能回调----------------------------------------
function UIUnionBtnCell:quitUnion()
    --退出联盟
    if global.userData:checkJoinUnion() then
        
        local panel = global.panelMgr:openPanel("UIPromptPanel")

        local errcodeKey = "UnionEseNg"
        if global.userData:getlAllyFirstAdd() < 2 then
            errcodeKey = "UnionEseNgOne"
        end
        panel:setData(errcodeKey, function()
            --二次确认
            global.unionApi:quitUnion(function(msg)
                global.userData:setlAllyFirstAdd(global.userData:getlAllyFirstAdd()+1)
                global.tipsMgr:showWarning(global.luaCfg:get_local_string(10081))
                self:quit()
            end)
        end)
    end
end

function UIUnionBtnCell:dismissUnion()
    --解散联盟
    if global.unionData:isLeader() then
        local panel = global.panelMgr:openPanel("UIPromptPanel")
        local errcodeKey = "uniondisone"
        if global.userData:getlAllyFirstAdd() < 2 then
            errcodeKey = "uniondisoneFirst"
        end
        panel:setData(errcodeKey, function()
            -- body
            local panel = global.panelMgr:openPanel("UIPromptPanel")
            panel:setData("uniondistwo", function()
                --二次确认
                global.unionApi:letAllyDismissReq(function()
                    -- body
                    global.userData:setlAllyFirstAdd(global.userData:getlAllyFirstAdd()+1)
                    global.tipsMgr:showWarning("uniondisok")
                    self:quit()
                end,global.userData:getlAllyID())
            end)
        end)
    else
        global.tipsMgr:showWarning("uniondisnoboss")
    end
end

function UIUnionBtnCell:editGG()
    --编辑公告
    global.panelMgr:openPanel("UIUnionEditGG")
end

function UIUnionBtnCell:editXY()
    --编辑宣言
    global.panelMgr:openPanel("UIUnionEditXY")
end

function UIUnionBtnCell:newName()

    global.panelMgr:openPanel("UIUnionModifyName"):setData(2)
end

function UIUnionBtnCell:newShortName()
    global.panelMgr:openPanel("UIUnionModifyName"):setData(1)
end

function UIUnionBtnCell:otherUnion()
    global.panelMgr:openPanel("UIUnionPanel"):setData()
end

function UIUnionBtnCell:changeModel()
    --修改招募模式
    global.panelMgr:openPanel("UIUnionJoinCondition")
end

function UIUnionBtnCell:changePermission()
    if not global.unionData:isHadPower(16) then
        return global.tipsMgr:showWarning("unionPowerNot")
    end
    --修改权限
    global.panelMgr:openPanel("UIUEditPower")
end

function UIUnionBtnCell:newFlag()
    global.panelMgr:openPanel("UIUnionModifyFlag")
end

function UIUnionBtnCell:setLanguage()
    global.panelMgr:openPanel("UIUnionEditLan")
end

function UIUnionBtnCell:publishRecruit()
    -- 发布招募信息
    global.panelMgr:openPanel("UIUnionPubRecruit")
end

return UIUnionBtnCell