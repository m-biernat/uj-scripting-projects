Button = {}
function Button:Create(text, px, py, sx, sy, func)
    local this = {
        label = text,
        position = {
            x = px,
            y = py
        },
        size = {
            x = sx,
            y = sy
        },
        callback = func
    }

    function this:Press(x, y)
        if  x >= self.position.x 
        and x <= self.position.x + self.size.x
        and y >= self.position.y
        and y <= self.position.y + self.size.y 
        then
            game.onClick()
            self.callback()
        end
    end

    function this:Draw()
        love.graphics.setColor(0, 0, 0.1, 0.15)
        love.graphics.rectangle("fill",
                                self.position.x,
                                self.position.y,
                                self.size.x,
                                self.size.y)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("line",
                                self.position.x,
                                self.position.y,
                                self.size.x,
                                self.size.y)
            
        love.graphics.setNewFont(20)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(self.label, 
                             self.position.x,
                             self.position.y + self.size.y / 4 + 2,
                             self.size.x,
                             "center")
    end

    return this
end
