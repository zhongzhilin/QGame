--region ScrollListItemPool.lua
--Author : Song
--Date   : 2016/6/7

local BasePool = require("game.UI.common.scrollSelectView.BasePool")
local ScrollListItemPool = class("ScrollListItemPool", BasePool)

--local MAX_ITEM_COUNT = 50

function ScrollListItemPool:ctor(maxCount)
    self.maxCount_ = maxCount
    ScrollListItemPool.super.ctor(self, ObjectPoolType.ARRAY, self.maxCount_)
end

function ScrollListItemPool:onReuseObj(obj)
    obj:release()
    obj:setVisible(true)
end

function ScrollListItemPool:onCacheObj(obj)
    obj:retain()
end

function ScrollListItemPool:onReleaseObj(obj)
    obj:release()
end

return ScrollListItemPool

--endregion
