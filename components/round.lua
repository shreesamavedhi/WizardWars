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
            print("POLAR ON")
        end
    end)
    attackReset = cron.after(0.5, function()
        if not round.attackMode then
            round.attackMode = true
        end
    end)
end

