function loadBackground()
    -- background = love.graphics.newImage('sprites/background.png')
end

function drawBackground()
    love.graphics.setColor(1, 1, 1, 1)
    backgroundWidth, backgroundHeight = 950, 450
    backgroundX, backgroundY = 20, 20
    love.graphics.rectangle("line", backgroundX, backgroundY, backgroundWidth, backgroundHeight)
    -- love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth()/background:getWidth(), love.graphics.getHeight()/background:getHeight())
end