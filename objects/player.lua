function loadPlayer()
    player = {
        x = 200,
        y = 200,
        speed = 0.3,
        scale = 3,
        vx = 1,
        vy = 1,
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

    player.anim = stillTable[1]
end

function updatePlayer(dt)
    local isDown = love.keyboard.isDown
    local lvx = isDown("left") and -1 or isDown("right") and 1 or 0
    local lvy = isDown("up") and -1 or isDown("down") and 1 or 0
    player.vx = lvx~=0 and lvx or player.vx
    player.vy = lvy~=0 and lvy or player.vy
    player.x = player.x + player.speed * lvx
    player.y = player.y + player.speed * lvy
    player.anim = (lvx~=0 or lvy~=0) and animTable[player.vx] or stillTable[player.vx]
    player.anim:update(dt)
end

function drawPlayer()
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, player.scale, player.scale)
end