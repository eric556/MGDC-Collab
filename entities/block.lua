Class = require "libs.middleclass.middleClass"
Entity = require "entities.entity"

local Block = Class("Block", Entity)

function Block:initialize(world,x,y,w,h)
	Entity.initialize(self,world,x,y,w,h)
end

function Block:drawRGB(r,g,b)
	util.drawFilledRectangle(self.x,self.y,self.w,self.h,r,g,b)
end

function Block:drawHSL(h,s,l)
	r,g,b = util.HSL(h,s,l)
	self:drawRGB(r,g,b)
end

function Block:update(dt)

end

function Block:destroy()
	Entity.destroy(self)
end

return Block

