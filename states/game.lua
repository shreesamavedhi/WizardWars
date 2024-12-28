function loadGame()
    data = loadData()
    game = {
        level = data.level,
        round = data.round,
        deck = data.deck,
        unlocks = data.unlocks,
        state = data.state,
        handSize = data.handSize
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
end

function changeGameState(state)
    game.state.menu = state == "menu"
    game.state.paused = state == "paused"
    game.state.running = state == "running"
    game.state.ended = state == "ended"

    if game.state.ended then
       game.level = 0
       game.round = 0
       game.deck = {}
    end
end
