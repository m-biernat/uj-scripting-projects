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
