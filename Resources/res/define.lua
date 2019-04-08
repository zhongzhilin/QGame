
---@classdef global
local define = {
    --time
    ------------------------------------------------------
    MINUTE = 60,
    HOUR   = 3600,
    DAY    = 86400,
}

require("util.cocos2dx")
define.SYSTEM_FONT = "Arial"

define.shaders = 
{   
    SHADER_NAME_POSITION_GRAYSCALE        = "ShaderUIGrayScale",
    SHADER_NAME_POSITION_TEXTURE_GRAY        = "ShaderPositionTextureGray",
    SHADER_NAME_POSITION_TEXTURE_GRAY_NO_MVP = "ShaderPositionTextureGray_noMVP",
}

global.define = define