local deckX, deckY = 90, 520
local cardScale = 0.7
local selectedScore = 0
local suitMatches = false
local topOfDeck = nil

local
function newCard(suit, number)
    return {
        inHand = false,
        discarded = false,
        selected = false,
        transform = {
            x = deckX,
            y = deckY,
        },
        suit = suit,
        number = number
    }
end

function loadCards()
    cardWidth = 126
    cardHeight = 176
    
    deckBack = love.graphics.newImage('sprites/deck-back.png')
    suits = {}
    spriteSheet = love.graphics.newImage('sprites/card-backs.png')
    suits["sun"] = love.graphics.newQuad(0, 0, cardWidth, cardHeight, spriteSheet)
    suits["moon"] = love.graphics.newQuad(cardWidth, 0, cardWidth, cardHeight, spriteSheet)
    suits["ice"] = love.graphics.newQuad(cardWidth * 2, 0, cardWidth, cardHeight, spriteSheet)
    suits["fire"] = love.graphics.newQuad(cardWidth * 3, 0, cardWidth, cardHeight, spriteSheet)

    cards = {}
    if #game.deck == 0 then
        -- create new deck
        for suit, _ in pairs(suits) do
            for j = 1, 9 do
                table.insert(cards, newCard(suit, tostring(j)))
            end
        end
    else
        -- load game deck from save data
        for _, card in pairs(game.deck) do
            table.insert(cards, card)
        end
    end
    shuffleCards()
    topOfDeck = #cards
    print("Load", 5)
    drawHand(5)
end

function shuffleCards()
    --Fisher-Yates shuffle:
    for i = #cards, 2, -1 do
        local j = math.random(i)
        cards[i], cards[j] = cards[j], cards[i]
    end
end

function selectCards(x, y)
    for i, card in pairs(cards) do
        local isSelecting = x > card.transform.x and x < card.transform.x + (cardWidth * cardScale) 
                    and y > card.transform.y and y < card.transform.y + (cardHeight * cardScale)
        if card.inHand and isSelecting then
            if cards[i].selected == true then
                cards[i].selected = false
                selectedScore = selectedScore - tonumber(cards[i].number)
            else
                cards[i].selected = true
                selectedScore = selectedScore + tonumber(cards[i].number)
            end
        end
    end
end

function discardCards()
    local disCard = playCards()
    drawHand(#disCard)
end

function scoreCards()
    local played = playCards()
    drawHand(#played)
    local scoredNum = 0
    local suitMatches = false
    local matchNum, matchColor = nil, nil
    if round.polarMode then
        -- check if the cards add up to playerNum
        matchNum = player.defenseNum
        matchColor = player.defenseColor
    else
        -- check if cards add up to enemyNum
        matchNum = enemy.attackNums[1]
        matchColor = enemy.attackColors[1]
    end
    for _, card in pairs(played) do
        scoredNum = scoredNum + tonumber(card.number)
        -- bonus points if suit matches the color
        if card.suit == matchColor then
            suitMatches = true
        end
    end
    if scoredNum == matchNum then
        player.shieldRepel = round.polarMode 
        enemy.attackMagnet = not round.polarMode

        magnetTimer:reset()
        shieldTimer:reset()

        removeDefenseNum()
        removeAttackNum()

        print("GOOD SCORE")
        -- cue score sound effect
        if suitMatches then
            player.bonus = true
            print("BONUS")
            -- cue bonus sound effect
        end
    else
        print("BAD SCORE")
        -- cue bad score sound effect
    end
end

function playCards()
    local played = {}
    for i, card in pairs(cards) do
        if card.selected then
            cards[i].inHand = false
            cards[i].selected = false
            cards[i].discarded = true
            selectedScore = selectedScore - tonumber(cards[i].number)
            table.insert(played, card)
        end
    end
    return played
end

function updateCards()
    margin = 70 / 5
    selectHeight = 500
    local inHandCount = 0
    for i = 1, #cards, 1 do
        if cards[i].inHand then
            inHandCount = inHandCount + 1
            cards[i].transform.x = (screenWidth - (cardWidth*cardScale)) / 2 - (inHandCount * ((cardWidth*cardScale) + margin)) + 300
            if cards[i].selected then
                cards[i].transform.y = selectHeight
            else
                cards[i].transform.y = deckY + 20
            end
        end
    end
end

function dealCard()
    if #cards == 0 then return end
    cards[topOfDeck].inHand = true
    topOfDeck = topOfDeck - 1
end

function drawHand(numDraw)
    for i = 1, numDraw do
        dealCard()
    end
end

function returnToDeck()
    for i, card in pairs(cards) do
        cards[i].inHand = false
        cards[i].selected = false
        cards[i].discarded = false
        cards[i].transform.x = deckX
        cards[i].transform.y = deckY
    end
    shuffleCards()
end

local font = nil
function drawCards()
    font = love.graphics.newFont(32)
    for i, card in pairs(cards) do
        if card.inHand then
            love.graphics.setColor(1, 1, 1, 1)
            -- print(card.transform.x, card.transform.y)
            love.graphics.draw(spriteSheet, suits[card.suit], card.transform.x, card.transform.y, nil, cardScale, cardScale)
            local textW = font:getWidth(card.number)
            local textH = font:getHeight(card.number)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(card.number, font, card.transform.x + (((cardWidth * cardScale) - textW)/2), card.transform.y + (((cardHeight * cardScale) - textH)/2), nil, cardScale, cardScale)
        elseif not card.discarded then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(deckBack, card.transform.x - (i*0.2), card.transform.y + (i*0.2), nil, cardScale, cardScale)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(selectedScore), font, 90, 500)
end