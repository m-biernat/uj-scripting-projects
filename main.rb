require 'ruby2d'
require './player'
require './physics'

set width: 800, height: 600
set title: "Ruby2D Game"
set background: 'blue'

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

@obj = Rectangle.new(x: Window.width / 2, y: Window.height - 100, width: 200, height: 100, color: 'green')
#@trg = Circle.new(x: 700, y: 550, radius: 30, color: 'fuchsia')

update do
    @player.move
    
    resolve_collision(@obj, @player)
    keep_in_bounds(@player)
    
    @player.after_collsions
end

show
