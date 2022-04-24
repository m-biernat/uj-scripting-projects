require("table-show")

game = {}

game.savename = "tetris.sav"

game.tickRate = 0.5
game.fallTickRate = 0.5
game.nextBlockId = 0

game.isReady = false
game.isOver = false

game.score = 0
game.seed = 0

function game.start()   
    board.setup()
    
    game.seed = os.time()
    math.randomseed(game.seed)
    
    game.nextBlockId = block.getNext()
    block.create(game.nextBlockId)
    
    game.isOver = false
    game.isReady = true
    game.score = 0

    gfx.startButton.label = "RESTART"
end

function game.load()
    love.filesystem.load(game.savename)()
    
    game.nextBlockId = save._game.nextBlockId
    game.isReady = save._game.isReady
    game.isOver = save._game.isOver
    game.score = save._game.score
    game.seed = save._game.seed

    math.randomseed(game.seed)
    
    block.load(save._block)
    board.load(save._board)
    
    save = nil

    gfx.startButton.label = "RESTART"
end

function game.save()
    local save = {
        _game = {
            nextBlockId = game.nextBlockId,
            isReady = game.isReady,
            isOver = game.isOver,
            score = game.score,
            seed = game.seed
        },
        _block = block.save(),
        _board = board.save()
    }
    love.filesystem.write(game.savename, table.show(save, "save"))
end

function game.quit()
    love.event.quit()
end

function game.onBlockCreate()
    game.nextBlockId = block.getNext()
end

function game.onBlockMove()
    
end

function game.onBlockPlace()
    board.scan()
    block.create(game.nextBlockId)
    love.audio.play(sfx.place)
end

function game.onFill()
    game.isReady = false
    game.score = game.score + 100
    love.audio.play(sfx.score)
end

function game.onScore()
    board.move()
    game.isReady = true
end

function game.onGameOver()
    game.isOver = true
    love.audio.play(sfx.gameover)
end

function game.onClick()
    love.audio.play(sfx.click)
end

return game
