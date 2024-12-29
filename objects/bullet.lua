function loadBullets()
    bullets = {}
end

function addBullet(px, py, pvx, pvy)
    table.insert(bullets, {
        x = px,
        y = py,
        vx = pvx,
        vy = pvy,
        speed = 1
    })
end

function updateBullet()
    for i = #bullets, 1, -1 do
        bullet = bullets[i]
        newX =  bullet.x + bullet.speed * bullet.vx
        newY = bullet.y + bullet.speed * bullet.vy
        bullet.x = newX
        bullet.y = newY
        print(bullet.x, bullet.y)
        -- remove bullets that are out of bounds
        if not (newX < screenWidth and newX > -1
        and newY < screenHeight and newY > -1) then
            print("removed out of bounds")
            table.remove(bullets, i)
        end
        -- remove bullets that hit the enemy if not polarMode
        -- if newX > enemy.x and newX < enemy.x + enemyWidth 
        -- and newY > enemy.y and newY < enemy.y + enemyHeight and not round.polarMode then
        --     enemy.attackNums[1] = enemy.attackNums[1] - 1
        --     table.remove(bullets, i)
        -- end
        -- remove bullets that hit the player if polarMode
        if newX > player.x and newX < player.x + playerWidth 
        and newY > player.y and newY < player.y + playerHeight and round.polarMode then
            print("removed hit player")
            player.defenseNum = player.defenseNum - 1
            table.remove(bullets, i)
        end

    end
end

function drawBullets()
    love.graphics.setColor(1, 1, 1)
    for i, bullet in pairs(bullets) do
        love.graphics.circle("fill", bullet.x, bullet.y, 4)
    end
end