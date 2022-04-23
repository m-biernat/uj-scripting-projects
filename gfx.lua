gfx = {}

gfx.boardSpacing = 28
gfx.boardOffsetX = 200
gfx.boardOffsetY = 20
gfx.rectSize = 25

function gfx.setColor(color)
    love.graphics.setColor(color.r, color.g, color.b, color.a)
end

function gfx.drawRect(mode, x, y, color)
    gfx.setColor(color)
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

function gfx.drawFragments(fragment, position, frame)
    for x = 0, fragment.size.x - 1 do
        for y = 0, fragment.size.y - 1 do
            gfx.drawRect("fill", position.x + x, position.y + y, 
                         gfx.colorRef[fragment[x][y]])
            
            if frame == true then
                local id = 0 
                if fragment[x][y] > 0 then
                    id = 1
                end
                
                gfx.drawRect("line", position.x + x,  position.y + y, 
                             gfx.colorRef[id])
            end
        end
    end
end

function gfx.drawBlock()
    gfx.drawFragments(block.fragment, block.position)
end

gfx.sidePanel = {
    offsetX = gfx.boardOffsetX + 12 * gfx.rectSize,
}

gfx.score = {
    text = "SCORE",
    color = gfx.color(0, 0, 0, 150),
    offsetX = gfx.sidePanel.offsetX + 5,
    offsetY = gfx.boardOffsetY - 4,
}

gfx.scoreValue = {
    color = gfx.color(255, 255, 255, 200),
    offsetX = gfx.score.offsetX - 5,
    offsetY = gfx.score.offsetY + gfx.rectSize + 5
}

function gfx.showScore()
    love.graphics.setNewFont(26)
    
    gfx.setColor(gfx.score.color)
    love.graphics.print(gfx.score.text, 
                        gfx.score.offsetX, 
                        gfx.score.offsetY)

    gfx.setColor(gfx.scoreValue.color)
    love.graphics.print(string.format("%06d", game.score), 
                        gfx.scoreValue.offsetX, 
                        gfx.scoreValue.offsetY)
end

gfx.nextBlock = {
    text = "NEXT\nBLOCK",
    color = gfx.color(0, 0, 0, 150),
    offsetX = gfx.sidePanel.offsetX,
    offsetY = gfx.boardOffsetY + 5 * gfx.rectSize
}

function gfx.drawNextBlock()
    love.graphics.setNewFont(26)
    
    gfx.setColor(gfx.nextBlock.color)
    love.graphics.printf(gfx.nextBlock.text, 
                        gfx.nextBlock.offsetX, 
                        gfx.nextBlock.offsetY,
                        100, "center")
    
    local frag = fragment[game.nextBlockId][0]
    local offset = 0
    if frag.size.x % 2 == 0 then
        offset = -1 * (frag.size.x - 3) * 0.5
    end

    gfx.drawFragments(frag, {x = 11 + offset, y = 7}, true)
end

gfx.gameOver = {
    bg = {
        color = gfx.color(0, 0, 0, 100),
        sizeX = gfx.rectSize * 10 + gfx.boardSpacing,
        sizeY = gfx.rectSize * 20 + 2 * gfx.boardSpacing + 2
    },
    text = {
        text = "GAME\nOVER",
        color = gfx.color(230, 28, 52, 255),
        offsetX = gfx.boardOffsetX + 1.6 * gfx.rectSize,
        offsetY = gfx.boardOffsetY + 7.6 * gfx.rectSize
    }, 
    shadow = {
        color = gfx.color(0, 0, 0, 127)
    },
    animation = {
        current = 300,
        startAt = 300,
        finishAt = 0
    }
} 

function gfx.drawGameOver()
    love.graphics.setNewFont(64)
    
    gfx.setColor(gfx.gameOver.bg.color)
    love.graphics.rectangle("fill", 
                            gfx.boardOffsetX, 
                            gfx.boardOffsetY, 
                            gfx.gameOver.bg.sizeX,
                            gfx.gameOver.bg.sizeY)

    gfx.setColor(gfx.gameOver.shadow.color)
    love.graphics.printf(gfx.gameOver.text.text, 
                         gfx.gameOver.text.offsetX - 2, 
                         gfx.gameOver.text.offsetY + 1 - gfx.gameOver.animation.current, 
                         200, "center", 0, 1.02, 1.02)
    
    gfx.setColor(gfx.gameOver.text.color)
    love.graphics.printf(gfx.gameOver.text.text, 
                         gfx.gameOver.text.offsetX, 
                         gfx.gameOver.text.offsetY - gfx.gameOver.animation.current, 
                         200, "center", 0, 1.00, 1.00)
end

function gfx.animateGameOver()
    if (gfx.gameOver.animation.current > gfx.gameOver.animation.finishAt) then
        gfx.gameOver.animation.current = 
        gfx.gameOver.animation.current - 0.02 * gfx.gameOver.animation.startAt
    end
end

return gfx
