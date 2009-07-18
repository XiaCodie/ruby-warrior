require 'base64'

module RubyWarrior
  class Profile
    attr_accessor :score, :epic_score, :current_epic_score, :abilities, :level_number, :tower_path, :warrior_name, :player_path
    
    def initialize
      @tower_path = nil
      @warrior_name = nil
      @score = 0
      @current_epic_score = 0
      @epic_score = 0
      @abilities = []
      @level_number = 0
    end
    
    def encode
      Base64.encode64(Marshal.dump(self))
    end
    
    def save
      update_epic_score
      @level_number = 0 if epic?
      File.open(player_path + '/.profile', 'w') { |f| f.write(encode) }
    end
    
    def self.decode(str)
      Marshal.load(Base64.decode64(str))
    end
    
    def self.load(path)
      player = decode(File.read(path))
      player.player_path = File.dirname(path)
      player
    end
    
    def player_path
      @player_path || Config.path_prefix + "/ruby-warrior/#{directory_name}"
    end
    
    def directory_name
      [warrior_name.downcase.gsub(/[^a-z0-9]+/, '-'), tower.name].join('-')
    end
    
    def to_s
      if epic?
        [warrior_name, tower.name, "first score #{score}", "epic score #{epic_score}"].join(' - ')
      else
        [warrior_name, tower.name, "level #{level_number}", "score #{score}"].join(' - ')
      end
    end
    
    def tower
      Tower.new(@tower_path)
    end
    
    def current_level
      Level.new(self, level_number)
    end
    
    def next_level
      Level.new(self, level_number+1)
    end
    
    def add_abilities(*abilities)
      @abilities += abilities
      @abilities.uniq!
    end
    
    def enable_epic_mode
      @epic = true
      @epic_score ||= 0
      @current_epic_score ||= 0
    end
    
    def epic?
      @epic
    end
    
    def update_epic_score
      if @current_epic_score > @epic_score
        @epic_score = @current_epic_score
      end
    end
  end
end
