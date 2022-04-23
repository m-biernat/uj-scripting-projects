game = {}

game.tickRate = 0.5
game.fallTickRate = 0.5
game.isReady = true
game.isOver = false

function game.onBlockCreate()
    
end

function game.onBlockMove()

end

function game.onBlockPlace()
    block.create()
end

function game.onGameOver()
    game.isOver = true
end

return game
