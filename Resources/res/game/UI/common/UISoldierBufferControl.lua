
local UISoldierBufferControl  = class("UISoldierBufferControl")
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg


function UISoldierBufferControl:setData(panel , data , mode, class, nextClass )


    self.mode = mode 

    self.panel = panel 
    self.data  = data    

    local property  = luaCfg:get_soldier_property_by(data.id)
    self.property   = property 


    -- dump(self.data)

    self.m_class = class
    self.m_nextClass = nextClass
    local tips_data =  global.SoldierBufferData:getBUffByID(self.data.id  , function () 

        local tips_data2 = global.SoldierBufferData:getBUffByID(self.data.id)

        -- dump(tips_data2 ,"get_tips_data2")

        if tips_data2 then 

            self:setBuffAdd(tips_data2)

        end 

    end )

    if tips_data then 

        self:setBuffAdd(tips_data)

    end 

    -- global.gmApi:effectBuffer({{lType =7,lBind =self.data.id}},function(msg)
    -- end)

end 


UISoldierBufferControl.SOLDIER_PROPERTY = 
{
    "atk",
    "dPower",
    "iftDef",
    "cvlDef",
    "acrDef",
    "magDef",
    "speed",
    "capacity",
    "alldef",
}


local def = {
    "iftDef",
    "cvlDef",
    "acrDef",
    "magDef",
}
local classWhiteList = {
    "atk",
    "dPower",
    "iftDef",
    "cvlDef",
    "acrDef",
    "magDef",
    "speed",
    "capacity",
}


function UISoldierBufferControl:setBuffAdd(msg)

    if msg and msg.tgEffect then 
        self:effectHandel(msg.tgEffect,self.m_class)
        if self.m_nextClass then
            self:effectHandel(msg.tgEffect,self.m_nextClass,true)
        end
    end 

end





 
function UISoldierBufferControl:effectHandel(msg,class,isNext)

    -- dump(msg , "这个是  buff msg ")

    -- print(self.mode , "这是什么东西啊。？？")
    local temp  ={}

    for _ ,v in pairs(msg) do 

        if not global.EasyDev:CheckContrains(temp , v.lEffectID) then 
            table.insert(temp , v.lEffectID)
        end 
    end

    class = class or 0 

    local classData = luaCfg:get_soldier_lvup_by(class+1)

    local upClass = function(pro,proName)
        -- body
        if table.hasval(classWhiteList,proName) and  classData then
            return math.ceil(pro*(classData.upPro+100)/100)
        else
            return pro
        end
    end
    -- dump(temp , "temp")

    local effect_arr = {} 

    for _ ,v in  pairs(temp) do 

        local effect ={} 
        effect.lEffectID = v
        effect.lVal = 0 
        effect.effect_data = luaCfg:get_data_type_by(effect.lEffectID)

        for _ ,vv in pairs(msg)  do 

            if vv.lEffectID  == v then 

                effect.lVal =effect.lVal + vv.lVal

            end 
        end 
        table.insert(effect_arr , effect)
    end


    for _ ,v in pairs(self.SOLDIER_PROPERTY) do 
        self[v] = 0         
    end 

    -- dump(effect_arr,"effect_arr ///////////////")


    for _ ,v in pairs(effect_arr) do 

        if  self.data.type == v.effect_data.soldierType  or v.effect_data.soldierType == 99    then 

            if  v.effect_data.natureType == 9 then -- 全防  

                for _ , vv  in pairs(def)  do 

                    if v.effect_data.extra == "%" then 

                        self[vv] =  self[vv] +  math.ceil( upClass(self.property[vv],vv) * (1 +  v.lVal  / 100 ))

                        self[vv] =  self[vv] -  upClass(self.property[vv],vv)
                    else 
                        self[vv]  =self[vv]  + v.lVal

                    end 
                end

            else
                local stype = self.SOLDIER_PROPERTY[v.effect_data.natureType]
                if v.effect_data.extra == "%" then 

                    self[stype]  = self[stype] +  math.ceil( upClass(self.property[stype],stype) * (1+ v.lVal / 100) )
                    self[stype] = self[stype] - upClass(self.property[stype],stype)
                else
                    self[stype]  =  v.lVal          

                end  
            end 

        end 

    end



    local add_suffix = ""
    if isNext then
        add_suffix = "_next"
    end
    
    for _ ,v in pairs(self.SOLDIER_PROPERTY) do 

        print( self[v]," self[v]/////////////")

        if self[v] >  0 then 

            if self.panel[v.."_num_add"..add_suffix] then
                
                self.panel[v.."_num_add"..add_suffix]:setVisible(true)

                self.panel[v.."_num_add"..add_suffix]:setString("  +"..self[v])

            end 
        end 
    end 

    if self.mode == "tips" then 

        for _ ,v in pairs(self.SOLDIER_PROPERTY) do 

            if self.panel[v.."_num"] then

                if self[v] >  0 then 
                    self.panel[v.."_num"]:setTextColor(gdisplay.COLOR_GREEN)

                    self.panel[v.."_num"]:setVisible(true)

                    self.panel[v.."_num"]:setString(""..self[v]+self.property[v])

                else 
                    self.panel[v.."_num"]:setTextColor(gdisplay.COLOR_WHITE)
                end 

            end 
        end 
    end  

end 


 
function UISoldierBufferControl:setRePlayBuff(useid , troopid , soliderid ,  panel, class, isNext)

    print(useid,"useid")
    print(troopid,"troopid")
    print(soliderid,"soliderid")

    local buffarr =  global.SoldierBufferData:getSoldierBuffByID(useid , troopid )

    -- dump(buffarr,"所有  buffarr")

    self.panel = panel 

    soldier_train_data = luaCfg:get_soldier_train_by(soliderid)
    soldier_property = luaCfg:get_soldier_property_by(soliderid)
    class = class or 0
    local classData = luaCfg:get_soldier_lvup_by(class+1)
    local upClass = function(pro,proName)
        -- body
        if table.hasval(classWhiteList,proName) and classData then
            return math.ceil(pro*(classData.upPro+100)/100)
        else
            return pro
        end
    end

    if not soldier_train_data then return end 
    
    if not soldier_property then return end 

    if not  buffarr then return end 

    if not self.panel  then return end 


    -- print("为什么这样啊///////////////////")
    -- dump(buffarr,"buffarr")


    for _ ,v in  pairs(buffarr) do 

        v.effect_data = luaCfg:get_data_type_by(v.lBuffid)
    end

    for _ ,v in pairs(self.SOLDIER_PROPERTY) do 

        self[v] = 0 
    end 



    for _ ,v in pairs(buffarr) do 

        if  soldier_train_data.type == v.effect_data.soldierType  or v.effect_data.soldierType == 99    then 

            if  v.effect_data.natureType == 9 then -- 全防  

                for _ , vv  in pairs(def)  do 

                    if v.effect_data.extra == "%" then 

                        self[vv] = self[vv]  + math.ceil( upClass(soldier_property[vv],vv)  * (1 + v.lValue/100) ) 

                         self[vv] = self[vv]  -  upClass(soldier_property[vv],vv)
                    else 
                        self[vv]  =  upClass(soldier_property[vv],vv)  +  v.lValue

                    end 
                end

            else
                local stype = self.SOLDIER_PROPERTY[v.effect_data.natureType]
                if v.effect_data.extra == "%" then 

                    self[stype]  = self[stype] + math.ceil(upClass(soldier_property[stype],stype) * ( 1+ v.lValue / 100 ))

                    self[stype]  = self[stype] - upClass(soldier_property[stype],stype)

                else
                    self[stype]  = v.lValue          

                end  
            end 
        end 
    end

    local add_suffix = "_num_add"
    if isNext then
        add_suffix = "_num_add_next"
    end
    for _ ,v in pairs(self.SOLDIER_PROPERTY) do 

        if self[v] >  0 then 

            if self.panel[v..add_suffix] then
                
                self.panel[v..add_suffix]:setVisible(true)

                self.panel[v..add_suffix]:setString("  +"..self[v])

            end 
        end 
    end 

end 



return UISoldierBufferControl 