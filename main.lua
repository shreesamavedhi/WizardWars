require "objects"
require "components"
require "states"

function love.load()
    anim8 = require 'libraries/anim8/anim8'
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    love.graphics.setDefaultFilter("nearest", "nearest")
    loadGame()
    loadButtons()
    loadPlayer()
    loadCards()
end

function love.mousepressed(x, y)
    selectCards(x, y)
end

function love.update(dt)
    if game.state.running then
        updatePlayer(dt)
        updateCards()
    end
end

function love.draw()
    love.graphics.reset()
    if game.state.menu then
        drawButtons()
    end
    if game.state.running then
        drawPlayer()
        drawCards()
    end
end