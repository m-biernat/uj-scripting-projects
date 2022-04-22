require "board"
require "block"
require "gfx"

title = "Tetris"

game = {}
game.updateDelay = 0.1

function love.load()
    love.window.setTitle(title)
    love.graphics.setBackgroundColor(gfx.bgColor["r"], 
                                     gfx.bgColor["g"], 
                                     gfx.bgColor["b"])
    board.setup()

    counter = 0
end

function love.update(dt)
    counter = counter + dt
    if counter > game.updateDelay then
        block.moveTo(board, 0, 1)
        counter = 0
    end
end

function love.draw()
    gfx.drawBlock(block)
    gfx.drawBoard(board)
end
