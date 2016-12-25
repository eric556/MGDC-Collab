Class = require "libs.middleclass.middleClass"
Entity = require "entities.entity"
Shield = require "entities.shield"
Bullet = require "entities.bullet"
Particle = require "entities.Player"
anim8 = require "libs.anim8.anim8"

local King = Class("King",Player)

jumpVelocity = 400
runAccel = 2000
brakeAccel = 1000
maxAmountOfJumps = 2
maxAmountOfSlams = 1
maxSpeed = 300

function King:initialize(world,x,y,w,h,joystick)
    Player.initialize(self,world,x,y,w,h,joystick)
    self.animations.image = love.graphics.newImage('characters.png')
    self.animations.grid = anim8.newGrid(32,32,self.animations.image:getWidth(),self.animations.image:getHeight())
    self.animations.frames["walk"] = anim8.newAnimation(self.animations.grid('1-4',2),0.1)
    self.animations.frames["idle"] = anim8.newAnimation(self.animations.grid(1,2),0.1)
    self.animations.frames["jump"] = anim8.newAnimation(self.animations.grid(5,2),0.1)
    self.animations.frames["jump"] = anim8.newAnimation(self.animations.grid('5-6',2),0.2,'pauseAtEnd')
    self.animations.frames["fall"] = anim8.newAnimation(self.animations.grid(7,2),0.1)
    self.animations.frames["land"] = anim8.newAnimation(self.animations.grid(8,2),0.1)
    self.animations.frames["hit"] = anim8.newAnimation(self.animations.grid('9-10',2,9,2),0.1)
    self.animations.frames["run"] = anim8.newAnimation(self.animations.grid('15-18',2),0.1)
end

function King:destroy()
    Player.destroy(self)
end

function King:update(dt)
    Player.update(self,dt)     
end

return King