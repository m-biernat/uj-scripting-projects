require 'matrix'
require 'ruby2d'

def make_light_constructor(klass)
    eval("def #{klass}(*args) #{klass}.new(*args) end")
end

class Vec2 
    make_light_constructor(Vec2)
    
    attr_accessor :v
    
    def initialize(x, y)
        @v = Vector[x.to_f, y.to_f]
    end

    def x
        @v[0]
    end

    def x=(value)
        @v[0] = value
    end

    def y
        @v[1]
    end

    def y=(value)
        @v[1] = value
    end

    def + (other)
        if other.is_a? Vec2
            r = self.v + other.v
            Vec2(r[0], r[1])
        elsif other.is_a? Float
            Vec2(self.x + other, self.y + other)
        end
    end

    def - (other)
        if other.is_a? Vec2
            r = self.v - other.v
            Vec2(r[0], r[1])
        elsif other.is_a? Float
            Vec2(self.x - other, self.y - other)
        end
    end

    def * (other)
        if other.is_a? Vec2
            self.v.dot(other.v)
        elsif other.is_a? Float
            Vec2(self.x * other, self.y * other)
        end
    end

    def / (other)
        if other.is_a? Vec2
            x = self.x / other.x
            y = self.y / other.y
            Vec2(x, y)
        elsif other.is_a? Float
            Vec2(self.x / other, self.y / other)
        end
    end

    def coerce(n)
        [self, n]
    end
end

def keep_in_bounds(object)
    width = Window.width - object.size
    if object.p.x <= 0
        object.p.x = 0
    elsif object.p.x >= width
        object.p.x = width
    end

    height = Window.height - object.size
    if object.p.y <= 0
        object.p.y = 0
    elsif object.p.y >= height
        object.p.y = height
        object.v.y = 0
    end
end

def left_collision(collider, object)
    x = object.p.x
    y1 = object.p.y - 0.1
    y2 = object.p.y + object.size - 0.1

    upper = collider.contains? x, y1
    lower = collider.contains? x, y2

    return (upper || lower)
end

def right_collision(collider, object)
    x = object.p.x + object.size
    y1 = object.p.y - 0.1
    y2 = object.p.y + object.size - 0.1

    upper = collider.contains? x, y1
    lower = collider.contains? x, y2

    return (upper || lower)
end

def down_collision(collider, object)
    x1 = object.p.x
    y = object.p.y + object.size + 0.9
    x2 = object.p.x + object.size

    left = collider.contains? x1, y
    inner_left = collider.contains? x1 + 4, y
    right = collider.contains? x2, y
    inner_right = collider.contains? x2 - 4, y

    return (left && inner_left || right && inner_right)
end

def resolve_collision(collider, object)
    if object.v.y > 0 && down_collision(collider, object)
        object.p.y = collider.y - object.size
        object.v.y = 0
    end

    if object.v.x < 0 && left_collision(collider, object)
        object.p.x = collider.x + collider.width
        object.v.x = 0
    elsif object.v.x > 0 && right_collision(collider, object)
        object.p.x = collider.x - object.size
        object.v.x = 0
    end
end

=begin Unfortunately code bewlow isn't working as intended
def swap(a, b)
    a2 = a
    a = b
    b = a2
end

def max(a, b)
    if a > b
        return a
    end
    
    return b
end

def min(a, b)
    if a < b
        return a
    end
    
    return b
end

class Collider
    attr_reader :position
    attr_reader :size
    
    def initialize(position, size)
        @position = position
        @size = size
    end
end

class Collision
    attr_reader :occured
    attr_reader :contact_point
    attr_reader :contact_normal
    attr_reader :contact_time
    
    def initialize(occured, 
                   contact_point = Vec2(0, 0), 
                   contact_normal = Vec2(0, 0), 
                   contact_time = 0)
        @occured = occured
        @contact_point = contact_point
        @contact_normal = contact_normal
        @contact_time = contact_time
    end
end

def point_collision(point, rect)
    rect.contains? point.x, point.y
end

def rect_collision(rect1, rect2)
    (rect1.x < rect2.x + rect2.width && rect1.x + rect1.width > rect2.x &&
     rect1.y < rect2.y + rect2.height && rect1.y + rect1.height > rect2.y)
end

def ray_collsion(r_origin, r_dir, t_col)
    t_pos = t_col.position
    t_size = t_col.size

    t_near = (t_pos - r_origin) / r_dir
    t_far = (t_pos + t_size - r_origin) / r_dir

    if t_near.x > t_far.x
        swap(t_near.x, t_far.x)
    end

    if t_near.y > t_far.y
        swap(t_near.y, t_far.y)
    end

    if (t_near.x > t_far.y || t_near.y > t_far.x)
        return Collision.new(false)
    end

    t_hit_near = max(t_near.x, t_near.y)
    t_hit_far = min(t_far.x, t_far.y)

    if t_hit_far < 0 
        return Collision.new(false)
    end

    contact_point = r_origin + t_hit_near * r_dir

    contact_normal = Vec2(0, 0)

    if t_near.x > t_near.y
        if r_dir.x < 0
            contact_normal = Vec2(1, 0)
        else
            contact_normal = Vec2(-1, 0)
        end
    elsif t_near.x < t_near.y
        if r_dir.y < 0
            contact_normal = Vec2(0, 1)
        else
            contact_normal = Vec2(0, -1)
        end
    end

    return Collision.new(true, 
                         contact_point, 
                         contact_normal, 
                         t_hit_near)
end

def dynamic_collision(rect, v, t_col)
    if (v.x == 0 && v.y == 0)
        return Collision.new(false)
    end

    r_pos = Vec2(rect.x, rect.y)
    r_size = Vec2(rect.width, rect.height)
    
    t_pos = t_col.position
    t_size = t_col.size

    exp_t = Collider.new(t_pos - r_size / 2.0, t_size + r_size)

    hit = ray_collsion(r_pos + r_size / 2.0, v, exp_t)

    if hit.occured
        if hit.contact_time <= 1.0
            return hit
        end
        
        return Collision.new(false)
    end
end
=end
