module RubyWarrior
  module Units
    class Sludge < Base
      def initialize
        @health = 8
        add_actions :attack
        add_senses :feel
      end
      
      def play_turn(turn)
        [:forward, :left, :right, :back].each do |direction|
          if turn.feel(direction).warrior?
            turn.attack!(direction)
            return
          end
        end
      end
      
      def attack_power
        2
      end
    end
  end
end
