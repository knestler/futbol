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
  end 

@season_stats =SeasonStats.new(@game, @team, @game_team)

describe 'Season Class initializes' do 
  it 'Season Class exist' do 
    expect(@season_stats).to be_an_instance_of(SeasonStats)
    expect(@)
  end
end
