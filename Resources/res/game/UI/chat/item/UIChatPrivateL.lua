--region UIChatPrivateL.lua
--Author : yyt
--Date   : 2017/01/04
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
local chat_cfg = require("asset.config.chat_cfg")

-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIUnionFlagWidget = require("game.UI.union.widget.UIUnionFlagWidget")
--REQUIRE_CLASS_END

local UIChatPrivateL  = class("UIChatPrivateL", function() return gdisplay.newWidget() end )

local ItemControl = require("game.UI.chat.item.ItemControl")
local UIPetStar1 = require("game.UI.pet.UIPetStar1")

function UIChatPrivateL:ctor()
    self:CreateUI()
end

function UIChatPrivateL:CreateUI()
    local root = resMgr:createWidget("chat/chat_private_l")
    self:initUI(root)
end

function UIChatPrivateL:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "chat/chat_private_l")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.Panel = self.root.Panel_export
    self.txtBtn = self.root.txtBtn_export
    self.txtContent = self.root.txtBtn_export.txtContent_export
    self.unionFlag = self.root.txtBtn_export.unionFlag_export
    self.unionFlag = UIUnionFlagWidget.new()
    uiMgr:configNestClass(self.unionFlag, self.root.txtBtn_export.unionFlag_export)
    self.unonWarIcon = self.root.txtBtn_export.unonWarIcon_export
    self.label = self.root.txtBtn_export.label_export
    self.transLine = self.root.txtBtn_export.transLine_export
    self.txtContentLabel = self.root.txtBtn_export.txtContentLabel_export
    self.transContent = self.root.txtBtn_export.transContent_export
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
    self.sysNode = self.root.NodeTitle_export.sysNode_export
    self.txtName = self.root.NodeTitle_export.txtName_export
    self.txtUnion = self.root.NodeTitle_export.txtUnion_export
    self.timeNode = self.root.NodeTitle_export.timeNode_export
    self.translate = self.root.translate_export
    self.transmalnPic = self.root.translate_export.transmalnPic_export
    self.transmaln = self.root.translate_export.transmaln_mlan_3_export

    uiMgr:addWidgetTouchHandler(self.txtBtn, function(sender, eventType) self:txtClickHandler(sender, eventType) end)
    uiMgr:addWidgetTouchHandler(self.root.NodeTitle_export.btnHead, function(sender, eventType) self:headClickHandler(sender, eventType) end)
--EXPORT_NODE_END

    self.ItemControl = ItemControl.new(self.root)

end

function UIChatPrivateL:onExit()
    for i,v in pairs(self.m_eventListenerCustomList) do
        cc.Director:getInstance():getEventDispatcher():removeEventListener(v)
    end
    self.m_eventListenerCustomList = {}
end
--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN
function UIChatPrivateL:onEnter()

    self:addEventListener(global.gameEvent.EV_ON_CHAT_TRANSLATEING,function(event, transKey)

        if not self.data then return end
        local md5Key = global.chatData:getTranslateKey(self.data) 
        if transKey and md5Key == transKey then
            self:showFlush()
        else
            self:hideFlush()
        end
    end)

    self:addEventListener(global.gameEvent.EV_ON_NET_SHOW_CIRCLE,function()
        if self.hideFlush then
            self:hideFlush()
        end
    end)
end

function UIChatPrivateL:hideFlush()
    if not tolua.isnull(self.flushNode) then
        self.flushNode:setVisible(false)
    end
end
function UIChatPrivateL:showFlush()

    if tolua.isnull(self.flushNode) then
        self.flushNode = resMgr:createCsbAction("world/map_Load", "animation0", true)
        self.flushNode:setScale(0.8)
        self.root:addChild(self.flushNode)
    end
    self.flushNode:setVisible(true)
    local x = self.txtBtn:getPositionX()+self.txtBtn:getContentSize().width + 25
    local y = self.txtBtn:getPositionY()+self.txtBtn:getContentSize().height/2
    self.flushNode:setPosition(cc.p(x, y))

end

function UIChatPrivateL:setData(data)

    self.m_eventListenerCustomList = self.m_eventListenerCustomList or {}

    local tSize = cc.size(460, 24)
    if data.itemKind == 2 and data.tagSpl and data.tagSpl.lKey == 10 then
        self.txtContent:setContentSize(cc.size(tSize.width - 60, tSize.height))
    else
        self.txtContent:setPositionX(35)
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

    self.txtBtn:loadTextureNormal("ui_surface_icon/mail_txt_l.png",ccui.TextureResType.plistType)
    self.txtBtn:loadTexturePressed("ui_surface_icon/mail_txt_l.png",ccui.TextureResType.plistType) 

    if data.itemKind == 2 then

        if data.tagSpl.lKey == 1 then
            self.txtBtn:loadTextureNormal("ui_surface_icon/mail_txt_war.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/mail_txt_war.png",ccui.TextureResType.plistType) 
            
        elseif data.tagSpl.lKey == 2 then
            
            self.txtBtn:loadTextureNormal("ui_surface_icon/mail_txt_share.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/mail_txt_share.png",ccui.TextureResType.plistType) 
        elseif data.tagSpl.lKey == 3 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/mail_txt_share.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/mail_txt_share.png",ccui.TextureResType.plistType) 
        elseif data.tagSpl.lKey == 4 or data.tagSpl.lKey == 9 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/hero_share_2.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/hero_share_2.png",ccui.TextureResType.plistType) 
        elseif data.tagSpl.lKey == 6 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/pub_bg.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/pub_bg.png",ccui.TextureResType.plistType) 
        elseif data.tagSpl.lKey == 7 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/mail_recruit2.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/mail_recruit2.png",ccui.TextureResType.plistType)     
        elseif data.tagSpl.lKey == 8 or data.tagSpl.lKey == 12 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/mail_better01.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/mail_better01.png",ccui.TextureResType.plistType) 
        elseif data.tagSpl.lKey == 10 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/union_gift1.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/union_gift1.png",ccui.TextureResType.plistType) 
        elseif data.tagSpl.lKey == 11 then

            self.txtBtn:loadTextureNormal("ui_surface_icon/share_pos_1.png",ccui.TextureResType.plistType)
            self.txtBtn:loadTexturePressed("ui_surface_icon/share_pos_1.png",ccui.TextureResType.plistType) 
        end        
    end
    self.txtBtn:setCapInsets(cc.rect(55,40,12,8))    -- 设置九宫格拉伸

    self.sysNode:setVisible(false)
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
        if temp.lFrom == 0 then  -- 系统公告
            self.sysNode:setVisible(true)
            self.txtUnion:setVisible(false)
            self.txtName:setVisible(false)
            self.vipNode:setVisible(false)
            self.flagNode:setVisible(false)
        else

            local leftPos = chat_cfg.chat_pos.namePos[1]
            if temp.lTotem and temp.lAllyID and curChatChannel == 2 and temp.lAllyID > 0 then
                self.flagNode:setVisible(true)
                self.flagNode:setPositionX(leftPos+10)
                self.flag:setData(temp.lTotem)
                leftPos = chat_cfg.chat_pos.namePos1[1]
            end

            if temp.lVipLevel > 0 then
                self.vipNode:setPositionX(leftPos+10)
                leftPos = leftPos + 88

                self.txtVip1:setVisible(false)
                self.txtVip:setPositionX(50)
                if temp.lVipLevel >= 10 then
                    self.txtVip:setString(temp.lVipLevel/10)
                    self.txtVip1:setString(temp.lVipLevel%10)
                    self.txtVip1:setVisible(true)   
                    self.txtVip:setPositionX(45)
                end

            end
            self.txtUnion:setPositionX(leftPos)
            if temp.union_name then
                self.txtName:setPositionX(self.txtUnion:getContentSize().width + leftPos - 10)
            else
                self.txtName:setPositionX(leftPos)
            end 
        end

        local hL = self.txtBtn:getContentSize().height
        -- 联盟招募
        if data.itemKind == 2 and data.tagSpl.lKey == 7 then
            self.unionFlag:setVisible(true)
            self.unionFlag:setPosition(cc.p(50, hL-30))
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
            self.unonWarIcon:setPosition(cc.p(55, hL-26))
        end

        -- 神兽分享
        if data.itemKind == 2 and data.tagSpl.lKey == 11 then

            if tolua.isnull(petStar) then
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
            self.unonGift:setPosition(cc.p(55, hL-45))
            self.txtContent:setPositionX(80)
        end
        
    end

    -- 翻译状态
    self.translate:setVisible(false)
    self.transLine:setVisible(false)
    self.txtBtn:setPositionY(18)
    self.transContent:setVisible(false)

    if data.tranState == 1 then
        self.translate:setVisible(true)
        self.transLine:setVisible(true)
        self.transContent:setVisible(true)

        self.translate:setContentSize(cc.size(self.transmaln:getContentSize().width+41, 34))
        self.transmaln:setPositionX(self.translate:getContentSize().width-10)
        self.transmalnPic:setPositionX(self.transmaln:getPositionX()-self.transmaln:getContentSize().width)
        self.translate:setPositionX(self.txtBtn:getPositionX()+self.txtBtn:getContentSize().width - 10)

        self.transLine:setContentSize(cc.size(self.txtBtn:getContentSize().width - 40 ,2))
        self.txtContentLabel:setTextAreaSize(cc.size(self.txtContentLabel:getContentSize().width, 0))
        self.txtContentLabel:setString(data.destStr)
        local label = self.txtContentLabel:getVirtualRenderer()
        local desSize = label:getContentSize()
        self.transLine:setPositionY(self.txtBtn:getContentSize().height - desSize.height - 37)

        -- 翻译文本显示
        self.transContent:setTailEnabled(false)   
        self.transContent:setTextAreaSize(cc.size(self.transContent:getContentSize().width, 0))
        self.transContent:setString(self.data.tranStr)
        local label1 = self.transContent:getVirtualRenderer()
        self.transContent:setContentSize(label1:getContentSize())
        self.txtContent:setString(self.data.destStr)
        self.transContent:setPosition(cc.p(self.txtContent:getPositionX() + self.ItemControl:getOffetXAndroid(),  self.transLine:getPositionY()-self.transContent:getContentSize().height/2 - 10))

        self.txtBtn:setPositionY(self.txtBtn:getPositionY()+chat_cfg.chat_item_ui.transNode_height)
        self.NodeTitle:setPositionY(self.NodeTitle:getPositionY()+chat_cfg.chat_item_ui.transNode_height)
    end

end

function UIChatPrivateL:txtClickHandler(sender, eventType)

    print("--------L txtClickHandler ")
end

function UIChatPrivateL:headClickHandler(sender, eventType)

    print("--------L headClickHandler ")
end
--CALLBACKS_FUNCS_END

return UIChatPrivateL

--endregion
