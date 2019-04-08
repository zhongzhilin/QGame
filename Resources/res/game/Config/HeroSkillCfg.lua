--region *.lua
--Date
--author wuwx
--此文件由[BabeLua]插件自动生成

local HeroSkillCfg = {}
local luaCfg = global.luaCfg

function HeroSkillCfg:initSkill()
    self.skillList_ = {}
    self.skillMap_ = global.luaCfg:tactic()
    for id, item in pairs(self.skillMap_ ) do 
        table.insert(self.skillList_, item)
    end
    table.sort(self.skillList_, function(a,b) 
        return b.id > a.id
    end)
end

function HeroSkillCfg:getSkillList()
    assert(self.skillList_, "未初始化技能学校表")
    return self.skillList_
end

-- 公会等级对应战术研究等级上限取值为：公会等级*10。
-- 自身等级对应战术研究等级上限取值为：超过40级部分数值/5+5
-- 公会贡献对应战术研究等级上限取值为：公会贡献/150+5
-- 实际等级上限取上述3者的最小值
function HeroSkillCfg:getTacticLimitLevel()
    local userLv = math.floor((global.userData:GetLevel()-40)/5)+5
    local limit = {}
    limit[0] = userLv
    limit[1] = 1
    limit[2] = userLv
    limit[3] = 1
    return limit
end


function HeroSkillCfg:getCurrToSomelvNeedexpForTactic(currlv,deslv,currexp)
    local sumExp = 0
    for i = currlv+1,deslv do
        sumExp = sumExp + luaCfg:get_levelup_by(i).tactic_exp
    end
    sumExp = (sumExp == 0) and 0 or (sumExp-currexp)
    return sumExp
end

return HeroSkillCfg

--endregion
