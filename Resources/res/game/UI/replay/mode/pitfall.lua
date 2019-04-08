--
-- Author: Your Name
-- Date: 2017-06-23 10:42:24
--
--
-- Author: Your Name
-- Date: 2017-06-23 10:41:54
--
--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local soldier  =require("game.UI.replay.mode.soldier")


local pitfall  = class("pitfall" , function () return  soldier.new() end)
 
--陷阱
function pitfall:ctor()

	self.type = "pitfall"
end 

return pitfall