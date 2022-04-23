require "board"
require "fragment"

block = {}
block.id = 4
block.rotation = 0
block.fragment = fragment[4][0]
block.position = {x = 5, y = 0}
block.nextPosition = {}
block.sideCollision = false
block.downCollision = false

function block.checkDownBorderCollision(position)
    if position.ny > 19 then
        return true
    else
        return false
    end
end

function block.checkSideBorderCollision(position)
    if position.nx < 0 then
        return true
    elseif position.nx > 9 then
        return true
    else
        return false
    end
end

function block.checkDownBoardCollision(position)
    if board[position.x][position.ny] > 1 then
        return true
    else
        return false
    end
end

function block.checkSideBoardCollision(position)
    if board[position.nx][position.y] > 1 then
        return true
    else
        return false
    end
end

function block.setCollisionFlags(fragment)
    block.downCollision = false
    block.sideCollision = false

    local position = {x = 0, y = 0, nx = 0, ny = 0}

    for x = 0, fragment.size.x - 1 do
        for y = 0, fragment.size.y - 1 do
            if fragment[x][y] == 0 then goto continue end

            position.x = block.position.x + x
            position.y = block.position.y + y
            position.nx = block.nextPosition.x + x
            position.ny = block.nextPosition.y + y
            
            if block.checkDownBorderCollision(position) == true then
                block.downCollision = true
                do return end
            elseif block.checkDownBoardCollision(position) == true then
                block.downCollision = true
                do return end
            end

            if block.checkSideBorderCollision(position) == true then
                block.sideCollision = true
                do return end
            elseif block.checkSideBoardCollision(position) == true then
                block.sideCollision = true
                do return end
            end

            ::continue::
        end
    end
end

function block.placeOnBoard()
    local position = {x = 0, y = 0}
    
    for x = 0, block.fragment.size.x - 1 do
        for y = 0, block.fragment.size.y - 1 do
            if block.fragment[x][y] == 0 then goto continue end
            
            position.x = block.position.x + x
            position.y = block.position.y + y
            
            board[position.x][position.y] = block.fragment[x][y]

            ::continue::
        end
    end

    game.onBlockPlace()
end

function block.move()
    block.position.x = block.nextPosition.x
    block.position.y = block.nextPosition.y
end

function block.create()
    block.id = math.random(0, 6)
    block.rotation = 0
    block.fragment = fragment[block.id][block.rotation]
    block.position.x = math.random(0, 10 - block.fragment.size.x)
    block.position.y = 0

    for x = 0, block.fragment.size.x - 1 do
        for y = 0, block.fragment.size.y - 1 do
            if board[block.position.x + x][block.position.y + y] > 1 then
                game.onGameOver()
                do return end
            end
        end
    end

    game.onBlockCreate()
end

function block.moveTo(x, y)
    block.nextPosition.x = block.position.x + x
    block.nextPosition.y = block.position.y + y

    block.setCollisionFlags(block.fragment)

    if block.downCollision == true then
        block.placeOnBoard()
    elseif block.sideCollision == true then
        block.nextPosition.x = block.position.x
        block.nextPosition.y = block.position.y + 1
        
        block.setCollisionFlags(block.fragment)
        
        if block.downCollision == true then
            block.placeOnBoard()
        else
            block.move()
        end
    else
        block.move()
    end
end

function block.rotate()
    local rotation = block.rotation + 1
    
    if rotation > 3 then
        rotation = 0
    end

    local rotated = fragment[block.id][rotation]

    if block.position.x + rotated.size.x - 1 > 9 then
        do return end
    elseif block.position.y + rotated.size.y - 1 > 19 then
        do return end
    else
        for x = 0, rotated.size.x - 1 do
            for y = 0, rotated.size.y - 1 do
                if board[block.position.x + x][block.position.y + y] > 1 then
                    do return end
                end
            end
        end
    end

    block.rotation = rotation
    block.fragment = rotated
end

return block
