--region UIUDonateRankItem.lua
--Author : wuwx
--Date   : 2017/02/16
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIUDonateRankItem  = class("UIUDonateRankItem", function() return gdisplay.newWidget() end )

function UIUDonateRankItem:ctor()
    self:CreateUI()
end

function UIUDonateRankItem:CreateUI()
    local root = resMgr:createWidget("union/union_donate_top_list")
    self:initUI(root)
end

function UIUDonateRankItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "union/union_donate_top_list")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.btn_bg = self.root.btn_bg_export
    self.rank_pic = self.root.btn_bg_export.rank_pic_export
    self.rank_num = self.root.btn_bg_export.rank_num_export
    self.portrait_node = self.root.btn_bg_export.portrait_node_export
    self.headFrame = self.root.btn_bg_export.portrait_node_export.headFrame_export
    self.name = self.root.btn_bg_export.name_export
    self.icon = self.root.btn_bg_export.icon_export
    self.num = self.root.btn_bg_export.num_export

--EXPORT_NODE_END
    self.btn_bg:setZoomScale(WCONST.BUTTON_SCALE.SMALL)
    self.btn_bg:setSwallowTouches(false)
end

local bgViews = {
    [1] = "rank_1st_bg.jpg",
    [2] = "rank_2nd_bg.jpg",
    [3] = "rank_3rd_bg.jpg",
    [4] = "wall_label_bg.jpg",
}
local rankViews = {
    [1] = "ui_surface_icon/rank_1st_icon.png",
    [2] = "ui_surface_icon/rank_2nd_icon.png",
    [3] = "ui_surface_icon/rank_3rd_icon.png",
}
local colors = {
    [1] = cc.c3b(255,205,69),
    [2] = cc.c3b(249,165,51),
    [3] = cc.c3b(164,110,40),
    [4] = cc.c3b(151,106,65),
}
function UIUDonateRankItem:setData(data)
    self.data = data
    
    self.rank_num:setString(data.lRank)
    self.num:setString(data.lValue)


    self.headFrame:setVisible(false)

    if data.lRank <= 3 then
        self.rank_pic:setVisible(true)
        self.rank_num:setVisible(false)
        self.rank_pic:setSpriteFrame(rankViews[data.lRank])
        -- global.panelMgr:setTextureFor(self.rank_pic,rankViews[data.lRank])
        self.btn_bg:loadTextures(bgViews[data.lRank],bgViews[data.lRank],bgViews[data.lRank],ccui.TextureResType.plistType)
        -- global.panelMgr:setTextureFor(self.btn_bg,bgViews[data.lRank])
        self.name:setTextColor(colors[data.lRank])
    else
        self.rank_pic:setVisible(false)
        self.rank_num:setVisible(true)
        self.btn_bg:loadTextures(bgViews[4],bgViews[4],bgViews[4],ccui.TextureResType.plistType)
        self.name:setTextColor(colors[4])
    end

    -- 澶村儚
    if data.szParams and data.szParams[1] then
        local head = global.luaCfg:get_rolehead_by(tonumber(data.szParams[1]))
        head = global.headData:convertHeadData(data,head)
        global.tools:setCircleAvatar(self.portrait_node, head)
    end

    if data.szParams and data.szParams[2] then
        self.name:setString(data.szParams[2])
    end

    if data.szParams and data.szParams[3] then
        self:setHeadFrame(data.szParams[3])
    end

end


function UIUDonateRankItem:setHeadFrame(id)

    local headInfo = global.luaCfg:get_role_frame_by(tonumber( id))

    if headInfo and headInfo.pic then
        -- print("设置头像框 //////////////")
        self.headFrame:setVisible(true)
        global.panelMgr:setTextureFor(self.headFrame,headInfo.pic)
    else 
    end 
end 


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

return UIUDonateRankItem

--endregion
