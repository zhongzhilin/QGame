---@classdef CCComponent
CCComponent = {}
function CCComponent:autorelease() end 
function CCComponent:retain() end 
function CCComponent:retainCount() end 
function CCComponent:isEqual() end 
function CCComponent:copy() end 
function CCComponent:release() end 
function CCComponent:isSingleReference() end 
function CCComponent:serialize() end 
function CCComponent:getOwner() end 
function CCComponent:delete() end 
function CCComponent:init() end 
function CCComponent:update() end 
function CCComponent:setOwner() end 
function CCComponent:setName() end 
---
-- @return @class CCComponent
--
function CCComponent:create() end 
function CCComponent:getName() end 
function CCComponent:isEnabled() end 
function CCComponent:setEnabled() end 
