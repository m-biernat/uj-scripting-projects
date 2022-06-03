class Player
    attr_accessor :p
    attr_reader :size
    attr_accessor :v

    def initialize
        @size = 25
        x = (Window.width / 2) - (@size / 2)
        y = (Window.height / 2) - (@size / 2)
        @p = Vec2(x, y)
        @v = Vec2(0, 0)
        
        @v_jump = 10
        @v_move = 3
        @v_fall = 0.3
        
        @j_timer = 0
        @j_frames = 30

        @shape = Square.new(x: @p.x, y: @p.y, size: @size, color: 'gray')
    end

    def move
        if @j_timer == @j_frames
            @v.y = 0
            @j_timer = 0
        end

        @p.x += @v.x

        @p.y += @v.y
        @v.y += @v_fall
    
        if @v.y < 0
            @j_timer += 1
        end
    end

    def after_collsions
        @v.x = 0
        @shape.x = @p.x
        @shape.y = @p.y
    end

    def go_left
        @v.x = -@v_move
    end

    def go_right
        @v.x = @v_move
    end

    def jump
        if @v.y == 0
            @v.y = -@v_jump
        end
    end
end
