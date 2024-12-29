local deckX, deckY = 90, 520
local hand = {}
local discarded = {}
local cardScale = 0.7

local
function newCard(suit, number)
    return {
        inHand = false,
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
    for suit, _ in pairs(suits) do
        for j = 1, 9 do
            table.insert(cards, newCard(suit, tostring(j)))
        end
    end
    shuffleCards()
    drawHand()
end

function shuffleCards()
    --Fisher-Yates shuffle:
    for i = #cards, 2, -1 do
        local j = math.random(i)
        cards[i], cards[j] = cards[j], cards[i]
    end
end

function selectCards(x, y)
    for i, card in pairs(hand) do
        if x > card.transform.x
            and x < card.transform.x + (cardWidth * cardScale)
            and y > card.transform.y
            and y < card.transform.y + (cardHeight * cardScale)
        then
            if hand[i].selected == true then
                hand[i].selected = false
            else
                hand[i].selected = true
            end
        end
    end
end

function discardCards()
    local played = playCards()
    drawHand()
end

function scoreCards()
    local played = playCards()
    drawHand()
    local scoredNum = 0
    local suitMatches = false
    local matchNum, matchColor = nil, nil
    if round.polarMode then
        -- check if the cards add up to playerNum
        matchNum = player.defenseNum
        matchColor = player.defenseColor
    else
        -- check if cards add up to enemyNum
        matchNum = enemy.attackNums[0]
        matchColor = enemy.attackColor
    end
    for _, card in pairs(played) do
        scoredNum = scoredNum + tonumber(card.number)
        -- bonus points if suit matches the color
        if card.suit == player.defenseColor then
            suitMatches = true
        end
    end
    if scoredNum == matchNum then
        player.shieldRepel = round.polarMode 
        player.attackMagnet = not round.polarMode
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
    for i = #hand, 1, -1 do
        if hand[i].selected then
            hand[i].inHand = false
            hand[i].selected = false
            --remove the card
            card = table.remove(hand, i)
            table.insert(played, card)
            table.insert(discarded, card)
        end
    end
    return played
end

function updateCards()
    margin = 70 / #hand
    selectHeight = 500
    for i, card in pairs(hand) do
        hand[i].transform.x = (screenWidth - (cardWidth*cardScale)) / 2 - (i * ((cardWidth*cardScale) + margin)) + 300
        if card.selected then
            hand[i].transform.y = selectHeight
        else
            hand[i].transform.y = deckY + 20
        end
    end
end


function dealCard()
    if #cards == 0 then return end
    cards[#cards].inHand = true
    table.insert(hand, cards[#cards])
    _ = table.remove(cards,#cards)
end

function drawHand()
    numDraw = 5 - #hand
    for i = 1, numDraw do
        dealCard()
    end
end

function returnToDeck()
    for i, _ in pairs(cards) do
        cards[i].inHand = false
    end
end

local font = nil
function drawCards()
    for i, card in pairs(cards) do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(deckBack, card.transform.x - (i*0.2), card.transform.y + (i*0.2), nil, cardScale, cardScale)
    end
    font = love.graphics.newFont(32)
    for _, card in pairs(hand) do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(spriteSheet, suits[card.suit], card.transform.x, card.transform.y, nil, cardScale, cardScale)
        local textW = font:getWidth(card.number)
        local textH = font:getHeight(card.number)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(card.number, font, card.transform.x + (((cardWidth * cardScale) - textW)/2), card.transform.y + (((cardHeight * cardScale) - textH)/2), nil, cardScale, cardScale)
    end
end