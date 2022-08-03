require_relative 'details_loader'
class Team < DetailsLoader

   def initialize(games, teams, game_teams)
    super(games, teams, game_teams)
    @details = DetailsLoader.new(games, teams, game_teams)
  end

  def team_info(team_id) #issue # 23 - Pass
      info = { "team_id" => team_id, "franchise_id" => 0, "team_name" => 0, "abbreviation" => 0,"link" => 0}
      @teams.each do |row|
        info["franchise_id"] = row[:franchiseid].to_s if row[:team_id] == team_id.to_i
        info["team_name"] = row[:teamname] if row[:team_id] == team_id.to_i
        info["abbreviation"] = row[:abbreviation] if row[:team_id] == team_id.to_i
        info["link"] = row[:link] if row[:team_id] == team_id.to_i
      end
      info
  end

  def best_season(team_id) #issue # 18 - PASS
    season_win_percentage(team_id.to_i).key(season_win_percentage(team_id.to_i).values.max).to_s
  end

  def season_win_percentage(team_id) # Percentage of won games per season by team - helper method for issue #18
    win_percentage = Hash.new
    number_team_games_per_season(team_id).each { |game_season, game_count|
      number_team_wins_per_season(team_id).each { |wins_season, win_count|
        if game_season == wins_season
          if win_count == 0
            percentage = 0.0
          else
            percentage = ((win_count/game_count.to_f) * 100).round(1) 
          end
          win_percentage[game_season] = percentage
        end } }
    win_percentage
  end
  def number_team_wins_per_season(team_id) # Count of number of games a team won each season -helper method for issue #18
    wins_by_season = Hash.new{0}
    games_by_season.each { |season, games|
      wins_by_team(team_id).each { |result_data|
        wins_by_season[season] += 1.0 if games.include?(result_data[0]) }
      wins_by_season[season] = 0.0 if wins_by_season[season] == 0 }
    wins_by_season
  end

  def number_team_games_per_season(team_id) # Count of number of games a team played each season - helper method for issue #18
    team_games_by_season = Hash.new{0}
    games_by_season.each { |season, games|
      games_by_team(team_id).each { |result_data|
        team_games_by_season[season] += 1.0 if games.include?(result_data[0])  
        team_games_by_season[season] = 0.0 if team_games_by_season[season] == 0 } }
    team_games_by_season
  end

  def games_by_season # All game_ids sorted by season - helper method for issue #18
    games_by_season = {}
    @games.values_at(:game_id, :season).each { |game|
      if games_by_season.include?(game[1])
        games_by_season[game[1]] << game[0]
      else
        games_by_season[game[1]] = [game[0]]
      end }
    games_by_season
  end

  def games_by_team(team_id) # List of every game a team played - helper method for issue #18
    @game_teams.filter_map {|row| [row[:game_id], team_id] if row[:team_id] == team_id}
  end

  def wins_by_team(team_id) # List of every game that was a win for a team - helper method for issue #18
    result_by_team = @game_teams.values_at(:game_id, :team_id, :result).find_all do |game|
      game[1] == team_id && game[2] == "WIN"
    end
  end

  def worst_season(team_id) #issue # 25 - Fail due to not written
    season_win_percentage(team_id.to_i).key(season_win_percentage(team_id.to_i).values.min).to_s
  end

  def average_win_percentage(team_id) #issue # 20
    (wins_by_team(team_id.to_i).count.to_f/games_by_team(team_id.to_i).count.to_f).round(2)
  end

  def most_goals_scored(team_id) #issue # 27 pass
    array_of_goals_for_specified_team = []

    @games.each { |row|
      array_of_goals_for_specified_team << row[:away_goals] if team_id.to_i == row[:away_team_id]
      array_of_goals_for_specified_team << row[:home_goals] if team_id.to_i == row[:home_team_id] }
    array_of_goals_for_specified_team.max()
  end

  def fewest_goals_scored(team_id) #issue # 28 - Fail due to not written
    array_of_goals_for_specified_team = []

      @games.each { |row|
        array_of_goals_for_specified_team << row[:away_goals] if team_id.to_i == row[:away_team_id]
        array_of_goals_for_specified_team << row[:home_goals] if team_id.to_i == row[:home_team_id] }
      array_of_goals_for_specified_team.min()
  end

  def favorite_opponent(team_id)#issue # 29
    rival_opp = {}
    rival_opp_wins = rival_wins(team_id)
    rival_opp_games = rival_game(team_id)
    rival_opp_games.each { | rogk, rogv |
      rival_opp_wins.each { | rowk, rowv |
        rival_opp.merge!("#{rowk}" => (rowv.to_f / rogv.to_f)) if rogk == rowk
        rival_opp[rogk.to_s] = 0.0 if rival_opp_wins[rogk].nil? } }
    rival_opp.each { |k, v| return team_by_id[k.to_i] if v == rival_opp.values.min }
  end

  def rival_wins(team_id) #helper for #24 and possibly fave opp
    rivals_wins = []
    @games.each { |row|
     rivals_wins << row[:home_team_id] if (row[:away_team_id] == team_id.to_i) && (row[:away_goals] < row[:home_goals])
     rivals_wins << row[:away_team_id] if (row[:home_team_id] == team_id.to_i) && (row[:home_goals] < row[:away_goals])}
     rivals_wins_hash = rivals_wins.tally
     rivals_wins_hash
  end

  def rival_game(team_id) #helper for #24 and possibly fave opp
    rivals_games = []
    games.each { |row|
     rivals_games << row[:away_team_id] if row[:home_team_id] == team_id.to_i
     rivals_games << row[:home_team_id] if row[:away_team_id] == team_id.to_i}
    rivals_games_hash = rivals_games.tally
    rivals_games_hash
  end

  def rival(team_id) #issue 24 - Fail due to not written
    rival_opp = {}
    rival_opp_wins = rival_wins(team_id)
    rival_opp_games = rival_game(team_id)
    rival_opp_games.each { | rogk, rogv |
      rival_opp_wins.each { | rowk, rowv |
       rival_opp.merge!("#{rowk}" => (rowv.to_f / rogv.to_f)) if rogk == rowk 
       rival_opp[rogk.to_s] = 0.0 if rival_opp_wins[rogk].nil? } }
    rival_opp.each{|k, v| return team_by_id[k.to_i] if v == rival_opp.values.max}
  end
end
