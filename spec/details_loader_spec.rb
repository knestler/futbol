require_relative 'spec_helper.rb'
require 'csv'
require './lib/csv_loader'
require './lib/details_loader'


describe DetailsLoader do

  before :each do

    @game_path = './data/games_dummy_revised.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams_dummy_revised.csv'

    @game = CSV.table(@game_path)
    @team = CSV.table(@team_path)
    @game_team = CSV.table(@game_teams_path)

    @details = DetailsLoader.new(@game, @team, @game_team)

  end

  describe 'Game Class initializes' do
    it 'Game Class exists'do
      expect(@details).to be_an_instance_of(DetailsLoader)
      expect(@details).to be_kind_of(CsvLoader)
    end

    it "read csv files" do
      expect(@details.games).to eq(CSV.table(@game_path))
      expect(@details.teams).to eq(CSV.table(@team_path))
      expect(@details.game_teams).to eq(CSV.table(@game_teams_path))
    end

  end

  describe "Stores Frequntly Needed Season Details" do

    it "team_by_id" do
      expect(@details.team_by_id[3]).to eq("Houston Dynamo")
      expect(@details.team_by_id[18]).to eq("Minnesota United FC")
    end

    it "coach_by_team_id" do
      expect(@details.coach_by_team_id[3][20142015]).to eq(["Alain Vigneault"])
      expect(@details.coach_by_team_id[18]).to eq({20162017=>["Peter Laviolette"]})
    end

    it "games_by_season" do
      expect(@details.games_by_season[20142015]).to eq([2014030314, 2014030315, 2014030316])
      expect(@details.games_by_season[20122013].count).to eq(25)
    end

  end

end
