gfx = {}

gfx.boardSpacing = 28
gfx.boardOffsetX = 240
gfx.boardOffsetY = 20
gfx.rectSize = 25

function gfx.drawRect(mode, x, y, color)
    love.graphics.setColor(color["r"], color["g"], color["b"], color["a"])
    love.graphics.rectangle(mode, 
                            x * gfx.boardSpacing + gfx.boardOffsetX, 
                            y * gfx.boardSpacing + gfx.boardOffsetY, 
                            gfx.rectSize,
                            gfx.rectSize)
end

function gfx.color(r, g, b, a)
    local color = {}
    color["r"] = r/255
    color["g"] = g/255
    color["b"] = b/255
    color["a"] = a/255
    return color
end

gfx.bgColor = gfx.color(176, 196, 222, 0)

gfx.colorRef = {
    [0] = gfx.color(0, 0, 0, 255),
    [1] = gfx.color(255, 255, 255, 255),
    [2] = gfx.color(143, 215, 143, 255),
    [3] = gfx.color(143, 188, 143, 255)
}

function gfx.drawBoard(board)
    for x = 0, 9 do
        for y = 0, 19 do
            if board[x][y] == 0 then
                gfx.drawRect("line", x, y, gfx.colorRef[board[x][y]])
            else
                gfx.drawRect("fill", x, y, gfx.colorRef[board[x][y]])
                gfx.drawRect("line", x, y, gfx.colorRef[0])
            end
        end
    end
end    

function gfx.drawFragments(fragment, position)
    for x = 0, fragment.size["x"] - 1 do
        for y = 0, fragment.size["y"] - 1 do
            gfx.drawRect("fill", position["x"] + x, position["y"] + y, 
                         gfx.colorRef[fragment[x][y]])
        end
    end
end

function gfx.drawBlock(block)
    gfx.drawFragments(block.fragment, block.position)
end

return gfx
