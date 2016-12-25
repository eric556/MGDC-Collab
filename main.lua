Gamestate = require "libs.hump.gamestate"
Bump = require "libs.bump.bump"
Baton = require "libs.baton.baton"
util = require "util"
Player = require "entities.player"
Tiki = require "entities.characters.Tiki"
Block = require "entities.block"
King = require "entities.characters.King"

local menu = {}
local game = {}
local world = Bump.newWorld()
players = {}
particles = {}
splatter = {}
numberOfPlayers = 0

local keyboard = {
  leftStickLeft = {'key:left','button:dpleft'},
  leftStickRight = {'key:right', 'button:dpright'},
  leftStickUp = {'axis:lefty-'},
  leftStickDown= {'axis:lefty+'},
  rightStickLeft = {'axis:rightx-'},
  rightStickRight = {'axis:rightx+'},
  rightStickUp = {'axis:righty-'},
  rightStickDown= {'axis:righty+'},
  jump = { 'key:up','button:dpup'},
  slam = { 'key:down','button:dpdown'},
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
    love.graphics.setBackgroundColor(74,102,137)
end

function game:update(dt)
    for i in ipairs(players) do
        if players[i].isDead then
            --particles[#particles + 1] = players[i].particles
            local s = {}
            s.image = love.graphics.newImage("Assets/bloodsplats/bloodsplats_0003.png")
            s.x = players[i].x
            s.y = players[i].y
            
            splatter[#splatter + 1] = s
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
                --particles[i][j]:update(dt)
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
    
    for i in ipairs(splatter) do
        love.graphics.setBlendMode("add")
        love.graphics.draw(splatter[i].image,splatter[i].x,splatter[i].y) 
        love.graphics.setBlendMode("alpha")
    end
    
    for i in ipairs(players) do
        players[i]:drawHSL(i * 50, 90, 58)
        players[i]:displayStats()
    end
    

    for i in ipairs(particles) do
        for j in ipairs(particles[i]) do
            --particles[i][j]:draw()
        end
    end
    
    floor:drawHSL(50,90,58)
    floor2:drawHSL(50,90,58)
end

function love.load()
    Gamestate.registerEvents()
    numberOfPlayers = numberOfPlayers + 1
    p = King:new(world,10 + (55 * numberOfPlayers),10,32 * 4,32 * 4,joystick,keyboard)
    p.input = Baton.new(keyboard,joystick)
	players[#players + 1] = p
    Gamestate.switch(menu)
end

function love.joystickadded(joystick)
    numberOfPlayers = numberOfPlayers + 1
    p = King:new(world,10 + (55 * numberOfPlayers),10,32 * 4,32 * 4,joystick,gamepad)
	players[#players + 1] = p
end