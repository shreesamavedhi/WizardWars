function loadEnemy()
    enemy = {
        x = 200,
        y = 200,
        speed = 0.3,
        scale = 3.5,
        vx = 1,
        vy = 1,
        attackColors = {},
        attackNums = {},
        spriteSheet = love.graphics.newImage('sprites/player.png'),
    }
    enemyWidth, enemyHeight = 1, 1
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

function updateEnemy()
    local updateNums = game.round
    for i = #enemy.attackNums, updateNums do
        addAttackNums(love.math.random(10, 30), colorArray[love.math.random(1, #colorArray)])
    end
end

function drawEnemy()

end