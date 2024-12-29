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
        if newX < backgroundX and newX > backgroundWidth + backgroundX
        and newY < backgroundY and newY > backgroundHeight + backgroundY then
            print("removed out of bounds")
            table.remove(bullets, i)
        end
        -- remove bullets that hit the enemy if not polarMode
        if newX > enemy.x and newX < enemy.x + enemyWidth 
        and newY > enemy.y and newY < enemy.y + enemyHeight and not round.polarMode then
            enemy.attackNums[1] = enemy.attackNums[1] - 1
            table.remove(bullets, i)
        end
        -- remove bullets that hit the player if polarMode
        if newX > player.x and newX < player.x + playerWidth 
        and newY > player.y and newY < player.y + playerHeight and round.polarMode then
            print("removed hit player")
            player.defenseNum = player.defenseNum - 1
            table.remove(bullets, i)
        end
    end
    -- attack mode
    if not round.polarMode and round.attackMode and not bulletSelector then
        bulletSelector = true
        round.attackMode = false
        attackReset:reset(dt)
    end
    if bulletSelector and isDown("space") and round.attackMode then
        print("SECOND SPACE")
        local bvx = math.cos(lastBulletAngle)
        local bvy = math.sin(lastBulletAngle)
        addBullet(lastBx, lastBy, bvx, bvy)
        bulletSelector = false
    end
    attackReset:update(dt)
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