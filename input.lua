input = {}

input.x = 0
input.y = 1
input.counter = 0
input.tickRate = 0.1

function input.moveLeft()
    input.x = -1
    input.y = 0
    game.tickRate = input.tickRate
end

function input.moveRight()
    input.x = 1
    input.y = 0
    game.tickRate = input.tickRate
end

function input.moveDown()
    game.tickRate = input.tickRate
end

function input.rotate()
    block.rotate()
end

function input.reset()
    input.x = 0
    input.y = 1
end

function input.beforeMove()
    if input.counter > 2 then
        input.reset()
        input.counter = 0
    end
end

function input.afterMove()
    if input.y == 1 then
        input.counter = 0
    else
        input.counter = input.counter + 1
    end
    input.reset()
    game.tickRate = game.fallTickRate
end

return input
