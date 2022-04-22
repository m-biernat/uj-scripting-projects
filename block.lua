require "fragment"

block = {}
block.fragment = fragment[0][0]
block.position = {["x"] = 5, ["y"] = 0}
block.nextPosition = {}
block.sideCollision = false
block.downCollision = false

function block.checkDownBorderCollision(position)
    if position["ny"] > 19 then
        return true
    else
        return false
    end
end

function block.checkSideBorderCollision(position)
    if position["nx"] < 0 then
        return true
    elseif position["nx"] > 9 then
        return true
    else
        return false
    end
end

function block.checkDownBoardCollision(position, board)
    if board[position["x"]][position["ny"]] > 0 then
        return true
    else
        return false
    end
end

function block.checkSideBoardCollision(position, board)
    if board[position["nx"]][position["y"]] > 0 then
        return true
    else
        return false
    end
end

function block.setCollisionFlags(board)
    block.downCollision = false
    block.sideCollision = false

    local position = {["x"] = 0, ["y"] = 0, ["nx"] = 0, ["ny"] = 0}

    for x = 0, block.fragment.size["x"] - 1 do
        for y = 0, block.fragment.size["y"] - 1 do
            if block.fragment[x][y] == 0 then goto continue end

            position["x"] = block.position["x"] + x
            position["y"] = block.position["y"] + y
            position["nx"] = block.nextPosition["x"] + x
            position["ny"] = block.nextPosition["y"] + y
            
            if block.checkDownBorderCollision(position) == true then
                block.downCollision = true
                do return end
            elseif block.checkDownBoardCollision(position, board) == true then
                block.downCollision = true
                do return end
            end

            if block.checkSideBorderCollision(position) == true then
                block.sideCollision = true
                do return end
            elseif block.checkSideBoardCollision(position, board) == true then
                block.sideCollision = true
                do return end
            end

            ::continue::
        end
    end
end

function block.place(board)
    local position = {["x"] = 0, ["y"] = 0}
    
    for x = 0, block.fragment.size["x"] - 1 do
        for y = 0, block.fragment.size["y"] - 1 do
            if block.fragment[x][y] == 0 then goto continue end
            
            position["x"] = block.position["x"] + x
            position["y"] = block.position["y"] + y
            
            board[position["x"]][position["y"]] = block.fragment[x][y]

            ::continue::
        end
    end
end

function block.move()
    block.position["x"] = block.nextPosition["x"]
    block.position["y"] = block.nextPosition["y"]
end

function block.reset()
    block.position["x"] = math.random(0, 8)
    block.position["y"] = 0
end

function block.moveTo(board, x, y)
    block.nextPosition["x"] = block.position["x"] + x
    block.nextPosition["y"] = block.position["y"] + y

    block.setCollisionFlags(board)

    if block.downCollision == true then
        block.place(board)
        block.reset()
    elseif block.sideCollision == true then
        block.nextPosition["x"] = block.position["x"]
        block.nextPosition["y"] = block.position["y"] + 1
        
        block.setCollisionFlags(board)
        
        if block.downCollision == true then
            block.place(board)
            block.reset()
        else
            block.move()
        end
    else
        block.move()
    end
end

return block
