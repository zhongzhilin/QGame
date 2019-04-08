--
-- Author: Your Name
-- Date: 2017-06-23 10:02:47
--
--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local hero  =require("game.UI.replay.mode.hero")

local wasteland  = class("wasteland" , function () return  hero.new() end)

-- 野地
function wasteland:ctor()

	self.type = "wasteland"
	
end 



return wasteland