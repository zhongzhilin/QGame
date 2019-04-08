--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

module("IconRes", package.seeall)

function get_item_icon(itemId)
    local itemtalbe = global.luaCfg:get_itemtable_by(itemId)
--    assert(itemtalbe, string.format(""))
    if itemtalbe then
        return itemtalbe.icon_id
    else
        return ""
    end
end

function get_equip_icon(equipId)
    local item_id = global.luaCfg.equipCfg:getItemTid(equipId)
    return get_item_icon(item_id)
end

function get_hero_show_img_by_job(jobId)
    local luaCfg = global.luaCfg
    local jobCfg = luaCfg:get_job_by(jobId)
    local heroPropCfg = luaCfg:get_hero_property_by(jobCfg.hero_id)
    local heroCfg = luaCfg:get_hero_by(heroPropCfg.avatar_id)
    return heroCfg.show_id
end

--endregion
