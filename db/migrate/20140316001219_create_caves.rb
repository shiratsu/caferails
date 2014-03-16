class CreateCaves < ActiveRecord::Migration
  def change
    create_table :caves do |t|
      t.string :name
      t.float :lat
      t.float :lon
      t.string :url
      t.string :address

      t.timestamps
    end
  end
end
