Class = require "libs.middleclass.middleClass"
Entity = require "entities.entity"

local Bullet = Class("Bullet",Entity)

local lifeSpan = 10

function Bullet:initialize(world,x,y,w,h,player,speed)
	Entity.initialize(self,world,x,y,w,h)
	self.player = player
	self.speed = speed
	self.vx = self.player.rightHorizontalRaw * self.speed
	self.vy = self.player.rightVerticalRaw * self.speed
	self.isDead = false
	self.aliveTime = 0
end

function Bullet:filter(other)
	local kind = other.class.name
	if kind == 'Shield' and self.player.shield.shieldID ~= other.shieldID then return 'touch' end
	if kind == 'Player' and self.player.playerID ~= other.playerID then return 'touch' end
    if kind == 'Block' then return 'touch' end
end

function Bullet:moveColliding(dt)
	local world = self.world
	local future_x = self.x + self.vx * dt
	local future_y = self.y + self.vy * dt

	local next_x, next_y, cols, len = world:move(self,future_x,future_y,self.filter)

	for i = 1,len do
		local col = cols[i]
		if col.other.class.name == 'Player'then
			col.other:takeHit(0.25)
			self:destroy()
			self.isDead = true
		end
		if col.other.class.name == 'Shield' then
			self:destroy()
			self.isDead = true
		end
        if col.other.class.name == 'Block' then
            self:destroy()
            self.isDead = true
        end
	end
	self.x, self.y = next_x, next_y
end

function Bullet:draw()
	util.drawFilledRectangle(self.x,self.y,self.w,self.h,255,0,0)
end

function Bullet:update(dt)
	self:moveColliding(dt)
	self.aliveTime = self.aliveTime + dt
	if self.aliveTime > lifeSpan then
		self.isDead = true
	end
end

return Bullet