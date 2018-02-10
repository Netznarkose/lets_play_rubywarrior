require 'pry-byebug'
require 'player_helper'
include PlayerHelper
class Player
  def initialize
    @turn_me = 0
  end
  def play_turn(warrior)
    case @turn_me
    when 0
      warrior.bind!(:left)
    when 1
      warrior.bind!(:right)
    when 2, 3
      warrior.detonate!(:forward)
    when 4, 5, 6, 7, 8
      warrior.rest!
    when 9
      warrior.walk!(:forward)
    when 10
      warrior.bind!(:left)
    when 11
      warrior.bind!(:right)
    when 12
      warrior.attack!(:forward)
    # when 7, 8
    #   warrior.detonate!(:left)
    # when 9
    #   warrior.walk!(:left)
    # when 10
    #   warrior.attack!(:forward)
    # when 11
    #   warrior.walk!(:forward)
    # when 12
    #   warrior.rescue!(:forward)
    end
    @turn_me += 1
  end

  def free_space_into_direction_of_bomb?(warrior)
    locate(:empty, warrior) == direction_of_bomb(warrior)
  end

  def hostage_in_bombing_zone?(warrior)
    distances = []
    warrior.listen.each_with_index do |space, index|
      distances << warrior.distance_of(space) if space.ticking?
    end
    distances.first < 3 rescue false
  end

  def locate_second_prioritized_enemies(warrior)
    [:forward, :left, :right, :backward].select do |direction|
      return direction if warrior.feel(direction).enemy? && direction != direction_of_bomb(warrior)
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
end
