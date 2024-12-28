local deckX, deckY = 1000, 400
local hand = {}
local discarded = {}

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
    
    suits = {}
    spriteSheet = love.graphics.newImage('sprites/card-backs.png')
    suits["sun"] = love.graphics.newQuad(0, 0, cardWidth, cardHeight, spriteSheet)
    suits["moon"] = love.graphics.newQuad(cardWidth, 0, cardWidth, cardHeight, spriteSheet)
    suits["ice"] = love.graphics.newQuad(cardWidth * 2, 0, cardWidth, cardHeight, spriteSheet)
    suits["fire"] = love.graphics.newQuad(cardWidth * 3, 0, cardWidth, cardHeight, spriteSheet)

    cards = {}
    for suit, _ in pairs(suits) do
        for j = 1, 9 do
            table.insert(cards, newCard(suit, j))
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
            and x < card.transform.x + cardWidth
            and y > card.transform.y
            and y < card.transform.y + cardHeight
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
    played = playCards()
    drawHand()
end

function scoreCards()
    played = playCards()
    drawHand()
end

function playCards()
    local played = {}
    for i = 1, #hand do
        if hand[i].selected then
            hand[i].inHand = false
            hand[i].selected = false
            card = table.remove(hand, i)
            table.insert(played, card)
            table.insert(discarded, card)
        end
    end
    return played
end

function updateCards()
    margin = 50 / #hand
    selectHeight = 300
    for i, card in pairs(hand) do
        hand[i].transform.x = (screenWidth - cardWidth) / 2 - (i * (cardWidth + margin)) + 300
        if card.selected then
            hand[i].transform.y = selectHeight
        else
            hand[i].transform.y = deckY
        end
    end
end


function dealCard(i)
    cards[i].inHand = true
    table.insert(hand, cards[i])
    _ = table.remove(cards,1)
end

function drawHand()
    for i = #hand, 4 do
        dealCard(i+1)
    end
end

function returnToDeck()
    for i, _ in pairs(cards) do
        cards[i].inHand = false
    end
end

function drawCards()
    for _, card in pairs(cards) do
        love.graphics.draw(spriteSheet, suits[card.suit], card.transform.x, card.transform.y)
    end
    for _, card in pairs(hand) do
        love.graphics.draw(spriteSheet, suits[card.suit], card.transform.x, card.transform.y)
    end
end