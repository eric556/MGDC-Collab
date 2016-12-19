Class = require "libs.middleclass.middleClass"

local Entity = Class('Entity')

local gravityAccel = 500

function Entity:initialize(world,x,y,w,h)
	self.world, self.x, self.y, self.w, self.h = world,x,y,w,h
	self.vx, self.vy = 0,0
	self.world:add(self,x,y,w,h)
end

function Entity:changeVelocityByGravity(dt)
	self.vy = self.vy + gravityAccel * dt
end

function Entity:changeVelocityByNormal(nx,ny,bounciness)
	bounciness = bounciness or 0
  	local vx, vy = self.vx, self.vy

  	if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
    	vx = -vx * bounciness
  	end

  	if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
    	vy = -vy * bounciness
  	end

  	self.vx, self.vy = vx, vy
end

function Entity:getCenter()
  return self.x + self.w / 2,
         self.y + self.h / 2
end

function Entity:destroy()
  self.world:remove(self)
end

return Entity