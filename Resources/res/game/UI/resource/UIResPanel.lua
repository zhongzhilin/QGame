
--region UIResPanel.lua
--Author : yyt
--Date   : 2016/11/02
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local panelMgr = global.panelMgr
local uiMgr = global.uiMgr
local resData = global.resData
local UIResItem = require("game.UI.resource.UIResItem")
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIAdSlideNode = require("game.UI.advertisementItem.UIAdSlideNode")
--REQUIRE_CLASS_END

local UIResPanel  = class("UIResPanel", function() return gdisplay.newWidget() end )
local UIAdvertisementItem = require("game.UI.advertisementItem.UIAdvertisementItem")

function UIResPanel:ctor()
    self:CreateUI()
end

function UIResPanel:CreateUI()
    local root = resMgr:createWidget("resource/res_pandect")
    self:initUI(root)
end

function UIResPanel:initUI(root)
    self.root = root
    self:addChild(root)
    self.root:setContentSize(cc.size(gdisplay.width, gdisplay.height))
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "resource/res_pandect")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.FileNode_1 = UIAdSlideNode.new()
    uiMgr:configNestClass(self.FileNode_1, self.root.FileNode_1)
    self.top = self.root.top_export
    self.itemLayout = self.root.itemLayout_export
    self.ScrollView_1 = self.root.ScrollView_1_export
    self.topLayout = self.root.topLayout_export
    self.top_node = self.root.top_node_export

--EXPORT_NODE_END
    uiMgr:addWidgetTouchHandler(self.top.esc, function(sender, eventType) self:exit_call(sender, eventType) end)
    
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
 
function UIResPanel:onExit()
 
end 


function UIResPanel:onEnter()
    self.FileNode_1:setData(6)
    global.loginApi:clickPointReport(nil,14,nil,nil)
end 

function UIResPanel:setData()

    local data = resData:getRes() 

    self.ScrollView_1:setContentSize(cc.size(gdisplay.width, self.top_node:getPositionY()-5))
    
    self.ScrollView_1:setInnerContainerSize(self.ScrollView_1:getContentSize())

    self.ScrollView_1:removeAllChildren()
    local contentSize = self.ScrollView_1:getContentSize().height
    local sH = self.itemLayout:getContentSize().height 
    local sW = self.itemLayout:getContentSize().width 
    local containerSize = sH*(#data)
    if containerSize < self.ScrollView_1:getContentSize().height then
        containerSize = contentSize
    end
    self.ScrollView_1:setInnerContainerSize(cc.size(gdisplay.width, containerSize))
    local pY = containerSize - sH/2

    for i=1,#data do
        local item = UIResItem.new()
        item:setPosition(cc.p(gdisplay.width/2, pY - sH*(i-1)))
        item:setData(data[i])
        self.ScrollView_1:addChild(item)
    end
    self.ScrollView_1:jumpToTop()

    -- 更新自己城池特色加成
    self:checkCityValue()

    -- 资源加成
    self:getResAdd()
end

function UIResPanel:getResAdd()

    self.resAddServer = {}

    local tgReq = {}
    for i=1,4 do
        local temp = {}
        temp.lType = 5
        temp.lBind = i
        table.insert(tgReq, temp)
    end

    -- 仓库保护百分比
    local wareHouse = {}
    wareHouse.lType = global.luaCfg:get_buildings_pos_by(18).funcType
    wareHouse.lBind = 18
    table.insert(tgReq, wareHouse)

    global.gmApi:effectBuffer(tgReq, function (msg)

        if not self.setResBuff or not self.resAddServer then -- 协议返回 方法可能为 nil  
            print("errcor<<<<<<<<<<<<<<< UIResPanel 117")
            return 
        end 
        msg.tgEffect = msg.tgEffect or {}
        for _,v in pairs(msg.tgEffect) do
            if v.tgEffect then 

                if v.lBind <= 4 then
                    local temp = {}
                    temp.lBind = v.lBind
                    temp.lType = v.lType
                    temp.serverData = self:setResBuff(v.tgEffect) 
                    table.insert(self.resAddServer, temp)
                elseif v.lBind == 18 then

                    local addVal = 0
                    local buffs = v.tgEffect or {}
                    for _,vv in pairs(buffs) do
                        if vv.lEffectID == 3060 then
                            addVal = addVal + vv.lVal
                        end
                    end
                    if addVal > 0 then
                        gevent:call(global.gameEvent.EV_ON_RESWAREHOUSE, addVal)
                    end
                end
            end
        end
        resData:setServerBuff(self.resAddServer)
        resData:initData()
        gevent:call(global.gameEvent.EV_ON_UI_CITY_FEATURE)

    end,1)
    

    self:addEventListener(global.gameEvent.EV_ON_LORDE_EQUIP_BUFF_UPDATE,function() --领主装备buff 请求之后刷新 UI 
        
        if global.resData:getOldBuff() then 
            resData:setServerBuff(global.resData:getOldBuff())
            resData:initData()
            gevent:call(global.gameEvent.EV_ON_UI_CITY_FEATURE)
        end 
        
    end)

end

function UIResPanel:setResBuff(msg)
    
    local itemBuff = {}
    local heroBuff = {}
    local techBuff = {}
    local divineBuff = {}
    local cityBuff = {}
    local vipBuff = {}
    local lordBuff={}

    for i,v in ipairs(msg) do

        if v.lFrom == 2 then
            table.insert(heroBuff, v)
        elseif v.lFrom == 3 then
            table.insert(techBuff, v)
        elseif v.lFrom == 4 then
            table.insert(vipBuff, v)
        elseif v.lFrom == 5 then
            table.insert(divineBuff, v)
        elseif v.lFrom == 6 then
            table.insert(itemBuff, v)
        elseif v.lFrom == 7 then
            table.insert(cityBuff, v)
        elseif v.lFrom == 12 then 
            table.insert(lordBuff, v)
        end       
    end

    local temp = {}
    temp.heroBuff = heroBuff
    temp.techBuff = techBuff
    temp.vipBuff = vipBuff
    temp.divineBuff = divineBuff
    temp.itemBuff = itemBuff
    temp.cityBuff = cityBuff
    temp.lordBuff = lordBuff
    return temp
end


function UIResPanel:checkCityValue()
    
    local mainCityId = global.userData:getWorldCityID()
    global.worldApi:getCityDetail(mainCityId,function(msg)

        resData:setOccupyMaxInfo(msg)
        resData:initData()
        gevent:call(global.gameEvent.EV_ON_UI_CITY_FEATURE)
    end)
    
end

function UIResPanel:exit_call(sender, eventType)
    panelMgr:closePanelForBtn("UIResPanel")
end


function UIResPanel:touEvnenter(sender, eventType)

end
--CALLBACKS_FUNCS_END

return UIResPanel

--endregion
