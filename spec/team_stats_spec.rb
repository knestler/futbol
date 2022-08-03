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
        expect(@team_stats.rival_wins("19")).to be_a Hash
      end

    it 'can determine number of rival games' do
      expect(@team_stats.rival_game("19")).to be_a Hash
    end
  end
    
end
