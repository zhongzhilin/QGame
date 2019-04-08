--region UIUnionMiraclePanel.lua
--Author : wuwx
--Date   : 2017/01/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUnionMiraclePanel  = class("UIUnionMiraclePanel", function() return gdisplay.newWidget() end )

function UIUnionMiraclePanel:ctor()
    self:CreateUI()
end

function UIUnionMiraclePanel:CreateUI()
    local root = resMgr:createWidget("union/union_miracle_bg")
    self:initUI(root)
end

function UIUnionMiraclePanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_miracle_bg")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.boom = self.root.Node_7.boom_mlan_8.boom_export
    self.capital = self.root.Node_7.capital_mlan_8.capital_export
    self.occupyNum = self.root.Node_7.occupyNum_mlan_18.occupyNum_export
    self.occupyMirNum = self.root.Node_7.occupyMirNum_mlan_18.occupyMirNum_export
    self.no = self.root.Node_7.no_mlan_20_export
    self.title = self.root.title_export
    self.itemBottomNode = self.root.itemBottomNode_export
    self.contentLayout = self.root.contentLayout_export
    self.itemTopNode = self.root.itemTopNode_export
    self.itemLayout = self.root.itemLayout_export
    self.node_tableView = self.root.node_tableView_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.title.esc, function(sender, eventType) self:exit_call(sender, eventType) end, nil, true)

    local UITableView = require("game.UI.common.UITableView")
    local UIUnionMiracleCell = require("game.UI.union.list.UIUnionMiracleCell")
    self.tableView = UITableView.new()
        :setSize(self.contentLayout:getContentSize(), self.itemTopNode, self.itemBottomNode)
        :setCellSize(self.itemLayout:getContentSize())
        :setCellTemplate(UIUnionMiracleCell)
        :setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        :setColumn(1)
    self.node_tableView:addChild(self.tableView)
end

function UIUnionMiraclePanel:exit_call()
    global.panelMgr:closePanelForBtn("UIUnionMiraclePanel")
end

function UIUnionMiraclePanel:onEnter()
    self.m_capital = 0
    self.m_boom = 0
    self.no:setVisible(false)

    self:setData()
    self:refresh()
end

function UIUnionMiraclePanel:setData()
    self.data = global.unionData:getInUnion()
    --没有联盟则不可能打开
    self.capital:setString(string.format("%s%s", self.m_capital, global.luaCfg:get_local_string(10076)))
    self.boom:setString(string.format("%s%s", self.m_boom, global.luaCfg:get_local_string(10076)))
    
    self.curOccupyMax = 0
    local curUnionLv = global.unionData:getInUnionCityLv()  
    for k,v in pairs(luaCfg:union_build_effect()) do
        if v.effecttype == 25 and v.LV == curUnionLv then
            self.curOccupyMax = v.typelevel
            break
        end
    end

    --润稿翻译处理 张亮
    global.tools:adjustNodePosForFather(self.capital:getParent(),self.capital,30)
    global.tools:adjustNodePosForFather(self.boom:getParent(),self.boom,30)
    global.tools:adjustNodePosForFather(self.occupyNum:getParent(),self.occupyNum, 5)
    global.tools:adjustNodePosForFather(self.occupyMirNum:getParent(),self.occupyMirNum, 5)

end

function UIUnionMiraclePanel:refresh()
    global.unionApi:getAllyMiracle(function(msg)
        -- body
        if tolua.isnull(self.tableView) then return end
        if msg.tagData and #msg.tagData>0 then

            local cityNum = 0 -- 联盟城市数量（除奇迹\神殿）
            for i,v in ipairs(msg.tagData) do
                for ii,vv in ipairs(v.tagPlus) do
                    if vv.lID == 29 then
                        --个人贡献值
                        if global.userData:isMine(v.lOwnerID)  then
                            --只有是自己占领的奇迹才算进去
                            self.m_capital = vv.lValue+self.m_capital
                        end
                    else
                        --繁荣度
                        self.m_boom = vv.lValue+self.m_boom
                    end
                end

                if v.lType < 100 then
                    cityNum = cityNum + 1
                end

            end
            self.tableView:setData(msg.tagData)
            self.no:setVisible(false)
            self.occupyNum:setString(cityNum .. "/" .. self.curOccupyMax)
            self.occupyMirNum:setString((#msg.tagData) - cityNum)

        else
            if not tolua.isnull(self.tableView) then 
                self.tableView:setData({})
            end 
            self.no:setVisible(true)
            self.occupyNum:setString(0 .. "/" .. self.curOccupyMax)
            self.occupyMirNum:setString(0)
        end
        
        self:setData()
    end,self.data.lID)
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUnionMiraclePanel

--endregion
