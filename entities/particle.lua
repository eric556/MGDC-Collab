Class = require "libs.middleclass.middleClass"
Entity = require "entities.entity"

local Particle = Class("Particle", Entity)

local lifeSpan = 5

function Particle:initialize(world,x,y,w,h,vx,vy)
	Entity.initialize(self,world,x,y,w,h)
	self.vx = vx
	self.vy = vy
	self.isDead = false
	self.aliveTime = 0
end

function Particle:filter(other)
    --local kind = other.class.name
    local kind = other.class.name
	if kind == "Block" then return 'slide' end
end

function Particle:moveColliding(dt)
	local world = self.world
	local future_x = self.x + self.vx * dt
	local future_y = self.y + self.vy * dt

	local next_x, next_y, cols, len = world:move(self,future_x,future_y,self.filter)

	for i = 1, len do
		local col = cols[i]
        self:changeVelocityByNormal(col.normal.x,col.normal.y,bonciness)
	end

	self.x,self.y = next_x, next_y
end

function Particle:draw()
	util.drawFilledRectangle(self.x,self.y,self.w,self.h,0,0,255)
end

function Particle:update(dt)
	self:changeVelocityByGravity(dt)
	self:moveColliding(dt)
	self.aliveTime = self.aliveTime + dt
	if self.aliveTime > lifeSpan then
		self.isDead = true
	end
end

return Particle