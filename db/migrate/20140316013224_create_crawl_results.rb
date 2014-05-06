class CreateCrawlResults < ActiveRecord::Migration
  def change
    create_table :crawl_results,:id=>false do |t|
      t.column :crawl_id, "int(11) PRIMARY KEY"
      t.integer :start
      t.date :crawl_date

    end
  end
end
