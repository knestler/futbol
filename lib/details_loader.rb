require_relative 'csv_loader'
class DetailsLoader < CsvLoader

  attr_reader :team_by_id, :coach_by_team_id, :games_by_season

  def initialize (games, teams, game_teams)
    super(games, teams, game_teams)
    @games_by_season = add_games_in_season
    @coach_by_team_id = add_coach_by_team_id
    @team_by_id = @teams.values_at(:team_id, :teamname).uniq.to_h
  end

  def add_coach_by_team_id
    coaches = Hash.new {|h, k| h[k] = {}}
    @games_by_season.each do |season, games|
      @game_teams.each do |row|
        if games.include?(row[:game_id])
          coaches[row[:team_id]][season] = [row[:head_coach]] if !coaches[row[:team_id]].keys.include?(season)
          coaches[row[:team_id]][season] << row[:head_coach] if !coaches[row[:team_id]][season].include?(row[:head_coach])
        end
      end
    end
    coaches
  end

  def add_games_in_season
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
end
