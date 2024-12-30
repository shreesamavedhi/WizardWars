local lastBulletAngle, lastBx, lastBy = 0, nil, nil

function loadBullets()
    bullets = {}
    bulletSelector = false
end

function addBullet(bx, by, bvx, bvy)
    table.insert(bullets, {
        x = bx,
        y = by,
        vx = bvx,
        vy = bvy,
        speed = 1
    })
end

function updateBullet(dt)
    local isDown = love.keyboard.isDown
    for i = #bullets, 1, -1 do
        bullet = bullets[i]
        newX =  bullet.x + bullet.speed * bullet.vx
        newY = bullet.y + bullet.speed * bullet.vy
        bullet.x = newX
        bullet.y = newY
        -- remove bullets that are out of bounds
        local outOfBounds = newX < backgroundX or newX > backgroundWidth + backgroundX
                or newY < backgroundY or newY > backgroundHeight + backgroundY
        if outOfBounds then
            table.remove(bullets, i)
        end
        -- remove bullets that hit the enemy if not polarMode
        local enemyCollision = newX > enemy.x and newX < enemy.x + enemyWidth 
                and newY > enemy.y and newY < enemy.y + enemyHeight
        if enemyCollision and not round.polarMode then
            enemy.attackNums[1] = enemy.attackNums[1] - 1
            table.remove(bullets, i)
        end
        -- remove bullets that hit the player if polarMode and not shield repel
        local playerCollision = newX > player.x and newX < player.x + playerWidth 
            and newY > player.y and newY < player.y + playerHeight
        if playerCollision and round.polarMode then
            if player.shieldRepel then
                updatePlayerSpells(i)
            else
                player.defenseNum = player.defenseNum - 1
                round.score = round.score - 1
                if player.defenseNum <= 0 then
                    changeGameState("ended")
                end
                table.remove(bullets, i)
            end
        end
        if round.polarMode and player.shieldRepel then
            shieldTimer:update(dt)
        end
    end
    -- defend mode
    if round.polarMode and round.enemyAttack then
        local bvx, bvy = distanceFrom(player.x + (playerWidth / 2), player.y + (playerHeight / 2), enemy.x + (enemyWidth / 2), enemy.y + (enemyHeight / 2))
        addBullet(enemy.x + (enemyWidth / 2), enemy.y + (enemyHeight / 2), bvx * enemy.bulletSpeed, bvy * enemy.bulletSpeed)
        round.enemyAttack = false
        enemyAttackReset:reset(dt)
    end
    -- attack mode
    if not round.polarMode and round.attackMode and not bulletSelector then
        bulletSelector = true
        round.attackMode = false
        attackReset:reset(dt)
    end
    if bulletSelector and isDown("space") and round.attackMode then
        local bvx = math.cos(lastBulletAngle)
        local bvy = math.sin(lastBulletAngle)
        addBullet(lastBx, lastBy, bvx, bvy)
        bulletSelector = false
    end
    attackReset:update(dt)
    updateEnemySpells(dt)
    enemyAttackReset:update(dt)
end

function updateEnemySpells(dt)
    if enemy.attackMagnet and not round.polarMode then
        for i, bullet in pairs(bullets) do
            bullet.vx, bullet.vy = distanceFrom(enemy.x, enemy.y, bullet.x, bullet.y)
        end
        magnetTimer:update(dt)
    end
end

function updatePlayerSpells(index)
    bullet = bullets[index]
    bullet.vx = bullet.vx * -1
    bullet.vy = bullet.vy * -1
end

function drawBullets()
    love.graphics.setColor(1, 1, 1, 1)
    for i, bullet in pairs(bullets) do
        love.graphics.circle("fill", bullet.x, bullet.y, 4)
    end
    if bulletSelector then
        lastBulletAngle = lastBulletAngle + 0.02
        lastBx = player.x + (playerWidth / 2) + math.cos(lastBulletAngle) * 50
        lastBy = player.y + (playerHeight / 2) + math.sin(lastBulletAngle) * 50
        love.graphics.circle("fill", lastBx, lastBy, 4)
    end
end