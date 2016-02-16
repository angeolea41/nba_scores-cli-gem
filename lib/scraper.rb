require 'nokogiri'
require 'open-uri'
require 'pry'
require 'date'

require_relative './teams.rb'
require_relative './players.rb'
class Scraper



  def games_today?
    !get_page.css("#site-takeover > div.main-container > div > div.large-column-left.scoreboard > p").text.eql?("No games scheduled.")
  end

  def get_page(url = "http://basketball.realgm.com/nba/scores")
    html = Nokogiri::HTML(open(url))
  end

  def get_team_names
    scoreboard = get_page.css("#site-takeover > div.main-container > div > div.large-column-left.scoreboard")
    team_names = []
    scoreboard.css(".game.played").each do |game|
      game.css(".team_name").each do |team|
        team_names << team.css("a").attribute("href").value[/(\w+-\w+)/].gsub("-", " ")
      end
    end
    team_names
  end

  def get_team_scores
    scoreboard = get_page.css("#site-takeover > div.main-container > div > div.large-column-left.scoreboard")
    team_scores = []
    scoreboard.css(".game.played").each do |game|
      game.css(".team_score").each do |score|
        team_scores << score.css("a").text.gsub("\n", "")
      end
    end
    team_scores
  end

  def get_team_records
    scoreboard = get_page.css("#site-takeover > div.main-container > div > div.large-column-left.scoreboard")
    team_records = []
    scoreboard.css(".game.played").each do |game|
      game.css(".team_record").each do |record|
        team_records << record.css("a").text
      end
    end
    team_records
  end

  def get_urls
    scoreboard = get_page.css("#site-takeover > div.main-container > div > div.large-column-left.scoreboard")
    urls = []
    scoreboard.css(".game.played").each do |game|
      urls << "http://basketball.realgm.com" + game.css("tr:nth-child(5) a").attribute("href").value
      urls << "http://basketball.realgm.com" + game.css("tr:nth-child(5) a").attribute("href").value
    end
    urls
  end

  def get_player_stats(url, team_1, team_2)
    page = Nokogiri::HTML(open(url))
    players = []
    container = page.css("div.main-container div.main.wrapper")
    count = 0
    container.css(".tablesaw").each do |table|
      table.css("tbody tr").each do |player|
        name = player.css("td:nth-child(2) a").text
        points = player.css("td:nth-child(18)").text
        rebounds = player.css("td:nth-child(12)").text
        assists = player.css("td:nth-child(13)").text
        blocks = player.css("td:nth-child(16)").text
        steals = player.css("td:nth-child(15)").text
        info = {:name => name, :points => points, :rebounds => rebounds, :blocks => blocks, :steals => steals, :assists => assists}
        player = Players.new(info) 
        player.team = team_1 if count == 0 
        player.team = team_2 if count == 1
        players << player
      end
      count += 1
    end
    team_1.players = players.select {|player| player.team == team_1}
    team_2.players = players.select {|player| player.team == team_2}
  end


  def put_together
    names = get_team_names
    scores = get_team_scores
    records = get_team_records
    urls = get_urls
    names.each.with_index do |name, index|
      Teams.new(name, scores[index], records[index], urls[index])
    end
    Teams.verses
  end
end



