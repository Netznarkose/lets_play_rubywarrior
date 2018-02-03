require 'pry-byebug'
class Player
  def play_turn(warrior)
    if warrior.feel.enemy?
      warrior.attack!
    elsif warrior.feel.captive?
      warrior.rescue!
    elsif !warrior.feel.enemy?  && warrior.health < 20 && !damage?(warrior)
      warrior.rest!
    else
      warrior.walk!
    end
    @health = warrior.health
  end
  def damage?(warrior)
    warrior.health < @health
  end
end
