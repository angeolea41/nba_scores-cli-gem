require_relative 'players.rb'
require_relative 'todays_games.rb'
require_relative 'todays_games.rb'
require_relative 'yesterdays_games.rb'
require_relative 'yesterdays_teams.rb'
class CLI

  attr_accessor :todays_games, :yesterdays_games, :today, :yesterday

  def call
    @yesterday = YesterdaysGames.new
    @yesterdays_games = yesterday.put_together
    @today = TodaysGames.new
    @todays_games = today.put_together
    list_todays_games
  end

#===========================Listing Games Regualar=======================#
 #Listing Current Day's Games
  def list_todays_games
    index = 0
    if !@todays_games.empty?
      puts "Today's NBA Games:"
      puts "-------------------"
      todays_games.each do |game|
        puts "#{game[index].name}: #{game[index].score}"
        puts "#{game[index].record}"
        puts "-at-"
        puts "#{game[index+1].name}: #{game[index+1].score}"
        puts "#{game[index+1].record}"
        puts "---------------------"
      end
    else
      puts "No games scheduled today"
    end
    list_options_for_today
  end

  #Listing Yesterday's Games
  def list_yesterdays_games
    index = 0
      puts "Yesterday's NBA Games:"
      puts "-------------------"
      yesterdays_games.each do |game|
        puts "#{game[index].name}: #{game[index].score}"
        puts "#{game[index].record}"
        puts "-at-"
        puts "#{game[index+1].name}: #{game[index+1].score}"
        puts "#{game[index+1].record}"
        puts "---------------------"
      end
      list_options_for_yesterday
  end

#===========================End of Listing Games Regualar====================================#

#===========================Listing Games Compacted=======================================#
  def list_todays_games_compact
    index = 0
    if !todays_games[0][0].score.nil?
      games_played = todays_games.select {|game| game[0].score != nil}
      unplayed_games = todays_games.select {|game| game[0].score == nil}
      #Listing The Games With Available Stats
      games_played.each.with_index(1) do |game, i|
        puts "#{i}. #{game[index].name} vs. #{game[index+1].name}"
      end
      unplayed_games.each do |game|
        puts "No stats available for #{game[index].name} vs. #{game[index+1].name}"
      end
      get_todays_game
    else
      puts "No stats at this time."
      list_options_for_today
    end
  end

  #Listing Yesterday's Games Compact
  def list_yesterdays_games_compact
    index = 0
    yesterdays_games.each.with_index(1) do |game, i|
      puts "#{i}. #{game[index].name} vs. #{game[index+1].name}"
    end
    get_yesterdays_game
  end

#=================================End Of Listing Games Compact======================================#

#=================================Listing Options===================================================#
  def list_options_for_today
    puts "1. View player stats"
    puts "2. Refresh Scores"
    puts "3. See yesterday's scores"
    puts "4. Exit"
    puts "Select 1-4"
    input = gets.strip.to_i
    while !input.between?(1, 4)
      puts "Invalid input. Please select 1-4"
      input = gets.strip.to_i
    end
    if input == 1
      list_todays_games_compact
    elsif input == 2
      call
    elsif input == 3
      list_yesterdays_games
    elsif input == 4
      goodbye
    end
  end

  def list_options_for_yesterday
    puts "1. View player stats"
    puts "2. exit"
    input = gets.strip.to_i
    if input == 1
      list_yesterdays_games_compact
    elsif input == 2
      goodbye
    end
  end

  def list_options_from_stats
    puts "1. View today's games"
    puts "2. View yesterday's games"
    puts "3. View different stats"
    puts "4. exit"
    puts "Please enter 1-4"
    input = gets.strip.to_i
    while !input.between?(1, 4)
      puts "Sorry, input invalid. Please enter 1-4"
    end
    if input == 1
      list_todays_games
    elsif input == 2
      list_yesterdays_games
    elsif input == 3
      list_yesterdays_games_compact
    elsif input == 4
      goodbye
    end
  end


#==============================End of Listing Options======================================#

#==============================Displaying Player Statistics===================================#

  def player_stats(team_1, team_2)
    count = 0
    puts "#{team_1.name}: #{team_1.score}"
    puts "#{team_1.record}"
    until count == team_1.players.length
      puts "#{team_1.players[count].name} - Points: #{team_1.players[count].points} Assists: #{team_1.players[count].assists}  Rebounds: #{team_1.players[count].rebounds} Steals: #{team_1.players[count].steals} Blocks: #{team_1.players[count].blocks}"
      count += 1
    end

    puts "----------------------------------------------------------------"

    count = 0
    puts "#{team_2.name}: #{team_2.score}"
    puts "#{team_2.record}"
    until count == team_2.players.length
      puts "#{team_2.players[count].name} - Points: #{team_2.players[count].points} Assists: #{team_2.players[count].assists}  Rebounds: #{team_2.players[count].rebounds} Steals: #{team_2.players[count].steals} Blocks: #{team_2.players[count].blocks}"
      count += 1
    end
    puts ""
    list_options_from_stats
  end

#==================================End of Displaying Player Statistics=============================#

  def get_todays_game
    available_stats = todays_games.select {|game| game[0].score != nil}
    puts "Which game would you like player stats on? Please enter 1 - #{available_stats.count}"
    input = gets.strip.to_i
    while !input.between?(1, available_stats.count)
      puts "Input not valid. Please enter 1 - #{available_stats.count}"
      input = gets.strip.to_i
    end
    input -= 1
    @today.get_player_stats(todays_games[input][0].url, todays_games[input][0], todays_games[input][1])
    player_stats(todays_games[input][0], todays_games[input][1])
  end

  def get_yesterdays_game
    puts "Which game would you like player stats on? Please enter 1 - #{yesterdays_games.count}"
    input = gets.strip.to_i
    while !input.between?(1, yesterdays_games.count)
      puts "Input not valid. Please enter 1 - #{yesterdays_games.count}"
      input = gets.strip.to_i
    end
    input -= 1
    @yesterday.get_player_stats(yesterdays_games[input][0].url, yesterdays_games[input][0], yesterdays_games[input][1])
    player_stats(yesterdays_games[input][0], yesterdays_games[input][1])
  end

  def goodbye
    puts "See you tomorrow"
  end
end
