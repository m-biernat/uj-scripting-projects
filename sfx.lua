sfx = {}

function sfx.load()
    sfx.click = love.audio.newSource("audio/click.ogg", "static")
    sfx.place = love.audio.newSource("audio/place.ogg", "static")
    sfx.score = love.audio.newSource("audio/score.ogg", "static")
    sfx.gameover = love.audio.newSource("audio/game-over.ogg", "static")
end

return sfx
