module PlayerHelper

  def free_space_into_direction_of_hostage?(warrior)
    locate(:empty, warrior) == direction_of_hostage(warrior)
  end

  def hostage_in_detonation_zone?(warrior)
    distances = []
    warrior.listen.each_with_index do |space, index|
      distances << warrior.distance_of(space) if space.ticking?
    end
    distances.first < 3 rescue false
  end

  def locate_second_prioritized_enemies(warrior)
    [:forward, :left, :right, :backward].select do |direction|
      return direction if warrior.feel(direction).enemy? && direction != direction_of_hostage(warrior)
    end
  end

  def direction_of_hostage(warrior)
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
  def count_enemies(warrior) #next to warrior
    count = 0
    [:forward, :left, :right, :backward].map do |direction|
      count += 1 if warrior.feel(direction).enemy?
    end
    count
  end

  def present?(who, warrior)
    [:forward, :left, :right, :backward].any? do |direction|
      if who == :enemy
        warrior.feel(direction).enemy?
      elsif who == :captive
        warrior.feel(direction).captive?
      elsif who == :empty
        warrior.feel(direction).empty?
      elsif who == :hostage
        warrior.feel(:forward).captive? && warrior.feel(:forward).ticking?
      end
    end
  end

  def locate(who, warrior)
    return false unless present?(who, warrior)
    [:forward, :left, :right, :backward].select do |direction|
      if who == :enemy
        return direction if warrior.feel(direction).enemy?
      elsif who == :empty
        return direction if warrior.feel(direction).empty?
      elsif who == :hostage
        return direction if warrior.feel(direction).captive? == warrior.feel(direction).ticking?
      elsif who == :captive
        return direction if warrior.feel(direction).captive?
      end
    end
  end
end
