require_relative 'spec_helper.rb'
require 'csv'
require './lib/games.rb'
require './lib/csv_loader.rb'
require './lib/details_loader'


describe Games do

  before :each do

    @game_path = './data/games_dummy_revised.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams_dummy_revised.csv'

    @game = CSV.table(@game_path)
    @team = CSV.table(@team_path)
    @game_team = CSV.table(@game_teams_path)

    @game_stats = Games.new(@game, @team, @game_team)

  end

  describe 'Game Class initializes' do
    it 'Game Class exists'do
      expect(@game_stats).to be_an_instance_of(Games)
      expect(@game_stats).to be_kind_of(DetailsLoader)
      expect(@game_stats).to be_kind_of(CsvLoader)
    end

    it "read csv files" do
      expect(@game_stats.games).to eq(CSV.table(@game_path))
      expect(@game_stats.teams).to eq(CSV.table(@team_path))
      expect(@game_stats.game_teams).to eq(CSV.table(@game_teams_path))
    end
  end

  describe 'Test Game Stats Helpers' do
    it "total_scores_by_game" do
      @game_1.highest_total_score
      expect(@game_1.total_scores_by_game).to be_a_kind_of(Array)
    end

    it "home_wins" do
      expect(@stat_tracker.home_wins).to eq(24)
    end

    it "home_games" do
      expect(@stat_tracker.home_games).to eq(40)
    end
  end
end
