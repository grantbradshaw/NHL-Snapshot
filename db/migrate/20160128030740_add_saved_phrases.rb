class AddSavedPhrases < ActiveRecord::Migration
  def change
    create_table :saved_phrases do |t|
      t.references(:collection)
      t.string :phrase
    end
  end
end
