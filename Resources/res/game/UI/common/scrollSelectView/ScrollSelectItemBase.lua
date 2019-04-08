--region ScrollSelectItemBase.lua
--Author : Song
--Date   : 2016/6/7
--此文件由[BabeLua]插件自动生成

local ScrollSelectItemBase = class("ScrollSelectItemBase", function() return gdisplay.newWidget() end)

ScrollSelectItemState = 
{
    NORMAL = 1, 
    SELECTED = 2,
}

function ScrollSelectItemBase:ctor()
    self.state_ = ScrollSelectItemState.NORMAL
    self:onStateChange(self.state_)
end

function ScrollSelectItemBase:setState(state)
    if self.state_ ~= state then 
        self.state_ = state
        self:onStateChange(state)
    end
end

function ScrollSelectItemBase:onStateChange(state)
    
end

return ScrollSelectItemBase

--endregion
