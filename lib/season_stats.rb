require_relative 'details_loader'
require_relative 'reusable'
class SeasonStats < DetailsLoader
  include Reusables

  def initialize(games, teams, game_teams)
    super(games, teams, game_teams)
    @details = DetailsLoader.new(games, teams, game_teams)
  end

  def winningest_coach(season) 
   highest_percent_wins = team_win_percent_by_season[season.to_i].max_by {|stat| stat[:win_perc]}
   coach_by_team_id[highest_percent_wins[:team_id]][season.to_i].sample
  end

  def worst_coach(season)
    lowest_percent_wins = team_win_percent_by_season[season.to_i].min_by {|stat| stat[:win_perc]}
    coach_by_team_id[lowest_percent_wins[:team_id]][season.to_i].sample
  end

  def game_teams_for_game_id(game_id) #Helper
    @game_teams.find_all do |game_team| 
      game_team[:game_id] == game_id
    end
  end

  def total_team_shots_and_goals #Helper
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
  end 

  def seasonal_team_accuracy(season_id) #Helper
     total_team_shots_and_goals[season_id].transform_values do |team_shots_and_goals|
     team_shots_and_goals["goals"].to_f / team_shots_and_goals["shots"]
    end
  end 

  def most_accurate_team(season_id) 
    team_by_id[seasonal_team_accuracy(season_id.to_i).key(seasonal_team_accuracy(season_id.to_i).values.max)]
  end

  def least_accurate_team(season) 
  games_by_season
  teams_with_goals_n_shots = Hash.new { |h,k| h[k] = [] }

  game_teams.each do |row|
    teams_with_goals_n_shots[row[:team_id]] = {"goals" => [], "shots" => []} if games_by_season[season.to_i].include?(row[:game_id])
  end

  game_teams.each do |row|
    teams_with_goals_n_shots[row[:team_id]]["goals"] << row[:goals] and teams_with_goals_n_shots[row[:team_id]]["shots"] << row[:shots] if games_by_season[season.to_i].include?(row[:game_id])
  end

  teams_with_goals_n_shots.keys.each do |team_id|
    teams_with_goals_n_shots[team_id] = teams_with_goals_n_shots[team_id]["goals"].sum.to_f / teams_with_goals_n_shots[team_id]["shots"].sum
  end

  team_by_id[teams_with_goals_n_shots.key(teams_with_goals_n_shots.values.min)]
  end

  def total_tackles_in_season_by_team
    team_id_and_tackles_hash = Hash.new {|h,k| h[k] = {}}

    games_by_season.each do |season, games|
      @game_teams.each do |row|
        if games.include?(row[:game_id])
          if team_id_and_tackles_hash[season] == {} ||
            team_id_and_tackles_hash[season][row[:team_id]].nil?
              team_id_and_tackles_hash[season][row[:team_id]] = row[:tackles]
          else
            team_id_and_tackles_hash[season][row[:team_id]] += row[:tackles]
          end
        end
      end
    end
    team_id_and_tackles_hash
  end

  def most_tackles(season_id) 
    team_by_id[total_tackles_in_season_by_team[season_id.to_i].key(total_tackles_in_season_by_team[season_id.to_i].values.max)]
  end

  def fewest_tackles(season_id)
    team_by_id[total_tackles_in_season_by_team[season_id.to_i].key(total_tackles_in_season_by_team[season_id.to_i].values.min)]
  end
end