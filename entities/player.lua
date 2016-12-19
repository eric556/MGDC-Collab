Class = require "libs.middleclass.middleClass"
Entity = require "entities.entity"
Shield = require "entities.shield"
Bullet = require "entities.bullet"
Particle = require "entities.particle"

local Player = Class("Player",Entity)

local jumpVelocity = 400
local runAccel = 500
local brakeAccel = 600
local maxAmountOfJumps = 2
local maxAmountOfSlams = 1

PlayerID = 0

function Player:initialize(world,x,y,w,h,joystick,controls)
	Entity.initialize(self,world,x,y,w,h)
	self.health = 5
	self.input = Baton.new(controls,joystick)
	self.rightHorizontal = self.input:get 'rightStickRight' - self.input:get 'rightStickLeft'
	self.rightVertical = self.input:get 'rightStickDown' - self.input:get 'rightStickUp'
	self.leftHorizontal = self.input:get 'leftStickRight' - self.input:get 'leftStickLeft'
	self.leftVertical = self.input:get 'leftStickDown' - self.input:get 'leftStickUp'
	self.numJumps = 0
	self.numSlams = 0
	self.shield = Shield:new(self.world,x,y,20,20,self)
	self.playerID = PlayerID + 1
	PlayerID = PlayerID + 1
	self.bullets={}
	self.shot = false
	self.particles = {}
	self.isDead = false
    self.animations = {}
    self.animations.frames = {}
    self.animations.currentAnimation = "idle"
    self.animations.currentDirection = 1
    self.animations.previousDirection = 1
end

function Player:filter(other)
	local kind = other.class.name
	if kind == 'Block' then return 'slide' end
	if kind == 'Player' and self.isSlamming and other.y - self.h > self.y  then 
		return 'slide'
	end
	if kind == 'Shield' and other.shieldID ~= self.shield.shieldID then
		return 'cross'
	end
	
end

function Player:changeVelocityByInput(dt)

	-- Getting current velocity
	local vx,vy = self.vx,self.vy

	if self.leftHorizontal < 0  then
		vx = vx - dt * (vx>0 and brakeAccel or runAccel)
	elseif self.leftHorizontal >0  then
		vx = vx + dt * (vx < 0 and brakeAccel or runAccel)
	else
		local brake = dt * (vx < 0 and brakeAccel or -brakeAccel)
		if math.abs(brake) > math.abs(vx) then
			vx = 0
		else
			vx = vx + brake
		end
	end

	if self.input:pressed 'jump' and (self.onGround or self.numJumps < maxAmountOfJumps) then
		self.numJumps = self.numJumps + 1
		vy = - jumpVelocity
        self.animations.currentAnimation = "jump"
		self.onGround = false
		self.isJumping = true
	end

	if self.input:pressed 'slam' and (not self.onGround and self.numSlams < maxAmountOfSlams) then
		vy = jumpVelocity
		self.isSlamming = true
		--self.isJumping = false
		self.numSlams = self.numSlams + 1
	end

	self.vx, self.vy = vx, vy
end

function Player:checkIfOnGround(ny, col)
	if ny < 0  then self.onGround = true self.isSlamming = false self.numJumps = 0 self.isJumping = false self.animations.frames["jump"]:gotoFrame(1) self.animations.frames["jump"]:resume() end
	if ny < 0 and col.other.class.name  ~= "Player"  then self.numSlams = 0 end
end

function Player:moveColliding(dt)
	self.onGround = false
	local world = self.world

	local future_x = self.x + self.vx * dt
	local future_y = self.y + self.vy * dt

	local next_x, next_y, cols, len = world:move(self,future_x,future_y,self.filter)

	for i = 1, len do
		local col = cols[i]
		if col.other.class.name == 'Player' and col.type == 'slide' then
			col.other:takeHit(1)
		end
		if col.other.class.name ~= 'Shield'then
			self:changeVelocityByNormal(col.normal.x, col.normal.y, bounciness)
			self:checkIfOnGround(col.normal.y, col)
		elseif self.isSlamming then
			self.isSlamming = false
		end		
	end

	self.x, self.y = next_x, next_y
end

function Player:update(dt)
    self.animations.previousDirection = self.animations.currentDirection
	self.rightHorizontal = self.input:get 'rightStickRight' - self.input:get 'rightStickLeft'
	self.rightVertical = self.input:get 'rightStickDown' - self.input:get 'rightStickUp'
	self.leftHorizontal = self.input:get 'leftStickRight' - self.input:get 'leftStickLeft'
	self.leftVertical = self.input:get 'leftStickDown' - self.input:get 'leftStickUp'
    
	self.rightHorizontalRaw = self.input:getRaw 'rightStickRight' - self.input:getRaw 'rightStickLeft'
	self.rightVerticalRaw = self.input:getRaw 'rightStickDown' - self.input:getRaw 'rightStickUp'
	self.leftHorizontalRaw = self.input:getRaw 'leftStickRight' - self.input:getRaw 'leftStickLeft'
	self.leftVerticalRaw = self.input:getRaw 'leftStickDown' - self.input:getRaw 'leftStickUp'
	self:changeVelocityByInput(dt)
	self:changeVelocityByGravity(dt)
    
    if self.leftHorizontal > 0 then
        if not self.isJumping then
            self.animations.currentAnimation = "run"
        end
        self.animations.currentDirection = 1
    elseif self.leftHorizontal < 0 then
        if not self.isJumping then
            self.animations.currentAnimation = "run"
        end
        self.animations.currentDirection = -1
    elseif not self.isJumping then
        self.animations.currentAnimation = "idle"
    end
  
    if self.animations.currentDirection ~= self.animations.previousDirection then
        --self.animations[self.animations.currentAnimation]:flipH() 
        for i,v in pairs(self.animations.frames) do
            self.animations.frames[i]:flipH() 
        end
    end
    
	self:moveColliding(dt)
	self.shield:update(dt)

	if self.health <= 0 then
		self:destroy()
	end

	if self.input:get 'shoot' == 1 and (self.rightHorizontal ~= 0 or self.rightVertical ~= 0) and not self.shot and not (self.input:get 'shield' > 0) then
		local x,y = self:getCenter()
		b = Bullet:new(self.world,x,y,10,10,self,400)
		self.bullets[#self.bullets + 1] = b
		self.shot = true
	elseif self.input:get 'shoot' == 0 then
		self.shot = false
	end
	for i in ipairs(self.bullets) do
		if self.bullets[i].isDead then
			table.remove(self.bullets,i)
		else
			self.bullets[i]:update(dt)
		end
	end
    self.animations.frames[self.animations.currentAnimation]:update(dt)
end


function Player:takeHit(damage)
	self.health = self.health - damage
end

function Player:drawRGB(r,g,b)
	util.drawFilledRectangle(self.x,self.y,self.w,self.h,r,g,b)
	self.shield:draw()
	for i in ipairs(self.bullets) do
		self.bullets[i]:draw()
	end
    love.graphics.setColor(255,255,255)
    self.animations.frames[self.animations.currentAnimation]:draw(self.animations.image,self.x,self.y,0,4,4)
end;

function Player:drawHSL(h,s,l)
	r,g,b = util.HSL(h,s,l)
	self:drawRGB(r,g,b)
    --love.graphics.print("Prev Direction: "..self.animations.currentDirection.."Current Dir: "..self.animations.currentDirection,0,0)
end;

function Player:displayStats()
	love.graphics.print("Health: "..self.health, self.x, self.y - 20)
	love.graphics.print("Shield ID: "..self.shield.shieldID, self.x, self.y - 40)
	love.graphics.print("Left Trigger: "..self.input:get 'shield',self.x,self.y - 60)
	love.graphics.print("Right Trigger: "..self.input:get 'shoot', self.x, self.y - 80)
    love.graphics.print("Left Stick: "..self.leftHorizontal,self.x,self.y - 100)
    love.graphics.print("Previous Dir: "..self.animations.currentDirection.."Current Dir: "..self.animations.currentDirection,self.x,self.y - 120)
    love.graphics.print("Current Animations: "..self.animations.currentAnimation,self.x,self.y - 140)
end

function Player:destroy()
	local angle = 360/10
	local speed = 300
	local x,y = self:getCenter()
	for i = 1, 10 do
		local vx = speed * math.cos(angle * i) 
		local vy = speed * math.sin(angle * i)
		p = Particle:new(self.world,x,y,10,10,vx,vy)
		self.particles[#self.particles + 1] = p
	end
	self.world:remove(self)
	self.shield:destroy()
	self.isDead = true
end

return Player