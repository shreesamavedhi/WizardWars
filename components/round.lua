function loadRound()
    round = {
        polarMode = false,
        attackMode = true
    }
    polarTime = cron.every(10, function() 
        if round.polarMode then
            round.polarMode = false
            print("POLAR OFF")
        else 
            round.polarMode = true
            bulletSelector = false
            print("POLAR ON")
        end
    end)
    attackReset = cron.after(0.5, function()
        if not round.attackMode then
            round.attackMode = true
        end
    end)
    magnetTimer = cron.after(4, function()
        enemy.attackMagnet = false
    end)
    shieldTimer = cron.after(4, function()
        player.shieldRepel = false
    end)
end

function updateRound()
    if #enemy.attackNums == 0 then
        changeGameState("shop")
        game.round = game.round + 1
        returnToDeck()
    end
end