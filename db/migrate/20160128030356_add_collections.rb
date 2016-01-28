class AddCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.references(:user)
      t.boolean :shared, default: false
      t.string :title, default: 'My Collection'      
    end
  end
end
