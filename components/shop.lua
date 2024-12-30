local purchased = false
local notEnough = false

function newCardUnlock(suit, number, price, name)
    return {
        selected = false,
        price = price,
        card = true,
        suit = suit,
        name = name,
        number = tostring(number),
        x = 0,
        y = 0,
        scale = 0,
        fn = function()
            local unlocked = newCard(suit, tostring(number))
            local insertPos = love.math.random(1, #cards)
            table.insert(cards, unlocked)
            topOfDeck = topOfDeck + 1
        end
    }
end

function newPowerUnlock(fn, price, name, png)
    return {
        selected = false,
        card = false,
        name = name,
        price = price,
        fn = fn,
        png = png,
        x = 0,
        y = 0,
        scale = 0
    }
end

function loadShop()
    unlockList = {
        newPowerUnlock(function() magTime = magTime + 1 end, 4, "PWR_LTMagnet", love.graphics.newImage('sprites/magnet-back.png')),
        newPowerUnlock(function() shieldTime = shieldTime + 1 end, 4, "PWR_LTShield", love.graphics.newImage('sprites/shield-back.png')),
        newCardUnlock("sun", 11, 3, "CRD_Eleven"),
        newCardUnlock("moon", 12, 3, "CRD_Twelve"),
        newCardUnlock("ice", -2, 3, "CRD_NegTwo")
    }
    for i, curList in pairs(unlockList) do
        for j, unlocked in pairs(game.unlocks) do
            if curList[i].name == unlocked[j].name then
                table.remove(unlockList, i)
            end
        end
    end
    purchasedTimer = cron.after(2, function()
        if purchased then
            purchased = false
        end
    end)
    notEnoughTimer = cron.after(2, function()
        if notEnough then
            notEnough = false
        end
    end)
    shuffleUnlocks()
end

function shuffleUnlocks()
    --Fisher-Yates shuffle:
    for i = #unlockList, 2, -1 do
        local j = math.random(i)
        unlockList[i], unlockList[j] = unlockList[j], unlockList[i]
    end
end

function selectShop(x, y)
    for i, unlock in pairs(unlockList) do
        local isSelecting = x > unlock.x and x < unlock.x + (cardWidth * unlock.scale) 
                    and y > unlock.y and y < unlock.y + (cardHeight * unlock.scale)
        if isSelecting then
            if unlockList[i].selected == true then
                unlockList[i].selected = false
            else
                unlockList[i].selected = true
            end
        end
    end
end

function updateShop(dt)
    purchasedTimer:update(dt)
    notEnoughTimer:update(dt)
end

function buyItem()
    local itemCost = 0
    local fnList = {}
    local indexRemove = {}
    for i = 1, 3 do
        if unlockList[i].selected then
            itemCost = itemCost + unlockList[i].price
            table.insert(fnList, unlockList[i].fn)
            table.insert(indexRemove, i)
        end
    end
    local font = love.graphics.newFont("sprites/yoster.ttf", 32)

    if game.money >= itemCost then
        game.money = game.money - itemCost
        for _, fn in pairs(fnList) do
            fn()
        end
        purchased = true
        purchasedTimer:reset()
        for _, i in pairs(indexRemove) do
            table.insert(game.unlocks, unlockList[i])
            table.remove(unlockList, i)
        end
    else
        notEnough = true
        notEnoughTimer:reset()
    end
end

function drawItems()
    if game.state.running then
        print("shop even though running")
    end

    local font = love.graphics.newFont("sprites/yoster.ttf", 50)
    love.graphics.setColor(1, 0.792, 0.016, 1)
    love.graphics.print("Wallet $" .. tostring(game.money), font, 900, 500)

    love.graphics.setColor(1, 1, 1, 1)
    local textW = font:getWidth("Shop")
    local textH = font:getHeight("Shop")
    love.graphics.print("Shop", font, 250, 50)

    for i = 1, 3 do
        if #unlockList < i then
            return
        end
        unlockList[i].x = (i *(200 + cardWidth)) - 220
        unlockList[i].y = 180
        if unlockList[i].selected then
            unlockList[i].y = unlockList[i].y - 50
        end
        unlockList[i].scale = 1.3
        card = unlockList[i]
        love.graphics.setColor(1, 1, 1, 1)
        if unlockList[i].card then
            love.graphics.draw(spriteSheet, suits[card.suit], card.x, card.y, nil, card.scale, card.scale)
            font = love.graphics.newFont("sprites/yoster.ttf", 32)
            local textW = font:getWidth(card.number)
            local textH = font:getHeight(card.number)
            love.graphics.print(card.number, font, card.x + (((cardWidth * card.scale) - textW)/2), card.y 
                                + (((cardHeight * card.scale) - textH)/2), nil, card.scale, card.scale)
        else
            love.graphics.draw(card.png, card.x, card.y, nil, card.scale, card.scale)
        end
        love.graphics.setColor(1, 0.792, 0.016, 1)
        font = love.graphics.newFont("sprites/yoster.ttf", 32)
        love.graphics.print(tostring(card.price) .. "$", font, card.x + (cardWidth * card.scale / 2), card.y + 250)
        if purchased then
            notEnough = false
            love.graphics.setColor(1, 0.792, 0.016, 1)
            love.graphics.print("Purchased", font, 500, 500)
        end
        if notEnough then
            purchased = false
            love.graphics.setColor(1, 0.424, 0.016, 1)
            love.graphics.print("Not Enough $", font, 500, 500)
        end
    end
end