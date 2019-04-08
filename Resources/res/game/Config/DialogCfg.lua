--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local DialogCfg = {}

function DialogCfg:getKeyParams(dialogCfg, keyNum)
    local dialogKey = "func_key"..keyNum
    if dialogCfg and dialogCfg[dialogKey] ~= "" then
        return
        {
            name = dialogCfg["name_key"..keyNum], 
            func = dialogCfg[dialogKey], 
            params={dialogCfg["param1_key"..keyNum], dialogCfg["param2_key"..keyNum]}
        }
    end
end

function DialogCfg:dialogHasKeyFunc(dialogCfg)
    return self:getKeyParams(dialogCfg, 1) and self:getKeyParams(dialogCfg, 2)
end

function DialogCfg:getQuestKeyDialogParams(questCfg)
    return {name = questCfg.key_relate, func=NPC_DIALOG_KEY.NEXT, params = {questCfg.dialog_relate}}
end

function DialogCfg:getRecieveQuestDialogParams(questCfg)
    local str = global.luaCfg:get_local_string(10108)
    return {name = str..questCfg.quest_name, func= NPC_DIALOG_KEY.RECIEVE_QUEST, params = {questCfg.id}}
end

return DialogCfg

--endregion
