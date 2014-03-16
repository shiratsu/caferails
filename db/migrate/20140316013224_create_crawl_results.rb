class CreateCrawlResults < ActiveRecord::Migration
  def change
    create_table :crawl_results do |t|
      t.int :point
      t.date :date
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
