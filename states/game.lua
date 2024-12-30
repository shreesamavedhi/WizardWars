function startGame()
    game = {
        round = 0,
        deck = {},
        unlocks = {},
        money = 0,
        state = {
            ["menu"] = true,
            ["paused"] = false,
            ["running"] = false,
            ["ended"] = false
        }
    }
end

function continueRun()
    if love.filesystem.exists("saveGame.lua") then
        print("Is it getting here?")
        jsonData = love.filesystem.read("saveGame.lua")
        data = json.decode(jsonData)
        print(data)
        game = {
            round = data.round,
            deck = data.deck,
            unlocks = data.unlocks,
            money = data.money,
            state = data.state
        }
        resetRound()
        love.graphics.clear()
    end
end

function resetGame()
    game.round = 0
    game.deck = {}
    game.unlocks = {}
    game.money = 0
end

function startNewRun()
    _ = love.filesystem.remove("saveGame.lua")
    resetGame()
    resetRound()
    changeGameState("running")
    love.graphics.clear()
end

function changeGameState(state)
    game.state.menu = state == "menu"
    game.state.shop = state == "shop"
    game.state.running = state == "running"
    game.state.ended = state == "ended"

    if game.state.ended then
        resetGame()
    end
end

function saveGame()
    data = {
        level = game.level,
        round = game.round,
        deck = game.deck,
        unlocks = game.unlocks,
        state = game.state,
    }
    love.filesystem.write("saveGame.lua", json.encode(data))
end