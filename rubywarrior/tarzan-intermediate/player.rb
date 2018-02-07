require 'pry-byebug'
class Player

  def play_turn(warrior)
    if count_enemies(warrior) > 1
      warrior.bind!(locate(:enemy, warrior))
    elsif !present?(:enemy, warrior) && warrior.health < 20
      warrior.rest!
    elsif present?(:enemy, warrior)
      warrior.attack!(locate(:enemy, warrior))
    elsif present?(:captive, warrior)
      warrior.rescue!(locate(:captive, warrior))
    elsif warrior.listen.empty?
      warrior.walk!(warrior.direction_of_stairs)
    else
      if warrior.feel.stairs?
        warrior.walk!(avoid_stairs(warrior))
      else
        warrior.walk!(warrior.direction_of(warrior.listen.first))
      end
    end
  end

  def avoid_stairs(warrior)
    [:forward, :left, :right, :backward].find do |direction|
      return direction if warrior.feel(direction).empty? && !warrior.feel(direction).stairs?
    end
  end

  def count_enemies(warrior)
    count = 0
    [:forward, :left, :right, :backward].map do |direction|
      count += 1 if warrior.feel(direction).enemy?
    end
    count
  end

  def present?(who = :enemy, warrior)
    [:forward, :left, :right, :backward].any? do |direction|
      who == :enemy ? warrior.feel(direction).enemy? : warrior.feel(direction).captive?
    end
  end

  def locate(who = :enemy, warrior)
    [:forward, :left, :right, :backward].select do |direction|
      if who == :enemy
        return direction if warrior.feel(direction).enemy?
      else
        return direction if warrior.feel(direction).captive?
      end
    end
  end
end
