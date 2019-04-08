--region UIInputBox.lua
--Author : Administrator
--Date   : 2016/08/22
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
--REQUIRE_CLASS_END

-- cc.EDITBOX_INPUT_MODE_ANY = 0
-- cc.EDITBOX_INPUT_MODE_EMAILADDR = 1
-- cc.EDITBOX_INPUT_MODE_NUMERIC = 2
-- cc.EDITBOX_INPUT_MODE_PHONENUMBER = 3
-- cc.EDITBOX_INPUT_MODE_URL = 4
-- cc.EDITBOX_INPUT_MODE_DECIMAL = 5
-- cc.EDITBOX_INPUT_MODE_SINGLELINE = 6

-- cc.EDITBOX_INPUT_FLAG_PASSWORD = 0
-- cc.EDITBOX_INPUT_FLAG_SENSITIVE = 1
-- cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD = 2
-- cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE = 3
-- cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS = 4

local UIInputBox  = class("UIInputBox", function() return gdisplay.newWidget() end )
local luaCfg = global.luaCfg

function UIInputBox:ctor()

end

function UIInputBox:CreateUI()

end

function UIInputBox:initUI(textField)

    self.mulSize = textField:getContentSize()
    self.singleSize = cc.size(self.mulSize.width,self.mulSize.height / 2 * 3)
    self.preMaxLen = textField:getMaxLength()

    self.box = ccui.EditBox:create(self.singleSize,"")
    self.box:setText(textField:getString())
    
    local placeHolder = textField:getPlaceHolder()
    local placeHolderId = tonumber(placeHolder)
    if placeHolderId then
        self.box:setPlaceHolder(luaCfg:get_local_string(placeHolderId))
    else
        self.box:setPlaceHolder(placeHolder)
    end
    
    self.box:setPlaceholderFontColor(gdisplay.COLOR_WHITE)
    self.box:setMaxLength(500)
    self:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.box:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)    
    self.box:setAnchorPoint(textField:getAnchorPoint())
    self.box:setFont("fonts/normal.ttf",textField:getFontSize())
    self:addChild(self.box)
    self:initListenner()
    self.rules = {}
end

function UIInputBox:setTextColor(color)
    self.box:setFontColor(color)
end 

function UIInputBox:initListenner()
    
    self:_addEventListener(function(arg0,arg1)

        if arg0 == "began" then

            self.model = global.uiMgr:addTopModal()
        end

        if arg0 == "return" then
        
            if self.model and not tolua.isnull(self.model) then
                self.model:runAction(cc.RemoveSelf:create())
                self.model = nil
            end
        end

        if arg0 == "ended" then            

            local text = self:cleanEnter(self.box:getText())

            local len = string.inputLen(text)
            local res = (len <= self.preMaxLen)

            for _,calls in ipairs(self.rules) do

                res = res and calls(text)
            end

            if self.endCall then self.endCall(res) end
        end

        if self.clientHandler then self.clientHandler(arg0,arg1) end
    end)
end

function LuaReomve(str,remove)  
    local lcSubStrTab = {}  
    while true do  
        local lcPos = string.find(str,remove)  
        if not lcPos then  
            lcSubStrTab[#lcSubStrTab+1] =  str      
            break  
        end  
        local lcSubStr  = string.sub(str,1,lcPos-1)  
        lcSubStrTab[#lcSubStrTab+1] = lcSubStr  
        str = string.sub(str,lcPos+1,#str)  
    end  
    local lcMergeStr =""  
    local lci = 1  
    while true do  
        if lcSubStrTab[lci] then  
            lcMergeStr = lcMergeStr .. lcSubStrTab[lci]   
            lci = lci + 1  
        else   
            break  
        end  
    end  
    return lcMergeStr  
end  

function UIInputBox:cleanEnter(text)    
    
    -- print(self.mode,"-><-",cc.EDITBOX_INPUT_MODE_ANY)

    -- global.tipsMgr:showWarningText(self.mode .. " -.-" .. cc.EDITBOX_INPUT_MODE_ANY)

    if self.mode ~= cc.EDITBOX_INPUT_MODE_ANY then
        text = LuaReomve(text,string.char(10))
        self.box:setText(text)
    end    
    return text

    -- if self.mode ~= cc.EDITBOX_INPUT_MODE_ANY then
    --     local len  = #text
    --     local res = {}
    --     for i = 1,len do
    --         local t = string.byte(text,i)
    --         if 10 ~= t then
    --             table.insert(res,t)
    --         end        
    --     end

    --     local resStr = ""
    --     for _,v in ipairs(res) do

    --         resStr = resStr .. string.char(v)
    --     end
    --     self.box:setText(resStr)
    -- end        
    -- return resStr

    -- local len  = #text
    -- local res = ""
    -- for i = 1,len do
    --     local t = string.byte(text,i)
    --     -- if 10 ~= t then
    --     --     table.insert(res,t)
    --     -- end     

    --     res = res .. " " .. t   
    -- end

    -- global.tipsMgr:showWarningText(res)

    -- return text
end
 
function UIInputBox:onExit()
    
    -- if self.model then
    --     self.model:removeFromParent()
    -- end
end

function UIInputBox:addReturnCall(endCall,rules)
    
    self.endCall = endCall
    self.rules = rules
end

function UIInputBox:getString()
    
    return self.box:getText()
end

function UIInputBox:setInputMode(mode)
    
    self.mode = mode

    if mode == cc.EDITBOX_INPUT_MODE_ANY then

        self.box:setContentSize(self.mulSize)
    else

        self.box:setContentSize(self.singleSize)
    end

    self.box:setInputMode(mode)
end

function UIInputBox:setMaxLength(len)
    self.box:setMaxLength(len)
end

function UIInputBox:setString( str )
 
    self.box:setText(str)
end

function UIInputBox:_addEventListener( textHandler )
    
    self.textHandler = textHandler
    self.box:registerScriptEditBoxHandler(function(arg0,arg1)
        
        self.textHandler(arg0,arg1)
    end)
end

function UIInputBox:addEventListener( textHandler )
    
    self.clientHandler = textHandler
end

function UIInputBox:textChange( eventType )
   
    self.textHandler(eventType) 
end

function UIInputBox:setPlaceHolder(text)
    
    self.box:setPlaceHolder(text)
end

function UIInputBox:getPlaceHolder()
    
    return self.box:getPlaceHolder()
end

function UIInputBox:setPlaceholderFontColor(color)
    
    self.box:setPlaceholderFontColor(color)
end

function UIInputBox:setFontColor(color)
    
    self.box:setFontColor(color)
end

function UIInputBox:touchDownAction()
    self.box:touchDownAction(self.box,ccui.TouchEventType.ended)
end

--不能有空格
function UIInputBox.EDIT_BOX_RULE_NO_SPACE(str)
    
    local list = string.utf8ToList(str)

    local res = 0
    for _,v in ipairs(list) do

        if v == " " then

            return false
        end
    end  

    return true
end

--只能输入字母和数字
function UIInputBox.EDIT_BOX_RULE_ONLY_CHAR_NUM(str)

    local list = string.utf8ToList(str)

    for _,v in ipairs(list) do

        local curByte = string.byte(v)
        if curByte > 0 and curByte <= 127 then

            
        else

            return false
        end
    end  

    return true
end

--空格不能是首字母
function UIInputBox.EDIT_BOX_RULE_FIRST_NOT_BE_SPACE(str)
    
    local list = string.utf8ToList(str)

    return list[1] ~= " "  
end

--用法示例
-- local rules = {UIInputBox.EDIT_BOX_RULE_FIRST_NOT_BE_SPACE,UIInputBox.EDIT_BOX_RULE_ONLY_CHAR_NUM}
--     self.account_id:addReturnCall(function(isuse)
        
--     end,rules)

return UIInputBox

--endregion
