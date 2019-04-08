--region UIChatPrivateR.lua
--Author : yyt
--Date   : 2017/01/05
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local chat_cfg = require("asset.config.chat_cfg")
local luaCfg = global.luaCfg

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIChatPrivateR  = class("UIChatPrivateR", function() return gdisplay.newWidget() end )

local ItemControl = require("game.UI.chat.item.ItemControl")
local UIPetStar1 = require("game.UI.pet.UIPetStar1")

function UIChatPrivateR:ctor()
    self:CreateUI()
end

function UIChatPrivateR:CreateUI()
    local root = resMgr:createWidget("chat/chat_private_r")
    self:initUI(root)
end

function UIChatPrivateR:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chat/chat_private_r")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Panel = self.root.Panel_export
    self.NodeTitle = self.root.NodeTitle_export
    self.IconNode = self.root.NodeTitle_export.btnHead.IconNode_export
    self.headFrame = self.root.NodeTitle_export.btnHead.IconNode_export.headFrame_export
    self.flagNode = self.root.NodeTitle_export.flagNode_export
    self.flag = self.root.NodeTitle_export.flagNode_export.flag_export
    self.flag = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.flag, self.root.NodeTitle_export.flagNode_export.flag_export)
    self.vipNode = self.root.NodeTitle_export.vipNode_export
    self.vipbg = self.root.NodeTitle_export.vipNode_export.vipbg_export
    self.txtVip = self.root.NodeTitle_export.vipNode_export.txtVip_export
    self.txtVip1 = self.root.NodeTitle_export.vipNode_export.txtVip1_export
    self.txtName = self.root.NodeTitle_export.txtName_export
    self.txtUnion = self.root.NodeTitle_export.txtUnion_export
    self.timeNode = self.root.NodeTitle_export.timeNode_export
    self.txtBtn = self.root.txtBtn_export
    self.txtContent = self.root.txtBtn_export.txtContent_export
    self.label = self.root.txtBtn_export.label_export
    self.unionFlag = self.root.txtBtn_export.unionFlag_export
    self.unionFlag = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.unionFlag, self.root.txtBtn_export.unionFlag_export)
    self.txtContentLabel = self.root.txtBtn_export.txtContentLabel_export

    uiMgr:addWidgetTouchHandler(self.root.NodeTitle_export.btnHead, function(sender, eventType) self:headClickHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.txtBtn, function(sender, eventType) self:txtClickHandler(sender, eventType) end)
--EXPORT_NODE_END
    self.textNamePos = self.txtName:getPositionX()
    self.ItemControl = ItemControl.new(self.root)

end

function UIChatPrivateR:onEnter()
    self.m_eventListenerCustomList = self.m_eventListenerCustomList or {}
end

function UIChatPrivateR:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
    self.m_eventListenerCustomList = {}
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

function UIChatPrivateR:setData(data)

    self.m_eventListenerCustomList = self.m_eventListenerCustomList or {}

    local tSize = cc.size(460, 24)
    if data.itemKind == 2 and data.tagSpl and data.tagSpl.lKey == 10 then
        self.txtContent:setAnchorPoint(cc.p(0, 0.5))
        self.txtContent:setContentSize(cc.size(tSize.width - 60, tSize.height))
    else
        self.txtContent:setPositionX(483)
        self.txtContent:setAnchorPoint(cc.p(1, 0.5))
        self.txtContent:setContentSize(tSize)
    end

    self.data = data
    self.ItemControl:setData(data)

    -- 下载用户头像
    local tdata = {data.szCustomIco}
    local storagePath = global.headData:downloadPngzips(tdata)
    table.insertTo(self.m_eventListenerCustomList,global.headData:addDownLoadCall(self,storagePath,function()
        -- body
        if self and not tolua.isnull(self.tableView) then
            self.showHead:setData(tdata)
        end
    end))
    
    self.txtBtn:loadTextureNormal("ui_surface_icon/mail_txt_r.png",ccui.TextureResType.plistType)
    self.txtBtn:loadTexturePressed("ui_surface_icon/mail_txt_r.png",ccui.TextureResType.plistType) 

    if data.itemKind == 2 then
        
        if data.tagSpl.lKey == 1 then
            self.txtBtn:loadTextureNormal("ui_surface_icon/mail_txt_war2.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/mail_txt_war2.png",ccui.TextureResType.plistType) 
            
        elseif data.tagSpl.lKey == 2 then
            
            self.txtBtn:loadTextureNormal("ui_surface_icon/mail_txt_share2.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/mail_txt_share2.png",ccui.TextureResType.plistType) 
        elseif data.tagSpl.lKey == 3 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/mail_txt_share2.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/mail_txt_share2.png",ccui.TextureResType.plistType) 
        elseif data.tagSpl.lKey == 4 or data.tagSpl.lKey == 9 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/hero_share_1.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/hero_share_1.png",ccui.TextureResType.plistType) 
        elseif data.tagSpl.lKey == 7 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/mail_recruit1.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/mail_recruit1.png",ccui.TextureResType.plistType)  
        elseif data.tagSpl.lKey == 8 or data.tagSpl.lKey == 12 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/mail_better03.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/mail_better03.png",ccui.TextureResType.plistType) 
        elseif data.tagSpl.lKey == 10 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/union_gift2.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/union_gift2.png",ccui.TextureResType.plistType)
        elseif data.tagSpl.lKey == 11 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/share_pos_2.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/share_pos_2.png",ccui.TextureResType.plistType) 
        end        
    end
    self.txtBtn:setCapInsets(cc.rect(22,40,20,8))      -- 设置九宫格拉伸


    self.unionFlag:setVisible(false)
    self.flagNode:setVisible(false)
    if not tolua.isnull(self.unonWarIcon) then
        self.unonWarIcon:setVisible(false)
    end
    if not tolua.isnull(self.petStar) then
        self.petStar:setVisible(false)
    end
    if not tolua.isnull(self.unonGift) then
        self.unonGift:setVisible(false)
    end

    local curChatChannel = global.chatData:getCurLType()
    if curChatChannel ~= 1 then

        local temp = self.ItemControl:getData()

        local rightPos = chat_cfg.chat_pos.namePos[2]
        local unionInfo = global.unionData:getInUnion()
        if unionInfo and unionInfo.lTotem and curChatChannel == 2 then
            self.flagNode:setVisible(true)
            self.flagNode:setPositionX(rightPos)
            self.flag:setData(unionInfo.lTotem)
            rightPos = chat_cfg.chat_pos.namePos1[2]
        end

        if temp.lVipLevel > 0 then
            self.vipNode:setPositionX(rightPos)
            rightPos = rightPos - 85

            self.txtVip1:setVisible(false)
            self.txtVip:setPositionX(-30)
            if temp.lVipLevel >= 10 then
                self.txtVip:setString(temp.lVipLevel/10)
                self.txtVip1:setString(temp.lVipLevel%10)
                self.txtVip1:setVisible(true)   
                self.txtVip:setPositionX(-35)
            end

        end

        self.txtName:setPositionX(rightPos)
        if temp.union_name then              
            self.txtUnion:setPositionX(rightPos - self.txtName:getContentSize().width)
        end

        local hL = self.txtBtn:getContentSize().height
        -- 联盟招募
        if data.itemKind == 2 and data.tagSpl.lKey == 7 then
            self.unionFlag:setVisible(true)
            self.label:setString(luaCfg:get_local_string(10776, ""))
            local wL = self.label:getContentSize().width
            self.unionFlag:setPosition(cc.p(26, hL-30))
            local szParam = global.tools:strSplit(data.tagSpl.szInfo, '@')   
            szParam[1] = szParam[1] or ""
            self.unionFlag:setData(tonumber(szParam[1]))
        end

        -- 联盟支援
        if data.itemKind == 2 and (data.tagSpl.lKey == 8 or data.tagSpl.lKey == 12) then
            if tolua.isnull(self.unonWarIcon) then
                self.unonWarIcon = cc.Sprite:create()
                self.unonWarIcon:setSpriteFrame("ui_surface_icon/mail_better02.png")
                self.txtBtn:addChild(self.unonWarIcon)
            end
            self.unonWarIcon:setVisible(true)
            self.unonWarIcon:setPosition(cc.p(35, hL-26))
        end

        -- 神兽分享
        if data.itemKind == 2 and data.tagSpl.lKey == 11 then
            if not self.petStar then
                self.petStar = UIPetStar1.new() 
                self.petStar:CreateUI()
                self.txtBtn:addChild(self.petStar)
            end
            self.petStar:setVisible(true)
            self.petStar:setPosition(cc.p(40, 10))
            self.petStar:setData(data.tagSpl.lValue)
        end

        -- 联盟礼包
        if data.itemKind == 2 and data.tagSpl.lKey == 10 then
            if tolua.isnull(self.unonGift) then
                self.unonGift = cc.Sprite:create()
                self.unonGift:setSpriteFrame("list1.png")
                self.txtBtn:addChild(self.unonGift)
                self.unonGift:setScale(0.8)
            end 
            self.unonGift:setVisible(true)
            self.unonGift:setPosition(cc.p(35, hL-45))
            self.txtContent:setPositionX(60)
        end

    end
    
end

function UIChatPrivateR:txtClickHandler(sender, eventType)
    
    print("--------R txtClickHandler ")
end

function UIChatPrivateR:sendFailHandler(sender, eventType)

    print("-------- sendFailHandler ")

end

function UIChatPrivateR:headClickHandler(sender, eventType)
    print("--------R headClickHandler ")
end
--CALLBACKS_FUNCS_END

return UIChatPrivateR

--endregion
