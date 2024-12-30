function loadBackground()
    background = love.graphics.newImage('sprites/background.png')
end

function drawBackground()
    love.graphics.setColor(1, 1, 1, 1)
    backgroundWidth, backgroundHeight = 950, 450
    backgroundX, backgroundY = 20, 20
    love.graphics.rectangle("line", backgroundX, backgroundY, backgroundWidth, backgroundHeight)
    love.graphics.draw(background, backgroundX, backgroundY, 0, backgroundWidth/background:getWidth(), backgroundHeight/background:getHeight())
end