require 'ruby2d'

set width: 800, height: 600
set title: "Ruby2D Game"
set background: 'blue'

class Player
    attr_accessor :x
    attr_accessor :y
    attr_reader :size
    attr_accessor :v_x
    attr_accessor :v_y

    def initialize
        @size = 25
        @x = (Window.width / 2) - (@size / 2)
        @y = (Window.height / 2) - (@size / 2)  
        @v_x = 0
        @v_y = 0
        
        @v_jump = 10
        @v_move = 3
        @v_fall = 0.3
        
        @j_timer = 0
        @j_frames = 30
    end

    def draw 
        @shape = Square.new(x: @x, y: @y, size: @size, color: 'gray')
    end

    def move
        if @j_timer == @j_frames
            @v_y = 0
            @j_timer = 0
        end

        @x += @v_x
        @v_x = 0

        @y += @v_y
        @v_y += @v_fall
    
        if @v_y < 0
            @j_timer += 1
        end
    end

    def go_left
        @v_x = -@v_move
    end

    def go_right
        @v_x = @v_move
    end

    def jump
        @v_y = -@v_jump
    end
end

@player = Player.new()

on :key_held do |event|
    if event.key == 'a'
        @player.go_left()
    elsif event.key == 'd'
        @player.go_right()
    end
end

on :key_down do |event|
    if event.key == 'space'
      @player.jump()
    end
end

def keep_in_bounds(object)
    width = Window.width - object.size
    if object.x <= 0
        object.x = 0
    elsif object.x >= width
        object.x = width
    end

    height = Window.height - object.size
    if object.y <= 0
        object.y = 0
    elsif object.y >= height
        object.y = height
    end
end


update do
    clear
    @player.move
    keep_in_bounds(@player)
    @player.draw
end

show
