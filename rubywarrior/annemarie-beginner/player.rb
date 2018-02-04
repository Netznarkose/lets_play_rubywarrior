require 'pry-byebug'
class Player
  def initialize
    @health = 20
  end

  def play_turn(warrior)
    if warrior.feel.wall?
      warrior.pivot!
    elsif under_attack_and_in_bad_shape(warrior)
      warrior.walk!(:backward)
    elsif warrior.feel.captive?
      warrior.rescue!
    elsif warrior.feel.enemy?
      warrior.attack!
    elsif not_attacked_no_enemy_around_and_health_under_max(warrior)
      warrior.rest!
    else
      warrior.walk!
    end
    @health = warrior.health
  end

  def under_attack_and_in_bad_shape(warrior)
    damage?(warrior) && warrior.health < 12
  end

  def not_attacked_no_enemy_around_and_health_under_max(warrior)
    !warrior.feel.enemy? && warrior.health < 20 && !damage?(warrior)
  end
  def damage?(warrior)
    warrior.health < @health
  end
end
