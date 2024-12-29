function loadPlayer()
    player = {
        x = 200,
        y = 200,
        speed = 0.3,
        scale = 3.5,
        vx = 1,
        vy = 1,
        shieldRepel = false,
        attackMagnet = false,
        bonus = false,
        defenseNum = nil,
        defenseColor = nil,
        spriteSheet = love.graphics.newImage('sprites/player.png'),
    }

    local grid = anim8.newGrid(32, 32, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    
    walkRight = anim8.newAnimation(grid('1-4', 1, '1-4', 2, '1-2', 3), 0.1)
    walkLeft = walkRight:clone():flipH()
    animTable = {
        [1] = walkRight,
        [-1] = walkLeft
    }

    stillRight = anim8.newAnimation(grid('3-4', 3, '1-2', 4), 0.2)
    stillLeft = stillRight:clone():flipH()
    stillTable = {
        [1] = stillRight,
        [-1] = stillLeft
    }
    playerWidth, playerHeight = stillRight:getDimensions()
    player.anim = stillTable[1]
end

function updatePlayer(dt)
    local isDown = love.keyboard.isDown
    local lvx = isDown("a") and -1 or isDown("d") and 1 or 0
    local lvy = isDown("w") and -1 or isDown("s") and 1 or 0
    player.vx = lvx~=0 and lvx or player.vx
    player.vy = lvy~=0 and lvy or player.vy
    newX =  player.x + player.speed * lvx
    newY = player.y + player.speed * lvy
    -- change this to be for bounding box
    if newX < screenWidth and newX > -1
    and newY < screenHeight and newY > -1 then
        player.x = newX
        player.y = newY
    end
    player.anim = (lvx~=0 or lvy~=0) and animTable[player.vx] or stillTable[player.vx]
    player.anim:update(dt)
    playerAttack(dt)
end

function removeDefenseNum()
    if round.polarMode then
        player.defenseNum, player.defenseColor = nil, nil
    end
end

function playerAttack(dt)
    local isDown = love.keyboard.isDown
    if not round.polarMode and isDown("space") and round.attackMode then
        print("attacked")
        addBullet(player.x, player.y, player.vx, player.vy)
        round.attackMode = false
        attackReset:reset()
    end
    attackReset:update(dt)
end

colors = {
    ["ice"] = {0.647, 0.835, 0.875, 1},
    ["fire"] = {0.882, 0.682, 0.596, 1},
    ["sun"] = {0.937, 0.859, 0.702, 1},
    ["moon"] = {0.718, 0.624, 0.733, 1}
}

colorArray = {
    "ice", "fire", "sun", "moon"
}

function drawPlayer()
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, player.scale, player.scale)
    if round.polarMode then
        player.defenseNum = player.defenseNum or love.math.random(10, 30)
        player.defenseColor = player.defenseColor or colorArray[love.math.random(1, #colorArray)]
        love.graphics.setColor(unpack(colors[player.defenseColor]))
        local font = love.graphics.newFont(32)
        local textW = font:getWidth(tostring(player.defenseNum))
        local textH = font:getHeight(tostring(player.defenseNum))
        local textXMargin = 40
        local textYMargin = 20
        love.graphics.print(
            tostring(player.defenseNum),
            font,
            player.x + textXMargin - (textW / 2),
            player.y - textYMargin - textH
        )
    end
end