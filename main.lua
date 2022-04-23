require "game"
require "block"
require "gfx"
require "input"

function love.load()
    love.window.setTitle("Tetris")
    love.keyboard.setKeyRepeat(true)

    love.graphics.setBackgroundColor(gfx.bgColor.r, 
                                     gfx.bgColor.g, 
                                     gfx.bgColor.b)

    love.graphics.setNewFont(64)
    
    board.setup()
    block.create()

    counter = 0
end

function love.update(dt)
    if game.isOver == true then
        gfx.animateGameOver()
        do return end
    end

    counter = counter + dt
    if counter > game.tickRate then
        if game.isReady then
            input.beforeMove()
            block.moveTo(input.x, input.y)
            input.afterMove()
        end
        counter = 0
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
    gfx.drawBlock()
    gfx.drawBoard()

    if game.isOver then
        gfx.drawGameOver()
    end
end
