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
         
        it 'can return the lowest score' do 
            expect(@stat_tracker.lowest_total_score).to eq(1)
        end
         
        it 'A hash with season names as keys and counts of games as values' do 
            expect(@stat_tracker.count_of_games_by_season).to eq({
                20122013 => 28,
                20132014 => 33,
                20142015 => 28,
                20162017 => 12,
            })
        end

    end
end
