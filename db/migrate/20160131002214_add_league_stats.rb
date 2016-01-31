class AddLeagueStats < ActiveRecord::Migration
  def change
    create_table :league_stats do |t|
      t.string :search_term
      t.integer :rank
      t.string :name
      t.timestamps null: false
    end
  end
end
