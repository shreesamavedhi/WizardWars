require "objects"
require "components"
require "states"

function love.load()
    --libraries
    cron = require 'libraries/cron/cron'
    anim8 = require 'libraries/anim8/anim8'
    json = require('libraries/json4lua/json/json')

    --music
    mainLoop = love.audio.newSource("music/main.wav", "stream")
    goodScoreWav = love.audio.newSource("music/goodScore.wav", "static")
    badScoreWav = love.audio.newSource("music/badScore.wav", "static")
    bonusWav = love.audio.newSource("music/bonus.wav", "static")
    hitWav = love.audio.newSource("music/hit.wav", "static")
    selectCardWav = love.audio.newSource("music/selectCard.wav", "static")
    purchasedWav = love.audio.newSource("music/purchased.wav", "static")
    notEnoughWav = love.audio.newSource("music/notEnough.wav", "static")
    
    --defaults
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    love.graphics.setDefaultFilter("nearest", "nearest")

    --load all items
    startGame()
    loadBackground()
    loadMenu()
    loadPlayer()
    loadEnemy()
    loadBullets()
    loadCards()
    loadRound()
    loadButtons()
    loadShop()
    loadEnding()
end

function love.mousepressed(x, y)
    if game.state.running then
        selectCards(x, y)
    end
    if game.state.shop then
        selectShop(x, y)
    end
end

function love.update(dt)
    if not mainLoop:isPlaying() then
		love.audio.play(mainLoop)
	end
    if game.state.running then
        updateBullet(dt)
        updatePlayer(dt)
        updateEnemy(dt)
        updateCards(dt)
        polarTime:update(dt)
        updateRound()
    end
    if game.state.shop then
        updateShop(dt)
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
        drawRound()
    end
    if game.state.shop then
        drawBackground()
        drawCards()
        drawItems()
        drawButtons()
    end
    if game.state.ended then
        drawEnding()
    end
end