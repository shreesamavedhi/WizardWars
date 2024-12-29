function loadEnemy()
    enemy = {
        x = 500,
        y = 200,
        speed = 0.3,
        scale = 3.5,
        vx = 1,
        vy = 1,
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

function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

function updateEnemy()
   lvx = player.x < enemy.x and -1 or player.x > enemy.x and 1 or 0
   lvy = player.y < enemy.y and -1 or player.y > enemy.y and 1 or 0


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