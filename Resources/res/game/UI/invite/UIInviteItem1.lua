--region UIInviteItem1.lua
--Author : zzl
--Date   : 2018/03/09
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIInviteItem1  = class("UIInviteItem1", function() return gdisplay.newWidget() end )

function UIInviteItem1:ctor()
    self:CreateUI()
end

function UIInviteItem1:CreateUI()
    local root = resMgr:createWidget("invite/Node1")
    self:initUI(root)
end

function UIInviteItem1:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "invite/Node1")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.table_contont = self.root.table_contont_export
    self.table_item = self.root.table_item_export
    self.table_add = self.root.table_add_export
    self.icon = self.root.icon_export
    self.get = self.root.get_export
    self.compete = self.root.compete_export
    self.des = self.root.des_export
    self.dim = self.root.dim_export
    self.now = self.root.now_export
    self.max = self.root.max_export

    uiMgr:addWidgetTouchHandler(self.get, function(sender, eventType) self:getRewardHandler(sender, eventType) end)
--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIInviteItem1:getRewardHandler(sender, eventType)

    if self.data.serverdata and self.data.serverdata.lState == 1 then 

        local data =self.data

        global.commonApi:inviteApi(2, data.id , nil , function (msg)

            local panel = global.panelMgr:getPanel("UIInvitePanel")
            if panel and panel.reFreshList then 
                panel:reFreshList(true)
            end 
            local item ={{6,tonumber(data.diamond),100}}
            global.panelMgr:openPanel("UIItemRewardPanel"):setData(item)

         end)
        -- local x, y = self.get:convertToWorldSpace(cc.p(0,0))
        -- global.EasyDev:playHarvestEffect(x, y, tonumber(self.data.diamond))

    else
        global.tipsMgr:showWarning("notFinishTarget")
    end 
end

function UIInviteItem1:onEnter()

end 

function UIInviteItem1:setData(data)

    self.get:setVisible(true)
    self.compete:setVisible(false)
    self.data  = data 

    self.dim:setString(":"..self.data.diamond)
    self.des:setString(string.format(gls(11147),self.data.num)..global.luaCfg:get_target_condition_by(self.data.targetId).description)

    if self.data.serverdata then -- -1未开启, 0进行中，1可领取，2已领取，3挑战失败

        local serdata = self.data.serverdata
        local lState  = serdata.lState or  0

        if lState ==  0 then 

            global.colorUtils.turnGray(self.get, true )

        elseif lState ==  1 then 

            global.colorUtils.turnGray(self.get, false )

        elseif lState == 2 then 

            self.get:setVisible(false)
            self.compete:setVisible(true)
        end 

        self.now:setString(serdata.lProgress)
        self.max:setString("/"..self.data.num)
        if  serdata.lProgress >self.data.num then 
            self.now:setString(self.data.num)
        end 
    else 
        global.colorUtils.turnGray(self.get, true)

        self.max:setString("/"..self.data.num)
        self.now:setString("0")
    end 

    -- self.get:setTouchEnabled(self.data.serverdata and self.data.serverdata.lState == 1 )
end 


--CALLBACKS_FUNCS_END

return UIInviteItem1

--endregion
