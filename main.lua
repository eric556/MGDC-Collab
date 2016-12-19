Gamestate = require "libs.hump.gamestate"
Bump = require "libs.bump.bump"
Baton = require "libs.baton.baton"
util = require "util"
Player = require "entities.player"
Tiki = require "entities.characters.Tiki"
Block = require "entities.block"

local menu = {}
local game = {}
local world = Bump.newWorld()
players = {}
particles = {}
numberOfPlayers = 0

controls = {
  leftStickLeft = {'axis:leftx-','key:left','button:dpleft'},
  leftStickRight = {'axis:leftx+','key:right', 'button:dpright'},
  leftStickUp = {'axis:lefty-'},
  leftStickDown= {'axis:lefty+'},
  rightStickLeft = {'axis:rightx-'},
  rightStickRight = {'axis:rightx+'},
  rightStickUp = {'axis:righty-'},
  rightStickDown= {'axis:righty+'},
  jump = {'button:a', 'key:up','button:dpup'},
  slam = {'button:x', 'key:down','button:dpdown'},
  shield = {'axis:triggerleft+'},
  shoot = {'axis:triggerright+'}
}


function menu:draw()
    love.graphics.print("Press Enter to continue", 10, 10)
end

function menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game)
    end
end

function game:enter()
    local width, height = love.graphics.getDimensions()
    floor = Block:new(world,0,height - 10,width,10)
    floor2 = Block:new(world,0,300,400,10)
end

function game:update(dt)
    for i in ipairs(players) do
        if players[i].isDead then
            particles[#particles + 1] = players[i].particles
            table.remove(players,i)
        else
            players[i].input:update()
            players[i]:update(dt)
            --players[i].animations["run"]:update(dt)
        end
    end
    for i in ipairs(particles) do
        for j in ipairs(particles[i]) do
            if particles[i][j].isDead then
                table.remove(particles[i],j)
            else
                particles[i][j]:update(dt)
            end
        end
    end
    floor:update(dt)
    floor2:update(dt)
    if love.keyboard.isDown( "escape" ) then
        love.event.quit()
    end
end

function game:draw()
    for i in ipairs(players) do
        players[i]:drawHSL(i * 50, 90, 58)
        --love.graphics.setColor(255,255,255)
        --players[i].animations["walk"]:draw(players[i].animations.image,players[i].x,players[i].y,0,4,4)
        --players[i]:draw()
        players[i]:displayStats()
    end

    for i in ipairs(particles) do
        for j in ipairs(particles[i]) do
            particles[i][j]:draw()
        end
    end
    floor:drawHSL(50,90,58)
    floor2:drawHSL(50,90,58)
end

function love.load()
    Gamestate.registerEvents()
    numberOfPlayers = numberOfPlayers + 1
    p = Player:new(world,10 + (55 * numberOfPlayers),10,32 * 4,32 * 4,joystick,controls)
    p.animations.image = love.graphics.newImage('characters.png')
    p.animations.grid = anim8.newGrid(32,32,p.animations.image:getWidth(),p.animations.image:getHeight())
    p.animations.frames["walk"] = anim8.newAnimation(p.animations.grid('1-4',2),0.1)
    p.animations.frames["idle"] = anim8.newAnimation(p.animations.grid(1,2),0.1)
    --p.animations.frames["jump"] = anim8.newAnimation(p.animations.grid(5,2),0.1)
    p.animations.frames["jump"] = anim8.newAnimation(p.animations.grid('5-6',2),0.2,'pauseAtEnd')
    p.animations.frames["fall"] = anim8.newAnimation(p.animations.grid(7,2),0.1)
    p.animations.frames["land"] = anim8.newAnimation(p.animations.grid(8,2),0.1)
    p.animations.frames["hit"] = anim8.newAnimation(p.animations.grid('9-10',2,9,2),0.1)
    p.animations.frames["run"] = anim8.newAnimation(p.animations.grid('15-18',2),0.1)
	players[#players + 1] = p
    Gamestate.switch(menu)
end

function love.joystickadded(joystick)
    numberOfPlayers = numberOfPlayers + 1
    p = Player:new(world,10 + (55 * numberOfPlayers),10,32 * 4,32 * 4,joystick,controls)
    p.animations.image = love.graphics.newImage('characters.png')
    p.animations.grid = anim8.newGrid(32,32,p.animations.image:getWidth(),p.animations.image:getHeight())
    p.animations.frames["walk"] = anim8.newAnimation(p.animations.grid('1-4',2),0.1)
    p.animations.frames["idle"] = anim8.newAnimation(p.animations.grid(1,2),0.1)
    --p.animations.frames["jump"] = anim8.newAnimation(p.animations.grid(5,2),0.1)
    p.animations.frames["jump"] = anim8.newAnimation(p.animations.grid('5-6',2),0.2,'pauseAtEnd')
    p.animations.frames["fall"] = anim8.newAnimation(p.animations.grid(7,2),0.1)
    p.animations.frames["land"] = anim8.newAnimation(p.animations.grid(8,2),0.1)
    p.animations.frames["hit"] = anim8.newAnimation(p.animations.grid('9-10',2,9,2),0.1)
    p.animations.frames["run"] = anim8.newAnimation(p.animations.grid('15-18',2),0.1)
	players[#players + 1] = p
end