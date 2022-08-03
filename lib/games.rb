require_relative 'details_loader'
class Games < DetailsLoader

  def initialize(games, teams, game_teams)
    super(games, teams, game_teams)
    @details = DetailsLoader.new(games, teams, game_teams)
  end

  def highest_total_score
    total_scores_by_game.max
  end

  def lowest_total_score
    total_scores_by_game.min
  end


  def total_scores_by_game
    @games.values_at(:away_goals, :home_goals).map do |game|
      game[0] + game[1]
    end
  end

  def percentage_home_wins
    percentage = (home_wins/home_games).round(2)
  end

  def home_wins
  home_win = 0.0
  @game_teams.values_at(:result, :hoa).flat_map {|row| home_win += 1 if row == ["WIN", "home"]}; home_win
  end

  def home_games
    home = 0.0
    @game_teams[:hoa].map {|row| home += 1 if row == "home"}; home
  end

  def percentage_visitor_wins
    away_wins = 0
    away_games_played = 0
    game_teams.each do |row|
      away_games_played += 1 if row[:hoa] == "away"
      away_wins += 1  if (row[:hoa] == "away" && row[:result] == "WIN")
    end
    (away_wins.to_f / away_games_played).round(2)
  end

  def percentage_ties
    ties = 0.0
    total_games = total_scores_by_game.count
    @games.values_at(:away_goals, :home_goals).each {|game| ties += 1 if game[0] == game[1]}
    (ties/total_games).round(1)
  end

  def count_of_games_by_season
    counts = {}
    games.each do |game|
        season = game[:season]
        counts[season.to_s] = 0 if counts[season.to_s].nil?
        counts[season.to_s] += 1
    end
    counts
  end

  def average_goals_per_game
    (total_scores_by_game.sum/@games.count.to_f).round(2)
  end

  def average_goals_by_season
    goals = Hash.new { |h,k| h[k] = [] }
    count_of_games_by_season.each do |season, game_count|
      goals[season] = []
      game_sum_calc = []
      games.each do |row|
        game_sum_calc << (row[:away_goals] + row[:home_goals]) if row[:season] == season.to_i
        goals[season] = (game_sum_calc.sum / game_count.to_f).round(2)
      end
    end
    goals
  end

end
