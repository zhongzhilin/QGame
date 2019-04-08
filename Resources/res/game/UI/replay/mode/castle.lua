--
-- Author: Your Name
-- Date: 2017-06-23 10:02:47
--
--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local hero  =require("game.UI.replay.mode.hero")


local castle  = class("castle" , function () return  hero.new() end)

-- 城堡
function castle:ctor()

	self.type = "castle"

end 

return castle