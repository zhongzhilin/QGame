--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local QuestData = {}

local function sortQuest(a, b)
    if a.tid == b.tid then
        return false
    end
   return a.tid < b.tid
end

function QuestData:init(questInfo)
    self.waitList = {}
    self.currentQuests = {}

    self:setCurrentQuests(questInfo.main_quest.quests)
    self:setWaitQuests(questInfo.main_quest.wait_quests)
end

function QuestData:setCurrentQuests(quests)
    self.currentQuests = quests
end

function QuestData:getCurrentQuests()
    table.sort(self.currentQuests, sortQuest)
    return self.currentQuests
end

function QuestData:setWaitQuests(waitList)
    self.waitList = waitList
end

function QuestData:getWaitQuests()
    return self.waitList
end

function QuestData:addNewWaitQuest(tid)
    table.insert(self.waitList, {tid = tid, state = WCONST.QUEST.STATE.WAIT})

    gevent:call(global.gameEvent.EV_ON_QUEST_WAIT_NOTIFY)
end

function QuestData:removeWaitQuest(tid)
    for i, quest in ipairs(self.waitList) do
        if quest.tid == tid then
            table.remove(self.waitList, i)
            break
        end
    end
end

function QuestData:canAutoCommit(quest)
    if quest.state == WCONST.QUEST.STATE.COMPLETE then
        local quest_table = global.luaCfg:get_quest_by(quest.tid)
        return quest_table.autocommit == 1
    end

    return false
end

function QuestData:getCurrentQuestInKind()
    local currentQuests = clone(self:getCurrentQuests())

    local function findKindList(datas, kind)
        for i, data in ipairs(datas) do 
            if data.kind == kind then
                return data
            end
        end
    end

    --{kind=1, list={}}
    local kindsData = {}
    for i, quest in ipairs(currentQuests) do 
        local questCfg = global.luaCfg:get_quest_by(quest.tid)
        local data = findKindList(kindsData, questCfg.kind)
        if not data then
            data = {kind=questCfg.kind, list={}}
            table.insert(kindsData, data)
        end
        table.insert(data.list, quest)
    end

    local function sortFunc(a, b)
        return a.kind <= b.kind
    end
    table.sort(kindsData, sortFunc)

    return kindsData
end

function QuestData:isTalkGoleInProcess(dialogId)
    for i, task in ipairs(self.currentQuests or {}) do
        if task.state == WCONST.QUEST.STATE.RECEIVE then
            local questCfg = global.luaCfg:get_quest_by(task.tid)
            if questCfg.goal[1] == QUEST_CONST.QUSET_GOAL.TALK and 
               dialogId == questCfg.goal[4] then
                return task.tid
            end
        end
    end
end

function QuestData:getQuestByTid(tid)
    for i, quest in ipairs(self.currentQuests or {}) do
        if quest.tid == tid then
            return quest
        end
    end
end

function QuestData:addNewQuest(quest)
    if self:getQuestByTid(quest.tid) then
        return
    end

    table.insert(self.currentQuests, quest)

    gevent:call(global.gameEvent.EV_ON_QUEST_LIST_CHANGE, quest)
end

function QuestData:remvoeQuestByTid(tid)
    for i, quest in ipairs(self.currentQuests) do
        if quest.tid == tid then
            table.remove(self.currentQuests, i)
            gevent:call(global.gameEvent.EV_ON_QUEST_LIST_CHANGE, quest)
            break
        end
    end  
end

function QuestData:remvoeQuest(toRemoveQuest)
    self:remvoeQuestByTid(toRemoveQuest.tid)
end

function QuestData:updateQuestState(quest)
    local currQuest = self:getQuestByTid(quest.tid)
    if currQuest and quest.tid == currQuest.tid then
        currQuest.count = quest.count
        currQuest.state = quest.state

        gevent:call(global.gameEvent.EV_ON_QUEST_STATE_CHANGE, currQuest)
    end
end

function QuestData:getRewardsCache()
    return self.rewardsCache
end

function QuestData:addRewards(items)
    self.rewardsCache = self.rewardsCache or {}

    table.insertto(self.rewardsCache, items)
end

function QuestData:removeRewardsCache()
    self.rewardsCache = nil
end

function QuestData:getReleateQuest(sceneId, npcId)
    local quests = self:getCurrentQuests()

    local releatedQuests = {}
    for i, quest in ipairs(quests) do 
        local questCfg = global.luaCfg:get_quest_by(quest.tid)
        if quest.state == WCONST.QUEST.STATE.RECEIVE and sceneId == questCfg.npc_relate[1] and 
           npcId == questCfg.npc_relate[2] then
            table.insert(releatedQuests, quest)
        end
    end

    return releatedQuests
end

function QuestData:getCommitQuest(sceneId, npcId)
    local quests = self:getCurrentQuests()

    for i, quest in ipairs(quests) do 
        local questCfg = global.luaCfg:get_quest_by(quest.tid)
        if quest.state == WCONST.QUEST.STATE.COMPLETE and sceneId == questCfg.npc_commit[1] and 
           npcId == questCfg.npc_commit[2] then
            return quest, questCfg
        end
    end
end

function QuestData:getWaitNpcQuest(sceneId, npcId)
    local waitList = self:getWaitQuests()
    table.sort(waitList, sortQuest)

    for i, quest in ipairs(waitList) do 
        local questCfg = global.luaCfg:get_quest_by(quest.tid)
        if sceneId == questCfg.npc_accept[1] and npcId == questCfg.npc_accept[2] then
            return quest, questCfg
        end
    end
end

global.questData = QuestData

--endregion
