require 'pry-byebug'
require 'player_helper'
include PlayerHelper
class Player

  def play_turn(warrior)
    if ticking?(warrior)
      hostage_liberation_mode(warrior)
    else
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
      elsif warrior.feel.stairs?
        warrior.walk!(avoid_stairs(warrior))
      else
        warrior.walk!(warrior.direction_of(warrior.listen.first))
      end
    end
  end
  def hostage_liberation_mode(warrior)
    if count_enemies(warrior) > 1
      warrior.bind!(locate_second_prioritized_enemies(warrior))
    elsif locate(:hostage, warrior)
      warrior.rescue!(locate(:hostage, warrior))
    elsif !present?(:enemy, warrior) && warrior.health < 10 && warrior.look.any?(&:enemy?)
      warrior.rest!
    elsif !present?(:enemy, warrior) && warrior.health < 4
      warrior.rest!
    elsif free_space_into_direction_of_hostage?(warrior)
      warrior.walk!(direction_of_hostage(warrior))
    elsif hostage_in_detonation_zone?(warrior)
      warrior.attack!(direction_of_hostage(warrior))
    else
      smart_use_of_weappons(warrior)
    end
  end

  def no_enemy_next_to_me_but_enemy_on_next_field_and_health_under_ten
  end

  def smart_use_of_weappons(warrior)
    if hostage_in_detonation_zone?(warrior) || warrior.health < 6
      warrior.attack!(direction_of_hostage(warrior))
    else
      warrior.detonate!(direction_of_hostage(warrior))
    end
  end
end
