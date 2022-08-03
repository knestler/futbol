require_relative 'spec_helper.rb'
require 'csv'
require './lib/league'
require './lib/csv_loader'
require './lib/details_loader'


describe League do

  before :each do

    @game_path = './data/games_dummy_revised.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams_dummy_revised.csv'

    @game = CSV.table(@game_path)
    @team = CSV.table(@team_path)
    @game_team = CSV.table(@game_teams_path)

    @league_stats = League.new(@game, @team, @game_team)

  end

  describe 'Game Class initializes' do
    it 'Game Class exists'do
      expect(@league_stats).to be_an_instance_of(League)
      expect(@league_stats).to be_kind_of(DetailsLoader)
      expect(@league_stats).to be_kind_of(CsvLoader)
    end

    it "read csv files" do
      expect(@league_stats.games).to eq(CSV.table(@game_path))
      expect(@league_stats.teams).to eq(CSV.table(@team_path))
      expect(@league_stats.game_teams).to eq(CSV.table(@game_teams_path))
    end
  end

  describe 'Test Game Stats Helpers' do

  it "average_scores_by_team_id" do
    expect(@league_stats.average_scores_by_team_id("home", "away")).to have_key(24)
    expect(@league_stats.average_scores_by_team_id("home")).to have_key(3)
    expect(@league_stats.average_scores_by_team_id("away")).to have_key(54)
  end

  it "scores_by_team_id" do
    expect(@league_stats.scores_by_team_id("home", "away")).to have_key(24)
    expect(@league_stats.scores_by_team_id("home")).to have_key(3)
    expect(@league_stats.scores_by_team_id("away")).to have_key(5)
  end

  end
end
