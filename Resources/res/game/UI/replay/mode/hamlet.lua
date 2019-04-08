--
-- Author: Your Name
-- Date: 2017-06-23 10:02:47
--
--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local hero  =require("game.UI.replay.mode.hero")

local hamlet  = class("hamlet" , function () return  hero.new() end)


 -- 村庄
function hamlet:ctor()

	self.type = "hamlet"
	
end 

return hamlet