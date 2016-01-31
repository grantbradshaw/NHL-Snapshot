class AddTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :search_term
      t.string :message
      t.timestamps null: true
    end
  end
end
