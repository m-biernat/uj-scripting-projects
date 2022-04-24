require "game"
require "block"
require "gfx"
require "input"
require "sfx"

function love.load()
    love.window.setTitle("Tetris")
    love.keyboard.setKeyRepeat(true)

    love.graphics.setBackgroundColor(gfx.bgColor.r, 
                                     gfx.bgColor.g, 
                                     gfx.bgColor.b)
    
    board.setup()

    sfx.load()

    counter = 0
end

function love.update(dt)
    if game.isOver == true then
        gfx.animateGameOver()
        do return end
    end

    counter = counter + dt
    if counter > game.tickRate then
        if game.isReady == true then
            input.beforeMove()
            block.moveTo(input.x, input.y)
            input.afterMove()
        end
        counter = 0
    end

    if board.isFilled == true then
        gfx.animateScore(counter)
    end
end

function love.mousepressed(x, y, button, istouch)
    if istouch or button == 1 then
        input.upButton:Press(x, y)
        input.downButton:Press(x, y)
        input.leftButton:Press(x, y)
        input.rightButton:Press(x, y)

        gfx.startButton:Press(x, y)
        gfx.loadButton:Press(x, y)
        gfx.saveButton:Press(x, y)
        gfx.quitButton:Press(x, y)
    end
end

function love.keypressed(key)
    if key == "a" or key == "left" then
        input.moveLeft()
    elseif key == "d" or key == "right" then
        input.moveRight()
    elseif key == "s" or key == "down" then
        input.moveDown()
    elseif key == "w" or key == "up" then
        input.rotate()
    end
end

function love.draw()
    gfx.showScore()
    gfx.drawNextBlock()
    
    if game.isReady == true then
        gfx.drawBlock()
    end
    gfx.drawBoard()

    if game.isOver then
        gfx.drawGameOver()
    end

    gfx.startButton:Draw()
    gfx.loadButton:Draw()
    gfx.saveButton:Draw()
    gfx.quitButton:Draw()
end
