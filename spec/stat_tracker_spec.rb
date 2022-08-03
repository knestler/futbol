require_relative 'spec_helper.rb'
require './lib/stat_tracker.rb'


describe StatTracker do

  before :each do
    @game_path = './data/games_dummy_revised.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams_dummy_revised.csv'

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

  end

  describe 'Game Statistics' do

    it 'percentage_visitor_wins' do
      expect(@stat_tracker.percentage_visitor_wins).to eq(0.40)
    end

    it "finds highest total score" do
      expect(@stat_tracker.highest_total_score).to eq(8)
    end

    it 'finds lowest score' do
      expect(@stat_tracker.lowest_total_score).to eq(1)
    end

    it 'calculates percentage home wins' do
      expect(@stat_tracker.percentage_home_wins).to eq(0.6)
    end

    it 'calculates percentage visitor wins' do
      expect(@stat_tracker.percentage_visitor_wins).to eq(0.40)
    end

    it "returns the percentage of tied games" do
      expect(@stat_tracker.percentage_ties).to eq(0.0)
    end

    it 'average goals' do 
      expect(@stat_tracker.average_goals_per_game).to eq(3.90) 
    end

    it 'returns hash with season name and average goals for each season ' do
      expected_hash = {"20122013"=>3.56, "20132014"=>4.33, "20142015"=>4.67, "20152016"=>5.0, "20162017"=>4.67, "20172018"=>3.67}
      expect(@stat_tracker.average_goals_by_season).to eq(expected_hash)
    end

    it 'Has hash with season names as keys and counts of games as values' do
      expect(@stat_tracker.count_of_games_by_season).to eq({"20122013"=>25, "20132014"=>3, "20142015"=>3, "20152016"=>3, "20162017"=>3, "20172018"=>3})
    end

  end

  describe 'League Statistics' do

    it 'can return total number of teams in the data' do
      expect(@stat_tracker.count_of_teams).to eq(32)
    end

    it 'can return Name of the team with the highest average number of goals scored per game across all seasons' do
      expect(@stat_tracker.best_offense).to eq("Reign FC")
    end

    it 'can return Name of the team with the lowest average number of goals scored per game across all seasons' do
      expect(@stat_tracker.worst_offense).to eq("Sporting Kansas City")
    end

    it 'can return Name of the team with the highest average score per game across all seasons when they are away' do
      expect(@stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
    end

    it 'can return Name of the team with the highest average score per game across all seasons when they are home' do
      expect(@stat_tracker.highest_scoring_home_team).to eq("Chicago Red Stars").or("Minnesota United FC")
    end

    it 'can return Name of the team with the lowest average score per game across all seasons when they are a visitor' do
      expect(@stat_tracker.lowest_scoring_visitor).to eq("Real Salt Lake")
    end

    it 'can return Name of the team with the lowest average score per game across all seasons when they are at home' do
      expect(@stat_tracker.lowest_scoring_home_team).to eq("Reign FC").or(eq("Los Angeles FC"))
    end

  end

  describe 'Season Statistics' do

    it 'can show name of coach with the best win percentage of the season' do
      expect(@stat_tracker.winningest_coach("20122013")).to eq("Claude Julien")
    end

    it 'can show name with the worst win percentage for the season' do
      expect(@stat_tracker.worst_coach("20122013")).to eq("John Tortorella").or(eq("Dan Bylsma"))
    end

    it 'can show name of the team with the best ratio of shots to goals for the season' do
      expect(@stat_tracker.most_accurate_team("20122013")).to eq("FC Dallas")
    end

    it 'can show name of the team with the worst ratio of shots to goals for the season' do
      expect(@stat_tracker.least_accurate_team("20122013")).to eq("Sporting Kansas City")
    end

    it 'can show name of the team with most tackles in the season' do
      expect(@stat_tracker.most_tackles("20122013")).to eq("New England Revolution")
    end

    it 'can show name of the team with fewest tackles in the season' do
      expect(@stat_tracker.fewest_tackles("20122013")).to eq("Sporting Kansas City")
    end

  end

  describe 'Team Statistics' do

    it 'can return a hash with key/value pairs for the following attributes: team_id, franchise_id, team_name, abbreviation, and link' do
      expect(@stat_tracker.team_info("1")).to eq(
        expected = {
          "team_id" => "1",
          "franchise_id" => "23",
          "team_name" => "Atlanta United",
          "abbreviation" => "ATL",
          "link" => "/api/v1/teams/1"
      })
    end

    it 'can show season with the highest win percentage for a team' do
      expect(@stat_tracker.best_season("3")).to eq("20142015")
    end

    it 'can show season with the lowest win percentage for a team' do
      expect(@stat_tracker.worst_season("3")).to eq("20122013")
    end

    it 'can show season with the lowest win percentage for a team' do
      expect(@stat_tracker.average_win_percentage("3")).to eq(0.25)
    end

    it 'can return highest number of goals a particular team has scored in a  single game' do
      expect(@stat_tracker.most_goals_scored("3")).to eq(5)
    end

    it 'can return lowest number of goals a particular team has scored in a single game' do
      expect(@stat_tracker.fewest_goals_scored('3')).to eq(0)
    end

    it 'can return name of the opponent that has the lowest win percentage against the given team' do
      expect(@stat_tracker.favorite_opponent("16")).to eq("Orlando City SC")
    end

    it 'can return name of the opponent that has the highest win percentage against the given team' do
      expect(@stat_tracker.rival("3")).to eq("FC Dallas")
    end

  end

end
