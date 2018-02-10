module PlayerHelper
  def count_enemies(warrior) #next to warrior
    count = 0
    [:forward, :left, :right, :backward].map do |direction|
      count += 1 if warrior.feel(direction).enemy?
    end
    count
  end

  def present?(who = :enemy, warrior)
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

  def locate(who = :enemy, warrior)
    return false if !present?(who, warrior)
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
