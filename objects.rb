class GameObject
    def move(x, y)
        @shape.x += x
        @shape.y += y
    end
end

class Trigger < GameObject
    def initialize(x, y, r, c)
        @shape = Circle.new(x: x, y: y, radius: r, color: c)
    end

    def check(object)
        if trigger(@shape, object)
            action()
        end
    end

    def action

    end
end

class Teleport < Trigger
    @@colliders
    @@player

    def initialize(x, y, t_off, t_px, t_py)
        super(x, y, 20, 'teal')
        @t_off = t_off
        @t_px = t_px
        @t_py = t_py
    end

    def action
        @@colliders.each do |collider|
            collider.move(-Window.width * @t_off, 0)
            @@player.p.x = @t_px
            @@player.p.y = @t_py
            @@player.v.x = 0
            @@player.v.y = 0
        end
    end

    def self.setup(colliders, player)
        @@colliders = colliders
        @@player = player
    end
end

class Coin < Trigger
    @@player
    
    def initialize(x, y)
        super(x, y, 10, 'yellow')
        @taken = false
    end

    def action
        if !@taken
            @@player.score += 1
            @shape.remove
            @taken = true
        end
    end

    def self.setup(player)
        @@player = player
    end
end

class Collider < GameObject
    attr_accessor :shape

    def initialize(x, y, w, h, c)
        @shape = Rectangle.new(x: x, y: y, width: w, height: h, color: c)
    end

    def check(object)
        resolve_collision(@shape, object)
    end
end

class Platform < Collider
    def initialize(x, w, h)
        super(x, Window.height - h, w, h, 'green')
    end
end

class Obstacle < Collider
    def initialize(x, y, w, h)
        super(x, y, w, h, 'lime')
    end
end

def w_off(i)
    return Window.width * i
end
