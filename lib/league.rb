require_relative 'details_loader'
class League < DetailsLoader

  def initialize(games, teams, game_teams)
    super(games, teams, game_teams)
    @details = DetailsLoader.new(games, teams, game_teams)
  end

  def count_of_teams
    @teams[:teamname].count
  end

  def best_offense
    max_average = average_scores_by_team_id("home", "away").values.max
    team_by_id[average_scores_by_team_id("home", "away").key(max_average)]
  end

  def worst_offense
    min_average = average_scores_by_team_id("home", "away").values.min
    team_by_id[average_scores_by_team_id("home", "away").key(min_average)]
  end

  def average_scores_by_team_id(*game_type)
    average_scores= {}
    scores_by_team_id(*game_type).each do |team, scores|
      next if scores.count ==0
      average = scores.sum/scores.count
      average_scores[team] = average.round(2)
    end
    average_scores
  end

  def highest_scoring_visitor
    away_team_ids_array = (@games[:away_team_id]).uniq.sort
    team_ids_hash = {}
    away_team_ids_array.each {|teamid| team_ids_hash[teamid] = {sum_away_goals: 0, count_of_away_games_played: 0}}

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

  def scores_by_team_id(*game_type)
  scores_by_team_id = {}
    scores_by_game_type = @game_teams.values_at(:team_id, :hoa, :goals).find_all do |game|
    game[1] == game_type[0] || game_type[1]
  end

  @game_teams[:team_id].each {|id| scores_by_team_id[id] = []}
  scores_by_game_type.each {|game|scores_by_team_id[game[0]] << game[2].to_f}
    scores_by_team_id
  end

  def highest_scoring_home_team
    max_average = average_scores_by_team_id("home").values.max
    team_by_id[average_scores_by_team_id("home").key(max_average)]
  end

  def lowest_scoring_visitor
    lowest_average = average_scores_by_team_id("away").values.min
    team_by_id[average_scores_by_team_id("away").key(lowest_average)]
  end

  def lowest_scoring_home_team
    min_average = average_scores_by_team_id("home").values.min
    team_by_id[average_scores_by_team_id("home").key(min_average)]
  end
end
