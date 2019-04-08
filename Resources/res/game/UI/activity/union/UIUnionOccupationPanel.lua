--region UIUnionOccupationPanel.lua
--Author : zzl
--Date   : 2017/12/28
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local CloseBtn = require("game.UI.commonUI.CloseBtn")
--REQUIRE_CLASS_END

local UIUnionOccupationPanel  = class("UIUnionOccupationPanel", function() return gdisplay.newWidget() end )

local UITableView =  require("game.UI.common.UITableView")
local UIRewardItemCell = require("game.UI.activity.cell.UIRewardItemCell")
local luaCfg = global.luaCfg

function UIUnionOccupationPanel:ctor()
    self:CreateUI()
end

function UIUnionOccupationPanel:CreateUI()
    local root = resMgr:createWidget("activity/activity_unioncity/activity_unioncity_bj")
    self:initUI(root)
end

function UIUnionOccupationPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "activity/activity_unioncity/activity_unioncity_bj")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Node = self.root.Node_export
    self.banner = self.root.Node_export.bg.banner_export
    self.FileNode_1 = CloseBtn.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.Node_export.bg.FileNode_1)
    self.act_name = self.root.Node_export.bg.act_name_export
    self.introduce = self.root.Node_export.introduce_export
    self.tb_bottom = self.root.Node_export.tb_bottom_export
    self.tb_top = self.root.Node_export.tb_top_export
    self.city_icon = self.root.Node_export.city_icon_export
    self.city_name = self.root.Node_export.Image_45.city_name_export
    self.scrollView = self.root.Node_export.reward_bg.scrollView_export
    self.table_item = self.root.Node_export.table_item_export
    self.table_contont = self.root.Node_export.table_contont_export
    self.ScrollView_1 = self.root.Node_export.ScrollView_1_export
    self.desc_text = self.root.Node_export.ScrollView_1_export.desc_text_export
    self.btn_node = self.root.Node_export.btn_node_export
    self.tb_add = self.root.Node_export.tb_add_export

    uiMgr:addWidgetTouchHandler(self.root.touch, function(sender, eventType) self:close_panel(sender, eventType) end)
--EXPORT_NODE_END

   self.FileNode_1:setData(function()
        self:close_panel(0)
    end)

    self.tableView = UITableView.new()
        :setSize(self.table_contont:getContentSize())-- 设置大小， scrollview滑动区域（定位置， 低位置）
        :setCellSize(self.table_item:getContentSize()) -- 每个小intem 的大小
        :setCellTemplate(UIRewardItemCell) -- 回调函数
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 
        :setColumn(1)
    self.tb_add:addChild(self.tableView)

    self.tips_node = cc.Node:create()
    self.root:addChild(self.tips_node)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UIUnionOccupationPanel:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_UI_ACTIVITY_UPDATE , function (event , id) 

        if self.data and self.data.activity_id == id  then 
            self:setData(self.data)
        end 
    end)
end 


function UIUnionOccupationPanel:setData(data)

    self.data = data

    self.banner:loadTexture(self.data.banner, ccui.TextureResType.plistType)

    uiMgr:setRichText(self, "desc_text", self.data.desc)

    local size = self.desc_text:getRichTextSize()

    self.ScrollView_1:setInnerContainerSize(cc.size(size.width,size.height))

    if size.height <  self.ScrollView_1:getContentSize().height then 
        self.desc_text:setPositionY(self.ScrollView_1:getContentSize().height)
    else 
        self.desc_text:setPositionY(size.height)
    end 

    self.ScrollView_1:jumpToTop()

    self.act_name:setString(self.data.name)

   local drop =  global.ActivityData:getDropItemByDropID(self.data.reward)

    for _ ,v in pairs(drop) do 

        v.tips_panel  = self
        v.scale = 1.4
    end 

    if global.ActivityData:isShowNumberActiviy(self.data.activity_id) then  --是否显示数字 
        for _ ,v in  pairs(drop) do  
            v.isshownumber = true 
         end
    end 

    self.tableView:setData(drop)

    if #self.data.btn > 0 then 
        self:initBtn()
    end 

    local  setMiracle = function () 
        local miracle = luaCfg:get_all_miracle_name_by(self.miracleID)
        local getIcon = function (lType) 
             for _ ,v in pairs(global.luaCfg:world_surface()) do
                    if lType == v.type then 
                        return v.worldmap
                    end 
             end 
        end 
        global.panelMgr:setTextureFor(self.city_icon, getIcon(miracle.type))
        self.city_name:setString(miracle.name)

        if self.data.serverdata.lStatus == 0 then  -- 如果没开启 则显示尽情 期待
            self.city_name:setString(gls(11036))
        end 
    end 

    self.miracleID = 110163409  -- 设置默认图片
    setMiracle()
    self.city_name:setString(gls(11036))

    global.ActivityAPI:ActivityListReq({self.data.activity_id},function(ret,msg)
        if msg and msg.tagAct then 
            if msg.tagAct[1].lParam and msg.tagAct[1].lParam ~=0 and msg.tagAct[1].lStatus == 1  then 
                self.miracleID = msg.tagAct[1].lParam
            else
                self.miracleID = 110163409
            end 
            setMiracle()
        end 
    end)


end 


function UIUnionOccupationPanel:initBtn()

    local btnCount = #self.data.btn

    print(btnCount,"btnCount")

    local btnNode = resMgr:createWidget("activity/activity_btns/btn_" .. btnCount)
    self.btn_node:removeAllChildren()
    self.btn_node:addChild(btnNode)

    uiMgr:configUITree(btnNode)

    -- dump(self.data.btn)
    -- dump(btnNode)
    for index, panel_index in pairs(self.data.btn) do

        print(panel_index ,  "panel_index ////////")

        local btn = btnNode["btn_" .. index]

        local btn_item =luaCfg:get_btn_by(self.data.btn[index])

        btn.text:setString(btn_item.name)

        btn:loadTextures(btn_item.pic,btn_item.pic,nil,ccui.TextureResType.plistType)

        uiMgr:addWidgetTouchHandler(btn, function(sender, eventType) 

            if self.data.serverdata.lStatus == 0 then 
                global.tipsMgr:showWarning("activityUnionCity01")
                return 
            end 

            local call = global.ActivityData:getCallBack("UIUnionOccupationPanel" , panel_index , self.data )
            if call then 
                if self.miracleID then 
                    call(self.miracleID)
                end 
            end 

        end)
    end
end


function UIUnionOccupationPanel:close_panel(sender, eventType)

    global.panelMgr:closePanel("UIUnionOccupationPanel")

end


function UIUnionOccupationPanel:onExit()

    self.miracleID = nil 

    gsound.stopEffect("city_click")

    gevent:call(gsound.EV_ON_PLAYSOUND,"ui_esc")
end 

--CALLBACKS_FUNCS_END

return UIUnionOccupationPanel

--endregion
