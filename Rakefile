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

  Collection.create(user_id: @user1.id, title: 'Developer Collection')
  Collection.create(user_id: @user2.id, title: 'Test Collection')
  Collection.create(user_id: @user3.id, title: 'User Collection')

  puts User.all.inspect
end
