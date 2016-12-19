Class = require "libs.middleclass.middleClass"
Player = require "entities.player"
anim8 = require "libs.anim8.anim8"

local Tiki = Class("Tiki",Player)


function Tiki:initialize(world,x,y,w,h,joystick,controls)
    Player.initialize(self,world,x,y,w,h,joystick,controls)
    self.image = love.graphics.newImage('TikiSprite.png')
    self.g = anim8.newGrid(32,32,self.image:getWidth(), self.image:getHeight())
    self.walkingAnim = anim8.newAnimation(self.g('1-6',2),0.1)
end

function Tiki:update(dt)
    Player.update(self,dt)
    self.walkingAnim:update(dt)
end

function Tiki:draw()
    Player.drawRGB(self,255,255,255)
    self.walkingAnim:draw(self.image,self.x,self.y)
end

return Tiki