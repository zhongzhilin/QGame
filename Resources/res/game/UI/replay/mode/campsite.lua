--
-- Author: Your Name
-- Date: 2017-06-23 10:02:47
--
--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local hero  =require("game.UI.replay.mode.hero")

local campsite  = class("campsite" , function () return  hero.new() end)


-- 营地
function campsite:ctor()

	self.type = "campsite"
	
end 

return campsite