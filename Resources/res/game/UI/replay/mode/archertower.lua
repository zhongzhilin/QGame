--
-- Author: Your Name
-- Date: 2017-06-23 10:41:54
--
--
-- Author: Your Name
-- Date: 2017-06-19 15:17:08
--
local soldier  =require("game.UI.replay.mode.soldier")


local archertower  = class("archertower" , function () return  soldier.new() end)
 

 --箭塔
function archertower:ctor()

	self.type = "archertower"
end 

return archertower