require 'pry-byebug'
class Player
  def initialize
    @health = 20
  end

  def play_turn(warrior)
    if !damage?(warrior) && warrior.health < 20
      warrior.rest!
    elsif enemy_present?(warrior)
      warrior.attack!(locate_enemy(warrior))
    else
      warrior.walk!(warrior.direction_of_stairs)
    end
    @health = warrior.health
  end

  def damage?(warrior)
    warrior.health < @health
  end

  def enemy_present?(warrior)
    [:forward, :left, :right, :backward].any? do |direction|
      warrior.feel(direction).enemy?
    end
  end

  def locate_enemy(warrior)
    [:forward, :left, :right, :backward].select do |direction|
      return direction if warrior.feel(direction).enemy?
    end
  end
end
