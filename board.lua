board = {}

function board.setup()
    for x = 0, 9 do
        board[x] = {}
        for y = 0, 19 do
            board[x][y] = 0
        end
    end
end    

return board
