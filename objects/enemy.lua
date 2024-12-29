function loadEnemy()
    enemy = {
        x = 500,
        y = 200,
        speed = 0.1,
        scale = 3.5,
        vx = 1,
        vy = 1,
        attackMagnet = false,
        attackColors = {},
        attackNums = {},
        spriteSheet = love.graphics.newImage('sprites/player.png'),
    }
    enemyWidth, enemyHeight = 100, 100
    loadAttackNums()
end

function loadAttackNums()
    local updateNums = game.round
    for i = #enemy.attackNums, updateNums do
        addAttackNums(love.math.random(10, 30), colorArray[love.math.random(1, #colorArray)])
    end
end

function addAttackNums(num, color)
    table.insert(enemy.attackNums, num)
    table.insert(enemy.attackColors, color)
end

function removeAttackNum()
    if #enemy.attackNums > 0 and not round.polarMode then
        table.remove(enemy.attackNums, 1)
        table.remove(enemy.attackColors, 1)
    end
end

function distanceFrom(x1,y1,x2,y2)
    local distX =  x1 - x2
    local distY =  y1 - y2
    local distance = math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
    return distX/distance, distY/distance
end

function updateEnemy(dt)
    -- local distX =  player.x - enemy.x
    -- local distY =  player.y - enemy.y
    -- local distance = math.sqrt(distX*distX+distY*distY)
    -- local distance = distanceFrom(player.x, player.y, enemy.x, enemy.y)
    -- enemy.vx = distX/distance
    -- enemy.vy = distY/distance
    enemy.vx, enemy.vy = distanceFrom(player.x, player.y, enemy.x, enemy.y)
    if not round.polarMode then
        enemy.vx = enemy.vx * -1
        enemy.vy = enemy.vy * -1
    end
    newX = enemy.x + enemy.vx*enemy.speed
    newY = enemy.y + enemy.vy*enemy.speed

    -- within bounding box
    local inBoundingBox = newX > backgroundX and newX < backgroundWidth + backgroundX - enemyWidth
    and newY > backgroundY and newY < backgroundHeight + backgroundY - enemyHeight
    -- check collision with player when polarMode
    local clashPlayer = checkCollision(newX, newY, enemyWidth, enemyHeight,  player.x - 20, player.y - 20, playerHeight + 40, playerWidth + 40)
    if (not clashPlayer and round.polarMode or not round.polarMode) and inBoundingBox then
            enemy.x = newX
            enemy.y = newY
    end
end

function drawEnemy()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", enemy.x, enemy.y, enemyWidth, enemyHeight)
    if not round.polarMode then
        love.graphics.setColor(unpack(colors[enemy.attackColors[1]]))
        local font = love.graphics.newFont(32)
        local textW = font:getWidth(tostring(enemy.attackNums[1]))
        local textH = font:getHeight(tostring(enemy.attackNums[1]))
        local textXMargin = 40
        local textYMargin = 20
        love.graphics.print(
            tostring(enemy.attackNums[1]),
            font,
            enemy.x + textXMargin - (textW / 2),
            enemy.y - textYMargin - textH
        )
    end
end