require 'pry-byebug'
class Player
  def initialize
    @health = 20
    @captive_rescued = false
  end

  def play_turn(warrior)
    if @captive_rescued == false
      funky_moves(warrior, :backward)
    else
      funky_moves(warrior, :forward)
    end
  end

  def funky_moves(warrior, direction)
    if under_attack_and_in_bad_shape(warrior)
      warrior.walk!(:backward)
    elsif warrior.feel(direction).captive?
      warrior.rescue!(direction)
      @captive_rescued = true
    elsif warrior.feel(direction).enemy?
      warrior.attack!(direction)
    elsif not_attacked_no_enemy_around_and_health_under_max(warrior)
      warrior.rest!
    else
      warrior.walk!(direction)
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
