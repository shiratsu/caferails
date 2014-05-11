class AddCafes < ActiveRecord::Migration
  def change
    add_column :caves, :latlng_update_flag, :integer
  end
end
