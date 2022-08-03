module Reusables
  
  def team_win_percent_by_season 
    team_win_percent = Hash.new {0}
    team_by_id.each do |id , team|
        season_win_percentage(id).each do |season, win|
          if number_team_games_per_season(id)[season] != (0.0 || 0)
            if team_win_percent[season] == 0
              team_win_percent[season] = [{team_id: id, win_perc: win}]
            else
              team_win_percent[season] << {team_id: id, win_perc: win}
          end
        end
      end
    end
    team_win_percent
  end

  def season_win_percentage(team_id) 
    win_percentage = Hash.new
    number_team_games_per_season(team_id).each do |game_season, game_count|
      number_team_wins_per_season(team_id).each do |wins_season, win_count|
        if game_season == wins_season
          if win_count == 0
            percentage = 0.0
          else
            percentage = ((win_count/game_count.to_f) * 100).round(1)
          end
          win_percentage[game_season] = percentage
        end
      end
    end
    win_percentage
  end

  def number_team_games_per_season(team_id) 
    team_games_by_season = Hash.new{0}
    games_by_season.each do |season, games|
      games_by_team(team_id).each do |result_data|
        if games.include?(result_data[0])
          team_games_by_season[season] += 1.0
        elsif team_games_by_season[season] == 0
          team_games_by_season[season] = 0.0
        end
      end
    end
    team_games_by_season
  end

  def games_by_team(team_id) 
    games = []
    @game_teams.each do |row|
      games <<[row[:game_id], team_id] if (row[:team_id] == team_id)
    end
    games
  end


  def number_team_wins_per_season(team_id) 
    wins_by_season = Hash.new{0}
    games_by_season.each do |season, games|
      wins_by_team(team_id).each do |result_data|
        if games.include?(result_data[0])
          wins_by_season[season] += 1.0
        end
      end
      if wins_by_season[season] == 0
        wins_by_season[season] = 0.0
      end
    end
    wins_by_season
  end

  def wins_by_team(team_id)
    result_by_team = @game_teams.values_at(:game_id, :team_id, :result).find_all do |game|
      game[1] == team_id && game[2] == "WIN"
    end
  end



end