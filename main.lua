require "objects"
require "components"
require "states"

function love.load()
    cron = require 'libraries/cron/cron'
    anim8 = require 'libraries/anim8/anim8'
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    love.graphics.setDefaultFilter("nearest", "nearest")
    loadGame()
    loadMenu()
    loadPlayer()
    loadEnemy()
    loadBullets()
    loadCards()
    loadRound()
    loadButtons()
end

function love.mousepressed(x, y)
    selectCards(x, y)
end

function love.update(dt)
    if game.state.running then
        updateBullet(dt)
        updatePlayer(dt)
        updateEnemy(dt)
        updateCards()
        polarTime:update(dt)
        updateRound()
    end
end

function love.draw()
    if game.state.menu then
        drawMenu()
    end
    if game.state.running then
        drawBackground()
        drawPlayer()
        drawEnemy()
        drawCards()
        drawButtons()
        drawBullets()
    end
    if game.state.shop then
        drawBackground()
        drawCards()
        drawButtons()
    end
end