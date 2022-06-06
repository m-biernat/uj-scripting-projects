require './objects'
require 'json'

def get_test_level
    colliders = []
    
    colliders.push(Platform.new(0, 150, 150))
    colliders.push(Platform.new(300, 200, 200))
    colliders.push(Coin.new(350, 380))
    colliders.push(Coin.new(390, 380))
    colliders.push(Coin.new(430, 380))
    
    colliders.push(Obstacle.new(470, 350, 30, 50))
    colliders.push(Platform.new(650, 150, 170))
    colliders.push(Obstacle.new(650, 380, 30, 50))
    colliders.push(Teleport.new(770, 400, 1, 100, 420))
    
    colliders.push(Teleport.new(30 + w_off(1), 420, -1, 710, 400))
    colliders.push(Platform.new(0 + w_off(1), 225, 150))
    colliders.push(Coin.new(213 + w_off(1), 430))
    colliders.push(Obstacle.new(140 + w_off(1), 370, 60, 80))
    colliders.push(Platform.new(370 + w_off(1), 430, 320))
    colliders.push(Coin.new(430 + w_off(1), 260))
    colliders.push(Coin.new(470 + w_off(1), 260))
    colliders.push(Coin.new(635 + w_off(1), 260))
    colliders.push(Coin.new(695 + w_off(1), 260))
    colliders.push(Coin.new(755 + w_off(1), 260))
    colliders.push(Enemy.new(385 + w_off(1), 255, 125, 1))
    colliders.push(Enemy.new(620 + w_off(1), 255, 75, 2))
    colliders.push(Obstacle.new(550 + w_off(1), 200, 40, 80))
    
    return colliders
end

def load_level(name)
    path = './' + name + '.json'
    file = File.read(path)
    hash = JSON.parse(file)

    colliders = []

    for i in 0..(hash.length() - 1)
        hash[i]['platforms'].each do |platform|
            colliders.push(
                Platform.new(platform['x'] + w_off(i), 
                             platform['w'], 
                             platform['h'])
            )
        end
        hash[i]['obstacles'].each do |obstacle|
            colliders.push(
                Obstacle.new(obstacle['x'] + w_off(i), 
                             obstacle['y'],
                             obstacle['w'], 
                             obstacle['h'])
            )
        end
        hash[i]['teleports'].each do |teleport|
            colliders.push(
                Teleport.new(teleport['x'] + w_off(i), 
                             teleport['y'],
                             teleport['t_off'], 
                             teleport['t_px'],
                             teleport['t_py'])
            )
        end
        hash[i]['coins'].each do |coin|
            colliders.push(
                Coin.new(coin['x'] + w_off(i), 
                         coin['y'])
            )
        end
        hash[i]['enemies'].each do |enemy|
            colliders.push(
                Enemy.new(enemy['x'] + w_off(i), 
                          enemy['y'],
                          enemy['range'],
                          enemy['speed'])
            )
        end
    end

    return colliders
end
