Class = require "libs.middleclass.middleClass"
Entity = require "entities.entity"
Shield = require "entities.shield"
Bullet = require "entities.bullet"
Particle = require "entities.Player"
anim8 = require "libs.anim8.anim8"

local King = Class("King")

jumpVelocity = 400
runAccel = 2000
brakeAccel = 1000
maxAmountOfJumps = 2
maxAmountOfSlams = 1
maxSpeed = 300

function King:initialize(world,x,y,w,h,joystick,controls)
    self.player = Player:new(world,x,y,w,h,joystick,controls)
    self.player.animations.image = love.graphics.newImage('characters.png')
    self.player.animations.grid = anim8.newGrid(32,32,self.player.animations.image:getWidth(),self.player.animations.image:getHeight())
    self.player.animations.frames["walk"] = anim8.newAnimation(self.player.animations.grid('1-4',2),0.1)
    self.player.animations.frames["idle"] = anim8.newAnimation(self.player.animations.grid(1,2),0.1)
    self.player.animations.frames["jump"] = anim8.newAnimation(self.player.animations.grid(5,2),0.1)
    self.player.animations.frames["jump"] = anim8.newAnimation(self.player.animations.grid('5-6',2),0.2,'pauseAtEnd')
    self.player.animations.frames["fall"] = anim8.newAnimation(self.player.animations.grid(7,2),0.1)
    self.player.animations.frames["land"] = anim8.newAnimation(self.player.animations.grid(8,2),0.1)
    self.player.animations.frames["hit"] = anim8.newAnimation(self.player.animations.grid('9-10',2,9,2),0.1)
    self.player.animations.frames["run"] = anim8.newAnimation(self.player.animations.grid('15-18',2),0.1)
end

return King