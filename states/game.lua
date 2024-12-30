function startGame()
    game = {
        round = 0,
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
    if love.filesystem.getInfo("saveGame.lua") then
        jsonData = love.filesystem.read("saveGame.lua")
        data = json.decode(jsonData)
        print(data)
        game = {
            round = data.round,
            unlocks = data.unlocks,
            money = data.money,
            state = data.state
        }
        returnToDeck()
        resetRound()
        enemy.speed = enemy.speed + (game.round * 0.05)
        enemy.bulletSpeed = enemy.bulletSpeed + (game.round * 0.2)
        enemyAttackPeriod = enemyAttackPeriod - (game.round * 0.2)
        love.graphics.clear()
    end
end

function resetGame()
    game.round = 0
    game.unlocks = {}
    game.money = 0
end

function startNewRun()
    _ = love.filesystem.remove("saveGame.lua")
    resetGame()
    loadCards()
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
        round = game.round,
        unlocks = game.unlocks,
        money = game.money,
        state = game.state,
    }
    love.filesystem.write("saveGame.lua", json.encode(data))
end