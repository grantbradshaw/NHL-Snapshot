class AddTeamStats < ActiveRecord::Migration
  def change
    create_table :team_stats do |t|
      t.string :team
      t.string :rank
      t.string :top_player
      t.string :top_player_photo
      t.string :top_goalie
      t.string :top_goalie_photo
      t.string :next_game
      t.string :last_game
      t.timestamps null: false
    end
  end
end
