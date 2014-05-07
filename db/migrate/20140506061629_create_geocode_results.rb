class CreateGeocodeResults < ActiveRecord::Migration
  def change
    create_table :geocode_results do |t|
      t.integer :point
      t.date :date
    end
  end
end
