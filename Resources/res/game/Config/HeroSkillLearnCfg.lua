--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local HeroSkillLearnCfg = {}

function HeroSkillLearnCfg:initSkillLearn()
    self.skillLeanMap_ = {}

    local skillLearn = global.luaCfg:skilllearn()
    for id, item in ipairs(skillLearn) do 
        if not self.skillLeanMap_[item.job_id] then
            self.skillLeanMap_[item.job_id] = {}
        end

        if not self.skillLeanMap_[item.job_id][item.learn_id] then
            self.skillLeanMap_[item.job_id][item.learn_id] = {}
        end
        table.insert(self.skillLeanMap_[item.job_id][item.learn_id], item)
    end
end

function HeroSkillLearnCfg:getSkillLearnCfg(job, learnId, level)
    assert(self.skillLeanMap_, "未初始化技能学校表")
    local jobSkillLearn = self.skillLeanMap_[job]

    assert(jobSkillLearn, string.format("错误， 未找到技能学习配置 职业<%d>", job))

    local learnList = jobSkillLearn[learnId]
    -- TODO by wenlong
    if learnList then
        for i, learnCfg in ipairs(learnList) do
            if learnCfg.maxlevel >= level and learnCfg.minlevel<=level then
                return learnCfg
            end
        end

        assert(false, string.format("错误， 未找到技能学习配置 level<%d>", level))
    end
end

function HeroSkillLearnCfg:getSkillLearnUnlockLevel(job, learnId)
    assert(self.skillLeanMap_, "未初始化技能学校表")
    local jobSkillLearn = self.skillLeanMap_[job]

    assert(jobSkillLearn, string.format("错误， 未找到技能学习配置 职业<%d>", job))

    local learnList = jobSkillLearn[learnId]
    return learnList[1].unlocklevel
end

function HeroSkillLearnCfg:getSkillLearnListByJob(job)
    local heroSkillList = {}
    local commonIntiativeSkillList = {}
    local commonPassiveSkillList = {}

    local jobSkillLearn = self.skillLeanMap_[job]
    assert(jobSkillLearn, string.format("错误 未找到对应职业的技能学习表 职业<%d>", job))

    for i, skillLeranList in pairs(jobSkillLearn) do
        local oneSkillLearnCfg = skillLeranList[1]
        if oneSkillLearnCfg.available ~= 0 then
            if oneSkillLearnCfg.type_id == 1 then
                table.insert(heroSkillList, oneSkillLearnCfg.learn_id)
            elseif oneSkillLearnCfg.type_id == 2 then
                table.insert(commonPassiveSkillList, oneSkillLearnCfg.learn_id)
            end
        end
    end

    local function sortFunc(a, b)
        return a < b
    end

    table.sort(heroSkillList, sortFunc)
    table.sort(commonIntiativeSkillList, sortFunc)
    table.sort(commonPassiveSkillList, sortFunc)

    return heroSkillList, commonIntiativeSkillList, commonPassiveSkillList
end

function HeroSkillLearnCfg:initLearnData(learnId)
    local data = {}
    local job = global.userData:GetCareer()
    local unlockLv = global.luaCfg.heroSkillLearnCfg:getSkillLearnUnlockLevel(job, learnId)
    local unlock =  global.userData:checkLevel(unlockLv)
    data.learnId = learnId
    data.unlock = unlock
    data.unlockLv = unlockLv

    local learnData = global.userData:GetSkillDataByLearnId(learnId)
    local cfgLv = math.max(learnData and learnData.lv or 1, 1)
    local learnCfg = global.luaCfg.heroSkillLearnCfg:getSkillLearnCfg(job, learnId, cfgLv)

    local masterSkill = global.luaCfg:get_master_skill_by(learnCfg.battleskill_id)
    assert(masterSkill, string.format("配置错误， 未找到maseter_skil<%d>", learnCfg.battleskill_id))
    data.masterSkill = masterSkill
    data.learnCfg = learnCfg
    data.level = learnData and learnData.lv or 0
    data.nextLevel = math.min(data.level + 1, global.userData:GetLevel())
    data.reachMax = data.level >= global.userData:GetLevel()

    return data
end

function HeroSkillLearnCfg:getMasterSkillAffects(affectStr)
    local ids_str = string.split(affectStr, "|")

    local masterAffects = {}
    for i, str in ipairs(ids_str) do
        local me = global.luaCfg:get_master_affect_by(tonumber(str))
        table.insert(masterAffects, me)
    end

    return masterAffects
end

function HeroSkillLearnCfg:getAffectsValue(affects, labelName, level)
    local avliableLabels = {"hurt", "dps", "antiarmor", "armor", "life", "spy"}
    assert(table.indexof(avliableLabels, labelName), string.format("错误， 未定义的描述标签<%s>", labelName))

    local value = 0
    for i, affect in ipairs(affects) do
        if labelName == "hurt" then
            if affect.type == "Hurt" then
                value = tonumber(affect.args) + affect.args_pro * (level - 1)
                break
            end
        else
            local curr_v = affect["add_"..labelName] + affect["add_"..labelName.."_pro"] * (level - 1)
            value = value + curr_v
        end
    end

    return value
end

function HeroSkillLearnCfg:getMasterSkillEffectDesc(learnData)
    local currLv = learnData.level > 0 and learnData.level or 1
    local skillLv = currLv - learnData.learnCfg.minlevel + 1
    local masterSkillDesc = learnData.masterSkill.desc
    local masterAffects = self:getMasterSkillAffects(learnData.masterSkill.affect)

    local pattern = "{(.-)}"
    for label in string.gmatch(masterSkillDesc, pattern) do
        local value = self:getAffectsValue(masterAffects, label, skillLv)
        masterSkillDesc = string.gsub(masterSkillDesc, string.format("{%s}", label),tostring(value))
    end

    return masterSkillDesc
end

return HeroSkillLearnCfg

--endregion
