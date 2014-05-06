class CreateCaves < ActiveRecord::Migration
  def change
    create_table :caves,:id=>false do |t|
      t.column :id, "varchar(20) PRIMARY KEY"
      t.string :store_name
      t.string :log_image
      t.string :address
      t.column :lat, "double"
      t.column :lng, "double"
      t.string :url

      t.timestamps
    end
  end
end
