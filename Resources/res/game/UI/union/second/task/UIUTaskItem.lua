--region UIUTaskItem.lua
--Author : wuwx
--Date   : 2017/02/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUTaskItem  = class("UIUTaskItem", function() return gdisplay.newWidget() end )

function UIUTaskItem:ctor()
    self:CreateUI()
end

function UIUTaskItem:CreateUI()
    local root = resMgr:createWidget("union/union_task_list")
    self:initUI(root)
end

function UIUTaskItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_task_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.icon = self.root.icon.icon_export
    self.text1 = self.root.text.text1_export
    self.text2 = self.root.text.text2_mlan_3_export
    self.text3 = self.root.text.text3_mlan_4_export
    self.text4 = self.root.text.text4_mlan_4_export
    self.text5 = self.root.text.text5_export
    self.text6 = self.root.text.text6_export
    self.LoadingBar_1 = self.root.jindutiao.LoadingBar_1_export
    self.progress_text = self.root.jindutiao.progress_text_export
    self.task_btn = self.root.task_btn_export
    self.btn_word = self.root.task_btn_export.btn_word_export
    self.go_target = self.root.go_target_export
    self.node_killed = self.root.node_killed_export
    self.result_text = self.root.node_killed_export.result_text_mlan_3_export

    uiMgr:addWidgetTouchHandler(self.task_btn, function(sender, eventType) self:onGet(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.go_target, function(sender, eventType) self:onGoTarget(sender, eventType) end)
--EXPORT_NODE_END
    self.btn_word:setString(luaCfg:get_local_string(10013))
end

local state = {
    DOING = 0,
    GET = 1,
    GOT = 2,
}
function UIUTaskItem:setData(data)
    self.data = data
    local itemData = global.luaCfg:get_union_task_by(data.sData.lID)
    -- self.icon:loadTexture(itemData.icon,ccui.TextureResType.plistType)
    global.panelMgr:setTextureFor(self.icon,itemData.icon)
    self.text1:setString(itemData.taskDescription)
    self.progress_text:setString(string.fformat("%s/%s",data.sData.lProgress,itemData.targetNum))
    self.LoadingBar_1:setPercent(data.sData.lProgress/itemData.targetNum*100)
    --+个人贡献
    self.text5:setString("+"..itemData.rewardnum)
    self.text6:setString("+"..itemData.rewardboom)

    self.task_btn:setVisible((data.sData.lState == state.GET))
    -- self.go_target:setVisible(itemData.taskType == 3)
    self.go_target:setVisible(false)

    if (data.sData.lState == state.GOT) then
        --已完成
        self.node_killed:setVisible(true)
        -- 红色
        -- self.node_killed:setSpriteFrame("ui_surface_icon/hero_frame_red.png")
        -- self.node_killed.result_text_mlan:setTextColor(cc.c3b(180, 29, 11))
        self.result_text:setString(global.luaCfg:get_local_string(10476))
    else
        self.node_killed:setVisible(false)
    end

    --润稿翻译处理 张亮
    global.tools:adjustNodePos(self.text2,self.text3)
    global.tools:adjustNodePos(self.text3,self.text5)
    --润稿处理 阿成
    global.tools:adjustNodePos(self.text5,self.text4,20)
    global.tools:adjustNodePos(self.text4,self.text6)



end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUTaskItem:onGet(sender, eventType)
    global.unionApi:getAllyTaskBonus(function(msg)
        -- body
        if self.data then --protect 
            local itemData = global.luaCfg:get_union_task_by(self.data.sData.lID)
            global.tipsMgr:showWarning("Uniontask01",math.floor(itemData.rewardboom),math.floor(itemData.rewardnum))
        end 
        gevent:call(global.gameEvent.EV_ON_REFRESH_UNION_TASK)
    end,self.data.sData.lID)
end

function UIUTaskItem:onGoTarget(sender, eventType)
    -- global.funcGame:gpsWorldCity(self.data.lMapID,2)
end
--CALLBACKS_FUNCS_END

return UIUTaskItem

--endregion
