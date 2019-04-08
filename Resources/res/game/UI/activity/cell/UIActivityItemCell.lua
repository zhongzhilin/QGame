--
-- Author: Your Name
-- Date: 2017-04-08 00:57:22
--
--
-- Author: Your Name
-- Date: 2017-03-31 17:11:09
--


local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIActivityItemCell  = class("UIActivityItemCell", function() return cc.TableViewCell:create() end )
local UIActivityItem = require("game.UI.activity.Node.UIActivityItems")

function UIActivityItemCell:ctor()
    self:CreateUI()
end

function UIActivityItemCell:CreateUI()
    self.item = UIActivityItem.new() 
    self:addChild(self.item)
end


local activity_panel  =  global.ActivityData.activity_panel


function UIActivityItemCell:onClick(notmuisc)
        
    if not notmuisc then 

        gevent:call(gsound.EV_ON_PLAYSOUND,"city_click")
    end 

    global.loginApi:clickPointReport(nil,self.data.activity_id,1,nil)
    --global.funcGame:startRecordTime()
    global.ActivityData:openActivityPanel(self.data.activity_id,self.item)        

end

function UIActivityItemCell:chooseServer()
end 

function UIActivityItemCell:setData(data)
    self.data = data
    self.item:setData(self.data)
end

function UIActivityItemCell:updateUI()
   --self.item:setData(self.data)
end

 
return UIActivityItemCell



