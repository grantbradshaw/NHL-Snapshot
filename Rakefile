require 'rake'
require "sinatra/activerecord/rake"
require ::File.expand_path('../config/environment', __FILE__)

Rake::Task["db:create"].clear
Rake::Task["db:drop"].clear

# NOTE: Assumes SQLite3 DB
desc "create the database"
task "db:create" do
  touch 'db/db.sqlite3'
end

desc "drop the database"
task "db:drop" do
  rm_f 'db/db.sqlite3'
end

desc 'Retrieves the current schema version number'
task "db:version" do
  puts "Current version: #{ActiveRecord::Migrator.current_version}"
end

desc 'Populates the database immediately' 
task "db:populate" do
  User.destroy_all
  Collection.destroy_all
  SavedPhrase.destroy_all

  @user1 = User.create(name: 'developer')
  @user2 = User.create(name: 'test')
  @user3 = User.create(name: 'user')
  @user4 = User.create(name: 'another')

  Collection.create(user_id: @user1.id, title: 'Developer Collection')
  Collection.create(user_id: @user2.id, title: 'Test Collection')
  Collection.create(user_id: @user3.id, title: 'User Collection')
  Collection.create(user_id: @user4.id)

  puts User.all.inspect
end

desc 'Pulls tweets for searching'
task 'db:tweets_populate' do
  Tweet.destroy_all

  SportsTwitter.popular("nhl", 1000, 3).each do |twit|
    Tweet.create(message: twit[0], search_term: 'nhl')
  end
  
  # Sentence.all_players.each do |player|
  #   sleep(2)
  #   SportsTwitter.search(player, 1).each do |twit|
  #     Tweet.create(message: twit.text, search_term: player)
  #   end
  # end

  puts Tweet.all.inspect
end

desc 'Pulls overall league stats'
task 'db:league_stats_populate' do
  LeagueStat.destroy_all

  WebScrape.top_three_svp.each_with_index do |player, index|
    LeagueStat.create(search_term: 'top_three_svp', name: player[:name], rank: index)
  end

  WebScrape.top_three_pts.each_with_index do |player, index|
    LeagueStat.create(search_term: 'top_three_pts', name: player[:name], rank: index)
  end

  WebScrape.top_three_teams.each_with_index do |team, index|
    LeagueStat.create(search_term: 'top_three_teams', name: team[:name], rank: index)
  end

  WebScrape.bottom_three_teams.each_with_index do |team, index|
    LeagueStat.create(search_term: 'bottom_three_teams', name: team[:name], rank: index)
  end
end

desc 'Pulls each teams statistics'
task 'db:team_stats_populate' do
  TeamStat.destroy_all

  WebScrape.all_teams.each do |team|
    TeamStat.create(
      team: team,
      rank: WebScrape.team_rank(team),
      top_player: WebScrape.top_scoring_player(team)[0],
      top_player_photo: WebScrape.top_scoring_player(team)[1],
      top_goalie: WebScrape.top_goalie(team)[0],
      top_goalie_photo: WebScrape.top_goalie(team)[1],
      next_game: WebScrape.next_game(team),
      last_game: WebScrape.last_game(team)
      )
  end
end
