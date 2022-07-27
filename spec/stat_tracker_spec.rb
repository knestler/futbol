require './lib/stat_tracker.rb'
require_relative 'spec_helper.rb'


describe StatTracker do

  before :each do

    @game_path = './data/games_dummy.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams_dummy.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(@locations)

  end

  describe '.from_csv(locations)' do
    it 'returns an instance of StatTracker' do
      expect(StatTracker.from_csv(@locations)).to be_an_instance_of(StatTracker)
    end

    it "read csv files" do
      expect(@stat_tracker.games).to eq(CSV.table(@game_path))
      expect(@stat_tracker.teams).to eq(CSV.table(@team_path))
      expect(@stat_tracker.game_teams).to eq(CSV.table(@game_teams_path))
    end

  end

  describe 'Game Statistics' do

    it "finds highest total score" do
      expect(@stat_tracker.highest_total_score).to eq(7)
    end

    it 'can return the lowest score' do
      expect(@stat_tracker.lowest_total_score).to eq(1)
    end

    it "finds highest total score" do
      expect(@stat_tracker.highest_total_score).to eq(7)
    end

    it "tracks wins" do
      expect(@stat_tracker.game_wins).to eq(29)
    end

    it "tracks losses" do
      expect(@stat_tracker.game_losses).to eq(29)
    end

    it "tracks home games" do
      expect(@stat_tracker.home_games).to eq(30)
    end

    it 'percentage_visitor_wins' do
        expect(@stat_tracker.percentage_visitor_wins).to eq(13.33)
    end
    
    it "tracks away games" do
      expect(@stat_tracker.away_games).to eq(30)
    end

    it "calculates home wins" do
      expect(@stat_tracker.home_wins).to eq(21)
    end

    it 'calculates percentage wins' do 
      expect(@stat_tracker.percentage_home_wins).to eq(70.0)
    end

    it "returns the percentage of tied games" do
      expect(@stat_tracker.percentage_ties).to eq(17.8)
    end

    it 'average goals' do
      expect(@stat_tracker.average_goals_per_game).to eq(4)
    end

    it 'Has hash with season names as keys and counts of games as values' do 
      expect(@stat_tracker.count_of_games_by_season).to eq({
          20122013 => 28,
          20132014 => 33,
          20142015 => 28,
          20162017 => 12,
      })
    end

  end
end
  

