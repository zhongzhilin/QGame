--region UIDetailFirstProItem.lua
--Author : wuwx
--Date   : 2016/10/24
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

local UIDetailFirstProItem  = class("UIDetailFirstProItem", function() return gdisplay.newWidget() end )

function UIDetailFirstProItem:ctor()
    
end

function UIDetailFirstProItem:CreateUI()
    local root = resMgr:createWidget("city/build_info_line")
    self:initUI(root)
end

function UIDetailFirstProItem:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "city/build_info_line")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.intro = self.root.intro_export
    self.icon = self.root.icon_export
    self.now_info = self.root.now_info_export
    self.up_info = self.root.up_info_export
    self.jiahao = self.root.jiahao_export

--EXPORT_NODE_END
end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_END

function UIDetailFirstProItem:setData(data,proId,paraNum,buffData)

    print(proId,paraNum)

    local pro = luaCfg:get_data_type_by(proId)
    self.intro:setString(pro.paraName)

    if proId == 7 then
        global.panelMgr:setTextureFor(self.icon,pro.icon)
    else
        self.icon:loadTexture(pro.icon, ccui.TextureResType.plistType)
    end

    local buffs = buffData.tgEffect or {}
    local allAdd = 0
    local isNeedShowTail = false
    for _,v in pairs(buffs) do

        if v.lTarget == buffData.lBind or v.lTarget == 0 then
            local buff_conf = luaCfg:get_data_type_by(v.lEffectID)              
            if buff_conf then
                if buff_conf.typeId == pro.typeId then

                    --pro 要显示的buff    buff_conf 服务器发过来的buff
                    if v.lFrom == 1 then 
                    else
                        if pro.extra == "%" and buff_conf.extra == "%" then                        
                            allAdd = math.floor(allAdd + v.lVal / buff_conf.magnification)                       
                        elseif pro.extra == "" and buff_conf.extra == "%" then                        
                            allAdd = math.floor(allAdd + paraNum * v.lVal / 100 / buff_conf.magnification)
                        elseif pro.extra == "" and buff_conf.extra == "" then
                            allAdd = math.floor(allAdd + v.lVal / buff_conf.magnification)
                        end
                    end
                end            
            end
        end
    end

    allAdd = math.floor(allAdd)
    if allAdd <= 0 then
        self.up_info:setVisible(false)
        self.jiahao:setVisible(false)
    else

        self.up_info:setVisible(true)
        self.jiahao:setVisible(true)

        if pro.extra == "%" then
            if proId == 3060 then
                local upProject = math.ceil(global.resData:getStoreMax()*allAdd/100)
                self.up_info:setString(allAdd .. "%" ..  "(" .. upProject .. ")")
            else
                self.up_info:setString(allAdd .. "%")
            end
        else
            self.up_info:setString(allAdd)
        end        
    end

    -- 仓库资源百分比
    if proId == 3060 then
        local resProject = math.ceil(global.resData:getStoreMax()*paraNum/100)
        self.now_info:setString(paraNum..pro.extra .. "(" .. resProject .. ")")
    else
        self.now_info:setString(paraNum..pro.extra)
    end

end

return UIDetailFirstProItem

--endregion
