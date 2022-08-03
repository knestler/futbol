require_relative 'spec_helper.rb'
require 'csv'
require './lib/team_stats.rb'
require './lib/csv_loader.rb'
require './lib/details_loader'

describe Team do
  before :each do
    @game_path = './data/games_dummy_revised.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams_dummy_revised.csv'

    @game = CSV.table(@game_path)
    @team = CSV.table(@team_path)
    @game_team = CSV.table(@game_teams_path)
    @team_stats = Team.new(@game, @team, @game_team)
  end 

  describe 'Team Class initializes' do 
    it 'Team Class exist' do 
      expect(@team_stats).to be_an_instance_of(Team)
      expect(@team_stats).to be_kind_of(DetailsLoader)
      expect(@team_stats).to be_kind_of(CsvLoader)
    end

    it "read csv files" do
      expect(@team_stats.games).to eq(CSV.table(@game_path))
      expect(@team_stats.teams).to eq(CSV.table(@team_path))
      expect(@team_stats.game_teams).to eq(CSV.table(@game_teams_path))
    end

    it 'can determine number of rival wins' do
      expect(@team_stats.rival_wins("19")).to eq({26=>1, 16=>2, 18=>1})
    end

    it 'can determine number of rival games' do
      expect(@team_stats.rival_game("19")).to eq({26=>4, 16=>3, 18=>3})
    end

    it 'can give percentage of won games per season by team id' do 
      expect(@team_stats.season_win_percentage(3)).to include(20142015=>66.7)
    end

    it 'count of games a team won' do 
      expect(@team_stats.number_team_wins_per_season(3)).to include(20142015=>2.0)
    end

    it 'number of games a team played each season' do 
      expect(@team_stats.number_team_games_per_season(3)).to include(20122013=>5.0)
    end

    it 'sort game id by season' do 
      expect(@team_stats.games_by_season).to include(20172018=>[2017030246, 2017030181, 2017030182])
    end

    it 'can list every game played by a team' do 
      expected = [[2012030221, 3], [2012030222, 3], [2012030223, 3], [2012030224, 3], [2012030225, 3], [2014030314, 3], [2014030315, 3], [2014030316, 3]]
      expect(@team_stats.games_by_team(3)).to eq(expected)
    end

    it 'can list every win by a team' do 
      expect(@team_stats.wins_by_team(3)).to eq([[2014030314, 3, "WIN"], [2014030316, 3, "WIN"]])
    end
  end 
end