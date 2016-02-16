class Players

  attr_accessor :name, :points, :assists, :rebounds, :steals, :blocks, :team

  def initialize(stat_hash)
    stat_hash.each {|key, value| self.send("#{key}=", value)}
  end

end