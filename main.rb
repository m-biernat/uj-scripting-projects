require 'ruby2d'
require './player'
require './physics'
require './objects'
require './level'
require './ui'

set width: 800, height: 600
set title: "Ruby2D Game"
set background: 'blue'

@player = Player.new(50, 420)

@colliders = get_test_level()

Teleport.setup(@colliders, @player)
Coin.setup(@player)

@score = Score.new(@player)

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

update do
    @player.move
    
    @colliders.each do |collider|
        collider.check(@player)
    end

    keep_in_bounds(@player)
    
    @player.after_collsions
    
    @score.update
end

show
