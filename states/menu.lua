local
function newButton(text, fn)
    return {
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

local buttons = {}
local font = nil

function loadMenu()
    font = love.graphics.newFont(32)
    table.insert(buttons, newButton(
        "Start New Run",
        function()
            startNewRun()
        end
    ))
    table.insert(buttons, newButton(
        "Continue Run",
        function()
            continueRun()
        end
    ))
    table.insert(buttons, newButton(
        "Collections",
        function()
            print("Collections")
        end
    ))
    table.insert(buttons, newButton(
        "Settings",
        function()
            print("Settings")
        end
    ))
    table.insert(buttons, newButton(
        "Exit",
        function()
            love.event.quit(0)
        end
    ))
end

function drawMenu()
    local buttonWidth = screenWidth * 1/3
    local buttonHeight = 64
    local margin = 16
    local totalHeight = (buttonHeight + margin) * #buttons
    
    for i, button in ipairs(buttons) do
        button.last = button.now
        local bx = (screenWidth - buttonWidth) / 2
        local by = (screenHeight - totalHeight) / 2 + ((i - 1) * (buttonHeight + margin))
        buttons[i].bx = bx
        buttons[i].by = by

        local color = {0.4, 0.4, 0.5, 1.0}
        local mx, my = love.mouse.getPosition()

        local hot = mx > bx and mx < bx + buttonWidth 
                and my > by and my < by + buttonHeight
        
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
            bx,
            by,
            buttonWidth,
            buttonHeight
        )

        love.graphics.setColor(0, 0, 0, 1)
        local textW = font:getWidth(button.text)
        local textH = font:getHeight(button.text)
        love.graphics.print(
            button.text,
            font,
            bx + ((buttonWidth - textW)/2),
            by + ((buttonHeight - textH)/2)
        )
    end
end
