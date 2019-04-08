--
-- Author: Your Name
-- Date: 2017-06-23 10:02:47
--
--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local hero  =require("game.UI.replay.mode.hero")

local monster  = class("monster" , function () return  hero.new() end)

-- 怪物
function monster:ctor()

	self.type = "monster"
	
end 

return monster