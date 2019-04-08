--
-- Author: Your Name
-- Date: 2017-07-14 09:58:01
--
  
local TextEffect = class("TextEffect", function() return gdisplay.newWidget() end )

function TextEffect:ctor(text , number ,time , getNumberCall ,farmaCall)


	text:addChild(self)

 	local old_number=  text:getString()

    if getNumberCall then

        old_number = getNumberCall(text:getString())

    end     

    if old_number  == number then return  end 

    self.all_number  =  math.abs(number - old_number) --总的步数

    print( self.all_number ," self.all_number ")

    self.isAdd = (number - old_number) > 0 
        
    self.count  = 0 

    self.text = text 

    self.getNumberCall = getNumberCall 

    self.step = math.ceil(  self.all_number  / time )

    self.farmaCall = farmaCall

    print(self.step  ,"self.step  ")

    self.original_number = old_number

    self:excute()

end



function TextEffect:excute()

	self.timer = gscheduler.scheduleGlobal( function (dt) 

		local old_number=  tonumber( self.text:getString())

		if self.getNumberCall then 
			old_number = self.getNumberCall( self.text:getString())
		end 

		local temp  = math.ceil(self.step *  dt)

		if self.isAdd then 
			old_number = old_number + temp
		else 
			old_number = old_number - temp
		end

		self.count  = self.count  + temp

		if  self.all_number < self.count then 
			old_number = self.all_number

			if not self.isAdd then
				old_number =   self.original_number - self.all_number
			end 
		end

		if  self.farmaCall  then 
			 self.text:setString(self.farmaCall(old_number))
		else 
			 self.text:setString(old_number)
		end

		if  self.all_number  <= self.count  then 
			self:cleanTimer()
		end 

	end , 1/20)
end 


function TextEffect:cleanTimer()
 	
	if self.timer then 
 		gscheduler.unscheduleGlobal(self.timer)
        self.timer = nil
    end 
end 

function TextEffect:onExit()
	
	self:cleanTimer()
end 


 return TextEffect
