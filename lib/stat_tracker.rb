require 'csv'

class StatTracker

  attr_reader :games, :teams, :game_teams
  def initialize (games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def self.from_csv(locations)
    games = CSV.table(locations[:games])
    teams = CSV.table(locations[:teams])
    game_teams = CSV.table(locations[:game_teams])
    StatTracker.new(games, teams, game_teams)
  end


 # Game Statistics

  def total_scores_by_game #helper for issue #2, #3, #6
    @games.values_at(:away_goals, :home_goals).map do |game|
      game[0] + game[1]
    end
  end

  def highest_total_score #issue #2
    total_scores_by_game.max
  end

  def lowest_total_score #issue #3
    total_scores_by_game.min
  end

  def home_wins #helper for issue #4
    home_win = 0.0
    @game_teams.values_at(:result, :hoa).flat_map {|row| home_win += 1 if row == ["WIN", "home"]}; home_win
  end

  def home_games #helper for issue #4
    home = 0.0
    @game_teams[:hoa].map {|row| home += 1 if row == "home"}; home
  end

  def percentage_home_wins #issue #4
    percentage = (home_wins/home_games) * 100
  end

  def percentage_visitor_wins #issue #5
        #sum of visitor wins / total games played

    away_wins = []
    game_results = game_teams.values_at(:hoa, :result)
    total_games_played = game_results.count.to_f

    game_results.each do |game|
    away_wins << game if game == ["away", "WIN"]

    end
    ((away_wins.count / total_games_played)*100).round(2)
  end

  def percentage_ties #issue #6
    ties = 0.0
    total_games = total_scores_by_game.count

    @games.values_at(:away_goals, :home_goals).each do |game|
      ties += 1 if game[0] == game[1]
    end
    ((ties/total_games)*100).round(1)
  end

  def count_of_games_by_season #issue 7, also helper for #9
    counts = {}
    games.each do |game|
        season = game[:season]
        if counts[season].nil?
             counts[season] = 0
        end
        counts[season] += 1
    end
    counts
    # games.reduce({}) do |counts, game|
    #     season = game[:season]
    #     counts[season] = 0 if counts[season].nil?
    #     counts[season] += 1
    #     counts
    # end
  end

  def average_goals_per_game #issue #8
    total_scores_by_game.sum/@games.size
  end

  def average_goals_by_season #issue #9
    my_hash = Hash.new { |h,k| h[k] = [] }

      count_of_games_by_season.each do |season, game_count|
        my_hash[season.to_s] = [] 
        game_sum_calc = []
        games.each do |row| 
          game_sum_calc << (row[:away_goals] + row[:home_goals]) if row[:season] == season
          my_hash[season.to_s] = (game_sum_calc.sum / game_count.to_f).round(2)
        end
      end
      my_hash
  end

  def game_wins #Helper method not yet used
    win = 0.0
    @game_teams[:result].map {|row| win += 1 if row == "WIN"}; win
  end

  def game_losses #Helper method not yet used
    loss = 0.0
    @game_teams[:result].map {|row| loss += 1 if row == "LOSS"}; loss
  end

  def away_games #Helper method not yet used
    away = 0.0
    @game_teams[:hoa].map {|row| away += 1  if row == "away"}; away
  end


  # League Statistics

  def count_of_teams #issue # 10
    @teams[:teamname].count
  end

  def best_offense #issue # 11
    max_average = average_scores_by_team_id("home", "away").values.max
    team_by_id[average_scores_by_team_id("home", "away").key(max_average)]

  end

  def worst_offense #issue # 12
    min_average = average_scores_by_team_id("home", "away").values.min
    team_by_id[average_scores_by_team_id("home", "away").key(min_average)]
  end

  def highest_scoring_visitor #issue # 13
      away_team_ids_array = (@games[:away_team_id]).uniq.sort

      team_ids_hash = {}
      away_team_ids_array.each do |teamid|
        team_ids_hash[teamid] = {sum_away_goals: 0, count_of_away_games_played: 0}
      end

      @games.each do |row|
        team_ids_hash[row[:away_team_id]][:sum_away_goals] += row[:away_goals]
        team_ids_hash[row[:away_team_id]][:count_of_away_games_played] += 1
      end

      averages_hash = {}

      team_ids_hash.keys.each do |teamid|
        averages_hash[teamid] = (team_ids_hash[teamid][:sum_away_goals]).to_f / (team_ids_hash[teamid][:count_of_away_games_played])
      end

      visitor_with_highest_score_array = averages_hash.max_by{|k,v| v}

      visitor_team_name_with_highest_avg_score = team_by_id[visitor_with_highest_score_array[0]]
  end

  def scores_by_team_id(*game_type) #helper method for issue #14
    scores_by_team_id = {}
      scores_by_game_type = @game_teams.values_at(:team_id, :hoa, :goals).find_all do |game|
      game[1] == game_type[0] || game_type[1]
    end

    @game_teams[:team_id].each do |id|
      scores_by_team_id[id] = []
    end
    scores_by_game_type.each do |game|
      scores_by_team_id[game[0]] << game[2].to_f
    end
    scores_by_team_id

  end

  def team_by_id #helper method for issue #14
    @teams.values_at(:team_id, :teamname).to_h
  end

  def average_scores_by_team_id(*game_type) #helper method for issue #14
    average_scores= {}
    scores_by_team_id(*game_type).each do |team, scores|
      average = scores.sum/scores.count
      average_scores[team] = average.round(1)
    end
    average_scores
  end

  def highest_scoring_home_team #issue # 14
    max_average = average_scores_by_team_id("home").values.max
    team_by_id[average_scores_by_team_id("home").key(max_average)]
  end

  def lowest_scoring_visitor #issue # 15
    lowest_average = average_scores_by_team_id("away").values.min
    team_by_id[average_scores_by_team_id("away").key(lowest_average)]
  

  end

  def lowest_scoring_home_team #issue # 16
    min_average = average_scores_by_team_id("away").values.min
    team_by_id[average_scores_by_team_id("away").key(min_average)]
  end


  # Season Statistics

  def coach_by_team_id #Provides hash of coach names by team id - Helper method for issue #27
    # Example hash: {3=>"John Tortorella", 6=>"Claude Julien",  5=>"Dan Bylsma",
    @game_teams.values_at(:team_id, :head_coach).to_h
  end

  def team_win_percent_by_season # Provides hash of seasons with array of hashes for team id
                                  #and win percentage for season - Helper for Issue #27
    # Example hash: {20132014=> [{:team_id=>1, :win_perc=>50.0}, {:team_id=>4, :win_perc=>40.0}, {:team_id=>26, :win_perc=>100.0}
    team_win_percent = Hash.new {0}
    team_by_id.map do |id , team|
      season_win_percentage(id).each do |season, win|
        if team_win_percent[season] == 0
          team_win_percent[season] = [{team_id: id, win_perc: win}]
        else
          team_win_percent[season] << {team_id: id, win_perc: win}
        end
      end
    end
    team_win_percent
  end

  def winningest_coach(season) #issue # 17
   # Name of the Coach with the best win percentage for the season
   highest_percent_wins = team_win_percent_by_season[season.to_i].max_by {|stat| stat[:win_perc]}
   coach_by_team_id[highest_percent_wins[:team_id]]
  end

  def worst_coach(season)#issue # 27
    lowest_percent_wins = team_win_percent_by_season[season.to_i].min_by {|stat| stat[:win_perc]}
    coach_by_team_id[lowest_percent_wins[:team_id]]
  end

  def game_teams_for_game_id(game_id) #Helper method for issue #28, may be able to be used for other season stats
    @game_teams.find_all do |game_team| #finds all stats for away and home team for a particular game
      game_team[:game_id] == game_id 
    end
  end
  
  def total_team_shots_and_goals(season_id) 
    games_by_season.transform_values do |game_ids| 
      team_totals_for_season = {}
      game_ids.each do |game_id|
        game_teams_for_game_id(game_id).each do |game_team|
          if team_totals_for_season[game_team[:team_id]].nil?
            team_totals_for_season[game_team[:team_id]] = {"shots" => 0, "goals" => 0}
          end
          team_totals_for_season[game_team[:team_id]]["shots"] += game_team[:shots]
          team_totals_for_season[game_team[:team_id]]["goals"] += game_team[:goals]
        end
      end
      team_totals_for_season
    end
  end #lines above gives total shots and total goals in a season for each team

  def seasonal_team_accuracy(season_id)
     total_team_shots_and_goals(season_id)[season_id].transform_values do |team_shots_and_goals|
     team_shots_and_goals["goals"].to_f / team_shots_and_goals["shots"]
    end
  end # Lines above gives accuracy ratio of team id for a given season
  
  def most_accurate_team(season_id) #issue # 28 
    team_by_id[seasonal_team_accuracy(season_id).key(seasonal_team_accuracy(season_id).values.max)]
  end 

  def least_accurate_team #issue # 20



  end

  def most_tackles(season_id) #issue # 21

    all_season_ids = []
    games.each do |row|
      all_season_ids << row[:season]
    end

    unique_season_ids = all_season_ids.uniq
    games_in_season_hash = {}

    unique_season_ids.each do |season|
      games_in_season_hash[season] = [[], {"team_id_and_tackles" => []}]
    end

    games.each do |row|
      games_in_season_hash[row[:season]][0] << row[:game_id]
    end 

    games_in_season_hash.each do |season, games|
      game_teams.each do |row|
        if games[0].include?(row[:game_id])
          games[1]["team_id_and_tackles"] << row.values_at(:team_id, :tackles)
        end
      end
    end
  
    all_tackles = [] 
    games_in_season_hash[season_id.to_i][1]["team_id_and_tackles"].each do |pair|
      all_tackles << pair[1]
    end
    highest_tackles = all_tackles.max()

      highest_tackle_pair = games_in_season_hash[season_id.to_i][1]["team_id_and_tackles"].find_all do |pair|
        pair[1] == highest_tackles
      end
      team_by_id[highest_tackle_pair[0][0]]
  end

  def fewest_tackles #issue # 22



  end

  def team_info(team_id) #issue # 23

      info = {
      "team_id" => team_id,
      "franchise_id" => 0,
      "team_name" => 0,
      "abbreviation" => 0,
      "link" => 0
              }

      @teams.each do |row|
        info["franchise_id"] = row[:franchiseid].to_s if row[:team_id] == team_id.to_i
        info["team_name"] = row[:teamname] if row[:team_id] == team_id.to_i
        info["abbreviation"] = row[:abbreviation] if row[:team_id] == team_id.to_i
        info["link"] = row[:link] if row[:team_id] == team_id.to_i
      end

      info
  end

  def games_by_season # All game_ids sorted by season - helper method for issue #18
    # {20122013=> [2012030221, 2012030222, 2012030223, 2012030224,
    games_by_season = {}
    @games.values_at(:game_id, :season).each do |game|
      if games_by_season.include?(game[1])
        games_by_season[game[1]] << game[0]
      else
        games_by_season[game[1]] = [game[0]]
      end
    end
    games_by_season
  end

  def wins_by_team(team_id) # List of every game that was a win for a team - helper method for issue #18
    # [[2013020252, 16], [2014030166, 16], [2016030151, 16], [2016030152, 16]]
    # wins = []
    # @games.each do |row|
    #   if (row[:away_goals] > row[:home_goals] && row[:away_team_id] == team_id) ||
    #     (row[:home_goals] > row[:away_goals] && row[:home_team_id] == team_id)
    #     wins << [row[:game_id], team_id]
    #   end
    # end
    # wins

    # Option with full data set, but does not work with current dummy data
    # (this could be made dynamic for win or loss):
    #def results_by_team(team_id, win_loss)
    result_by_team = @game_teams.values_at(:game_id, :team_id, :result).find_all do |game|
      game[1] == team_id && game[2] == "WIN"
    end
  end

  def games_by_team(team_id) # List of every game a team played - helper method for issue #18
    # [[2013020252, 16], [2013020987, 16], [2014020903, 16], [2012020574, 16], [2014030161, 16],
    games = []
    @games.each do |row|
      if (row[:away_team_id] == team_id) || (row[:home_team_id] == team_id)
        games <<[row[:game_id], team_id]
      end
    end
    games

    # Option with full data set, but does not work with current dummy data:
    # games_by_team = @game_teams.values_at(:game_id, :team_id, :result).find_all do |game|
    #   game[1] == team_id
    # end
  end

  def number_team_games_per_season(team_id) # Count of number of games a team played each season - helper method for issue #18
    # {20122013=>1, 20132014=>2, 20142015=>7, 20162017=>4}
    team_games_by_season = Hash.new(0)
    games_by_season.each do |season, games|
      games_by_team(team_id).each do |result_data|
        if games.include?(result_data[0])
          team_games_by_season[season] += 1
        end
      end
    end
    team_games_by_season
  end

  def number_team_wins_per_season(team_id) # Count of number of games a team won each season -helper method for issue #18
    # {20132014=>1, 20142015=>1, 20162017=>2}
    wins_by_season = Hash.new(0)
    games_by_season.each do |season, games|
      wins_by_team(team_id).each do |result_data|
        if games.include?(result_data[0])
          wins_by_season[season] += 1
        end
      end
    end
    wins_by_season
  end

  def season_win_percentage(team_id) # Percentage of won games per season by team - helper method for issue #18
    # {20132014=>50.0, 20142015=>14.3, 20162017=>50.0}
    win_percentage = {}
    number_team_wins_per_season(team_id).each do |season, win_count|
      game_count = number_team_games_per_season(team_id)[season].to_f
      percentage = ((win_count/game_count) * 100).round(1)
      win_percentage[season] = percentage
    end
    win_percentage
  end

  def best_season (team_id) #issue # 18
    season_win_percentage(team_id.to_i).key(season_win_percentage(team_id.to_i).values.max).to_s
  end

  def worst_season #issue # 25



  end

  def average_win_percentage #issue # 26



  end

  def most_goals_scored(team_id) #issue # 21

    array_of_goals_for_specified_team = []

    @games.each do |row|
      array_of_goals_for_specified_team << row[:away_goals] if team_id.to_i == row[:away_team_id]
      array_of_goals_for_specified_team << row[:home_goals] if team_id.to_i == row[:home_team_id]
    end
    array_of_goals_for_specified_team.max()
  end

  def fewest_goals_scored #issue # 28



  end

  def favorite_opponent #issue # 29



  end

  def rival #issue # 30



  end

end
