Class = require "libs.middleclass.middleClass"
Entity = require "entities.entity"

shieldID = 0

local Shield = Class("Shield", Entity)

function Shield:initialize(world,x,y,w,h,player)
	Entity.initialize(self,world,x,y,w,h)
	self.player = player
	self.shieldID = shieldID + 1
	shieldID = shieldID + 1
end

function Shield:update(dt)
	pX,pY = self.player:getCenter()
	self.x = (pX + (self.player.rightHorizontalRaw * 60 * self.player.input:get 'shield')) - self.w/2
	self.y = (pY + (self.player.rightVerticalRaw * 60 * self.player.input:get 'shield')) - self.h/2
	self.world:update(self,self.x,self.y)
end

function Shield:draw()
	if self.player.input:get 'shield' > 0 then
		util.drawFilledRectangle(self.x,self.y,self.w,self.h,255,0,0)
	end
end

return Shield