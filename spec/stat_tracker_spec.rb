require './lib/stat_tracker.rb'
require_relative 'spec_helper.rb'


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
    xit 'returns an instance of StatTracker' do
      expect(StatTracker.from_csv(@locations)).to be_an_instance_of(StatTracker)
    end


    xit "read csv files" do
      expect(@stat_tracker.games).to eq(CSV.table(@game_path))
      expect(@stat_tracker.teams).to eq(CSV.table(@team_path))
      expect(@stat_tracker.game_teams).to eq(CSV.table(@game_teams_path))
    end

  end

  describe 'Game Statistics' do



    xit 'percentage_visitor_wins' do
   #move to correct location
        expect(@stat_tracker.percentage_visitor_wins).to eq(13.33)
    end

    xit "finds highest total score" do
      expect(@stat_tracker.highest_total_score).to eq(7)
    end

    xit 'can return the lowest score' do
      expect(@stat_tracker.lowest_total_score).to eq(1)
    end

    xit "tracks wins" do
      expect(@stat_tracker.game_wins).to eq(29)
    end

    xit "tracks losses" do
      expect(@stat_tracker.game_losses).to eq(29)
    end

    xit "tracks home games" do
      expect(@stat_tracker.home_games).to eq(30)
    end

    xit "tracks away games" do
      expect(@stat_tracker.away_games).to eq(30)
    end

    xit "calculates home wins" do
      expect(@stat_tracker.home_wins).to eq(21)
    end

    xit 'calculates percentage wins' do
      expect(@stat_tracker.percentage_home_wins).to eq(70.0)
    end

    xit "returns the percentage of tied games" do
      expect(@stat_tracker.percentage_ties).to eq(17.8)
    end

    xit 'average goals' do
      expect(@stat_tracker.average_goals_per_game).to eq(4)
    end

    xit 'returns hash with season name and average goals for each season ' do

      expected_hash = {"20122013"=>3.64, "20132014"=>4.15, "20142015"=>4.64, "20162017"=>3.75}      
      expect(@stat_tracker.average_goals_by_season).to eq(expected_hash)
    end

    xit 'Has hash with season names as keys and counts of games as values' do
      expect(@stat_tracker.count_of_games_by_season).to eq({
          20122013 => 28,
          20132014 => 33,
          20142015 => 28,
          20162017 => 12,
      })
    end
  end

  describe 'League Statistics' do

    xit 'can return total number of teams in the data' do
      expect(@stat_tracker.count_of_teams).to eq(32)
    end

    xit 'can return Name of the team with the highest average number of goals scored per game across all seasons' do
      expect(@stat_tracker.best_offense).to eq("New York City FC")
    end

    xit 'can return Name of the team with the lowest average number of goals scored per game across all seasons' do
      expect(@stat_tracker.worst_offense).to eq("Sporting Kansas City")
    end

    xit 'can return Name of the team with the highest average score per game across all seasons when they are away' do
      expect(@stat_tracker.highest_scoring_visitor).to eq("Utah Royals FC")
    end

    xit 'can return Name of the team with the highest average score per game across all seasons when they are home' do
      expect(@stat_tracker.highest_scoring_home_team).to eq("New York City FC")
    end

    xit 'can return Name of the team with the lowest average score per game across all seasons when they are a visitor' do
      expect(@stat_tracker.lowest_scoring_visitor).to eq("Sporting Kansas City")
    end

    xit 'can return Name of the team with the lowest average score per game across all seasons when they are at home' do
      expect(@stat_tracker.lowest_scoring_home_team).to eq("Sporting Kansas City")
    end
  end

  describe 'Season Statistics' do

    xit 'can show name of coach with the best win percentage of the season' do
      expect(@stat_tracker.winningest_coach("20132014")).to eq("Darryl Sutter")
    end

    it 'can show name with the worst win percentage for the season' do
      expect(@stat_tracker.worst_coach("20122013")).to eq("Mike Yeo")
    end

    xit 'can show name of the team with the best ratio of shots to goals for the season' do
      expect(@stat_tracker.most_accurate_team(20122013)).to eq("FC Dallas")
    end

    xit 'can show name of the team with the worst ratio of shots to goals for the season' do
      expect(@stat_tracker.least_accurate_team).to eq("")
    end

    xit 'can show name of the team with most tackles in the season' do
      expect(@stat_tracker.most_tackles("20122013")).to eq("Chicago Fire")
    end

  end

  describe 'Team Statistics' do

    xit 'can return a hash with key/value pairs for the following attributes: team_id, franchise_id, team_name, abbreviation, and link' do
      expect(@stat_tracker.team_info("1")).to eq(
        expected = {
          "team_id" => "1",
          "franchise_id" => "23",
          "team_name" => "Atlanta United",
          "abbreviation" => "ATL",
          "link" => "/api/v1/teams/1"
      })
    end

    xit 'can show season with the highest win percentage for a team' do
      expect(@stat_tracker.best_season("16")).to eq("20132014")
    end

    xit 'can show season with the lowest win percentage for a team' do
      expect(@stat_tracker.average_win_percentage).to eq#(float)
    end

    it 'can return highest number of goals a particular team has scored in a  single game' do
      expect(@stat_tracker.most_goals_scored('3')).to eq(5)
    end

    xit 'can return lowest number of goals a particular team has scored in a single game' do
       expect(@stat_tracker.fewest_goals_scored).to eq#(integer)
    end

    xit 'can return name of the opponent that has the lowest win percentage against the given team' do
      expect(@stat_tracker.favorite_opponent).to eq("")
    end

    xit 'can return name of the opponent that has the highest win percentage against the given team' do
      expect(@stat_tracker.rival).to eq("")
    end
  end

end
