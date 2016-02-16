# CLI Controller
require_relative './teams.rb'
require_relative './scraper.rb'
require_relative './players.rb'
require 'pry'
class CLI

  attr_accessor :games, :scraper

  def initialize
    @scraper = Scraper.new
    @games = scraper.put_together
  end

  def call
    puts "Today's NBA Games:"
    puts "-------------------"
    list_games
    list_options if scraper.games_today?
  end

  def list_games
    index = 0
    if scraper.games_today?
      games.each do |game|
        puts "#{game[index].name}: #{game[index].score}"
        puts "#{game[index].record}"
        puts "-at-"
        puts "#{game[index+1].name}: #{game[index+1].score}"
        puts "#{game[index+1].record}"
        puts "---------------------"
      end
    else
      puts "Sorry, there are no games today"
      list_additional_options
    end
  end

  def list_games_compact
    index = 0
    games.each.with_index(1) do |game, i|
      puts "#{i}. #{game[index].name} vs. #{game[index+1].name}"
    end
    puts "Which game would you like player stats on? Please enter 1 - #{games.count}"
    input = gets.strip.to_i
    while !input.between?(1, games.count)
      puts "Input not valid. Please enter 1 - #{games.count}"
      input = gets.strip.to_i
    end
    scraper.get_player_stats(games[input][0].url, games[input][0], games[input][1])
    player_stats(games[input][0], games[input][1])
  end  

  def list_options
    puts "1. View player stats"
    puts "2. Refresh Scores (For live games)"
    puts "3. exit"
    input = gets.strip.to_i
    if input == 1
      list_games_compact
    elsif input == 2
      list_games
    elsif input == exit
      goodbye 
    end
  end

  def list_additional_options
    print "Would you like to see yesterday's scores?(y/n): "
    input = gets.strip
    if input == "y"
      CLI.new.call
  

  def player_stats(team_1, team_2) 
    binding.pry
    count = 0 
    puts "#{team_1.name}: #{team_1.score}"
    puts "#{team_1.record}"
    until count == team_1.players.length
      puts "#{team_1.players[count].name} - Points: #{team_1.players[count].points} Assists: #{team_1.players[count].assists}  Rebounds: #{team_1.players[count].rebounds} Steals: #{team_1.players[count].steals}"
      count += 1
    end

    puts "----------------------------------------------------------------"

    count = 0
    puts "#{team_2.name}: #{team_2.score}"
    puts "#{team_2.record}"
    until count == team_2.players.length
      puts "#{team_2.players[count].name} - Points: #{team_2.players[count].points} Assists: #{team_2.players[count].assists}  Rebounds: #{team_2.players[count].rebounds} Steals: #{team_2.players[count].steals}"    
    end
  end

  def goodbye
    puts "See you tomorrow"
  end
end