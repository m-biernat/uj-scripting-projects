class Score
    def initialize(player)
        @player = player
        @text = Text.new('00')
        @text.x = Window.width - 35
        @text.y = 21
        Circle.new(x: Window.width - 60, y: 32, radius: 15, color: 'yellow')
    end

    def update
        @text.text = @player.score
    end
end

class Life
    def initialize(player)
        @player = player    
        @lives = []
        @current = @player.lives
        for i in 0..(@player.lives - 1)
            off = i * 30
            t = Triangle.new(
                x1: 40 + off,  y1: 15,
                x2: 15 + off, y2: 15,
                x3: 27.5 + off,   y3: 40,
                color: 'red'
            )
            @lives.append(t)
        end
    end

    def update
        if @player.lives < @current
            @current -= 1
            @lives[@current].remove
        end
    end
end
