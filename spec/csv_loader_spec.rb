require_relative 'spec_helper.rb'
require 'csv'
require './lib/csv_loader'


describe CsvLoader do

  before :each do

    @game_path = './data/games_dummy_revised.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams_dummy_revised.csv'

    @game = CSV.table(@game_path)
    @team = CSV.table(@team_path)
    @game_team = CSV.table(@game_teams_path)

    @csv = CsvLoader.new(@game, @team, @game_team)

  end

  describe 'CSV Loader initializes' do
    it 'CSV Loader exists'do
      expect(@csv).to be_an_instance_of(CsvLoader)
    end

    it "read csv files" do
      expect(@csv.games).to eq(CSV.table(@game_path))
      expect(@csv.teams).to eq(CSV.table(@team_path))
      expect(@csv.game_teams).to eq(CSV.table(@game_teams_path))
    end

  end

end
