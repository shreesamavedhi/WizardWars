local deckX, deckY = 1000, 400

local
function newCard(suit, number)
    return {
        selected = false,
        transform = {
            x = (screenWidth - 126) / 2,
            y = (screenHeight - 176) / 2,
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

end

function pressCards(card)
    if x > card.transform.x
        and x < card.transform.x + card.transform.width
        and Y > card.transform.y
        and y < card.transform.y + card.transform.height
    then
        card.selected = true
    end
end

function updateCards()
end

function dealCards()
end

function drawCards()
    for _, card in pairs(cards) do
        love.graphics.draw(spriteSheet, suits[card.suit], deckX, deckY)
    end
end