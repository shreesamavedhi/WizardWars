function loadRound()
    round = {
        polarMode = false,
        attackMode = true,
        enemyAttack = false,
        score = 0
    }
    magTime = 4
    shieldTime = 4
    enemyAttackPeriod = 2
    polarTime = cron.every(13, function() 
        if round.polarMode then
            round.polarMode = false
        else 
            round.polarMode = true
            bulletSelector = false
        end
    end)
    attackReset = cron.after(0.5, function()
        if not round.attackMode then
            round.attackMode = true
        end
    end)
    enemyAttackReset = cron.after(enemyAttackPeriod, function()
        if not round.enemyAttack then
            round.enemyAttack = true
        end
    end)
    magnetTimer = cron.after(magTime, function()
        enemy.attackMagnet = false
    end)
    shieldTimer = cron.after(shieldTime, function()
        player.shieldRepel = false
    end)
end

function updateRound()
    if #enemy.attackNums == 0 then
        game.money = math.floor(round.score / 4)
        if game.money < 0 then
            changeGameState("ended")
        else
            changeGameState("shop")
            game.round = game.round + 1
            enemy.speed = enemy.speed + 0.05
            enemy.bulletSpeed = enemy.bulletSpeed + 0.2
            enemyAttackPeriod = enemyAttackPeriod - 0.2
            round.score = 0 
            returnToDeck()
            shuffleUnlocks()
        end
    end
end

function nextRound()
    loadEnemy()
    loadPlayer()
    changeGameState("running")
    drawHand(5)
end

function drawRound()
    local font = love.graphics.newFont("sprites/yoster.ttf", 30)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Score " .. tostring(round.score), font, 1000, 50)
    love.graphics.print("Round " .. tostring(game.round), font, 1000, 100)
    font = love.graphics.newFont("sprites/yoster.ttf", 24)
    if enemy.attackMagnet and not round.polarMode then
        love.graphics.setColor(1, 0.294, 0, 1)
        love.graphics.print("Magnet Active", font, 1000, 150)
    end
    if player.shieldRepel and round.polarMode then
        love.graphics.setColor(1, 0.557, 1, 1)
        love.graphics.print("Shield Active", font, 1000, 150)
    end
end

function resetRound()
    loadCards()
    loadEnemy()
    loadPlayer()
    loadRound()
    round.polarMode = false
    round.attackMode = true
    round.enemyAttack = false
    round.score = 0
end