--region TabControl.lua
--Author : Song
--Date   : 2016/4/14
local mainControl  =require("game.UI.replay.control.mainControl")


local pvpMainControl = class("pvpMainControl" ,function () return  mainControl.new() end)


function pvpMainControl:start() 

	mainControl.start(self)

end


return pvpMainControl

--endregion
