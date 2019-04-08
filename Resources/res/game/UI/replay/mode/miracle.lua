--
-- Author: Your Name
-- Date: 2017-06-23 10:02:47
--
--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local hero  =require("game.UI.replay.mode.hero")

local miracle  = class("miracle" , function () return  hero.new() end)

-- 奇迹
function miracle:ctor()

	self.type = "miracle"
	
end 

return miracle