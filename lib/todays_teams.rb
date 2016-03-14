class TodaysTeams

  @@all = []

  attr_accessor :name, :score, :record, :url, :players

  def initialize(name, score, record, url)
    @name = name
    @score = score
    @record = record
    @url = url
    @@all << self
  end

  def self.verses
    games = []
    self.all.each_slice(2) do |slice|
      games << slice
    end
    games
  end

  def self.all
    @@all
  end
  
end
