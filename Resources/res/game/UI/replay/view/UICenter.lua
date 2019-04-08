--region UICenter.lua
--Author : anlitop
--Date   : 2017/06/29
--generate by [ui_code_tool.py] automatically

local resMgr = global.resMgr
local uiMgr = global.uiMgr
-- do not edit code in this region!!!!
--REQUIRE_CLASS_BEGIN
local UIComat = require("game.UI.replay.view.UIComat")
local UISilder = require("game.UI.replay.view.UISilder")
local UIResult = require("game.UI.replay.view.UIResult")
local UIPKSoldier = require("game.UI.replay.view.UIPKSoldier")
local UIVS = require("game.UI.replay.view.UIVS")
local UITitle = require("game.UI.replay.view.UITitle")
local UIChooseSoliderEffect = require("game.UI.replay.view.UIChooseSoliderEffect")
local UIRestrain = require("game.UI.replay.view.UIRestrain")
--REQUIRE_CLASS_END

local UICenter  = class("UICenter", function() return gdisplay.newWidget() end )
local actionManger  =require("game.UI.replay.excute.actionManger")

function UICenter:ctor()
    self:CreateUI()
end

function UICenter:CreateUI()
    local root = resMgr:createWidget("player/node/center")
    self:initUI(root)
end

function UICenter:initUI(root)
    self.root = root
    self:addChild(root)
    ccui.Helper:doLayout(self.root)
    
    uiMgr:configUITree(self.root)
    uiMgr:configUILanguage(self.root, "player/node/center")

-- do not edit code in this region!!!!
--EXPORT_NODE_BEGIN
    self.comat = self.root.Node_8.comat_export
    self.comat = UIComat.new()
    uiMgr:configNestClass(self.comat, self.root.Node_8.comat_export)
    self.silder = self.root.silder_export
    self.silder = UISilder.new()
    uiMgr:configNestClass(self.silder, self.root.silder_export)
    self.result = self.root.Panel_1.result_export
    self.result = UIResult.new()
    uiMgr:configNestClass(self.result, self.root.Panel_1.result_export)
    self.right_pk = self.root.sdfsdf.right_pk_export
    self.right_pk = UIPKSoldier.new()
    uiMgr:configNestClass(self.right_pk, self.root.sdfsdf.right_pk_export)
    self.left_pk = self.root.asdfsdwer.left_pk_export
    self.left_pk = UIPKSoldier.new()
    uiMgr:configNestClass(self.left_pk, self.root.asdfsdwer.left_pk_export)
    self.vs = self.root.vs_export
    self.vs = UIVS.new()
    uiMgr:configNestClass(self.vs, self.root.vs_export)
    self.title = self.root.title_export
    self.title = UITitle.new()
    uiMgr:configNestClass(self.title, self.root.title_export)
    self.right_pk_ps = self.root.right_pk_ps_export
    self.left_pk_ps = self.root.left_pk_ps_export
    self.bottomChooseSoliderEffect = self.root.bottomChooseSoliderEffect_export
    self.bottomChooseSoliderEffect = UIChooseSoliderEffect.new()
    uiMgr:configNestClass(self.bottomChooseSoliderEffect, self.root.bottomChooseSoliderEffect_export)
    self.topChooseSoliderEffect = self.root.topChooseSoliderEffect_export
    self.topChooseSoliderEffect = UIChooseSoliderEffect.new()
    uiMgr:configNestClass(self.topChooseSoliderEffect, self.root.topChooseSoliderEffect_export)
    self.left_pk_lgith_ps = self.root.left_pk_lgith_ps_export
    self.right_pk_light_ps = self.root.right_pk_light_ps_export
    self.right_restrain = self.root.right_restrain_export
    self.right_restrain = UIRestrain.new()
    uiMgr:configNestClass(self.right_restrain, self.root.right_restrain_export)
    self.left_restrain = self.root.left_restrain_export
    self.left_restrain = UIRestrain.new()
    uiMgr:configNestClass(self.left_restrain, self.root.left_restrain_export)

--EXPORT_NODE_END


    self.title:setLocalZOrder(9999)
    self:keepPs()



end

--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN


function UICenter:showCapacity()

end

function UICenter:onEnter()

    global.left_pk_ps ={}
    global.right_pk_ps ={}

    global.left_pk_ps.x,  global.left_pk_ps.y  = self.left_pk_ps:getPosition()

    global.right_pk_ps.x ,  global.right_pk_ps.y =self.right_pk_ps:getPosition()

    dump(global.left_pk_ps ,"    global.left_pk_ps ")
    dump(global.right_pk_ps ,"    global.right_pk_ps ")


end 

function UICenter:showResumeButton()

     self.silder:showResumeButton()
end 


function UICenter:hideResumeButton()

     self.silder:hideResumeButton()
end 

function UICenter:hideCapacity()
 
end

function UICenter:hideHurtNoAction()
    self.right_pk:hideHurtNoAction()
    self.left_pk:hideHurtNoAction()
end 

function UICenter:hideShowSoliderLight()

    self.topChooseSoliderEffect:HideAllNoAction()
    self.bottomChooseSoliderEffect:HideAllNoAction()
    
end 


function UICenter:getLeftPKPS()
    return  global.left_pk_ps
end 


function UICenter:getRightPKPS()
    return  global.right_pk_ps
end 

function UICenter:showResult(result)
    self.result:setVisible(true)
    self.result:setData(result)
end 

function UICenter:hideRoundResult()
    self.result:setVisible(false)
end 

function UICenter:updateCapacity(data , isAction)

    self.comat:setData(data,isAction)
    
end 

function UICenter:updateLeftCapacity(Capacity,isAction)
    self.left_pk:updateCapacity(Capacity,isAction)
end 

function UICenter:updateRightCapacity(Capacity , isAction)
    self.right_pk:updateCapacity(Capacity,isAction)
end 


function UICenter:updateLeftCount(Count,isAction)

    self.left_pk:updateCount(Count,isAction)
end 

function UICenter:updateRightCount(Count,isAction)

    self.right_pk:updateCount(Count,isAction)
end 

function UICenter:setRightSoldierData(data,fightType)
    self.right_pk:setData(data,fightType)
end 

function UICenter:setLeftSoldierData(data,fightType)
    self.left_pk:setData(data ,fightType,isaction)
end 

function UICenter:hidePKSolider()

    actionManger.getInstance():createTimeline(self.root ,"hidePkAction" , true , true)
end 



function UICenter:hideLefPKSolider()
-- 
end 

function UICenter:hideRightPKSolider()
    -- self.right_pk:setVisible(false)

end 

function UICenter:setRoundData(round_data)
    self.silder:setData(round_data)
end 



function UICenter:ShowSoliderAction(node, start_ps,end_ps,end_ps2 ,direction )
    
    node:setScale(0.1)
    local test  =node:getParent():convertToNodeSpace(start_ps)
    test.x =test.x+50
    node:setPosition(test)

    -- print(start_ps.x,start_ps.y," 士兵 开始点///////////")
    -- print(end_ps2.x,end_ps2.y,"士兵 结束点///////////")
    local angle = 0 
    angle = self:getAngle(start_ps.x ,start_ps.y , end_ps2.x , end_ps2.y)

    -- print(angle,"angle 士兵旋转角度")

    -- if direction ==1 then 
    --   node:setRotation(-angle)    
    -- else 
    --  node:setRotation(angle)    
    -- end 

    local moveto = cc.MoveTo:create(0.2,end_ps)
    local scaleto = cc.ScaleTo:create(0.2,1)
    -- local rotateto  =cc.RotateTo:create(0.1,0)

    local spawn = cc.Spawn:create( moveto ,scaleto)
    actionManger.getInstance():createAction(node, spawn, true)

end


function UICenter:getAngle(px1, py1, px2, py2) 
        --两点的x、y值
        local x = px2-px1
        local  y = py2-py1
        -- atan2((x2-x1),(y2-y1))*180/3.1415926
        return math.atan2(x,y)*180/3.1415926
end 

function UICenter:ShowSoliderEffectAction(node, start_ps,end_ps,direction)
        
    local offset = 50

    local  test2 =  end_ps.x /  90

    local test  =node:getParent():convertToNodeSpace(start_ps)

    test.x =test.x+offset

    node:setPosition(test)
    
   local x = end_ps.x - start_ps.x - offset
    
    -- dump(start_ps,"start_ps////////")   
    -- dump(end_ps,"end_ps////////")

    -- print(x,"两点偏差///////////")
    -- print(start_ps.x,start_ps.y," 光 开始点///////////")
    -- print(end_ps.x,end_ps.y,"光 结束点///////////")

    local angle = 0 

    angle = self:getAngle(start_ps.x ,start_ps.y , end_ps.x , end_ps.y)

    -- print(angle,"angle///////////",direction,"direction")

    if direction == 1 then  -- top 

        node:setRotation(0)
        
        node:setRotation(180- node:getRotation() + angle ) 

        self.topChooseSoliderEffect:showTopAction()

    elseif direction ==2  then  -- bottom

        node:setRotation(0)

        node:setRotation(node:getRotation() + angle ) 
       
        self.bottomChooseSoliderEffect:showBottomAction()
    end 
end


function UICenter:showPKSoliderNoAction()

    actionManger.getInstance():createTimeline(self.root ,"showPkNOAction" , true , true)
end

function UICenter:showRightPkSoliderNoAction()

    actionManger.getInstance():createTimeline(self.root ,"showRightPkSoliderNoAction" , true , true)
end 

function UICenter:showLeftPkSoliderNoAction()

    actionManger.getInstance():createTimeline(self.root ,"showLeftPkSoliderNoAction" , true , true)
end 

function UICenter:setLeftPKSoliderVisible(state)
    self.left_pk:setVisible(state)
end

function UICenter:setRightPKSoliderVisible(state)
    self.right_pk:setVisible(state)
end 

function UICenter:showLeftPkSoliderNoAction()

    actionManger.getInstance():createTimeline(self.root ,"showLeftPkSoliderNoAction" , true , true)
end 



function UICenter:hidePKSoliderNoAction()
    actionManger.getInstance():createTimeline(self.root ,"hidePkNOAction" , true , true)

end 

function UICenter:showLeftPKSolider(start_ps, end_ps)
 
    if start_ps ==nil then
            global.tipsMgr:showWarning("start_ps  showLeftPKSolider == nil ")

     return end 

    self.left_pk:setVisible(true)



    local fuck = self.left_pk_lgith_ps:convertToWorldSpace(cc.p(0,0))


    self:ShowSoliderEffectAction(self.topChooseSoliderEffect ,start_ps ,fuck ,1)

    self:ShowSoliderAction(self.left_pk.root,start_ps, global.left_pk_ps ,fuck , 1 )

end



function UICenter:showRightPKSolider(start_ps, end_ps)
    
    if start_ps ==nil then
            global.tipsMgr:showWarning("start_ps showRightPKSolider == nil ")
     return end 

    self.right_pk:setVisible(true)

    local fuck = self.right_pk_light_ps:convertToWorldSpace(cc.p(0,0))

  
    self:ShowSoliderEffectAction(self.bottomChooseSoliderEffect ,start_ps , fuck ,2 )

    self:ShowSoliderAction(self.right_pk.root,start_ps, global.right_pk_ps , fuck , 2 )
end 



function UICenter:setTitleData(data)
    self.title:setData(data)
end 

function UICenter:showTitle()
    self.title:ShowAction()
end 


function UICenter:showVs()
    self.vs:showVsWithAction()
end 

function UICenter:hideVsWithAction()
    self.vs:hideVsWithAction()
end

function UICenter:hideVs()
    self.vs:hideVsNoAction()
end  


function UICenter:hideTitleNoAction()

    self.title:hideTitleNoAction()
end 

function UICenter:hideTitleWithAction()

    self.title:hideTitleWithAction()
end 


function UICenter:showSelf()
    self:setVisible(true)
end 

function UICenter:hideSelf()
    self:setVisible(false)
end 

function UICenter:showpk(station)

    if station ==  2  then 
        self:showPKAction1()
    else
        self:showPKAction()
    end 
end 


function UICenter:showPKAction1()

     actionManger.getInstance():createTimeline(self.root ,"centerpk1" , true , true)

end 

function UICenter:showPKAction()

     actionManger.getInstance():createTimeline(self.root ,"centerpk" , true , true)
end


function UICenter:showLeftPKSoliderHurt(hurt)
    
     self.left_pk:showHurt(hurt)
end 

function UICenter:showRightPKSoliderHurt(hurt)
     self.right_pk:showHurt(hurt)
end 


function UICenter:showRightRestrain()

    self.right_restrain:showRightRestrain()
end 

function UICenter:showLeftRestrain()
    
    self.left_restrain:showLeftRestrain()
end 

function UICenter:hideRestrain()

    self.left_restrain:hideSelf()
    self.right_restrain:hideSelf()

end 


function UICenter:updateProgress(progress)
    self.silder:updateProgress(progress)
end


function UICenter:hideComatNoAction()
    self.comat:hideComatNoAction()
end

function UICenter:keepPs()

    self.title_old_ps =   self.title:getPosition()
    self.right_pk_old_ps =  self.right_pk:getPosition()
    self.left_pk_old_ps =  self.left_pk:getPosition()
    self.result_old_ps =   self.result:getPosition()
    self.silder_old_ps =  self.silder:getPosition()
end 


function UICenter:showComatWithAction()
     self.comat:showComatWithAction()
end 


--if the funcion doesn't exists, it will insert a blank func
--CALLBACK_FUNCS_BEGIN

--CALLBACKS_FUNCS_ENDXPORT_NODE_END

return UICenter

--endregion
