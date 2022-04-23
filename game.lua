game = {}

game.tickRate = 0.5
game.fallTickRate = 0.5
game.isReady = true
game.isOver = false
game.nextBlockId = 0
game.score = 0

function game.onStart()
    board.setup()
    game.nextBlockId = block.getNext()
    block.create(game.nextBlockId)
end

function game.onBlockCreate()
    game.nextBlockId = block.getNext()
end

function game.onBlockMove()

end

function game.onBlockPlace()
    board.scan()
    block.create(game.nextBlockId)
end

function game.onFill()
    game.isReady = false
    game.score = game.score + 100
end

function game.onScore()
    board.move()
    game.isReady = true
end

function game.onGameOver()
    game.isOver = true
end

return game
