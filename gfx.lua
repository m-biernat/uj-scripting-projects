require "board"

gfx = {}

gfx.boardSpacing = 28
gfx.boardOffsetX = 240
gfx.boardOffsetY = 20
gfx.rectSize = 25

function gfx.drawRect(mode, x, y, color)
    love.graphics.setColor(color.r, color.g, color.b, color.a)
    love.graphics.rectangle(mode, 
                            x * gfx.boardSpacing + gfx.boardOffsetX, 
                            y * gfx.boardSpacing + gfx.boardOffsetY, 
                            gfx.rectSize,
                            gfx.rectSize)
end

function gfx.color(r, g, b, a)
    local color = {}
    color.r = r/255
    color.g = g/255
    color.b = b/255
    color.a = a/255
    return color
end

gfx.bgColor = gfx.color(176, 196, 222, 0)

gfx.colorRef = {
    [0] = gfx.color(0, 0, 0, 0),
    
    [1] = gfx.color(0, 0, 0, 255),
    
    [2] = gfx.color(254, 223, 98, 255),     -- ## 
    [3] = gfx.color(255, 204, 0, 255),      -- ##
    
    [4] = gfx.color(129, 224, 192, 255),    --
    [5] = gfx.color(51, 203, 152, 255),     -- ####
    
    [6] = gfx.color(83, 174, 219, 255),     -- #
    [7] = gfx.color(40, 136, 184, 255),     -- ###
    
    [8] = gfx.color(255, 181, 108, 255),    --   #
    [9] = gfx.color(255, 153, 52, 255),     -- ###
    
    [10] = gfx.color(186, 222, 116, 255),   --  ##
    [11] = gfx.color(153, 204, 51, 255),    -- ##
    
    [12] = gfx.color(252, 93, 111, 255),    -- ##
    [13] = gfx.color(230, 28, 52, 255),     --  ##
    
    [14] = gfx.color(179, 124, 179, 255),   --  #
    [15] = gfx.color(152, 102, 153, 255)    -- ###
}

function gfx.drawBoard()
    for x = 0, 9 do
        for y = 0, 19 do
            if board[x][y] == 1 then
                gfx.drawRect("line", x, y, gfx.colorRef[board[x][y]])
            else
                gfx.drawRect("fill", x, y, gfx.colorRef[board[x][y]])
                gfx.drawRect("line", x, y, gfx.colorRef[1])
            end
        end
    end
end    

function gfx.drawFragments(fragment, position)
    for x = 0, fragment.size.x - 1 do
        for y = 0, fragment.size.y - 1 do
            gfx.drawRect("fill", position.x + x, position.y + y, 
                         gfx.colorRef[fragment[x][y]])
        end
    end
end

function gfx.drawBlock()
    gfx.drawFragments(block.fragment, block.position)
end

return gfx
