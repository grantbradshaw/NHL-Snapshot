class AddCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.references(:user)
      t.boolean :public
      t.string :title      
    end
  end
end
