Class = require "libs.middleclass.middleClass"
Entity = require "entities.entity"
Shield = require "entities.shield"
Bullet = require "entities.bullet"
Particle = require "entities.Player"
anim8 = require "libs.anim8.anim8"

local Tiki = Class("Tiki")

jumpVelocity = 400
runAccel = 2000
brakeAccel = 1000
maxAmountOfJumps = 2
maxAmountOfSlams = 1
maxSpeed = 300

function Tiki:initialize(world,x,y,w,h,joystick)
    self.player = Player:new(world,x,y,w,h,joystick)
    self.player.animations.image = love.graphics.newImage('TikiSprite.png')
    self.player.animations.grid = anim8.newGrid(32,32,self.player.animations.image:getWidth(),self.player.animations.image:getHeight())
    self.player.animations.frames["walk"] = anim8.newAnimation(self.player.animations.grid('1-6',2),0.1)
    self.player.animations.frames["idle"] = anim8.newAnimation(self.player.animations.grid(1,1),0.1)
    self.player.animations.frames["run"] = anim8.newAnimation(self.player.animations.grid('1-6',3),0.1)
    self.player.animations.frames["fall"] = anim8.newAnimation(self.player.animations.grid(5,1),0.1)
    self.player.animations.frames["jump"] = anim8.newAnimation(self.player.animations.grid(1,4),0.1,'pauseAtEnd')
    self.player.animations.frames["land"] = anim8.newAnimation(self.player.animations.grid(1,1),0.1)
    
    --self.player.shield = Shield:new(self.world,x,y,20,20,self)
end


return Tiki