--region TabControl.lua
--Author : Song
--Date   : 2016/4/14
local mainControl  =require("game.UI.replay.control.mainControl")


local pveMainControl = class("pveMainControl" ,function () return  mainControl.new() end)



return pveMainControl

--endregion
