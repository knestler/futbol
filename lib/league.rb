require_relative 'details_loader'
class League < DetailsLoader

  def initialize(games, teams, game_teams)
    super(games, teams, game_teams)
    @details = DetailsLoader.new(games, teams, game_teams)
  end

  def count_of_teams #issue # 10 - PASS
    @teams[:teamname].count
  end

  def best_offense #issue # 11 - Fail Wrong team returning
    max_average = average_scores_by_team_id("home", "away").values.max
    team_by_id[average_scores_by_team_id("home", "away").key(max_average)]
  end

  def worst_offense #issue # 12 - PASS
    min_average = average_scores_by_team_id("home", "away").values.min
    team_by_id[average_scores_by_team_id("home", "away").key(min_average)]
  end

  def average_scores_by_team_id(*game_type)# need test in league_spec #helper method for issue #14
    average_scores= {}
    scores_by_team_id(*game_type).each do |team, scores|
      next if scores.count ==0
      average = scores.sum/scores.count
      average_scores[team] = average.round(1)
    end
    average_scores
  end

  def highest_scoring_visitor #issue # 13 - Pass
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
    @teams.values_at(:team_id, :teamname).uniq.to_h
  end

  def highest_scoring_home_team #issue # 14 - PASS
    max_average = average_scores_by_team_id("home").values.max
    team_by_id[average_scores_by_team_id("home").key(max_average)]
  end

  def lowest_scoring_visitor #issue # 15 - PASS
    lowest_average = average_scores_by_team_id("away").values.min
    team_by_id[average_scores_by_team_id("away").key(lowest_average)]
  end

  def lowest_scoring_home_team #issue # 16 - Fail wrong team being returned
    min_average = average_scores_by_team_id("home").values.min
    team_by_id[average_scores_by_team_id("home").key(min_average)]
  end
end
