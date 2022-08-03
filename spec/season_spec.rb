require_relative 'spec_helper.rb'
require 'csv'
require './lib/season_stats.rb'
require './lib/csv_loader.rb'
require './lib/details_loader'

describe SeasonStats do
  before :each do
    @game_path = './data/games_dummy_revised.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams_dummy_revised.csv'

    @game = CSV.table(@game_path)
    @team = CSV.table(@team_path)
    @game_team = CSV.table(@game_teams_path)
    @season_stats = SeasonStats.new(@game, @team, @game_team)
  end 


describe 'Season Class initializes' do 
  it 'Season Class exist' do 
    expect(@season_stats).to be_an_instance_of(SeasonStats)
    expect(@season_stats).to be_kind_of(DetailsLoader)
    expect(@season_stats).to be_kind_of(CsvLoader)
  end

  it "read csv files" do
      expect(@season_stats.games).to eq(CSV.table(@game_path))
      expect(@season_stats.teams).to eq(CSV.table(@team_path))
      expect(@season_stats.game_teams).to eq(CSV.table(@game_teams_path))
    end
  end

  describe 'Test Season Stats Helpers' do 
    it 'Can find all stats for away and home team for a particular game' do
      expect(@season_stats.game_teams_for_game_id(2012030151)).to be_a_kind_of(Array)
    end

    it 'can give total shots and total goals in a season for each team' do 
      expect(@season_stats.total_team_shots_and_goals).to include(20122013)
    end

    it 'can give accuracy ratio of team for a given season' do 
      expect(@season_stats.seasonal_team_accuracy(20122013)).to include(3=>0.21052631578947367, 5=>0.0625)
    end

    it 'returns total tackles in a season by a team' do 
      expect(@season_stats.total_tackles_in_season_by_team).to include(20172018 => {28=>67, 24=>65, 54=>38})
    end
  end
end
