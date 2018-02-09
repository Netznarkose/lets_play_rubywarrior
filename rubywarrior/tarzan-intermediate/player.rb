require 'pry-byebug'
class Player
  def play_turn(warrior)
    if only_attack_enemies_which_block_rescues(warrior)
      warrior.attack!(locate(:enemy, warrior))
    elsif only_rescue_captives_with_bombs(warrior)
      warrior.rescue!(locate(:captive, warrior))
    elsif ticking?(warrior)
      warrior.walk!(direction_of_bomb(warrior))
    elsif !present?(:enemy, warrior) && warrior.health < 20
      warrior.rest!
    elsif present?(:enemy, warrior)
      warrior.attack!(locate(:enemy, warrior))
    elsif present?(:captive, warrior)
      warrior.rescue!(locate(:captive, warrior))
    elsif warrior.listen.empty?
      warrior.walk!(warrior.direction_of_stairs)
    else
      warrior.walk!(warrior.direction_of(warrior.listen.first))
    end
  end

  def only_attack_enemies_which_block_rescues(warrior)
    if ticking?(warrior)
      locate(:enemy, warrior) == direction_of_bomb(warrior)
    end
  end

  def only_rescue_captives_with_bombs(warrior)
    if ticking?(warrior)
      locate(:captive, warrior) == direction_of_bomb(warrior)
    end
  end

  def direction_of_bomb(warrior)
    warrior.listen.each_with_index do |space, index|
      @platz = index if space.ticking?
    end
    warrior.direction_of(warrior.listen[@platz])
  end

  def ticking?(warrior)
    warrior.listen.any?(&:ticking?)
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
