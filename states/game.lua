function loadGame()
    data = loadData()
    game = {
        level = data.level,
        round = data.round,
        deck = data.deck,
        unlocks = data.unlocks,
        state = data.state
    }
end

function continueRun()
    if not game.state.running then
        print("No run started")
        return
    end
end

function startNewRun()
    if game.state.running then
        changeGameState("ended")
    end
    changeGameState("running")
    love.graphics.clear()
end

function changeGameState(state)
    game.state.menu = state == "menu"
    game.state.shop = state == "shop"
    game.state.running = state == "running"
    game.state.ended = state == "ended"

    if game.state.ended then
       game.level = 0
       game.round = 0
       game.deck = {}
    end
end
