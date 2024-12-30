function loadEnding()
    endButtonWidth = screenWidth * 1/3
    endButtonHeight = 64
    endButton = {
        bx = (screenWidth - endButtonWidth) * 1/2,
        by = 500,
        text = "Back to Menu",
        now = false,
        last = false,
        fn = function()
            changeGameState("menu") 
        end
    }
end

function drawEnding()
    local color = {0.4, 0.4, 0.5, 1.0}
    local mx, my = love.mouse.getPosition()
    local hot = mx > endButton.bx and mx < endButton.bx + endButtonWidth 
            and my > endButton.by and my < endButton.by + endButtonHeight
    
    if hot then
        color = {0.8, 0.8, 0.9, 1.0}
    end
    endButton.now = love.mouse.isDown(1)
    if endButton.now and not endButton.last and hot then
        endButton.fn()
    end
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(
        "fill", 
        endButton.bx,
        endButton.by,
        endButtonWidth,
        endButtonHeight,
        10,
        10
    )
    love.graphics.setColor(1, 1, 1, 1)
    local font = love.graphics.newFont("sprites/yoster.ttf", 32)
    local textW = font:getWidth(endButton.text)
    local textH = font:getHeight(endButton.text)
    love.graphics.print(
        endButton.text,
        font,
        endButton.bx + ((endButtonWidth - textW)/2),
        endButton.by + ((endButtonHeight - textH)/2)
    )
    love.graphics.setColor(0.988, 0.165, 0.165, 1)
    local textW = font:getWidth("Game Over")
    local textH = font:getHeight("Game Over")
    love.graphics.print("Game Over", font, endButton.bx + ((endButtonWidth - textW)/2), endButton.by + ((endButtonHeight - textH)/2) - 200)
end
