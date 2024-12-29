local
function newButton(text, fn, x, y)
    return {
        text = text,
        fn = fn,
        bx = x,
        by = y,
        now = false,
        last = false
    }
end

local buttons = {}
local font = nil

function loadButtons()
    font = love.graphics.newFont(20)
    table.insert(buttons, newButton(
        "Save & Exit",
        function()
            saveGame()
            changeGameState("ended")
        end,
        1000,
        50
    ))
    table.insert(buttons, newButton(
        "Cast Spell",
        function()
            scoreCards()
        end,
        1000,
        500
    ))
    table.insert(buttons, newButton(
        "Toss Spells",
        function()
            discardCards()
        end,
        1000,
        600
    ))
end

function drawButtons()
    local buttonWidth = screenWidth * 0.1
    local buttonHeight = 64
    local margin = 16
    local totalHeight = (buttonHeight + margin) * #buttons

    for i, button in ipairs(buttons) do
        button.last = button.now

        local color = {0.4, 0.4, 0.5, 1.0}
        local mx, my = love.mouse.getPosition()

        local hot = mx > button.bx and mx < button.bx + buttonWidth 
                and my > button.by and my < button.by + buttonHeight
        
        if hot then
            color = {0.8, 0.8, 0.9, 1.0}
        end
        button.now = love.mouse.isDown(1)
        if button.now and not button.last and hot then
            button.fn()
        end
        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill", 
            button.bx,
            button.by,
            buttonWidth,
            buttonHeight,
            10,
            10
        )

        love.graphics.setColor(0, 0, 0, 1)
        local textW = font:getWidth(button.text)
        local textH = font:getHeight(button.text)
        love.graphics.print(
            button.text,
            font,
            button.bx + ((buttonWidth - textW)/2),
            button.by + ((buttonHeight - textH)/2)
        )
    end
end
