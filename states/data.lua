function createNewSave()
    return {
        level = 0,
        round = 0,
        saveCount = 0,
        deck = {},
        unlocks = {},
        state = {
            ["menu"] = true,
            ["paused"] = false,
            ["running"] = false,
            ["ended"] = false
        }
    }
end

function saveGame()
    data.saveCount = data.saveCount + 1
    data.level = game.level
    data.round = game.round
    data.deck = game.deck
    data.unlocks = game.unlocks
    data.state = game.state
    love.filesystem.write("saveGame.lua", table.show(data, "data"))
end

function loadData()
    if love.filesystem.getInfo("saveGame.lua") ~= nil then
        return love.filesystem.load("saveGame.lua")
    else
        return createNewSave()
    end
end
